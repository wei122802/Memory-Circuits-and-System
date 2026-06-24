wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/Final/SRAM_2KB.tr0.fsdb}
wvRestoreSignal -win $_nWave1 \
           "/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/Final/signal.rc" \
           -overWriteAutoAlias on -appendSignals on
wvResizeWindow -win $_nWave1 0 23 1920 1017
wvUnknownSaveResult -win $_nWave1 -clear
wvResizeWindow -win $_nWave1 1920 23 1680 987
wvZoomAll -win $_nWave1
wvResizeWindow -win $_nWave1 1920 23 1680 987
wvScrollDown -win $_nWave1 35
wvScrollDown -win $_nWave1 1
wvSetCursor -win $_nWave1 616907.433380
wvSetCursor -win $_nWave1 683201.963534
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvZoomAll -win $_nWave1
wvZoomAll -win $_nWave1
wvSetCursor -win $_nWave1 642688.639551
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 639005.610098
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvResizeWindow -win $_nWave1 0 23 1920 1017
wvSplitWindow -win $_nWave1
wvResizeWindow -win $_nWave1 0 23 1920 1017
wvSelectSignal -win $_nWave1 {( "G1" 36 )} 
wvSplitWindow -win $_nWave1 off
wvResizeWindow -win $_nWave1 0 23 1920 1017
wvResizeWindow -win $_nWave1 2254 34 893 202
wvResizeWindow -win $_nWave1 1920 23 1680 987
wvScrollDown -win $_nWave1 0
wvGetSignalOpen -win $_nWave1
wvSetPosition -win $_nWave1 {("G3" 2)}
wvSetPosition -win $_nWave1 {("G3" 2)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/v\(clk\)} -color ID_RED7 \
{/v\(a0\)} -color ID_RED5 \
{/v\(a1\)} -color ID_ORANGE5 \
{/v\(a2\)} -color ID_YELLOW5 \
{/v\(a3\)} -color ID_GREEN5 \
{/v\(a4\)} -color ID_CYAN5 \
{/v\(a5\)} -color ID_BLUE5 \
{/v\(a6\)} -color ID_PURPLE5 \
{/v\(d0\)} -color ID_RED7 \
{/v\(d1\)} -color ID_ORANGE7 \
{/v\(d2\)} -color ID_YELLOW4 \
{/v\(d3\)} -color ID_GREEN7 \
{/v\(d4\)} -color ID_CYAN7 \
{/v\(d5\)} -color ID_BLUE7 \
{/v\(d6\)} -color ID_PURPLE7 \
{/v\(d7\)} -color ID_ORANGE4 \
{/v\(d8\)} -color ID_YELLOW5 \
{/v\(d9\)} -color ID_RED5 \
{/v\(d10\)} -color ID_ORANGE5 \
{/v\(d11\)} -color ID_YELLOW5 \
{/v\(d12\)} -color ID_GREEN5 \
{/v\(d13\)} -color ID_CYAN5 \
{/v\(d14\)} -color ID_BLUE5 \
{/v\(d15\)} -color ID_PURPLE5 \
{/v\(q0\)} -color ID_RED7 \
{/v\(q1\)} -color ID_ORANGE7 \
{/v\(q2\)} -color ID_YELLOW4 \
{/v\(q3\)} -color ID_GREEN7 \
{/v\(q4\)} -color ID_CYAN7 \
{/v\(q5\)} -color ID_BLUE7 \
{/v\(q6\)} -color ID_PURPLE7 \
{/v\(q7\)} -color ID_ORANGE4 \
{/v\(q8\)} -color ID_YELLOW5 \
{/v\(q9\)} -color ID_RED5 \
{/v\(q10\)} -color ID_ORANGE5 \
{/v\(q11\)} -color ID_YELLOW5 \
{/v\(q12\)} -color ID_GREEN5 \
{/v\(q13\)} -color ID_CYAN5 \
{/v\(q14\)} -color ID_BLUE5 \
{/v\(q15\)} -color ID_PURPLE5 \
{/v\(wen\)} -color ID_RED5 \
{/A\[6:0\]} \
{/Q\[15:0\]} \
{/D\[15:0\]} \
{/v\(clk\)} -color ID_RED7 \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/v\(bl\[0\]\)} -color ID_RED5 \
{/v\(blb\[0\]\)} -color ID_ORANGE5 \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G3" 1 2 )} 
wvSetPosition -win $_nWave1 {("G3" 2)}
wvSetPosition -win $_nWave1 {("G3" 2)}
wvSetPosition -win $_nWave1 {("G3" 2)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/v\(clk\)} -color ID_RED7 \
{/v\(a0\)} -color ID_RED5 \
{/v\(a1\)} -color ID_ORANGE5 \
{/v\(a2\)} -color ID_YELLOW5 \
{/v\(a3\)} -color ID_GREEN5 \
{/v\(a4\)} -color ID_CYAN5 \
{/v\(a5\)} -color ID_BLUE5 \
{/v\(a6\)} -color ID_PURPLE5 \
{/v\(d0\)} -color ID_RED7 \
{/v\(d1\)} -color ID_ORANGE7 \
{/v\(d2\)} -color ID_YELLOW4 \
{/v\(d3\)} -color ID_GREEN7 \
{/v\(d4\)} -color ID_CYAN7 \
{/v\(d5\)} -color ID_BLUE7 \
{/v\(d6\)} -color ID_PURPLE7 \
{/v\(d7\)} -color ID_ORANGE4 \
{/v\(d8\)} -color ID_YELLOW5 \
{/v\(d9\)} -color ID_RED5 \
{/v\(d10\)} -color ID_ORANGE5 \
{/v\(d11\)} -color ID_YELLOW5 \
{/v\(d12\)} -color ID_GREEN5 \
{/v\(d13\)} -color ID_CYAN5 \
{/v\(d14\)} -color ID_BLUE5 \
{/v\(d15\)} -color ID_PURPLE5 \
{/v\(q0\)} -color ID_RED7 \
{/v\(q1\)} -color ID_ORANGE7 \
{/v\(q2\)} -color ID_YELLOW4 \
{/v\(q3\)} -color ID_GREEN7 \
{/v\(q4\)} -color ID_CYAN7 \
{/v\(q5\)} -color ID_BLUE7 \
{/v\(q6\)} -color ID_PURPLE7 \
{/v\(q7\)} -color ID_ORANGE4 \
{/v\(q8\)} -color ID_YELLOW5 \
{/v\(q9\)} -color ID_RED5 \
{/v\(q10\)} -color ID_ORANGE5 \
{/v\(q11\)} -color ID_YELLOW5 \
{/v\(q12\)} -color ID_GREEN5 \
{/v\(q13\)} -color ID_CYAN5 \
{/v\(q14\)} -color ID_BLUE5 \
{/v\(q15\)} -color ID_PURPLE5 \
{/v\(wen\)} -color ID_RED5 \
{/A\[6:0\]} \
{/Q\[15:0\]} \
{/D\[15:0\]} \
{/v\(clk\)} -color ID_RED7 \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/v\(bl\[0\]\)} -color ID_RED5 \
{/v\(blb\[0\]\)} -color ID_ORANGE5 \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G3" 1 2 )} 
wvSetPosition -win $_nWave1 {("G3" 2)}
wvGetSignalClose -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/"
wvSetPosition -win $_nWave1 {("G3" 4)}
wvSetPosition -win $_nWave1 {("G3" 4)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/v\(clk\)} -color ID_RED7 \
{/v\(a0\)} -color ID_RED5 \
{/v\(a1\)} -color ID_ORANGE5 \
{/v\(a2\)} -color ID_YELLOW5 \
{/v\(a3\)} -color ID_GREEN5 \
{/v\(a4\)} -color ID_CYAN5 \
{/v\(a5\)} -color ID_BLUE5 \
{/v\(a6\)} -color ID_PURPLE5 \
{/v\(d0\)} -color ID_RED7 \
{/v\(d1\)} -color ID_ORANGE7 \
{/v\(d2\)} -color ID_YELLOW4 \
{/v\(d3\)} -color ID_GREEN7 \
{/v\(d4\)} -color ID_CYAN7 \
{/v\(d5\)} -color ID_BLUE7 \
{/v\(d6\)} -color ID_PURPLE7 \
{/v\(d7\)} -color ID_ORANGE4 \
{/v\(d8\)} -color ID_YELLOW5 \
{/v\(d9\)} -color ID_RED5 \
{/v\(d10\)} -color ID_ORANGE5 \
{/v\(d11\)} -color ID_YELLOW5 \
{/v\(d12\)} -color ID_GREEN5 \
{/v\(d13\)} -color ID_CYAN5 \
{/v\(d14\)} -color ID_BLUE5 \
{/v\(d15\)} -color ID_PURPLE5 \
{/v\(q0\)} -color ID_RED7 \
{/v\(q1\)} -color ID_ORANGE7 \
{/v\(q2\)} -color ID_YELLOW4 \
{/v\(q3\)} -color ID_GREEN7 \
{/v\(q4\)} -color ID_CYAN7 \
{/v\(q5\)} -color ID_BLUE7 \
{/v\(q6\)} -color ID_PURPLE7 \
{/v\(q7\)} -color ID_ORANGE4 \
{/v\(q8\)} -color ID_YELLOW5 \
{/v\(q9\)} -color ID_RED5 \
{/v\(q10\)} -color ID_ORANGE5 \
{/v\(q11\)} -color ID_YELLOW5 \
{/v\(q12\)} -color ID_GREEN5 \
{/v\(q13\)} -color ID_CYAN5 \
{/v\(q14\)} -color ID_BLUE5 \
{/v\(q15\)} -color ID_PURPLE5 \
{/v\(wen\)} -color ID_RED5 \
{/A\[6:0\]} \
{/Q\[15:0\]} \
{/D\[15:0\]} \
{/v\(clk\)} -color ID_RED7 \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/v\(bl\[0\]\)} -color ID_RED5 \
{/v\(blb\[0\]\)} -color ID_ORANGE5 \
{/v\(wl0\)} -color ID_YELLOW5 \
{/v\(wl1\)} -color ID_GREEN5 \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G3" 3 4 )} 
wvSetPosition -win $_nWave1 {("G3" 4)}
wvSetPosition -win $_nWave1 {("G3" 4)}
wvSetPosition -win $_nWave1 {("G3" 4)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/v\(clk\)} -color ID_RED7 \
{/v\(a0\)} -color ID_RED5 \
{/v\(a1\)} -color ID_ORANGE5 \
{/v\(a2\)} -color ID_YELLOW5 \
{/v\(a3\)} -color ID_GREEN5 \
{/v\(a4\)} -color ID_CYAN5 \
{/v\(a5\)} -color ID_BLUE5 \
{/v\(a6\)} -color ID_PURPLE5 \
{/v\(d0\)} -color ID_RED7 \
{/v\(d1\)} -color ID_ORANGE7 \
{/v\(d2\)} -color ID_YELLOW4 \
{/v\(d3\)} -color ID_GREEN7 \
{/v\(d4\)} -color ID_CYAN7 \
{/v\(d5\)} -color ID_BLUE7 \
{/v\(d6\)} -color ID_PURPLE7 \
{/v\(d7\)} -color ID_ORANGE4 \
{/v\(d8\)} -color ID_YELLOW5 \
{/v\(d9\)} -color ID_RED5 \
{/v\(d10\)} -color ID_ORANGE5 \
{/v\(d11\)} -color ID_YELLOW5 \
{/v\(d12\)} -color ID_GREEN5 \
{/v\(d13\)} -color ID_CYAN5 \
{/v\(d14\)} -color ID_BLUE5 \
{/v\(d15\)} -color ID_PURPLE5 \
{/v\(q0\)} -color ID_RED7 \
{/v\(q1\)} -color ID_ORANGE7 \
{/v\(q2\)} -color ID_YELLOW4 \
{/v\(q3\)} -color ID_GREEN7 \
{/v\(q4\)} -color ID_CYAN7 \
{/v\(q5\)} -color ID_BLUE7 \
{/v\(q6\)} -color ID_PURPLE7 \
{/v\(q7\)} -color ID_ORANGE4 \
{/v\(q8\)} -color ID_YELLOW5 \
{/v\(q9\)} -color ID_RED5 \
{/v\(q10\)} -color ID_ORANGE5 \
{/v\(q11\)} -color ID_YELLOW5 \
{/v\(q12\)} -color ID_GREEN5 \
{/v\(q13\)} -color ID_CYAN5 \
{/v\(q14\)} -color ID_BLUE5 \
{/v\(q15\)} -color ID_PURPLE5 \
{/v\(wen\)} -color ID_RED5 \
{/A\[6:0\]} \
{/Q\[15:0\]} \
{/D\[15:0\]} \
{/v\(clk\)} -color ID_RED7 \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/v\(bl\[0\]\)} -color ID_RED5 \
{/v\(blb\[0\]\)} -color ID_ORANGE5 \
{/v\(wl0\)} -color ID_YELLOW5 \
{/v\(wl1\)} -color ID_GREEN5 \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G3" 3 4 )} 
wvSetPosition -win $_nWave1 {("G3" 4)}
wvGetSignalClose -win $_nWave1
wvScrollUp -win $_nWave1 1
wvSetCursor -win $_nWave1 648867.895863
wvSetCursor -win $_nWave1 570719.572639
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvZoomAll -win $_nWave1
wvScrollDown -win $_nWave1 1
wvResizeWindow -win $_nWave1 0 23 1920 1017
wvSelectSignal -win $_nWave1 {( "G1" 42 )} 
wvSelectSignal -win $_nWave1 {( "G1" 42 43 )} 
wvSelectSignal -win $_nWave1 {( "G1" 42 43 44 )} 
wvSelectSignal -win $_nWave1 {( "G1" 42 )} 
wvSelectSignal -win $_nWave1 {( "G1" 42 43 )} 
wvSelectSignal -win $_nWave1 {( "G1" 42 43 44 )} 
wvSelectSignal -win $_nWave1 {( "G1" 42 )} 
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvSelectSignal -win $_nWave1 {( "G1" 43 )} 
wvSelectSignal -win $_nWave1 {( "G1" 42 )} 
wvSelectSignal -win $_nWave1 {( "G1" 42 43 )} 
wvSelectSignal -win $_nWave1 {( "G1" 42 43 44 )} 
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G3" 4)}
wvScrollUp -win $_nWave1 39
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 1
wvSelectSignal -win $_nWave1 {( "G1" 2 3 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 3 4 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 3 4 5 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 3 4 5 6 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 3 4 5 6 7 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 3 4 5 6 7 8 )} 
wvCreateBusOpen -win $_nWave1
wvSetPosition -win $_nWave1 {("G3" 4)}
wvSetPosition -win $_nWave1 {("G3" 4)}
wvSetPosition -win $_nWave1 {("G3" 5)}
wvSetPosition -win $_nWave1 {("G3" 4)}
wvSetPosition -win $_nWave1 {("G3" 4)}
wvCreateBus -win $_nWave1 -high 0.350000 -low 0.350000 "A\[6:0\]" "/v\(a6\)" \
           "/v\(a5\)" "/v\(a4\)" "/v\(a3\)" "/v\(a2\)" "/v\(a1\)" "/v\(a0\)"
