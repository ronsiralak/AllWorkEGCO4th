.ORG	0x0			;location for reset 
	JMP	MAIN		;bypass interrupt vector table
.ORG	0x1A		;ISR location for Timer1 overflow
	JMP	T1_OV_ISR	;go to an address with more space 
.ORG	0x20		;ISR location for Timer0 overflow
	JMP	T0_OV_ISR	;go to an address with more space 
;----main program for initialization and keeping CPU busy
.ORG	0x100
MAIN:	LDI	R20,HIGH(RAMEND)
	OUT	SPH,R20
	LDI	R20,LOW(RAMEND)
	OUT	SPL,R20		;initialize stack point
	SBI	DDRB,1		;PB1 as an output
	SBI	DDRB,3		;PB3 as an output

	LDI	R20,0x00
	OUT	DDRC,R20	;make PORTC input
	LDI	R20,0xFF
	OUT	PORTC,R20	;enable the pull-up resistors
	OUT	DDRD,R20	;make PORTD output

	LDI	R20,		;value for 10 us TODO
	OUT	TCNT0,R20		;load Timer0 with xxxx
	LDI	R20,0x00
	OUT	TCCR0A,R20		
	LDI	R20,0x01
	OUT	TCCR0B,R20		;Normal mode, int clk, no prescaler
	LDI	R20,HIGH()  	;the high byte of value for 100 us TODO
	STS	TCNT1H,R20		;load Timer1 high byte
	LDI	R20,LOW()  ;the low byte of value for 100 us TODO
	STS	TCNT1L,R20	;load Timer1 low byte
	LDI	R20,0x00
	STS	TCCR1A,R20	;Normal mode
	LDI	R20,0x01
	STS	TCCR1B,R20	;internal clk, no prescaler

	LDI	R20,(1<<TOIE0)	
	STS	,R20		;enable Timer0 overflow interrupt TODO
	LDI	R20,(1<<TOIE1)	
	STS	,R20		;enable Timer1 overflow interrupt TODO
	SEI					;set I (enable interrupts globally)

;--------------- Infinite loop
HERE:	IN	R20,PINC	;read from PORTC
	OUT PORTD,R20	;and give it to PORTD
	JMP	HERE	   	;keeping CPU busy waiting for interrupt
;------ISR for Timer0 (It comes here after elapse of 10 us time)
.ORG	0x200
T0_OV_ISR:
	LDI	R16,	;value for 10 us TODO	
	OUT	TCNT0,R16	;load Timer0 with xxxx (for next round)
	IN	R16,PORTB	;read PORTB
	LDI	R17,0x02	;00000010 for toggling PB1
	EOR	R16,R17
	OUT PORTB,R16	;toggle PB1
	RETI			;return from interrupt 
;------ISR for Timer1 (It comes here after elapse of 100 us time)
.ORG	0x300
T1_OV_ISR:
	LDI	R18,HIGH() ; high byte of value for 100 us TODO
	STS	TCNT1H,R18	;load Timer1 high byte
	LDI	R18,LOW() ;  low byte of of value for 100 us TODO
	STS	TCNT1L,R18	;load Timer1 low byte (for next round)
	IN	R18,PORTB	;read PORTB
	LDI	R19,(1<<3)	;00001000 for toggling PB3
	EOR	R18,R19
	OUT PORTB,R18	;toggle PB3
	RETI			;return from interrupt 