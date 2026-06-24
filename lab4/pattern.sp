* ========================================================
* Input Pattern: Continuous Read & Write Lifecycle
* ========================================================
V_VDD VDD_net 0 'VDD'
V_Vref Vref 0 'VHALF'

V_In1 Input1 0 PWL(0 0.7V 35n 0.7V 36n 0V) 
V_In2 Input2 0 PWL(0 0V 35n 0V 36n 0.7V)

* 1. EQ 
V_EQ EQ 0 PWL(0 'VDD' 10n 'VDD' 10.1n 0 60n 0 60.1n 'VDD' 70n 'VDD' 70.1n 0)

* 2. WL 
V_WL WL 0 PWL(0 0 12n 0 12.1n 'VDD' 55n 'VDD' 55.1n 0 75n 0 75.1n 'VDD' 100n 'VDD' 100.1n 0)

* 3. SAN
V_SAN SAN 0 PWL(0 'VHALF' 20n 'VHALF' 20.1n 0 55n 0 55.1n 'VHALF' 83n 'VHALF' 83.1n 0)

* 4. SAP
V_SAP SAP 0 PWL(0 'VHALF' 20n 'VHALF' 20.1n 'VDD' 55n 'VDD' 55.1n 'VHALF' 83n 'VHALF' 83.1n 'VDD')

* 5. CSL & WE 
V_CSL CSL 0 PWL(0 0 40n 0 40.1n 'VDD' 50n 'VDD' 50.1n 0)
V_WE WE 0 PWL(0 0 40n 0 40.1n 'VDD' 50n 'VDD' 50.1n 0)


* 0n~10n   : [Read] Step 1 Precharge
* 12n~35n  : [Read] Step 2~4 Access, Sense, Restore 
* 40n~50n  : [Write] Step 4 Write 
* 50n~60n  : [Write] Step 5 Write Recovery 
* 60n~70n  : [Read]  Step 1 Precharge，
* 75n~100n : [Read]  Step 2~4 Access & Sense 