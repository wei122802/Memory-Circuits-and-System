# Memory Circuits & Systems (記憶體電路與系統設計)

此儲存庫包含了 2026 記憶體電路與系統設計 (Memory Circuits & Systems) 課程的所有實驗 (Labs) 與期末專題 (Final Project) 的實作原始碼與分析報告。本課程著重於先進製程 (7nm/22nm FinFET) 下 SRAM 與 DRAM 的電路設計、周邊控制電路實作，以及記憶體控制器的系統級模擬分析。

## 目錄結構與實驗總覽

本專案分為五個核心實驗與一個期末大型專題，涵蓋了從 Device-level 穩定度分析、Circuit-level 陣列與周邊設計，到 System-level 的效能模擬。

### [Lab 1: Static Noise Margin of SRAM](file:///c:/Users/林佳葦/Desktop/碩一下/Memory/Lab/lab1/Lab1_Report.md)
- **核心內容**：SRAM Cell 穩定度分析。
- **實作細節**：使用 7nm FinFET 模型，針對 1:1:1 與 1:2:2 比例的 SRAM Cell，在不同 VDD 與 WL 電壓下測量 Static Noise Margin (SNM)、Read Margin (RSNM) 以及 Write Margin (WNM)。結合 Python 腳本自動萃取 Butterfly Curve，並完成 LPE (Layout Parasitic Extraction) 的 Post-simulation 比較。

### [Lab 2: 6-to-64 Row Decoder Design](file:///c:/Users/林佳葦/Desktop/碩一下/Memory/Lab/lab2/Lab2_Report.md)
- **核心內容**：SRAM 列解碼器設計與自動化。
- **實作細節**：設計符合 1GHz 操作頻率的 6-to-64 Row Decoder。實作中考慮了真實 64 顆 SRAM Cell 帶來的 Pass-Gate 與 7nm Wire Loading 負載 (8.087 fF)。透過 Python 腳本自動生成龐大的 HSPICE Netlist，並分析其 Delay 與 Power。

### [Lab 3: Sensing Amplifier](file:///c:/Users/林佳葦/Desktop/碩一下/Memory/Lab/lab3/Lab3_Report.md)
- **核心內容**：感測放大器設計與強健性分析。
- **實作細節**：設計並比較 Voltage-mode 與 Current-mode Sensing Amplifier 在 SRAM 讀取上的效能。利用 Monte Carlo 模擬分析 SA 在 Bitline Voltage Offset ($\Delta V$) 與電晶體 $V_{th}$ 變異下的讀取正確率，探討 Mismatch 對正回授 Latch 的致命影響。

### [Lab 4: DRAM Differential Sense Amplifier](file:///c:/Users/林佳葦/Desktop/碩一下/Memory/Lab/lab4/Lab4_Report.md)
- **核心內容**：DRAM 讀寫操作與時序分析。
- **實作細節**：利用 22nm 製程模型實作 1T1C (20 fF) DRAM Array 的讀寫操作 (Precharge, Access, Sense, Restore, Write Recovery)。結合 512x512 陣列的寄生 RC 負載模型，精確萃取並測量出核心時序參數 ($t_{RCD}$, $t_{RAS}$, $t_{RP}$)，並分析 Bitline 與 Cell 電容比例對 Charge Sharing 的影響。

### [Lab 5: Ramulator 2.0 DRAM Controller Simulator](file:///c:/Users/林佳葦/Desktop/碩一下/Memory/Lab/lab5/Lab5_Report.md)
- **核心內容**：系統層級 DRAM 控制器模擬。
- **實作細節**：跳脫電路層級，進入 C++ 架構的 Cycle-level 模擬器 Ramulator 2.0。探討 Address Mapping (更改位址映射順序以提升平行度與頻寬) 以及 Row Policy (比較 Open-row 與 Close-row policy 在 Sequential 與 Random traces 下的 Row Conflict/Hit 表現差異)。

### [Final Project: 2kb SRAM Design](file:///c:/Users/林佳葦/Desktop/碩一下/Memory/Lab/Final/Final_Report.md)
- **核心內容**：全客製化 (Full-custom) 2kb SRAM 記憶體整合設計。
- **實作細節**：整合 Lab 1 ~ Lab 3 的技術，完成 128 $\times$ 16 (2kb) 的 SRAM 陣列設計。設計包含了具有強健驅動力的 Clock Buffer Tree、Column MUX、Precharge、Sense Amplifier 與 Write Driver。成功在 1GHz 頻率下驗證 Self-timed 的寫入與讀取時序，並通過嚴格的 Post-simulation。

---
*詳細的規格與模擬結果請點擊上方各實驗的報告連結進行查看。*
