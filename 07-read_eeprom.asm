.INCLUDE "m328Pdef.inc" ; make sure this file is in the same directory as main.asm

; IMPORTANT
; EEWE is defined as EEPE
; EEMWE is defined as EEMPE

WAIT: SBIC EECR, EEPE
    RJMP WAIT
    LDI R18, 0
    LDI R17, 0x5F
    OUT EEARH, R18
    OUT EEARL, R17
    SBI EECR, EERE
    IN R16, EEDR

HERE: RJMP HERE