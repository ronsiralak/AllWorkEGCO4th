; example 6-3
; 0x25 * 0x65

    LDI R23, 0x25
    LDI R24, 0x65
    MUL R23, R24 ;25H * 65H = E99 where  ;R1 = 0x0E and R0 = 0x99

HERE: RJMP HERE