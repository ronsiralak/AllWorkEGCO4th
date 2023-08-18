    LDI R20, HIGH(RAMEND)
    OUT SPH, R20
    LDI R20, LOW(RAMEND)
    OUT SPL, R20
    LDI R20, 0xFF ;make the port D an output port
    OUT DDRD, R20
    LDI R20, 0
LOOP: OUT PORTD, R20
    INC R20
    RCALL DELAY
    RJMP LOOP ;goto LOOP

; how many times is the innermost loop in the DELAY subroutine executed?
; what is the approximate delay time?
DELAY: LDI R21, 32
DL1: LDI R22, 200
DL2: LDI R23, 250
DL3: NOP ; 1 cycle
    NOP ; 1 cycle
    DEC R23 ; 1 cycle
    BRNE DL3 ;2 cycles if branch, 1 cycle if doesn't branch
    DEC R22
    BRNE DL2
    DEC R21
    BRNE DL1
    RET