wvSetPosition -win $_nWave1 {("G3" 5)}
wvSetPosition -win $_nWave1 {("G3" 5)}
wvScrollDown -win $_nWave1 38
wvScrollUp -win $_nWave1 31
wvSelectSignal -win $_nWave1 {( "G1" 9 )} 
wvSelectSignal -win $_nWave1 {( "G1" 9 10 )} 
wvSelectSignal -win $_nWave1 {( "G1" 9 10 11 )} 
wvSelectSignal -win $_nWave1 {( "G1" 9 10 11 12 )} 
wvSelectSignal -win $_nWave1 {( "G1" 9 10 11 12 13 )} 
wvSelectSignal -win $_nWave1 {( "G1" 9 10 11 12 13 14 )} 
wvSelectSignal -win $_nWave1 {( "G1" 9 10 11 12 13 )} 
wvSelectSignal -win $_nWave1 {( "G1" 9 10 11 12 13 14 )} 
wvSelectSignal -win $_nWave1 {( "G1" 9 10 11 12 13 14 15 )} 
wvSelectSignal -win $_nWave1 {( "G1" 9 10 11 12 13 14 15 16 )} 
wvScrollDown -win $_nWave1 6
wvSelectSignal -win $_nWave1 {( "G1" 9 10 11 12 13 14 15 16 17 )} 
wvSelectSignal -win $_nWave1 {( "G1" 9 10 11 12 13 14 15 16 17 18 )} 
wvSelectSignal -win $_nWave1 {( "G1" 9 10 11 12 13 14 15 16 17 18 19 )} 
wvSelectSignal -win $_nWave1 {( "G1" 9 10 11 12 13 14 15 16 17 18 19 20 )} 
wvSelectSignal -win $_nWave1 {( "G1" 9 10 11 12 13 14 15 16 17 18 19 20 21 )} \
           
