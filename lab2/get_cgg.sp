*  Cgg for nmos_sram
.INCLUDE '/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/7nm_TT.pm'

.PARAM SUP=0.7V
Vdd VDD 0 'SUP'
Vss VSS 0 0

M_pass Drain Gate VSS VSS nmos_sram NFIN=1 L=21n
V_G Gate 0 'SUP'
V_D Drain 0 'SUP'
.OP
.OPTION POST=1
.END
