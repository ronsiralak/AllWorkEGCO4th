; example 6-2
; 2762H – 1296H

    LDI R26, 0x62
    LDI R27, 0x27

    LDI R28, 0x96
    LDI R29, 0x12

    SUB R26, R28 ; subtract the low byte ;R26 = R26 - R28 = 62 - 96 = 0xCC;
                    ; C = borrow = 1, N = 1
    SBC R27, R29 ;R27 = R27 - R29 - C  ;R27 = 27 - 12 - 1 = 14H ; -1 because gave borrow of 1 to lower byte

HERE: RJMP HERE