wvSelectSignal -win $_nWave1 {( "G1" 9 10 11 12 13 14 15 16 17 18 19 20 21 22 \
           )} 
wvScrollDown -win $_nWave1 6
wvSelectSignal -win $_nWave1 {( "G1" 9 10 11 12 13 14 15 16 17 18 19 20 21 22 \
           23 )} 
wvSelectSignal -win $_nWave1 {( "G1" 9 10 11 12 13 14 15 16 17 18 19 20 21 22 \
           23 24 )} 
wvCreateBusOpen -win $_nWave1
wvSetPosition -win $_nWave1 {("G3" 5)}
wvSetPosition -win $_nWave1 {("G3" 5)}
wvSetPosition -win $_nWave1 {("G3" 6)}
wvSetPosition -win $_nWave1 {("G3" 5)}
wvSetPosition -win $_nWave1 {("G3" 5)}
wvCreateBus -win $_nWave1 -high 0.350000 -low 0.350000 "D\[15:0\]" "/v\(d15\)" \
           "/v\(d14\)" "/v\(d13\)" "/v\(d12\)" "/v\(d11\)" "/v\(d10\)" \
           "/v\(d9\)" "/v\(d8\)" "/v\(d7\)" "/v\(d6\)" "/v\(d5\)" "/v\(d4\)" \
           "/v\(d3\)" "/v\(d2\)" "/v\(d1\)" "/v\(d0\)"
