* 6-to-64 Row Decoder Testbench

* 1. 引入模型與 Netlist
.INCLUDE '/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/7nm_TT.pm'
.INCLUDE "decoder_netlist.sp"

* 2. 設定
.GLOBAL VDD VSS
.PARAM SUP=0.7V
Vdd VDD 0 'SUP'
Vss VSS 0 0

* 3. 激發訊號 (1GHz)
V_CLK CLK 0 PULSE(0 'SUP' 0 0.1n 0.1n 0.4n 1n)

* Address Signals (維持你的計數器設定)
V_A0 A0 0 PULSE(0 'SUP' 0.5n 0.1n 0.1n 0.8n  2n)   
V_A1 A1 0 PULSE(0 'SUP' 1.5n 0.1n 0.1n 1.8n  4n)   
V_A2 A2 0 PULSE(0 'SUP' 3.5n 0.1n 0.1n 3.8n  8n)   
V_A3 A3 0 PULSE(0 'SUP' 7.5n 0.1n 0.1n 7.8n  16n)   
V_A4 A4 0 PULSE(0 'SUP' 15.5n 0.1n 0.1n 15.8n 32n) 
V_A5 A5 0 PULSE(0 'SUP' 31.5n 0.1n 0.1n 31.8n 64n)

* 4. 實體化 Decoder
XDUT A5 A4 A3 A2 A1 A0 
+ WL0 WL1 WL2 WL3 WL4 WL5 WL6 WL7 WL8 WL9 WL10 WL11 WL12 WL13 WL14 WL15 
+ WL16 WL17 WL18 WL19 WL20 WL21 WL22 WL23 WL24 WL25 WL26 WL27 WL28 WL29 WL30 WL31 
+ WL32 WL33 WL34 WL35 WL36 WL37 WL38 WL39 WL40 WL41 WL42 WL43 WL44 WL45 WL46 WL47 
+ WL48 WL49 WL50 WL51 WL52 WL53 WL54 WL55 WL56 WL57 WL58 WL59 WL60 WL61 WL62 WL63 
+ VDD VSS ROW_DECODER

* 5. 負載電容 (請填入你剛剛算出的 8.087f)
* 為了報告完整，建議 WL0 到 WL63 都要掛上負載 (可以用簡單的迴圈或手寫代表性的)
C_load0 WL0 0 8.087f
C_load1 WL1 0 8.087f
C_load2 WL2 0 8.087f
C_load3 WL3 0 8.087f
C_load4 WL4 0 8.087f
C_load5 WL5 0 8.087f
C_load6 WL6 0 8.087f
C_load7 WL7 0 8.087f
C_load8 WL8 0 8.087f
C_load9 WL9 0 8.087f
C_load10 WL10 0 8.087f
C_load11 WL11 0 8.087f
C_load12 WL12 0 8.087f
C_load13 WL13 0 8.087f
C_load14 WL14 0 8.087f
C_load15 WL15 0 8.087f
C_load16 WL16 0 8.087f
C_load17 WL17 0 8.087f
C_load18 WL18 0 8.087f
C_load19 WL19 0 8.087f
C_load20 WL20 0 8.087f 
C_load21 WL21 0 8.087f
C_load22 WL22 0 8.087f
C_load23 WL23 0 8.087f
C_load24 WL24 0 8.087f
C_load25 WL25 0 8.087f
C_load26 WL26 0 8.087f
C_load27 WL27 0 8.087f
C_load28 WL28 0 8.087f
C_load29 WL29 0 8.087f
C_load30 WL30 0 8.087f
C_load31 WL31 0 8.087f
C_load32 WL32 0 8.087f
C_load33 WL33 0 8.087f
C_load34 WL34 0 8.087f
C_load35 WL35 0 8.087f
C_load36 WL36 0 8.087f
C_load37 WL37 0 8.087f
C_load38 WL38 0 8.087f
C_load39 WL39 0 8.087f
C_load40 WL40 0 8.087f
C_load41 WL41 0 8.087f
C_load42 WL42 0 8.087f
C_load43 WL43 0 8.087f
C_load44 WL44 0 8.087f
C_load45 WL45 0 8.087f
C_load46 WL46 0 8.087f
C_load47 WL47 0 8.087f
C_load48 WL48 0 8.087f
C_load49 WL49 0 8.087f
C_load50 WL50 0 8.087f
C_load51 WL51 0 8.087f
C_load52 WL52 0 8.087f
C_load53 WL53 0 8.087f
C_load54 WL54 0 8.087f
C_load55 WL55 0 8.087f
C_load56 WL56 0 8.087f
C_load57 WL57 0 8.087f
C_load58 WL58 0 8.087f
C_load59 WL59 0 8.087f
C_load60 WL60 0 8.087f
C_load61 WL61 0 8.087f
C_load62 WL62 0 8.087f
C_load63 WL63 0 8.087f

* 6. 模擬設定
.TRAN 10p 65n
* .OPTION FSDB
.OPTION POST=1

* 7. 修改後的量測指令

* --- Delay 量測 (挑選第一個和最後一個) ---
* 量測 WL0 (發生在第一個 CLK 週期)
* .MEASURE TRAN dly_WL0 TRIG v(CLK) VAL='SUP/2' RISE=1 TARG v(WL0) VAL='SUP/2' RISE=1
* * 量測 WL63 (發生在第 64 個 CLK 週期，也就是 63.5ns 左右)
* .MEASURE TRAN dly_WL63 TRIG v(CLK) VAL='SUP/2' RISE=64 TARG v(WL63) VAL='SUP/2' RISE=1

* --- Power 量測 (量測完整 64 個週期的平均功耗) ---
* 我們量測從 Vdd 流出的電流絕對值，這樣 Power 就會是正的
.MEASURE TRAN avg_pwr AVG '-p(Vdd)' FROM=0 TO=64n

.END