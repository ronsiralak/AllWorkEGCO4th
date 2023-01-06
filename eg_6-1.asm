; example 6-1
    
    LDI R16, 0x8D
    LDI R17, 0x3B
    LDI R18, 0xE7
    LDI R19, 0x3C

    ADD R18, R16 ;R18 = R18 + R16 = E7 + 8D = 74 and C = 1 
    ADC R19, R17 ;R19 = R19 + R17 + carry, adding the upper byte  
                ;with carry from lower byte  
                ;R19 = 3C + 3B + 1 = 78H (all in hex)

HERE: RJMP HERE