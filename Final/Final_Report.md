# Memory Circuits & Systems Final Project: 2kb SRAM Design

## 1. Specification Overview
本期末專題的目標是完成一個 2kb (128 x 16) 的 SRAM 完整硬體設計，包含核心陣列與所有周邊控制電路。
主要規格如下：
- **容量**：2kb，架構為 128 Rows $\times$ 16 Columns (實體佈局上通常會透過 Column MUX 進行更寬的陣列設計以優化長寬比，例如 64 $\times$ 32)。
- **操作頻率**：最低 1GHz。
- **輸入緩衝**：為避免測試環境提供無限驅動能力，所有輸入訊號均須通過至少一個最小尺寸的 Buffer。
- **訊號邊緣時間**：所有輸入訊號的 Rise Time 與 Fall Time 皆為 50ps。
- **I/O 介面**：
  - `Clock`：時脈輸入。
  - `A[6:0]`：7-bit 位址線，可尋址 128 個 Word。
  - `D[15:0]`：16-bit 寫入資料輸入。
  - `WEN`：Write Enable (1 代表 Write 操作，0 代表 Read 操作)。
  - `Q[15:0]`：16-bit 讀取資料輸出。
- **模擬要求**：SRAM Array 與 Column-based 周邊電路「必須」進行 Post-layout Simulation (萃取 RC 後模擬)。Row-based 與 Global 控制電路則可選擇性進行 Post-sim。

## 2. 系統架構設計

我們在 `SRAM_2KB.sp` 測試檔中完整建構了這顆 2kb SRAM 的 HSPICE Netlist。系統大致分為以下幾個子模組：

### 2.1 基礎邏輯與 Buffer Tree
- **INV_MIN / BUF_MIN**：滿足 SPEC 要求的「最小輸入緩衝」。
- **驅動級 Buffer**：由於 WL (Wordline) 需驅動整列 Cell、CLK 需驅動所有周邊，因此實作了 `BUF_X4`, `BUF_X16`, `BUF_X64` 等大驅動力的 Buffer 進行 Fan-out 分配。

### 2.2 SRAM Array (核心陣列)
- 使用 7nm FinFET 製程的 `pmos_sram` 與 `nmos_sram` 模型實作標準 6T SRAM Cell。
- 為了正確模擬寄生效應並進行驗證，測試檔中手動展開了龐大的 Cell 陣列。

### 2.3 Row-based Peripheral Circuits (列周邊電路)
- **Row Decoder**：利用 Lab 2 所建立的技術，採用 3 組 2-to-4 pre-decoder 結合而成的 `ROW_DECODER_3X2TO4`。負責將 `A[6:1]` (6-bit) 解碼並驅動 64 條物理 Wordline。

### 2.4 Column-based Peripheral Circuits (行周邊電路)
封裝在 `COL_PERIPHERAL` 子電路中，負責處理 Bitline 上的所有訊號：
- **Precharge Unit**：在讀寫操作前將 Bitline 預充電至 VDD。
- **Column MUX (2-to-1)**：利用 `A[0]` 選擇哪兩條相鄰的實體 Bitline 要連接到一組 Sense Amplifier 與 Write Driver。這使得實體陣列可以設計為 64 (Row) $\times$ 32 (Col)，並透過 2-to-1 MUX 吐出 16-bit 資料，優化陣列長寬比。
- **Sense Amplifier & Latch**：採用高效的差動感測放大器，快速放大 Bitline 微小壓差並鎖存輸出至 `Q_OUT`。
- **Write Driver**：強力的 Inverter 驅動器，負責在寫入模式 (`WEN=1`) 時強勢覆蓋 Bitline 電壓。

### 2.5 Global Control Circuits (全域控制電路)
封裝在 `GLOBAL_CTRL` 子電路中，負責由單一 `Clock` 產生內部操作所需的精確時序：
- 利用 Inverter Chain (Delay Line) 延遲時脈，產生 `SA_EN` (感測致能) 訊號。
- 整合 `WEN` 與 `CLK`，產生 `PRE` (Precharge 關閉)、`WR_EN` (Write Driver 開啟) 等同步控制訊號。

## 3. 讀寫操作與驗證
- **寫入操作 (Write)**：`WEN` 為 High。`CLK` 上升沿觸發後，`PRE` 關閉，Address 解碼開啟對應 Wordline，同時 `WR_EN` 開啟，資料寫入 Bitline 並覆寫 Cell。
- **讀取操作 (Read)**：`WEN` 為 Low。`CLK` 上升沿觸發後，`PRE` 關閉，Wordline 開啟，Bitline 發生放電。隨後 Delay Line 觸發 `SA_EN` 開啟，放大壓差，保證在下一個 Clock Edge 前 `Q[15:0]` 輸出有效 (Valid) 資料。
- 透過 HSPICE Transient Analysis (搭配 Gear Method 與 CAPTAB) 驗證在 1GHz 操作頻率下的正確性，確保這套複雜的自我時序 (Self-timed) 邏輯完美運作。
