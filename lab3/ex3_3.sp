.title SA latch threshold voltage variation 
*****************************
**     Library setting     **
*****************************
.protect
.include '7nm_TT.pm'
.unprotect 

*******************************************
***  Monte Carlo Variation Parameters   ***
*******************************************
* Vth variation: You have to modify this for different cases.
.param sigma_vth = 0.015

.param dvth = AGAUSS(0, 'sigma_vth*3', 3)

*****************************
**       SubCircuit        **
*****************************
* Do not modify the SRAM cell circuit.
.subckt SRAM WL BL BLB q qb
Mpr  q   qb  VDD  x  pmos_sram  m=1
Mnr  q   qb  GND  x  nmos_sram  m=1

Mpl  qb  q  VDD  x  pmos_sram  m=1
Mnl  qb  q  GND  x  nmos_sram  m=1

Mnpr BL  WL  q    x  nmos_sram  m=1
Mnpl BLB WL  qb   x  nmos_sram  m=1
.ends


*****************************
**   Circuit Description   **
*****************************
Mpre1   BL  PRE VDD VDD pmos_sram m=1
Mpre2   BLB PRE VDD VDD pmos_sram m=1
Mpre_eq BL  PRE BLB VDD pmos_sram m=4 

X_SRAM WL BL BLB q qb SRAM

Min_l  sense_b  BL   tail  x  nmos_sram m=4 
Min_r  sense    BLB  tail  x  nmos_sram m=4 

Mpl VDD      sense_b  sense    x  pmos_sram m=2  delvtrand='dvth'
Mpr VDD      sense    sense_b  x  pmos_sram m=2  delvtrand='dvth'
Mnl sense    sense_b  tail     x  nmos_sram m=2  delvtrand='dvth'
Mnr sense_b  sense    tail     x  nmos_sram m=2  delvtrand='dvth'

Mfoot tail  SAEN  GND  x  nmos_sram m=4

Mpre_sa1 sense   PRE VDD VDD pmos_sram m=1
Mpre_sa2 sense_b PRE VDD VDD pmos_sram m=1
Mpre_sa_eq sense PRE sense_b VDD pmos_sram m=2 

* You should add the Vth variation(delvtrand='dvth') to the cross-coupled latch in the SA
* If not, you will fail this part
* Example:
* Mpl  node_1  in      in_b  x  pmos_sram m=1  delvtrand='dvth'
* Mnl    in_b  in    node_2  x  nmos_sram m=1  delvtrand='dvth'
* Mpr  node_1  in_b      in  x  pmos_sram m=1  delvtrand='dvth'
* Mnr      in  in_b  node_2  x  nmos_sram m=1  delvtrand='dvth'


*****************************
**     Voltage Source      **
*****************************
* Do not modify below *
.global VDD GND
.param  BITCAP = 80f

VVDD VDD GND 0.7v

CBLB BLB GND BITCAP
CBL  BL  GND BITCAP

Vw WL   GND PULSE  ( 0V  0.7V     4ns  0.05ns  0.05ns  0.2ns   1ns )
Vp PRE  GND PULSE  ( 0V  0.7V     4ns  0.05ns  0.05ns  0.35ns  1ns )
Vs SAEN GND PULSE  ( 0V  0.7V  4.25ns  0.05ns  0.05ns  0.1ns   1ns )
* Do not modify above *

*****************************
**    Initial Conditions   **
*****************************
* Do not modify the initial conditions for BL and BLB, which are both 0V.
* We assume there is no initial voltage on the bitlines before precharge.
.ic v(BL)  = 0v
.ic v(BLB) = 0v

* You should set the initial conditions for q and qb in every SRAMs.
* q should be 0V and qb should be 0.7V, which means the SRAM cell is storing "0".
.ic v(q) = 0v
.ic v(qb) = 0.7v

*****************************
**    Simulator setting    **
*****************************
.op
.option post 
.options probe
.probe v(*) i(*)

* Do Not Modify !!!
.options cshunt=1e-15
.option seed=random
.tran 0.05ns 5ns SWEEP MONTE=1000

.measure tran V_final FIND v(sense) AT=4.37n

* Check if read 0 is successful. 
.measure tran Read_0_Success param='V_final < 0.35 ? 1 : 0'

.end