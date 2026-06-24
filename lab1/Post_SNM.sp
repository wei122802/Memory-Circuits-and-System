* Post-Sim (1:1:1 SNM)
.include '/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/7nm_TT.pm'
.include '/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/lab1/layout/SRAM_cell.pex.netlist'

VDD vdd 0 0.7  
VSS vss 0 0
VWL wl 0 0    
VBL bl 0 0.7
VBLB blb 0 0.7

X_PEX  wl blb bl 0 vdd 0 vdd in_L SRAM

VinL in_L 0 0
VinR in_R 0 0

.option post=2 probe
.DC VinL 0 0.7 0.01
.DC VinL 0 0.7 0.01 SWEEP vdd 0.4 0.7 0.1
.print DC V(X_PEX.N_QB_M1_d)