wvSetPosition -win $_nWave1 {("G3" 6)}
wvSetPosition -win $_nWave1 {("G3" 6)}
wvSelectSignal -win $_nWave1 {( "G1" 25 )} 
wvSelectSignal -win $_nWave1 {( "G1" 25 26 )} 
wvSelectSignal -win $_nWave1 {( "G1" 25 26 27 )} 
wvSelectSignal -win $_nWave1 {( "G1" 25 26 27 28 )} 
wvScrollDown -win $_nWave1 4
wvSelectSignal -win $_nWave1 {( "G1" 25 26 27 28 29 )} 
wvSelectSignal -win $_nWave1 {( "G1" 25 26 27 28 29 30 )} 
wvSelectSignal -win $_nWave1 {( "G1" 25 26 27 28 29 30 31 )} 
wvSelectSignal -win $_nWave1 {( "G1" 25 26 27 28 29 30 31 32 )} 
wvScrollDown -win $_nWave1 4
wvSelectSignal -win $_nWave1 {( "G1" 25 26 27 28 29 30 31 32 33 )} 
wvSelectSignal -win $_nWave1 {( "G1" 25 26 27 28 29 30 31 32 33 34 )} 
wvSelectSignal -win $_nWave1 {( "G1" 25 26 27 28 29 30 31 32 33 34 35 )} 
wvSelectSignal -win $_nWave1 {( "G1" 25 26 27 28 29 30 31 32 33 34 35 36 )} 
wvScrollDown -win $_nWave1 5
wvSelectSignal -win $_nWave1 {( "G1" 25 26 27 28 29 30 31 32 33 34 35 36 37 )} \
           
