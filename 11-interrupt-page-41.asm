.ORG 0				;location for reset
	JMP	MAIN
.ORG 0x06				;location for pin change interrupt 0
	JMP	PCINT0_ISR		

MAIN:	LDI	R20,HIGH(RAMEND)
	OUT	SPH,R20
	LDI	R20,LOW(RAMEND)
	OUT	SPL,R20		;initialize stack
	SBI	DDRB,5
	CBI	PORTB,5
	LDI	R20,0b00001101	
	STS	PCMSK0,R20		;enable PB0, PB2, and PB3 in PCMSK0
	OUT	PORTB,R20		;enable pull-up resistors
	LDI	R20,(1<<PCIE0)	
	STS	PCICR,R20		;enable PORTB change interrupt	
	SEI				;enable interrupts
HERE: JMP	HERE		

PCINT0_ISR:
	SBI	PORTB,5
	RETI