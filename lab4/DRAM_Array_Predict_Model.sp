* ========================================================
* EX4: 32KB DRAM Array (22nm) HSPICE Simulation Template
* Modified from CMU-SAFARI CLRDRAM for HSPICE compatibility
* ========================================================

* Include 22nm PTM Transistor Model
.include "./22nm.pm"

* --------------------------------------------------------
* 1. SENSE AMPLIFIER (Cross-coupled Latch)
* --------------------------------------------------------
* [STUDENT TODO 1]: Implement the Sense Amplifier circuit.
* Hints: 
* - Use cross-coupled PMOS and NMOS pairs.
* - Connect the NMOS pair to 'sense_N' and the PMOS pair to 'sense_P' .
* - Connect the cross-coupled inputs/outputs to 'bitline0' and 'bitline1'.
* - Please use the pre-defined parameters for transistor sizes:
*   For NMOS latch: l=SA_nmos_L w=SA_nmos_W
*   For PMOS latch: l=SA_pmos_L w=SA_pmos_W
*   For Enable NMOS: l=SA_nset_L w=SA_nset_W
*   For Enable PMOS: l=SA_pset_L w=SA_pset_W

* << Write your SA circuit here >>
* NMOS Cross-coupled pair (Tn1, Tn2)
M_Tn1 bitline0 bitline1 sense_N 0 nmoslp L=SA_nmos_L W=SA_nmos_W
M_Tn2 bitline1 bitline0 sense_N 0 nmoslp L=SA_nmos_L W=SA_nmos_W

* PMOS Cross-coupled pair (Tp1, Tp2)
M_Tp1 bitline0 bitline1 sense_P VDD pmoslp L=SA_pmos_L W=SA_pmos_W
M_Tp2 bitline1 bitline0 sense_P VDD pmoslp L=SA_pmos_L W=SA_pmos_W

* --------------------------------------------------------
* 2. PRECHARGE & EQUALIZATION CIRCUIT
* --------------------------------------------------------
* [STUDENT TODO]: Implement the Precharge and Equalization circuit.
* Hints:
* - Use an Equalization signal (e.g., 'Eq') to short 'bitline0' and 'bitline1'.
* - Precharge the bitlines to 'VDDby2'.

* << Write your Precharge circuit here >>
M_Te1 bitline0 Eq VDDby2 0 nmoslp L=SA_eq_L W=SA_eq_W

* Te2: Precharge bitline1 to VDDby2
M_Te2 bitline1 Eq VDDby2 0 nmoslp L=SA_eq_L W=SA_eq_W

* Te3: Equalize bitline0 and bitline1
M_Te3 bitline0 Eq bitline1 0 nmoslp L=SA_eq_L W=SA_eq_W


* --------------------------------------------------------
* 3. DRAM CELL ARRAY (1T1C - Row 0 & Row 3)
* --------------------------------------------------------
M7 N001 ra0 mb0 0 nmoslp l=access_tran_L  w=access_tran_W 
cell_cap_0 mb0 PV cell_cap  IC=cell_0_ic 

M8 N007 ra3 mb3 0 nmoslp l=access_tran_L  w=access_tran_W 
cell_cap_2 mb3 PV cell_cap  IC=cell_2_ic

* --------------------------------------------------------
* 4. PARASITIC BITLINE RC NETWORK (Simulating 32KB Array Load)
* --------------------------------------------------------
XX1 N001 bitline0 bitline R=40 C=bitline_cap/512 
XX2 bitline1 N007 bitline R=40 C=bitline_cap/512 

* --------------------------------------------------------
* 5. WRITE DRIVER & COLUMN SELECT
* --------------------------------------------------------

M47 N003 WR_0 0 N004 NMOS l=SA_nWR_L  w=SA_nWR_W 
M54 WR_VDD WR_0 N003 N002 PMOS l=SA_pWR_L  w=SA_pWR_W 
M55 bitline0 CSEL N003 0 NMOS l=SA_CSEL_L  w=SA_CSEL_W 

M56 N006 WR_1 0 N008 NMOS l=SA_nWR_L  w=SA_nWR_W 
M57 WR_VDD WR_1 N006 N005 PMOS l=SA_pWR_L  w=SA_pWR_W 
M58 bitline1 CSEL N006 0 NMOS l=SA_CSEL_L  w=SA_CSEL_W 

* --------------------------------------------------------
* 6. POWER SUPPLIES
* --------------------------------------------------------
VDD_source VDD 0 core_voltage 
V_HALFVDD VDDby2 0 'core_voltage/2' 
V_PV PV 0 plate_voltage 
V_WRVDD WR_VDD 0 core_voltage 
V_WR0 WR_0 0 core_voltage 
V_WR1 WR_1 0 0
V_RA3_ideal node_ra3_ideal 0 0
R_RA3 node_ra3_ideal ra3 'wordline_R*WL_res_factor'
C_RA3 ra3 0 'wordline_C*WL_cap_factor'

* ========================================================
* DRAM Control Signals
* ========================================================
* [STUDENT TODO 3]: Define the timing (PULSE parameters) for Read/Write operation.
* Hint: Replace the '?' with proper voltage or time values.
* V_EQ Eq 0 PULSE(1.2 0 10n 0.5n 0.5n 80n 100n)
V_EQ Eq 0 PULSE(2.5 0 10n 0.5n 0.5n 80n 200n)

