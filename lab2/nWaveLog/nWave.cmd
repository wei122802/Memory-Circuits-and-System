wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/lab2/decoder.tr0.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/"
wvSetPosition -win $_nWave1 {("G1" 6)}
wvSetPosition -win $_nWave1 {("G1" 6)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/v\(a0\)} -color ID_RED5 \
{/v\(a1\)} -color ID_ORANGE5 \
{/v\(a2\)} -color ID_YELLOW5 \
{/v\(a3\)} -color ID_GREEN5 \
{/v\(a4\)} -color ID_CYAN5 \
{/v\(a5\)} -color ID_BLUE5 \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 6 )} 
wvSetPosition -win $_nWave1 {("G1" 6)}
wvGetSignalClose -win $_nWave1
wvCreateBusOpen -win $_nWave1
wvSetCursor -win $_nWave1 3828.604651 -snap {("G1" 6)}
wvSetCursor -win $_nWave1 4415.813953 -snap {("G1" 2)}
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvResizeWindow -win $_nWave1 2199 310 893 202
wvResizeWindow -win $_nWave1 1920 23 1680 987
wvSetCursor -win $_nWave1 13247.441860 -snap {("G1" 1)}
wvZoom -win $_nWave1 19072.558140 19236.976744
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSetCursor -win $_nWave1 19179.876330 -snap {("G1" 2)}
wvExit
