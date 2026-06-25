# Memory Circuits & Systems Lab 2: 6-to-64 Row Decoder Design

## 1. Specification Overview
本實驗的目標是設計一個用於 SRAM 陣列的 6-to-64 Row Decoder (列解碼器)。
主要規格如下：
- **操作頻率**：1GHz (50% Duty Cycle)。
- **時序控制**：Address 訊號於 Clock 的下降沿 (falling edge) 改變，Wordline 則於 Clock 為 High 時 (clock is 1) 觸發 (asserted)。
- **輸入端**：所有的輸入訊號 (包含 Address 與 Clock) 都必須先連接至 Buffer，避免理想訊號源提供無限的驅動能力。
- **邊緣時間**：輸入訊號的 Rise Time 與 Fall Time 皆設定為 0.1ns。
- **負載電容 (Wordline Capacitance)**：每個 Wordline 掛載了 64 顆 1:2:2 SRAM Cell 的 Pass-Gate NMOS 閘極電容與對應的 7nm Wire Loading。
- **自動化化生成**：需透過高階語言程式 (如 Python 或 AI) 自動生成含有大量重複結構的 Netlist 供 HSPICE 模擬。

## 2. 實驗實作與架構設計

### 2.1 架構設計 (Architecture)
為了實作 6-to-64 的解碼，我們採用了分層解碼 (Hierarchical Decoding) 或 Pre-decoding 架構：
1. **輸入 Buffer 級**：將 `A[5:0]` 與 `CLK` 先通過 Inverter Chain 緩衝，產生強健的 `A` 與 `A_bar` 訊號。
2. **Pre-decoder (預解碼器)**：將 6 bit 分組 (例如 3-to-8 搭配 3-to-8，或 2-to-4 分組) 進行第一階的解碼，以降低最終輸出級的電晶體堆疊數量 (stacking depth) 並減少走線複雜度。
3. **Final Decoder (最終輸出級)**：利用 NAND/NOR 邏輯閘搭配 Clock 進行同步。當對應的 Address 命中且 CLK 為 High 時，最終透過一個強大的 Inverter (Wordline Driver) 將 WL 拉升至 VDD。

### 2.2 Wire Loading 估算 (Capacitance Estimation)
Wordline 的總負載電容由兩部分組成：
1. **Gate Capacitance ($C_{gate}$)**：1:2:2 架構下，Pass-Gate NMOS 的寬度比例為 2。單顆 Cell 貢獻 2 個 Pass-Gate 閘極電容。一行 64 顆 SRAM Cell 貢獻總計 $64 \times 2 \times C_{pg}$。
2. **Wire Capacitance ($C_{wire}$)**：根據 7nm 製程參數，Wordline 跨越 64 顆 SRAM Cell 的總實體長度，乘上單位長度的金屬線寄生電容。
經過計算，最終將單一 Wordline 的總等效負載電容設定為 `8.087 fF`。在 `decoder.sp` 測試檔中，我們為 WL0 到 WL63 每一條線都掛上了 `8.087fF` 的負載 (`C_load`).

### 2.3 自動化 Netlist 生成
考量到 64 條 Wordline 與其對應邏輯閘的宣告極度繁瑣且易錯，我們實作了 Python 腳本 (`decoder.py`)。該腳本利用字串格式化與迴圈：
- 自動展開 64 組 Decoder 的連接關係。
- 自動化宣告每一級的邏輯閘 (NAND, NOR, Inverter)。
- 輸出完整的 `decoder_netlist.sp` 檔案供主測試檔引入 (`.INCLUDE`)。

## 3. 模擬與分析 (Delay & Power)
利用 HSPICE 執行 64 個 Clock Cycle 的 Transient Analysis (0~65ns)：
- **功能驗證**：觀察 `WL0` 到 `WL63` 是否依序在對應的 Clock High 期間正確升起，確保 Decoder 邏輯無誤。
- **Delay 測量**：透過 `.MEASURE TRAN` 測量 `CLK` 上升沿到 `WL` 上升沿 (50% VDD) 的延遲時間。
- **Power 測量**：使用 `.MEASURE TRAN avg_pwr AVG '-p(Vdd)'` 指令，計算在跑完 64 個位址切換週期內的平均動態功耗。

透過此實驗，成功驗證了在高頻 1GHz 操作且掛載真實 SRAM 負載下，Row Decoder 的功能與效能表現。