* Wordline (Access): 15ns 時升至 2.5V，脈衝寬度 65ns (80ns 時關閉)
V_RA0_ideal node_ra0_ideal 0 PULSE(0 'wordline_voltage*wl0_act' 15n 0.5n 0.5n 65n 100n)
R_RA0 node_ra0_ideal ra0 'wordline_R*WL_res_factor'
C_RA0 ra0 0 'wordline_C*WL_cap_factor'

* SAP (Sense P): 25ns 時升至 1.2V，維持 60ns (85ns 時關閉)
V_SP_ideal node_sp_ideal 0 PULSE('core_voltage/2' core_voltage 25n 0.5n 0.5n 60n 100n)
R_SP node_sp_ideal sense_P 100
C_SP sense_P 0 1fF

* SAN (Sense N): 25ns 時降至 0V，維持 60ns (85ns 時關閉)
V_SN_ideal node_sn_ideal 0 PULSE('core_voltage/2' 0 25n 0.5n 0.5n 60n 100n)
R_SN node_sn_ideal sense_N 100
C_SN sense_N 0 1fF

* CSEL (Column Select / Write): 50ns 時開啟 (2.5V)，寫入資料，維持 20ns (70ns 時關閉)
V_CSEL CSEL 0 PULSE(0 2.5 50n 0.5n 0.5n 20n 100n)
* ========================================================


