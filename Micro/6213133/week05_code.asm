; example 1

    SUB R20,R21	;Z will be set if R20 == R21
    BRNE NEXT		;if Not Equal jump to next
    INC R22
NEXT: 


; example 2

    CP R26, R24  ; Rd - Rr => R26 - R24 if !(R26 < R24) then the result is positive

    BRPL NEXT ; branch if positive
    INC R22 ; didn't branch
NEXT:



; example 3

    LDI R17,5
    SUB R21, R20	;C is set when R20>R21
    BRCC ELSE_LABEL	;jump to else if cleared
    INC R22
    JMP NEXT
ELSE_LABEL:
	DEC R22
NEXT:
	INC R17 


; example 4
.ORG 00	 
    LDI R16,9		;R16 = 9
L1: ADD R30,R31	
	DEC R16		;R16 = R16 - 1
	BRNE L1	 	;if Z = 0
L2: RJMP L2		;Wait here forever


; demo for PICSimLab
	LDI	R20, 0xFF	;make port B an output port
	OUT	DDRB, R20	

L1:	LDI	R20, 0x55	
	OUT	PORTB,R20	;send data to port B
	RJMP	L1		;keep doing this