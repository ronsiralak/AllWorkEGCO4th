; slide 32

; 1/16 MHz = 0.0625 µs and 15 µs/0.0625 µs = 240. That means we must have OCR0A  = 240 – 1 = 239 (line 19)

.ORG	0x0	;location for reset 
	JMP	MAIN
.ORG	0x1C	;ISR location for Timer0 compare match A
	JMP	T0_CM_ISR

;main program for initialization and keeping CPU busy
MAIN:	
	LDI	R20,HIGH(RAMEND)
	OUT	SPH,R20
	LDI	R20,LOW(RAMEND)
	OUT	SPL,R20			;set up stack 
	SBI	DDRB,5			;PB5 as an output

	LDI	R20,239
	OUT	OCR0A,R20		;load Timer0 with 239
	LDI	R20,(1<<WGM01)  ;0000 0010
	OUT	TCCR0A,R20	
	LDI	R20,0x01
	OUT	TCCR0B,R20		;start Timer0, CTC mode, no prescaler int clk
	LDI	R20,(1<<OCIE0A)
	STS	TIMSK0,R20		;enable Timer0 compare match interrupt
	SEI					;set I (enable interrupts globally)

	LDI	R20,0x00
	OUT	DDRC,R20	;make PORTC input
	LDI	R20,0xFF
	OUT	DDRD,R20	;make PORTD output
;--------------- Infinite loop
HERE:	
	IN	R20,PINC	;read from PORTC
	OUT PORTD,R20	;and send it to PORTD
	JMP	HERE		;keeping CPU busy waiting for interrupt

;----------------ISR for Timer0 (it is executed every 40 �s)
T0_CM_ISR:
	IN	R16,PORTB	;read PORTB
	LDI	R17,1<<5	;00100000 for toggling PB5
	EOR	R16,R17
	OUT PORTB,R16	;toggle PB5
	RETI			;return from interrupt