    LDI R20, HIGH(RAMEND)
    OUT SPH, R20
    LDI R20, LOW(RAMEND)
    OUT SPL, R20
    LDI R20, 0xFF ;make the port D an output port
    OUT DDRD, R20
BEGIN: LDI R20, 0
LOOP: OUT PORTD, R20
    INC R20
    RCALL DELAY
    CPI R20, 10 ;compare R20 with 10
    BRNE LOOP ;if R20 not equal to 10, goto LOOP
    RJMP BEGIN
DELAY: LDI R21, 32
DL1: LDI R22, 200
DL2: LDI R23, 250
DL3: NOP
    NOP
    DEC R23
    BRNE DL3
    DEC R22
    BRNE DL2
    DEC R21
    BRNE DL1
    RET