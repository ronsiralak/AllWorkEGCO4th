.ORG 0
	LDI R16,HIGH(RAMEND)	
	OUT SPH,R16
	LDI R16,LOW(RAMEND)
	OUT SPL,R16

BACK:
	LDI R16,0x55	
	OUT PORTB,R16	
	RCALL DELAY		
	LDI R16,0xAA	
	OUT PORTB,R16	
	RCALL DELAY		
	RJMP BACK		

;-------------------delay subroutine---------------
	.ORG 0x300	; put the subroutine far away at 0x300	
DELAY:
	LDI R20,0xFF	
AGAIN:
	NOP				
	NOP
	DEC R20			
	BRNE AGAIN		
	RET	