* ========================================================
* PARASITIC SUBCIRCUIT DEFINITION
* ========================================================
* block symbol definitions
.subckt bitline L R
    R1 P001 L R 
    C1 P001 0 C 
    R2 P002 P001 R 
    C2 P002 0 C 
    R3 P003 P002 R 
    C3 P003 0 C 
    R4 P004 P003 R 
    C4 P004 0 C 
    R5 P005 P004 R 
    C5 P005 0 C 
    R6 P006 P005 R 
    C6 P006 0 C 
    R7 P007 P006 R 
    C7 P007 0 C 
    R8 P008 P007 R 
    C8 P008 0 C 
    R9 P009 P008 R 
    C9 P009 0 C 
    R10 P010 P009 R 
    C10 P010 0 C 
    R11 P011 P010 R 
    C11 P011 0 C 
    R12 P012 P011 R 
    C12 P012 0 C 
    R13 P013 P012 R 
    C13 P013 0 C 
    R14 P014 P013 R 
    C14 P014 0 C 
    R15 P015 P014 R 
    C15 P015 0 C 
    R16 P016 P015 R 
    C16 P016 0 C 
    R17 P017 P016 R 
    C17 P017 0 C 
    R18 P018 P017 R 
    C18 P018 0 C 
    R19 P019 P018 R 
    C19 P019 0 C 
    R20 P020 P019 R 
    C20 P020 0 C 
    R21 P021 P020 R 
    C21 P021 0 C 
    R22 P022 P021 R 
    C22 P022 0 C 
    R23 P023 P022 R 
    C23 P023 0 C 
    R24 P024 P023 R 
    C24 P024 0 C 
    R25 P025 P024 R 
    C25 P025 0 C 
    R26 P026 P025 R 
    C26 P026 0 C 
    R27 P027 P026 R 
    C27 P027 0 C 
    R28 P028 P027 R 
    C28 P028 0 C 
    R29 P029 P028 R 
    C29 P029 0 C 
    R30 P030 P029 R 
    C30 P030 0 C 
    R31 P031 P030 R 
    C31 P031 0 C 
    R32 P032 P031 R 
    C32 P032 0 C 
    R33 P033 P032 R 
    C33 P033 0 C 
    R34 P034 P033 R 
    C34 P034 0 C 
    R35 P035 P034 R 
    C35 P035 0 C 
    R36 P036 P035 R 
    C36 P036 0 C 
    R37 P037 P036 R 
    C37 P037 0 C 
    R38 P038 P037 R 
    C38 P038 0 C 
    R39 P039 P038 R 
    C39 P039 0 C 
    R40 P040 P039 R 
    C40 P040 0 C 
    R41 P041 P040 R 
    C41 P041 0 C 
    R42 P042 P041 R 
    C42 P042 0 C 
    R43 P043 P042 R 
    C43 P043 0 C 
    R44 P044 P043 R 
    C44 P044 0 C 
    R45 P045 P044 R 
    C45 P045 0 C 
    R46 P046 P045 R 
    C46 P046 0 C 
    R47 P047 P046 R 
    C47 P047 0 C 
    R48 P048 P047 R 
    C48 P048 0 C 
    R49 P049 P048 R 
    C49 P049 0 C 
    R50 P050 P049 R 
    C50 P050 0 C 
    R51 P051 P050 R 
    C51 P051 0 C 
    R52 P052 P051 R 
    C52 P052 0 C 
    R53 P053 P052 R 
    C53 P053 0 C 
    R54 P054 P053 R 
    C54 P054 0 C 
    R55 P055 P054 R 
    C55 P055 0 C 
    R56 P056 P055 R 
    C56 P056 0 C 
    R57 P057 P056 R 
    C57 P057 0 C 
    R58 P058 P057 R 
    C58 P058 0 C 
    R59 P059 P058 R 
    C59 P059 0 C 
    R60 P060 P059 R 
    C60 P060 0 C 
    R61 P061 P060 R 
    C61 P061 0 C 
    R62 P062 P061 R 
    C62 P062 0 C 
    R63 P063 P062 R 
    C63 P063 0 C 
    R64 P064 P063 R 
    C64 P064 0 C 
    R65 P065 P064 R 
    C65 P065 0 C 
    R66 P066 P065 R 
    C66 P066 0 C 
    R67 P067 P066 R 
    C67 P067 0 C 
    R68 P068 P067 R 
    C68 P068 0 C 
    R69 P069 P068 R 
    C69 P069 0 C 
    R70 P070 P069 R 
    C70 P070 0 C 
    R71 P071 P070 R 
    C71 P071 0 C 
    R72 P072 P071 R 
    C72 P072 0 C 
    R73 P073 P072 R 
    C73 P073 0 C 
    R74 P074 P073 R 
    C74 P074 0 C 
    R75 P075 P074 R 
    C75 P075 0 C 
    R76 P076 P075 R 
    C76 P076 0 C 
    R77 P077 P076 R 
    C77 P077 0 C 
    R78 P078 P077 R 
    C78 P078 0 C 
    R79 P079 P078 R 
    C79 P079 0 C 
    R80 P080 P079 R 
    C80 P080 0 C 
    R81 P081 P080 R 
    C81 P081 0 C 
    R82 P082 P081 R 
    C82 P082 0 C 
    R83 P083 P082 R 
    C83 P083 0 C 
    R84 P084 P083 R 
    C84 P084 0 C 
    R85 P085 P084 R 
    C85 P085 0 C 
    R86 P086 P085 R 
    C86 P086 0 C 
    R87 P087 P086 R 
    C87 P087 0 C 
    R88 P088 P087 R 
    C88 P088 0 C 
    R89 P089 P088 R 
    C89 P089 0 C 
    R90 P090 P089 R 
    C90 P090 0 C 
    R91 P091 P090 R 
    C91 P091 0 C 
    R92 P092 P091 R 
    C92 P092 0 C 
    R93 P093 P092 R 
    C93 P093 0 C 
    R94 P094 P093 R 
    C94 P094 0 C 
    R95 P095 P094 R 
    C95 P095 0 C 
    R96 P096 P095 R 
    C96 P096 0 C 
    R97 P097 P096 R 
    C97 P097 0 C 
    R98 P098 P097 R 
    C98 P098 0 C 
    R99 P099 P098 R 
    C99 P099 0 C 
    R100 P100 P099 R 
    C100 P100 0 C 
    R101 P101 P100 R 
    C101 P101 0 C 
    R102 P102 P101 R 
    C102 P102 0 C 
    R103 P103 P102 R 
    C103 P103 0 C 
    R104 P104 P103 R 
    C104 P104 0 C 
    R105 P105 P104 R 
    C105 P105 0 C 
    R106 P106 P105 R 
    C106 P106 0 C 
    R107 P107 P106 R 
    C107 P107 0 C 
    R108 P108 P107 R 
    C108 P108 0 C 
    R109 P109 P108 R 
    C109 P109 0 C 
    R110 P110 P109 R 
    C110 P110 0 C 
    R111 P111 P110 R 
    C111 P111 0 C 
    R112 P112 P111 R 
    C112 P112 0 C 
    R113 P113 P112 R 
    C113 P113 0 C 
    R114 P114 P113 R 
    C114 P114 0 C 
    R115 P115 P114 R 
    C115 P115 0 C 
    R116 P116 P115 R 
    C116 P116 0 C 
    R117 P117 P116 R 
    C117 P117 0 C 
    R118 P118 P117 R 
    C118 P118 0 C 
    R119 P119 P118 R 
    C119 P119 0 C 
    R120 P120 P119 R 
    C120 P120 0 C 
    R121 P121 P120 R 
    C121 P121 0 C 
    R122 P122 P121 R 
    C122 P122 0 C 
    R123 P123 P122 R 
    C123 P123 0 C 
    R124 P124 P123 R 
    C124 P124 0 C 
    R125 P125 P124 R 
    C125 P125 0 C 
    R126 P126 P125 R 
    C126 P126 0 C 
    R127 P127 P126 R 
    C127 P127 0 C 
    R128 N001 P127 R 
    C128 N001 0 C 
    R129 P128 N001 R 
    C129 P128 0 C 
    R130 P129 P128 R 
    C130 P129 0 C 
    R131 P130 P129 R 
    C131 P130 0 C 
    R132 P131 P130 R 
    C132 P131 0 C 
    R133 P132 P131 R 
    C133 P132 0 C 
    R134 P133 P132 R 
    C134 P133 0 C 
    R135 P134 P133 R 
    C135 P134 0 C 
    R136 P135 P134 R 
    C136 P135 0 C 
    R137 P136 P135 R 
    C137 P136 0 C 
    R138 P137 P136 R 
    C138 P137 0 C 
    R139 P138 P137 R 
    C139 P138 0 C 
    R140 P139 P138 R 
    C140 P139 0 C 
    R141 P140 P139 R 
    C141 P140 0 C 
    R142 P141 P140 R 
    C142 P141 0 C 
    R143 P142 P141 R 
    C143 P142 0 C 
    R144 P143 P142 R 
    C144 P143 0 C 
    R145 P144 P143 R 
    C145 P144 0 C 
    R146 P145 P144 R 
    C146 P145 0 C 
    R147 P146 P145 R 
    C147 P146 0 C 
    R148 P147 P146 R 
    C148 P147 0 C 
    R149 P148 P147 R 
    C149 P148 0 C 
    R150 P149 P148 R 
    C150 P149 0 C 
    R151 P150 P149 R 
    C151 P150 0 C 
    R152 P151 P150 R 
    C152 P151 0 C 
    R153 P152 P151 R 
    C153 P152 0 C 
    R154 P153 P152 R 
    C154 P153 0 C 
    R155 P154 P153 R 
    C155 P154 0 C 
    R156 P155 P154 R 
    C156 P155 0 C 
    R157 P156 P155 R 
    C157 P156 0 C 
    R158 P157 P156 R 
    C158 P157 0 C 
    R159 P158 P157 R 
    C159 P158 0 C 
    R160 P159 P158 R 
    C160 P159 0 C 
    R161 P160 P159 R 
    C161 P160 0 C 
    R162 P161 P160 R 
    C162 P161 0 C 
    R163 P162 P161 R 
    C163 P162 0 C 
    R164 P163 P162 R 
    C164 P163 0 C 
    R165 P164 P163 R 
    C165 P164 0 C 
    R166 P165 P164 R 
    C166 P165 0 C 
    R167 P166 P165 R 
    C167 P166 0 C 
    R168 P167 P166 R 
    C168 P167 0 C 
    R169 P168 P167 R 
    C169 P168 0 C 
    R170 P169 P168 R 
    C170 P169 0 C 
    R171 P170 P169 R 
    C171 P170 0 C 
    R172 P171 P170 R 
    C172 P171 0 C 
    R173 P172 P171 R 
    C173 P172 0 C 
    R174 P173 P172 R 
    C174 P173 0 C 
    R175 P174 P173 R 
    C175 P174 0 C 
    R176 P175 P174 R 
    C176 P175 0 C 
    R177 P176 P175 R 
    C177 P176 0 C 
    R178 P177 P176 R 
    C178 P177 0 C 
    R179 P178 P177 R 
    C179 P178 0 C 
    R180 P179 P178 R 
    C180 P179 0 C 
    R181 P180 P179 R 
    C181 P180 0 C 
    R182 P181 P180 R 
    C182 P181 0 C 
    R183 P182 P181 R 
    C183 P182 0 C 
    R184 P183 P182 R 
    C184 P183 0 C 
    R185 P184 P183 R 
    C185 P184 0 C 
    R186 P185 P184 R 
    C186 P185 0 C 
    R187 P186 P185 R 
    C187 P186 0 C 
    R188 P187 P186 R 
    C188 P187 0 C 
    R189 P188 P187 R 
    C189 P188 0 C 
    R190 P189 P188 R 
    C190 P189 0 C 
    R191 P190 P189 R 
    C191 P190 0 C 
    R192 P191 P190 R 
    C192 P191 0 C 
    R193 P192 P191 R 
    C193 P192 0 C 
    R194 P193 P192 R 
    C194 P193 0 C 
    R195 P194 P193 R 
    C195 P194 0 C 
    R196 P195 P194 R 
    C196 P195 0 C 
    R197 P196 P195 R 
    C197 P196 0 C 
    R198 P197 P196 R 
    C198 P197 0 C 
    R199 P198 P197 R 
    C199 P198 0 C 
    R200 P199 P198 R 
    C200 P199 0 C 
    R201 P200 P199 R 
    C201 P200 0 C 
    R202 P201 P200 R 
    C202 P201 0 C 
    R203 P202 P201 R 
    C203 P202 0 C 
    R204 P203 P202 R 
    C204 P203 0 C 
    R205 P204 P203 R 
    C205 P204 0 C 
    R206 P205 P204 R 
    C206 P205 0 C 
    R207 P206 P205 R 
    C207 P206 0 C 
    R208 P207 P206 R 
    C208 P207 0 C 
    R209 P208 P207 R 
    C209 P208 0 C 
    R210 P209 P208 R 
    C210 P209 0 C 
    R211 P210 P209 R 
    C211 P210 0 C 
    R212 P211 P210 R 
    C212 P211 0 C 
    R213 P212 P211 R 
    C213 P212 0 C 
    R214 P213 P212 R 
    C214 P213 0 C 
    R215 P214 P213 R 
    C215 P214 0 C 
    R216 P215 P214 R 
    C216 P215 0 C 
    R217 P216 P215 R 
    C217 P216 0 C 
    R218 P217 P216 R 
    C218 P217 0 C 
    R219 P218 P217 R 
    C219 P218 0 C 
    R220 P219 P218 R 
    C220 P219 0 C 
    R221 P220 P219 R 
    C221 P220 0 C 
    R222 P221 P220 R 
    C222 P221 0 C 
    R223 P222 P221 R 
    C223 P222 0 C 
    R224 P223 P222 R 
    C224 P223 0 C 
    R225 P224 P223 R 
    C225 P224 0 C 
    R226 P225 P224 R 
    C226 P225 0 C 
    R227 P226 P225 R 
    C227 P226 0 C 
    R228 P227 P226 R 
    C228 P227 0 C 
    R229 P228 P227 R 
    C229 P228 0 C 
    R230 P229 P228 R 
    C230 P229 0 C 
    R231 P230 P229 R 
    C231 P230 0 C 
    R232 P231 P230 R 
    C232 P231 0 C 
    R233 P232 P231 R 
    C233 P232 0 C 
    R234 P233 P232 R 
    C234 P233 0 C 
    R235 P234 P233 R 
    C235 P234 0 C 
    R236 P235 P234 R 
    C236 P235 0 C 
    R237 P236 P235 R 
    C237 P236 0 C 
    R238 P237 P236 R 
    C238 P237 0 C 
    R239 P238 P237 R 
    C239 P238 0 C 
    R240 P239 P238 R 
    C240 P239 0 C 
    R241 P240 P239 R 
    C241 P240 0 C 
    R242 P241 P240 R 
    C242 P241 0 C 
    R243 P242 P241 R 
    C243 P242 0 C 
    R244 P243 P242 R 
    C244 P243 0 C 
    R245 P244 P243 R 
    C245 P244 0 C 
    R246 P245 P244 R 
    C246 P245 0 C 
    R247 P246 P245 R 
    C247 P246 0 C 
    R248 P247 P246 R 
    C248 P247 0 C 
    R249 P248 P247 R 
    C249 P248 0 C 
    R250 P249 P248 R 
    C250 P249 0 C 
    R251 P250 P249 R 
    C251 P250 0 C 
    R252 P251 P250 R 
    C252 P251 0 C 
    R253 P252 P251 R 
    C253 P252 0 C 
    R254 P253 P252 R 
    C254 P253 0 C 
    R255 P254 P253 R 
    C255 P254 0 C 
    R256 N002 P254 R 
    C256 N002 0 C 
    R257 P255 N002 R 
    C257 P255 0 C 
    R258 P256 P255 R 
    C258 P256 0 C 
    R259 P257 P256 R 
    C259 P257 0 C 
    R260 P258 P257 R 
    C260 P258 0 C 
    R261 P259 P258 R 
    C261 P259 0 C 
    R262 P260 P259 R 
    C262 P260 0 C 
    R263 P261 P260 R 
    C263 P261 0 C 
    R264 P262 P261 R 
    C264 P262 0 C 
    R265 P263 P262 R 
    C265 P263 0 C 
    R266 P264 P263 R 
    C266 P264 0 C 
    R267 P265 P264 R 
    C267 P265 0 C 
    R268 P266 P265 R 
    C268 P266 0 C 
    R269 P267 P266 R 
    C269 P267 0 C 
    R270 P268 P267 R 
    C270 P268 0 C 
    R271 P269 P268 R 
    C271 P269 0 C 
    R272 P270 P269 R 
    C272 P270 0 C 
    R273 P271 P270 R 
    C273 P271 0 C 
    R274 P272 P271 R 
    C274 P272 0 C 
    R275 P273 P272 R 
    C275 P273 0 C 
    R276 P274 P273 R 
    C276 P274 0 C 
    R277 P275 P274 R 
    C277 P275 0 C 
    R278 P276 P275 R 
    C278 P276 0 C 
    R279 P277 P276 R 
    C279 P277 0 C 
    R280 P278 P277 R 
    C280 P278 0 C 
    R281 P279 P278 R 
    C281 P279 0 C 
    R282 P280 P279 R 
    C282 P280 0 C 
    R283 P281 P280 R 
    C283 P281 0 C 
    R284 P282 P281 R 
    C284 P282 0 C 
    R285 P283 P282 R 
    C285 P283 0 C 
    R286 P284 P283 R 
    C286 P284 0 C 
    R287 P285 P284 R 
    C287 P285 0 C 
    R288 P286 P285 R 
    C288 P286 0 C 
    R289 P287 P286 R 
    C289 P287 0 C 
    R290 P288 P287 R 
    C290 P288 0 C 
    R291 P289 P288 R 
    C291 P289 0 C 
    R292 P290 P289 R 
    C292 P290 0 C 
    R293 P291 P290 R 
    C293 P291 0 C 
    R294 P292 P291 R 
    C294 P292 0 C 
    R295 P293 P292 R 
    C295 P293 0 C 
    R296 P294 P293 R 
    C296 P294 0 C 
    R297 P295 P294 R 
    C297 P295 0 C 
    R298 P296 P295 R 
    C298 P296 0 C 
    R299 P297 P296 R 
    C299 P297 0 C 
    R300 P298 P297 R 
    C300 P298 0 C 
    R301 P299 P298 R 
    C301 P299 0 C 
    R302 P300 P299 R 
    C302 P300 0 C 
    R303 P301 P300 R 
    C303 P301 0 C 
    R304 P302 P301 R 
    C304 P302 0 C 
    R305 P303 P302 R 
    C305 P303 0 C 
    R306 P304 P303 R 
    C306 P304 0 C 
    R307 P305 P304 R 
    C307 P305 0 C 
    R308 P306 P305 R 
    C308 P306 0 C 
    R309 P307 P306 R 
    C309 P307 0 C 
    R310 P308 P307 R 
    C310 P308 0 C 
    R311 P309 P308 R 
    C311 P309 0 C 
    R312 P310 P309 R 
    C312 P310 0 C 
    R313 P311 P310 R 
    C313 P311 0 C 
    R314 P312 P311 R 
    C314 P312 0 C 
    R315 P313 P312 R 
    C315 P313 0 C 
    R316 P314 P313 R 
    C316 P314 0 C 
    R317 P315 P314 R 
    C317 P315 0 C 
    R318 P316 P315 R 
    C318 P316 0 C 
    R319 P317 P316 R 
    C319 P317 0 C 
    R320 P318 P317 R 
    C320 P318 0 C 
    R321 P319 P318 R 
    C321 P319 0 C 
    R322 P320 P319 R 
    C322 P320 0 C 
    R323 P321 P320 R 
    C323 P321 0 C 
    R324 P322 P321 R 
    C324 P322 0 C 
    R325 P323 P322 R 
    C325 P323 0 C 
    R326 P324 P323 R 
    C326 P324 0 C 
    R327 P325 P324 R 
    C327 P325 0 C 
    R328 P326 P325 R 
    C328 P326 0 C 
    R329 P327 P326 R 
    C329 P327 0 C 
    R330 P328 P327 R 
    C330 P328 0 C 
    R331 P329 P328 R 
    C331 P329 0 C 
    R332 P330 P329 R 
    C332 P330 0 C 
    R333 P331 P330 R 
    C333 P331 0 C 
    R334 P332 P331 R 
    C334 P332 0 C 
    R335 P333 P332 R 
    C335 P333 0 C 
    R336 P334 P333 R 
    C336 P334 0 C 
    R337 P335 P334 R 
    C337 P335 0 C 
    R338 P336 P335 R 
    C338 P336 0 C 
    R339 P337 P336 R 
    C339 P337 0 C 
    R340 P338 P337 R 
    C340 P338 0 C 
    R341 P339 P338 R 
    C341 P339 0 C 
    R342 P340 P339 R 
    C342 P340 0 C 
    R343 P341 P340 R 
    C343 P341 0 C 
    R344 P342 P341 R 
    C344 P342 0 C 
    R345 P343 P342 R 
    C345 P343 0 C 
    R346 P344 P343 R 
    C346 P344 0 C 
    R347 P345 P344 R 
    C347 P345 0 C 
    R348 P346 P345 R 
    C348 P346 0 C 
    R349 P347 P346 R 
    C349 P347 0 C 
    R350 P348 P347 R 
    C350 P348 0 C 
    R351 P349 P348 R 
    C351 P349 0 C 
    R352 P350 P349 R 
    C352 P350 0 C 
    R353 P351 P350 R 
    C353 P351 0 C 
    R354 P352 P351 R 
    C354 P352 0 C 
    R355 P353 P352 R 
    C355 P353 0 C 
    R356 P354 P353 R 
    C356 P354 0 C 
    R357 P355 P354 R 
    C357 P355 0 C 
    R358 P356 P355 R 
    C358 P356 0 C 
    R359 P357 P356 R 
    C359 P357 0 C 
    R360 P358 P357 R 
    C360 P358 0 C 
    R361 P359 P358 R 
    C361 P359 0 C 
    R362 P360 P359 R 
    C362 P360 0 C 
    R363 P361 P360 R 
    C363 P361 0 C 
    R364 P362 P361 R 
    C364 P362 0 C 
    R365 P363 P362 R 
    C365 P363 0 C 
    R366 P364 P363 R 
    C366 P364 0 C 
    R367 P365 P364 R 
    C367 P365 0 C 
    R368 P366 P365 R 
    C368 P366 0 C 
    R369 P367 P366 R 
    C369 P367 0 C 
    R370 P368 P367 R 
    C370 P368 0 C 
    R371 P369 P368 R 
    C371 P369 0 C 
    R372 P370 P369 R 
    C372 P370 0 C 
    R373 P371 P370 R 
    C373 P371 0 C 
    R374 P372 P371 R 
    C374 P372 0 C 
    R375 P373 P372 R 
    C375 P373 0 C 
    R376 P374 P373 R 
    C376 P374 0 C 
    R377 P375 P374 R 
    C377 P375 0 C 
    R378 P376 P375 R 
    C378 P376 0 C 
    R379 P377 P376 R 
    C379 P377 0 C 
    R380 P378 P377 R 
    C380 P378 0 C 
    R381 P379 P378 R 
    C381 P379 0 C 
    R382 P380 P379 R 
    C382 P380 0 C 
    R383 P381 P380 R 
    C383 P381 0 C 
    R384 N003 P381 R 
    R385 P382 N003 R 
    C385 P382 0 C 
    R386 P383 P382 R 
    C386 P383 0 C 
    R387 P384 P383 R 
    C387 P384 0 C 
    R388 P385 P384 R 
    C388 P385 0 C 
    R389 P386 P385 R 
    C389 P386 0 C 
    R390 P387 P386 R 
    C390 P387 0 C 
    R391 P388 P387 R 
    C391 P388 0 C 
    R392 P389 P388 R 
    C392 P389 0 C 
    R393 P390 P389 R 
    C393 P390 0 C 
    R394 P391 P390 R 
    C394 P391 0 C 
    R395 P392 P391 R 
    C395 P392 0 C 
    R396 P393 P392 R 
    C396 P393 0 C 
    R397 P394 P393 R 
    C397 P394 0 C 
    R398 P395 P394 R 
    C398 P395 0 C 
    R399 P396 P395 R 
    C399 P396 0 C 
    R400 P397 P396 R 
    C400 P397 0 C 
    R401 P398 P397 R 
    C401 P398 0 C 
    R402 P399 P398 R 
    C402 P399 0 C 
    R403 P400 P399 R 
    C403 P400 0 C 
    R404 P401 P400 R 
    C404 P401 0 C 
    R405 P402 P401 R 
    C405 P402 0 C 
    R406 P403 P402 R 
    C406 P403 0 C 
    R407 P404 P403 R 
    C407 P404 0 C 
    R408 P405 P404 R 
    C408 P405 0 C 
    R409 P406 P405 R 
    C409 P406 0 C 
    R410 P407 P406 R 
    C410 P407 0 C 
    R411 P408 P407 R 
    C411 P408 0 C 
    R412 P409 P408 R 
    C412 P409 0 C 
    R413 P410 P409 R 
    C413 P410 0 C 
    R414 P411 P410 R 
    C414 P411 0 C 
    R415 P412 P411 R 
    C415 P412 0 C 
    R416 P413 P412 R 
    C416 P413 0 C 
    R417 P414 P413 R 
    C417 P414 0 C 
    R418 P415 P414 R 
    C418 P415 0 C 
    R419 P416 P415 R 
    C419 P416 0 C 
    R420 P417 P416 R 
    C420 P417 0 C 
    R421 P418 P417 R 
    C421 P418 0 C 
    R422 P419 P418 R 
    C422 P419 0 C 
    R423 P420 P419 R 
    C423 P420 0 C 
    R424 P421 P420 R 
    C424 P421 0 C 
    R425 P422 P421 R 
    C425 P422 0 C 
    R426 P423 P422 R 
    C426 P423 0 C 
    R427 P424 P423 R 
    C427 P424 0 C 
    R428 P425 P424 R 
    C428 P425 0 C 
    R429 P426 P425 R 
    C429 P426 0 C 
    R430 P427 P426 R 
    C430 P427 0 C 
    R431 P428 P427 R 
    C431 P428 0 C 
    R432 P429 P428 R 
    C432 P429 0 C 
    R433 P430 P429 R 
    C433 P430 0 C 
    R434 P431 P430 R 
    C434 P431 0 C 
    R435 P432 P431 R 
    C435 P432 0 C 
    R436 P433 P432 R 
    C436 P433 0 C 
    R437 P434 P433 R 
    C437 P434 0 C 
    R438 P435 P434 R 
    C438 P435 0 C 
    R439 P436 P435 R 
    C439 P436 0 C 
    R440 P437 P436 R 
    C440 P437 0 C 
    R441 P438 P437 R 
    C441 P438 0 C 
    R442 P439 P438 R 
    C442 P439 0 C 
    R443 P440 P439 R 
    C443 P440 0 C 
    R444 P441 P440 R 
    C444 P441 0 C 
    R445 P442 P441 R 
    C445 P442 0 C 
    R446 P443 P442 R 
    C446 P443 0 C 
    R447 P444 P443 R 
    C447 P444 0 C 
    R448 P445 P444 R 
    C448 P445 0 C 
    R449 P446 P445 R 
    C449 P446 0 C 
    R450 P447 P446 R 
    C450 P447 0 C 
    R451 P448 P447 R 
    C451 P448 0 C 
    R452 P449 P448 R 
    C452 P449 0 C 
    R453 P450 P449 R 
    C453 P450 0 C 
    R454 P451 P450 R 
    C454 P451 0 C 
    R455 P452 P451 R 
    C455 P452 0 C 
    R456 P453 P452 R 
    C456 P453 0 C 
    R457 P454 P453 R 
    C457 P454 0 C 
    R458 P455 P454 R 
    C458 P455 0 C 
    R459 P456 P455 R 
    C459 P456 0 C 
    R460 P457 P456 R 
    C460 P457 0 C 
    R461 P458 P457 R 
    C461 P458 0 C 
    R462 P459 P458 R 
    C462 P459 0 C 
    R463 P460 P459 R 
    C463 P460 0 C 
    R464 P461 P460 R 
    C464 P461 0 C 
    R465 P462 P461 R 
    C465 P462 0 C 
    R466 P463 P462 R 
    C466 P463 0 C 
    R467 P464 P463 R 
    C467 P464 0 C 
    R468 P465 P464 R 
    C468 P465 0 C 
    R469 P466 P465 R 
    C469 P466 0 C 
    R470 P467 P466 R 
    C470 P467 0 C 
    R471 P468 P467 R 
    C471 P468 0 C 
    R472 P469 P468 R 
    C472 P469 0 C 
    R473 P470 P469 R 
    C473 P470 0 C 
    R474 P471 P470 R 
    C474 P471 0 C 
    R475 P472 P471 R 
    C475 P472 0 C 
    R476 P473 P472 R 
    C476 P473 0 C 
    R477 P474 P473 R 
    C477 P474 0 C 
    R478 P475 P474 R 
    C478 P475 0 C 
    R479 P476 P475 R 
    C479 P476 0 C 
    R480 P477 P476 R 
    C480 P477 0 C 
    R481 P478 P477 R 
    C481 P478 0 C 
    R482 P479 P478 R 
    C482 P479 0 C 
    R483 P480 P479 R 
    C483 P480 0 C 
    R484 P481 P480 R 
    C484 P481 0 C 
    R485 P482 P481 R 
    C485 P482 0 C 
    R486 P483 P482 R 
    C486 P483 0 C 
    R487 P484 P483 R 
    C487 P484 0 C 
    R488 P485 P484 R 
    C488 P485 0 C 
    R489 P486 P485 R 
    C489 P486 0 C 
    R490 P487 P486 R 
    C490 P487 0 C 
    R491 P488 P487 R 
    C491 P488 0 C 
    R492 P489 P488 R 
    C492 P489 0 C 
    R493 P490 P489 R 
    C493 P490 0 C 
    R494 P491 P490 R 
    C494 P491 0 C 
    R495 P492 P491 R 
    C495 P492 0 C 
    R496 P493 P492 R 
    C496 P493 0 C 
    R497 P494 P493 R 
    C497 P494 0 C 
    R498 P495 P494 R 
    C498 P495 0 C 
    R499 P496 P495 R 
    C499 P496 0 C 
    R500 P497 P496 R 
    C500 P497 0 C 
    R501 P498 P497 R 
    C501 P498 0 C 
    R502 P499 P498 R 
    C502 P499 0 C 
    R503 P500 P499 R 
    C503 P500 0 C 
    R504 P501 P500 R 
    C504 P501 0 C 
    R505 P502 P501 R 
    C505 P502 0 C 
    R506 P503 P502 R 
    C506 P503 0 C 
    R507 P504 P503 R 
    C507 P504 0 C 
    R508 P505 P504 R 
    C508 P505 0 C 
    R509 P506 P505 R 
    C509 P506 0 C 
    R510 P507 P506 R 
    C510 P507 0 C 
    R511 P508 P507 R 
    C511 P508 0 C 
    R512 R P508 R 
    C512 R 0 C 
    C384 N003 0 C 
