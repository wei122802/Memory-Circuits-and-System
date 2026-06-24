# Memory Circuits & Systems Lab 4: DRAM Differential Sense Amplifier

## 1. Specification Overview
本實驗旨在利用 22nm (或 7nm 依設定而定) FinFET 模型設計 DRAM 的 Differential Sense Amplifier (差動式感測放大器)，並實作與模擬完整的 DRAM Read 與 Write 操作週期。
主要規格與任務包含：
- **DRAM Cell 架構**：1T1C (1 Transistor, 1 Capacitor)，其中 Storage Capacitor (儲存電容) 設定為 `C = 20 fF`。
- **電壓設定**：Operating Voltage (VDD) = 1.2V，Wordline Voltage (用於開啟 Access Transistor) = 2.5V，以克服 NMOS 的 $V_{th}$ 壓降，確保完整寫入 VDD。
- **Array 負載模擬**：利用 TA 提供的長串級聯 RC 電路模型，模擬 512 x 512 (32KB) DRAM Array 下 Bitline 與 Wordline 的真實寄生 RC 延遲與負載效應 ($C_{BL}$)。
- **Sensing Amplifier 設計**：實作 Cross-coupled Latch (包含 PMOS 與 NMOS pair)。
- **Precharge & Equalization 設計**：實作等化電路，使 Bitline 在操作前能穩定 Precharge 至 $V_{DD}/2$。
- **Timing Measurement**：透過 Transient Analysis 萃取 DRAM 關鍵時序參數：$t_{RCD}$, $t_{RAS}$, 與 $t_{RP}$。

## 2. DRAM 操作階段分析與實作

我們在 `DRAM_Array_Predict_Model.sp` 中設計了 SA 與 Precharge 電路，並透過精確的 PULSE 訊號控制各個操作階段。

### 2.1 Read Mode (讀取模式)
讀取操作依序分為以下四個階段：
1. **Precharge (預充電)**：開啟 Equalization 訊號 (`Eq`)，將 Bitline0 與 Bitline1 短路並充電至 $V_{DD}/2$ (0.6V)。此階段結束後關閉 `Eq`。
2. **Access (存取)**：拉高 Wordline 電壓至 2.5V，開啟 Access Transistor (Ta)。此時 Storage Capacitor 內的電荷會與 Bitline 產生電荷分享 (Charge Sharing)，使 Bitline 產生微小的電壓偏移 ($\Delta V$)。
3. **Sense (感測)**：開啟 Sense Amplifier (SAP 接至 VDD, SAN 接至 GND)。SA 會將 Bitline 之間微小的 $\Delta V$ 放大，最終一端拉至 VDD，另一端拉至 GND。
4. **Restore (回寫/還原)**：由於讀取是破壞性操作，在 SA 穩定後，由於 Wordline 依然保持開啟，放大後的 VDD 或 GND 會經由 Ta 對 Storage Capacitor 重新充電，還原原本的資料。

### 2.2 Write Mode (寫入模式)
寫入操作的前三個階段 (Precharge, Access, Sense) 與讀取完全相同，主要是為了打開該 Row 並將 SA 準備好。
4. **Write (寫入)**：在 SA 運作的同時，開啟 Column Select (CSL) 與 Write Driver (`WR_0` 或 `WR_1`)，強勢將外部資料灌入 Bitline，覆蓋掉原本由 Cell 讀出的資料。
5. **Write Recovery (寫入恢復)**：關閉 CSL 後，維持 Wordline 開啟一段時間，讓新的資料有足夠的時間充飽 Storage Capacitor。最後關閉 Wordline 鎖住電荷，並重新進入 Precharge 階段。

## 3. 負載分析與時序萃取 (Timing Measurement)

### 3.1 Bitline 負載關係 ($C_{BL}$ vs $C_{C}$)
DRAM 的讀取訊號強度正比於電荷分享後的 $\Delta V$，其公式近似為 $\Delta V = \frac{V_{DD}/2}{1 + C_{BL}/C_{C}}$。
在實驗中，我們掛載了 512 顆 Cell 的 RC 模型，並額外加入補償電容來模擬寄生效應。一般而言，$C_{BL}$ 與 $C_{C}$ 的比例會落在 3:1 到 6:1 之間。若 $C_{BL}$ 過大，$\Delta V$ 會小於 SA 的 Offset 容忍值，導致讀取出錯；若要增加 $C_{C}$，則會犧牲面積。本實驗透過 RC 模型真實反映了這層 trade-off，並觀察兩條 differential bitline 因掛載 active cell 與 dummy/reference cell 造成的細微負載差異。

### 3.2 關鍵時序參數 (Timing Parameters)
透過模擬波形，我們成功標定並萃取出以下時序：
- **$t_{RCD}$ (Row Address to Column Address Delay)**：從 Wordline 開啟 (Row Active) 到可以下達 Column Select (進行讀寫) 所需的時間。主要由 Charge Sharing 與 SA 放大的時間決定。
- **$t_{RAS}$ (Row Active Time)**：Wordline 必須保持開啟的最短時間，確保 Restore 或 Write Recovery 完整充電。
- **$t_{RP}$ (Row Precharge Time)**：關閉 Wordline 到下一次可以再次 Active 所需的等待時間，確保 Bitline 完全 Precharge 到 $V_{DD}/2$。
此設計成功在 1.2V 系統電壓下完成了高速 DRAM 陣列的核心控制與模擬。