wvSelectSignal -win $_nWave1 {( "G1" 25 26 27 28 29 30 31 32 33 34 35 36 37 38 \
           )} 
wvSelectSignal -win $_nWave1 {( "G1" 25 26 27 28 29 30 31 32 33 34 35 36 37 38 \
           39 )} 
wvSelectSignal -win $_nWave1 {( "G1" 25 26 27 28 29 30 31 32 33 34 35 36 37 38 \
           39 40 )} 
wvCreateBusOpen -win $_nWave1
wvSetPosition -win $_nWave1 {("G3" 6)}
wvSetPosition -win $_nWave1 {("G3" 6)}
wvSetPosition -win $_nWave1 {("G3" 7)}
wvSetPosition -win $_nWave1 {("G3" 6)}
wvSetPosition -win $_nWave1 {("G3" 6)}
wvCreateBus -win $_nWave1 -high 0.350000 -low 0.350000 "Q\[15:0\]" "/v\(q15\)" \
           "/v\(q14\)" "/v\(q13\)" "/v\(q12\)" "/v\(q11\)" "/v\(q10\)" \
           "/v\(q9\)" "/v\(q8\)" "/v\(q7\)" "/v\(q6\)" "/v\(q5\)" "/v\(q4\)" \
           "/v\(q3\)" "/v\(q2\)" "/v\(q1\)" "/v\(q0\)"
