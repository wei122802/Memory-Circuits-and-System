# Memory Circuits & Systems Lab 1: Static Noise Margin of SRAM

## 1. Specification Overview
本實驗旨在使用 7nm FinFET 模型分析 SRAM Cell 的 Static Noise Margin (SNM), Read Static Noise Margin (RSNM), 以及 Write Noise Margin (WNM)。
針對兩種不同 sizing ratio 的 SRAM Cell：
- High-Density (HD) 1:1:1 (Pull-Up PMOS : Pass-Gate NMOS : Pull-Down NMOS)
- High-Performance (HP) 1:2:2

量測條件包含：
- 不同的 Supply Voltage (VDD): 從 0.7V 降至 0.4V (此時 BL/WL 電壓與 VDD 同步)。
- 不同的 Wordline Voltage (WL): 在 VDD 保持 0.7V 的情況下，將 WL 從 0.9V 掃描至 0.5V。

同時，需針對 TA 提供的 1:1:1 佈局進行 RC Extraction，並完成 Post-Simulation 以與 Pre-Simulation 數據進行比較。

## 2. 實驗實作與模擬設定

### 2.1 測量方式 (Pre-sim)
- **SNM (Hold Margin)**: 透過斷開兩側 Inverter 的 cross-coupled 連線，分別掃描輸入電壓 (Vin)，觀察輸出電壓 (Vout) 形成的 Voltage Transfer Curve (VTC)。透過兩條 VTC 疊加繪製出 Butterfly Curve，並尋找最大的內切正方形面積，其邊長即為 SNM。此時 WL=0。
- **RSNM (Read Margin)**: 類似 SNM 的量測方式，但是此時 WL=VDD，且 BL/BLB precharge 到 VDD。觀察 Read 操作時的穩定度。
- **WNM (Write Margin)**: 量測寫入操作時的 VTC。例如欲將儲存節點從 1 寫入 0 時，將該側 BL 設為 0，並掃描另一側節點電壓，觀察該節點翻轉為 0 的點與 VDD/2 之間的距離，或依據定義測量相關的 margin。

### 2.2 HSPICE 模擬檔
使用 HSPICE 進行直流掃描 (`.DC`)：
- 對 Vin 進行 0 到 VDD 的掃描，並以 `.DC Vin 0 0.7 0.01 SWEEP vdd 0.4 0.7 0.1` 指令同時掃描不同的 VDD 條件。
- 為了產生 Butterfly Curve，我們透過 Python 腳本 (`butterfly.py`) 自動讀取 `.print` 出來的電壓數據，運用 scipy 進行插值運算並自動尋找最大內切正方形，最後透過 matplotlib 繪製出美麗的 Butterfly Curve。

### 2.3 Post-Simulation
- 將 layout 經過 LPE (Layout Parasitic Extraction) 萃取出包含寄生電阻及電容的 netlist。
- 替換掉原本的 ideal schematic netlist，再次執行相同條件的 HSPICE 模擬。
- 觀察寄生效應 (如接線電容、電阻) 造成的 VTC 偏移，以及 SNM/RSNM/WNM 的下降幅度。

## 3. 結論
透過 1:1:1 與 1:2:2 架構的比較，可以發現 1:2:2 由於 Pull-Down NMOS 較寬，其 Cell Ratio (CR) 較高，RSNM 會比 1:1:1 更好；同時 Pass-Gate NMOS 較寬也提供了較佳的 WNM (Pull-Up Ratio 較低)。此外，透過降低 VDD，所有的 Margin 均呈現明顯縮小趨勢。在 Post-sim 加入 RC 寄生參數後，Margin 亦會受到佈線影響而進一步劣化。本實驗成功建立了一套自動化的 SRAM 穩定度分析流程。
