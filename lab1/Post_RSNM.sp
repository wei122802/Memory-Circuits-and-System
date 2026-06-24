* Post-Sim (1:1:1 RSNM)
.include '/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/7nm_TT.pm'
.include '/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/lab1/layout/SRAM_cell.pex.netlist'

.param v_vdd = 0.7
.param v_wl = v_vdd  

VDD vdd 0 v_vdd  
VSS vss 0 0
VWL wl 0 v_wl     
VBL bl 0 v_vdd    
VBLB blb 0 v_vdd  

X_PEX  wl blb bl 0 vdd 0 vdd in_L SRAM

VinL in_L 0 0
VinR in_R 0 0

.option post=2 probe

* ==============================================================
* A¡GRSNM Sweep VDD (0.4V ~ 0.7V)
* ==============================================================
* .DC VinL 0 v_vdd 0.01 SWEEP v_vdd 0.4 0.7 0.1

* ==============================================================
*  B¡GRSNM Sweep WL (0.5V ~ 0.9V¡AVDD=0.7V )
* ==============================================================
.DC VinL 0 0.7 0.01 SWEEP v_wl 0.5 0.9 0.1

.print DC V(X_PEX.N_QB_M1_d)

.end