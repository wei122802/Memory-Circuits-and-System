.title SRAM and Sense Amplifier Simulation
*****************************
**     Library setting     **
*****************************
.protect
.include '7nm_TT.pm'
.unprotect 

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

* --- Precharge Circuit ---
Mpre1 BL  PRE VDD VDD pmos_sram m=1
Mpre2 BLB PRE VDD VDD pmos_sram m=1
Mpre3 BL  PRE BLB VDD pmos_sram m=1 
* --- 6T SRAM Cell ---
X_SRAM WL BL BLB q qb SRAM

* ==========================================
*        Voltage-Mode Sense Amplifier
* ==========================================
* Mpass_l  BL   SAEN  sense    x  pmos_sram m=1
* Mpass_r  BLB  SAEN  sense_b  x  pmos_sram m=1

* Mpl  VDD      sense_b  sense    x  pmos_sram m=1
* Mpr  VDD      sense    sense_b  x  pmos_sram m=1
* Mnl  sense    sense_b  tail     x  nmos_sram m=1
* Mnr  sense_b  sense    tail     x  nmos_sram m=1

* Mfoot tail  SAEN  GND  x  nmos_sram m=1

* ==========================================
*        Current-Mode Sense Amplifier
* ==========================================
Mpre_sa1 sense   PRE VDD VDD pmos_sram m=1
Mpre_sa2 sense_b PRE VDD VDD pmos_sram m=1

Min_l  sense_b  BL   tail  x  nmos_sram m=1
Min_r  sense    BLB  tail  x  nmos_sram m=1

Mpl VDD sense_b sense   x pmos_sram m=1
Mpr VDD sense   sense_b x pmos_sram m=1
Mnl sense   sense_b tail  x nmos_sram m=1
Mnr sense_b sense   tail  x nmos_sram m=1

Mfoot tail  SAEN  GND  x  nmos_sram m=1

R_dummy SAEN SA_EN 0
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

* You should set the initial conditions for q and qb in the SRAM.
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
.tran 0.05ns 5ns 

.measure tp
+ TRIG v(SA_EN) VAL='0.35' rise=1
+ TARG v(sense) VAL='0.35' fall=1

.measure TRAN Avg_read_pwr avg POWER from=4n to=5n

.end