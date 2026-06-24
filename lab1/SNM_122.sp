* Exercise 1 (1:1:1 SNM)
.include '/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/7nm_TT.pm'

VDD vdd 0 0.7  
VSS vss 0 0
VWL wl 0 0    
VBL bl 0 0.7
VBLB blb 0 0.7

MP1 Q1 in_L vdd vdd pmos_rvt nfin=1
MN1 Q1 in_L vss vss nmos_rvt nfin=2

MP2 Q2 in_R vdd vdd pmos_rvt nfin=1
MN2 Q2 in_R vss vss nmos_rvt nfin=2

MN3 bl wl Q1 vss nmos_rvt nfin=2
MN4 blb wl Q2 vss nmos_rvt nfin=2

VinL in_L 0 0
VinR in_R 0 0

.option post=2 probe
.DC VinL 0 0.7 0.01
.DC VinL 0 0.7 0.01 SWEEP vdd 0.4 0.7 0.1
.print DC V(Q1)
