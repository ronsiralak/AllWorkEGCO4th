	LDI     R20, 0xFF
    OUT     DDRB, R20 ; set the direction of port B
    LDI 	R16, 0x55	
	OUT 	PORTB, R16	
	LDI 	R20, 10	; counter for the outer loop
LOP_1:LDI 	R21, 70	; counter for the inner loop
LOP_2:COM 	R16		
	OUT 	PORTB, R16	; complement the value in port B
	DEC 	R21		
	BRNE	LOP_2 ; inner loop		
	DEC 	R20		
	BRNE 	LOP_1 ; outer loop		
HERE: RJMP	HERE