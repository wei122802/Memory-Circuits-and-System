* Exercise 1 (1:2:2 WNM)
.include '/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/7nm_TT.pm'

.param v_vdd = 0.7
.param v_wl = v_vdd  

VDD vdd 0 v_vdd  
VSS vss 0 0
VWL wl 0 v_wl     

VBL bl 0 0       
VBLB blb 0 v_vdd  

MP1 Q1 in vdd vdd pmos_rvt nfin=1
MN1 Q1 in vss vss nmos_rvt nfin=2
MN3 bl wl Q1 vss nmos_rvt nfin=2

MP2 Q2 in vdd vdd pmos_rvt nfin=1
MN2 Q2 in vss vss nmos_rvt nfin=2
MN4 blb wl Q2 vss nmos_rvt nfin=2

Vin in 0 0

.option post=2 probe

* ==============================================================
* A¡GWNM Sweep VDD (0.4V ~ 0.7V)
* ==============================================================
* .DC Vin 0 v_vdd 0.01 SWEEP v_vdd 0.4 0.7 0.1

* ==============================================================
*  B¡GWNM Sweep WL (0.5V ~ 0.9V¡AVDD=0.7V )
* ==============================================================
.DC Vin 0 0.7 0.01 SWEEP v_wl 0.5 0.9 0.1

.print DC V(Q1) V(Q2)
.end