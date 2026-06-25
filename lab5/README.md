# Memory Circuits & Systems Lab 5: Ramulator 2.0 DRAM Controller Simulator

## 1. Specification Overview
本實驗探討系統層級的 DRAM 操作效能，使用 **Ramulator 2.0** (一個 Cycle-level 的 DRAM Controller Simulator) 進行模擬與分析。
實驗重點分為兩大項：
- **Address Mapping (位址映射)**：探討不同的實體位址到 Channel/Rank/Bank/Row/Col 的映射方式如何影響記憶體頻寬。
- **Row Policy (列緩衝區替換策略)**：比較 Open-row policy 與 Close-row policy 在不同記憶體存取特徵 (Sequential vs. Random traces) 下的 Row Hit/Conflict 機率與頻寬表現。

系統硬體參數設定：
- 架構：4 Channels, 1 Bank per Channel, 65536 Rows per Bank, 16 Columns per Row。
- 觀察 Timing Constraints：$t_{RCD}$ (ACT to READ/WRITE), $t_{RP}$ (PRE to ACT), $t_{CL}$, $t_{RAS}$, $t_{RC}$ 等對連續指令發布的延遲影響。

## 2. Address Mapping 實驗與分析

### 2.1 預設映射分析 (Given Address Mapping)
使用預設的 Address Mapping，分別執行 `sequential` (循序存取) 與 `random` (隨機存取) trace。
- **Sequential Trace**：對於連續的記憶體位址，若預設的映射將其對應到同一個 Row，會觸發大量的 Row Hit，使得指令序列呈現 `ACT -> READ -> READ -> ...`，僅需等待 $t_{CL}$ (Data Available Delay)。
- **Random Trace**：位址隨機跳躍，容易跳出當下開啟的 Row，導致嚴重的 Row Conflict。此時指令序列為 `PRE -> ACT -> READ`，且每一個指令間均受限於 $t_{RP}$ 與 $t_{RCD}$ 等延遲，大幅降低有效頻寬。

### 2.2 效能優化 (Design New Address Mapping)
為提升效能，修改了 `src/addr_mapper/impl/linear_mappers.cpp` 中的位址映射邏輯：
- **交錯存取 (Interleaving)**：改變 Ch/Ra/Ba/Row/Col 的解碼順序。將較低位元的位址映射至 Channel 或 Bank (例如：Row:Bank:Col:Channel)，使得連續的物理位址存取被分散到不同的 Channel 或 Bank 中。
- **優化結果**：透過這種 Channel/Bank-level parallelism，當一個 Bank 處於 `PRE` 或 `ACT` 的延遲狀態時，另一個 Bank 已經可以接收 `READ`/`WRITE` 指令，有效隱藏了 Timing constraints 帶來的 stall cycles，進而大幅提升有效頻寬。

## 3. Row Policy 實驗與分析

Row-buffer 扮演了 DRAM 中微小的 Cache 角色，Bank 一次只能開啟一個 Row。

### 3.1 Open-row Policy
- **機制**：在存取完畢後，不主動發出 `PRE` (Precharge) 指令，而是保持 Row 開啟。
- **適用場景**：對於 **Sequential Trace** 或具有高度空間局部性 (Spatial Locality) 的工作負載，這能極大化 Row Hit Rate，省略後續存取的 $t_{RCD}$ 與 $t_{RP}$ 時間。
- **缺點**：當面臨 Random Trace 時，極容易發生 Row Conflict，此時不但要承受關閉錯誤 Row ($t_{RP}$) 與開啟新 Row ($t_{RCD}$) 的懲罰，還因為先前沒有提早關閉，導致延遲更加惡化。

### 3.2 Close-row Policy
- **機制**：當同一個 Row 的存取次數達到設定上限 (Cap) 或一段時間無存取後，主動發送 `PRE` 指令將其關閉。
- **適用場景**：非常適合 **Random Trace** 或是高度多核心競爭記憶體的場景 (Locality 低)。由於每次存取後就立刻 Precharge，下一次存取雖然仍需經過 `ACT` ($t_{RCD}$)，但省去了遭遇 Row Conflict 時等待 `PRE` ($t_{RP}$) 的時間。
- **實驗對比**：在 `src/dram_controller/impl/rowpolicy/basic_rowpolicies.cpp` 中配置 Cap 值。模擬結果顯示，對於 Sequential Trace，Open-row 的頻寬表現遠勝 Close-row；而對於 Random Trace，Close-row 藉由提早預充電的機制，能有效減少 Row Conflict 帶來的劇烈效能衰退，表現優於 Open-row。