.ends bitline

* ========================================================
* SIMULATION SETTINGS & PARAMETERS
* ========================================================
.tran 0.1n 200n uic
.TEMP 85

.option post=1

* Voltage and Technology Parameters
.param core_voltage=1.2V
.param wordline_voltage=2.5V
.param pv_modifier=0.5
.param plate_voltage='core_voltage*pv_modifier'
.param wl0_act=1.0
.param cell_init_voltage='0.55*1.2'
.param tech_node=7

* Technology Scaling (POW is used for HSPICE compatibility)
.param cell_cap_factor=POW(0.95, tech_node)
.param bl_cap_factor=POW(0.95, tech_node)
.param access_tran_L_factor=POW(0.95, tech_node)
.param access_tran_W_factor=POW(0.85, tech_node)
.param SA_nmos_L_factor=POW(0.93, tech_node)
.param SA_nmos_W_factor=POW(0.93, tech_node)
.param SA_pmos_L_factor=POW(0.93, tech_node)
.param SA_pmos_W_factor=POW(0.93, tech_node)
.param SA_nset_L_factor=POW(0.93, tech_node)
.param SA_nset_W_factor=POW(0.93, tech_node)
.param SA_pset_L_factor=POW(0.93, tech_node)
.param SA_pset_W_factor=POW(0.95, tech_node)
.param WL_cap_factor=POW(0.95, tech_node)
.param WL_res_factor=POW(0.95, tech_node)
.param SA_nWR_L_factor=POW(0.93, tech_node)
.param SA_nWR_W_factor=POW(0.93, tech_node)
.param SA_pWR_L_factor=POW(0.93, tech_node)
.param SA_pWR_W_factor=POW(0.93, tech_node)
.param SA_CSEL_L_factor=POW(0.93, tech_node)
.param SA_CSEL_W_factor=POW(0.93, tech_node)

