* ========================================================
* EX4 Part 1: DRAM Main Simulation (7nm)
* ========================================================
.include "../7nm_TT.pm"

.param VDD = 0.7V
.param VHALF = 'VDD/2'
.param C_cell = 20fF
.param C_bl = 60fF

* 1. DRAM 1T1C Cell
M_Ta Bitline1 WL cell_node 0 nmos_rvt L=7n W=21n
C_storage cell_node Vref 'C_cell'

* 2. Sensing Circuit (Sense Amplifier)
M_Tn1 Bitline1 Bitline2 SAN 0 nmos_rvt L=7n W=42n
M_Tn2 Bitline2 Bitline1 SAN 0 nmos_rvt L=7n W=42n
M_Tp1 Bitline1 Bitline2 SAP VDD_net pmos_rvt L=7n W=84n
M_Tp2 Bitline2 Bitline1 SAP VDD_net pmos_rvt L=7n W=84n

* 3. Voltage Equalization Circuit
M_Te1 Bitline1 EQ Vref 0 nmos_rvt L=7n W=42n
M_Te2 Bitline2 EQ Vref 0 nmos_rvt L=7n W=42n
M_Te3 Bitline1 EQ Bitline2 0 nmos_rvt L=7n W=42n

* 4. Parasitic Load
C_BL1 Bitline1 0 'C_bl'
C_BL2 Bitline2 0 'C_bl'

* 5. Write Driver & Column Switch
M_Tc1 Bitline1 CSL Output1 0 nmos_rvt L=7n W=42n
M_Tc2 Bitline2 CSL Output2 0 nmos_rvt L=7n W=42n
M_Tw1 Output1 WE Input1 0 nmos_rvt L=7n W=84n
M_Tw2 Output2 WE Input2 0 nmos_rvt L=7n W=84n

C_Out1 Output1 0 10fF
C_Out2 Output2 0 10fF

.include 'pattern.sp'
.ic v(cell_node)=0.7V v(Bitline1)='VHALF' v(Bitline2)='VHALF'
.tran 0.1n 110n uic sweep C_bl POI 4 60fF 80fF 100fF 120fF
.meas tran V_sharing FIND v(Bitline1) AT=19.9n
.meas tran T_sense trig v(SAP) val=0.4 rise=1 TD=18n targ v(Bitline1) val=0.63 rise=1 TD=18n
.option post=1
.end