wvSetPosition -win $_nWave1 {("G3" 7)}
wvSetPosition -win $_nWave1 {("G3" 7)}
wvSelectSignal -win $_nWave1 {( "G1" 41 )} 
wvScrollDown -win $_nWave1 6
wvSetPosition -win $_nWave1 {("G1" 41)}
wvSetPosition -win $_nWave1 {("G2" 0)}
wvSetPosition -win $_nWave1 {("G3" 1)}
wvSetPosition -win $_nWave1 {("G3" 2)}
wvSetPosition -win $_nWave1 {("G3" 3)}
wvSetPosition -win $_nWave1 {("G3" 4)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G3" 5)}
wvSelectSignal -win $_nWave1 {( "G1" 41 )} 
wvSetPosition -win $_nWave1 {("G1" 41)}
wvSetPosition -win $_nWave1 {("G3" 1)}
wvSetPosition -win $_nWave1 {("G3" 2)}
wvSetPosition -win $_nWave1 {("G3" 3)}
wvSetPosition -win $_nWave1 {("G3" 4)}
wvSetPosition -win $_nWave1 {("G3" 5)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G3" 6)}
wvSetCursor -win $_nWave1 598179.471789
wvSelectGroup -win $_nWave1 {G4}
wvSelectGroup -win $_nWave1 {G4}
wvSaveSignal -win $_nWave1 \
           "/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/Final/signal.rc"
wvSelectSignal -win $_nWave1 {( "G3" 5 )} 
wvSelectSignal -win $_nWave1 {( "G3" 6 )} 
wvSelectSignal -win $_nWave1 {( "G3" 5 )} 
wvSelectSignal -win $_nWave1 {( "G3" 6 )} 
wvScrollUp -win $_nWave1 1
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 0
wvSelectSignal -win $_nWave1 {( "G3" 3 )} 
wvSelectSignal -win $_nWave1 {( "G3" 4 )} 
wvExit