* Array Architecture Parameters
.param cells_per_BL=512
.param cells_per_LWL=512
.param R_per_cell=60
.param WL_R_per_cell=40
.param WL_C_per_cell=0.07fF
.param cell_cap='24fF * cell_cap_factor'
.param bitline_cap=70fF
.param wordline_C='WL_C_per_cell*cells_per_LWL'
.param wordline_R='WL_R_per_cell*cells_per_LWL'
.param bitline_R='R_per_cell*cells_per_BL'

.param cell_0_ic='-plate_voltage + cell_init_voltage'
.param cell_2_ic='-plate_voltage + 0.024'
.param bl_cap_div='bitline_cap/512'
* Device Dimensions
.param access_tran_L='85n*access_tran_L_factor'
.param access_tran_W='55n*access_tran_W_factor'
.param SA_nmos_L='160n*SA_nmos_L_factor'
.param SA_nmos_W='1900n*SA_nmos_W_factor'
.param SA_pmos_L='160n*SA_pmos_L_factor'
.param SA_pmos_W='1330n*SA_pmos_W_factor'
.param SA_eq_L=96.3n
.param SA_eq_W=541n
.param SA_nset_L='255n*SA_nset_L_factor'
.param SA_nset_W='220n*SA_nset_W_factor'
.param SA_pset_L='255n*SA_pset_L_factor'
.param SA_pset_W='220n*SA_pset_W_factor'
.param SA_nWR_L = '70n*SA_nWR_L_factor'
.param SA_nWR_W = '840n*SA_nWR_W_factor'
.param SA_pWR_L = '70n*SA_pWR_L_factor'
.param SA_pWR_W = '840n*SA_pWR_W_factor'
.param SA_CSEL_L = '70n*SA_CSEL_L_factor'
.param SA_CSEL_W = '840n*SA_CSEL_L_factor'


