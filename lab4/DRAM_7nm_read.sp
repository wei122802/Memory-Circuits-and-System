* ========================================================
* EX4 Part 1: DRAM Read Mode Only
* Technology: 7nm Model | Voltage: 0.7V
* ========================================================

.include "/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/7nm_TT.pm"

.param VDD = 0.7V
.param VHALF = 'VDD/2'
.param C_cell = 20fF
.param C_bl = 60fF 

* 1. 儲存單元 (DRAM 1T1C Cell)
M_Ta Bitline1 WL cell_node 0 nmos_rvt L=7n W=21n
C_storage cell_node Vref 'C_cell' 

* 2. 感測放大器 (Sensing Circuit)
M_Tn1 Bitline1 Bitline2 SAN 0 nmos_rvt L=7n W=42n
M_Tn2 Bitline2 Bitline1 SAN 0 nmos_rvt L=7n W=42n
M_Tp1 Bitline1 Bitline2 SAP VDD_net pmos_rvt L=7n W=84n
M_Tp2 Bitline2 Bitline1 SAP VDD_net pmos_rvt L=7n W=84n

* 3. 預充與等化電路 (Voltage Equalization Circuit)
M_Te1 Bitline1 EQ Vref 0 nmos_rvt L=7n W=42n
M_Te2 Bitline2 EQ Vref 0 nmos_rvt L=7n W=42n
M_Te3 Bitline1 EQ Bitline2 0 nmos_rvt L=7n W=42n

* 4. 寄生電容 (Bitline Parasitic Capacitance)
C_BL1 Bitline1 0 'C_bl'
C_BL2 Bitline2 0 'C_bl'

* ========================================================
* [報告截圖區塊] Input Pattern (Read Mode)
* ========================================================
V_VDD VDD_net 0 'VDD'
V_Vref Vref 0 'VHALF'

* 步驟 1: Precharge (0~10ns)
V_EQ EQ 0 PWL(0 'VDD' 10n 'VDD' 10.1n 0)

* 步驟 2: Access (12ns 啟動 Wordline)
V_WL WL 0 PWL(0 0 12n 0 12.1n 'VDD' 50n 'VDD' 50.1n 0)

* 步驟 3 & 4: Sense & Restore (20ns 啟動 SA)
V_SAN SAN 0 PWL(0 'VHALF' 20n 'VHALF' 20.1n 0)
V_SAP SAP 0 PWL(0 'VHALF' 20n 'VHALF' 20.1n 'VDD')

* Read Mode 下關閉寫入相關控制
V_CSL CSL 0 DC 0
V_WE WE 0 DC 0
* ========================================================

* 初始狀態：設定 Cell 內部存有資料 '1' (0.7V)
.ic v(cell_node)=0.7V v(Bitline1)='VHALF' v(Bitline2)='VHALF'

* 掃描寄生電容比例 (3:1, 4:1, 6:1)
.step param C_bl list 60fF 80fF 120fF

* 測量 Charge Sharing 結束瞬間 (19.9ns) 的 Bitline1 電壓
.meas tran V_sharing param v(Bitline1) TD=19.9n

* 測量 SA 啟動到 Bitline1 拉升至 0.63V 的時間
.meas tran T_sense trig v(SAP) val=0.35 rise=1 targ v(Bitline1) val=0.63 rise=1

.tran 0.1n 60n uic
.option post=1
.end