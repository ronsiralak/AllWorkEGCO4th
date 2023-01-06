; slide 28

.ORG	0x0		;location for reset 
	JMP	MAIN
.ORG	0x20		;location for Timer0 overflow (see Table 10.1)
	JMP	T0_OV_ISR		;jump to ISR for Timer0
;-main program for initialization and keeping CPU busy
.ORG	0x100
MAIN:	LDI	R20,HIGH(RAMEND)
	OUT	SPH,R20
	LDI	R20,LOW(RAMEND)
	OUT	SPL,R20		;initialize stack
	SBI	DDRB,5		;PB5 as an output
	LDI	R20,(1<<TOIE0)	
	STS	TIMSK0,R20	;enable Timer0 overflow interrupt
	SEI			;set I (enable interrupts globally)
	LDI	R20,-32	;timer value for 2 us 
	OUT	TCNT0,R20	;load Timer0 with -32
	LDI	R20,0x00
	OUT	TCCR0A,R20	
	LDI	R20,0x01
	OUT	TCCR0B,R20	;Normal, internal clock, no prescaler
	LDI	R20,0x00
	OUT	DDRC,R20	;make PORTC input
	LDI	R20,0xFF
	OUT	PORTC,R20	;enable pull-up resistors
	OUT	DDRD,R20	;make PORTD output
;--------------- Infinite loop
HERE:	IN	R20,PINC	;read from PORTC
	OUT PORTD,R20	;give it to PORTD
	JMP	HERE	   	;keeping CPU busy waiting for interrupt
;--------------ISR for Timer0	(it is executed every 4 �s)
.ORG	0x200
T0_OV_ISR:
	IN	R16,PORTB	;read PORTB
	LDI	R17,(1<<5)	;00100000 for toggling PB5
	EOR	R16,R17
	OUT PORTB,R16	;toggle PB5
	LDI	R16,-32	;timer value for 2 us 
	OUT	TCNT0,R16	;load Timer0 with -32 (for next round)
	RETI			;return from interrupt