* ========================================================
* TIMING MEASUREMENT (tRCD, tRAS, tRP)
* ========================================================
* [STUDENT TODO 4]: Write .meas statements to measure the following timings:
* 1. tRCD: Time from Wordline activation to Bitline reaching valid level.
* 2. tRAS: Time from Wordline activation to Cell capacitor fully restored.
* 3. tRP: Time from Precharge signal activation to Bitline returning to VDD/2.
*
* Hint: Use `.meas tran [Name] trig v([node]) val=[voltage] rise/fall=1 targ v([node]) val=[voltage] rise/fall=1`
* 1. tRCD: Time from Wordline activation to Bitline reaching valid level (1.08V).
.meas tran tRCD trig v(ra0) val=1.25 rise=1 targ v(bitline0) val=1.08 rise=1

* 2. tRAS: Time from Wordline activation to Cell capacitor fully restored (1.15V).
.meas tran tRAS trig v(ra0) val=1.25 rise=1 targ v(mb0) val=1.15 rise=1

* 3. tRP: Time from Precharge signal activation to Bitline returning to VDD/2 (approx 0.62V).
* .meas tran tRP trig v(Eq) val=0.6 rise=1 targ v(bitline0) val=0.62 fall=1
.meas tran tRP trig v(Eq) val=0.6 rise=1 TD=80n targ v(bitline1) val=0.62 fall=1 TD=80n

.end