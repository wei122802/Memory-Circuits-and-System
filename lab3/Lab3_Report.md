# Memory Circuits & Systems Lab 3: Sensing Amplifier

## 1. Specification Overview
本實驗探討 SRAM 在讀取模式下的感測放大器 (Sensing Amplifier, SA) 設計與強健性分析。
實驗主要涵蓋以下目標：
- **Sensing Amplifier 設計**：利用 7nm FinFET 模型設計並比較兩種 SA 架構：
  - 電壓模式 (Voltage-mode) Sensing Amplifier
  - 電流模式 (Current-mode) Sensing Amplifier
- **操作環境設定**：使用單一 6T SRAM Cell 模擬，並在 BL 與 BLB 掛載 `80 fF` 的等效電容 (相當於 1 個 column 具有 512 顆 SRAM Cell 的線負載)。
- **效能比較**：比較兩種 SA 在讀取功耗 (Read Power) 與感測速度 (Sensing Timing) 的差異。
- **強健性測試 (Robustness)**：透過 1000 次 Monte Carlo 模擬，評估 SA 在以下兩種非理想效應下的表現：
  1. **Bitline Voltage Offset**：BL/BLB 初始電壓存在常態分佈偏差 ($\Delta V$ 遵循 $\sigma = 20mV$)。需保證 100% 的讀取正確率。
  2. **$V_{th}$ Variation**：感測放大器內部 4 顆 cross-coupled latch 電晶體的閾值電壓產生飄移。Case 1 ($\sigma_{vth} = 0.01V$) 需達到 100% 正確率；Case 2 ($\sigma_{vth} = 0.015V$) 需分析正確率下降原因。

## 2. 架構設計與實作

### 2.1 Voltage-mode vs Current-mode SA
- **Voltage-mode SA**：透過 Pass Transistor 將 BL/BLB 直接耦合至內部 latch 節點。當 `SA_EN` 開啟時，依靠 BL/BLB 本身累積的微小壓降差驅動內部 Latch 進行正回授放大。由於其直接與高負載的 BL/BLB 連接，速度容易受限。
- **Current-mode SA**：使用輸入對電晶體 (Input Pair) 接收 BL/BLB 的電壓作為閘極輸入，將電壓差轉換為電流差，進而拉動內部的 Latch 節點。這隔離了龐大的 BL/BLB 電容負載，有助於加速 Sensing。
在 `ex3_1.sp` 檔中，我們建立了統一的測試環境，包含 Precharge, SRAM Cell, 以及兩種可切換的 SA 電路區塊。

### 2.2 模擬量測設定
- **初始條件**：SRAM 內部儲存節點初始設定為 `v(q) = 0v, v(qb) = 0.7v` (儲存資料 "0")。BL 與 BLB 初始設為 `0V`，等待 `PRE` 訊號將其拉升。
- **Sensing Delay**：透過 `.measure tp` 測量 `SA_EN` 訊號上升至 `0.35V` 到 `sense` 節點下降至 `0.35V` 的時間差。
- **Read Power**：利用 `.measure TRAN Avg_read_pwr avg POWER from=4n to=5n` 量測讀取區間內的平均功耗。

## 3. 強健性分析 (Monte Carlo Simulation)

### 3.1 Bitline Voltage Offset
實際 SRAM 操作中，Precharge 可能不完美導致 BL/BLB 存在初始電壓差。我們透過 Monte Carlo 模型引入 $\sigma = 20mV$ 的高斯分佈電壓源。因為 Current-mode SA 的隔離特性及較大的 Gain，其抵抗 Offset 的能力較強，在此條件下成功達成 100% 的讀取正確率。

### 3.2 Transistor Vth Variation
Cross-coupled latch 是 SA 放大的核心，若左右兩側的 $V_{th}$ 不匹配，可能導致正回授方向顛倒。
- **Case 1 ($\sigma_{vth} = 0.01V$)**：Mismatch 範圍在設計容忍度內，成功測得 100% 的正確率 (自 `.mt` 檔案讀取成功次數除以 1000 得之)。
- **Case 2 ($\sigma_{vth} = 0.015V$)**：隨著變異量增加，正確率開始下降。根本原因在於，當內部的 $V_{th}$ 差異產生的偏置電流大於 BL/BLB 傳入的訊號電流時，Latch 將往錯誤的方向鎖存。
- **改善方案**：可透過稍微增大 Latch 內部電晶體的 Size (降低隨機變異的影響)、增加 BL/BLB 的發展時間 (Sensing Delay) 以獲取更大的訊號差，或是改用具備 Offset Cancellation 能力的 SA 架構來提升強健性。
