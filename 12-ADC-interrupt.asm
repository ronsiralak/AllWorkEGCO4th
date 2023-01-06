.ORG 0x00
	RJMP	MAIN
.ORG	0x2A		;ADC Conversion Complete int.	
	RJMP	ADC_INT_HANDLER
;*****************************
MAIN:	LDI	R16, HIGH(RAMEND)
	OUT	SPH, R16
	LDI	R16, LOW(RAMEND)
	OUT	SPL,R16

	LDI	R16,0xFF
	OUT	DDRB, R16		;make Port B an output
	OUT	DDRD, R16		;make Port D an output
	LDI	R16,0
	OUT	DDRC, R16		;make Port C an input for ADC
	LDI	R16,0x8F		;enable ADC and select ck/128 (1000 1111)
	STS	ADCSRA, R16		;enable ADC interrupt
	LDI	R16,0xC0		;1.1 Vref, ADC0 
	STS	ADMUX, R16		;input right-justified data
	LDI	R16,0x8F|(1<<ADSC)
	STS	ADCSRA,R16		;start conversion
	SEI
WAIT_HERE:
	RJMP	WAIT_HERE		;keep repeating it
;*****************************
ADC_INT_HANDLER:
	LDS	R16,ADCL		;YOU HAVE TO READ ADCL FIRST
	OUT	PORTD,R16		;give the low byte to PORTD
	LDS	R16,ADCH		;READ ADCH AFTER ADCL 
	OUT	PORTB,R16		;give the high byte to PORTB
	LDI	R16,0x8F|(1<<ADSC)
	STS	ADCSRA,R16		;start conversion again
	RETI

; ADMUX register: [REFS1, REFS0, ADLAR, UNUSED, MUX3, MUX2, MUX1, MUX0]
; ADCSRA register: [ADEN, ADSC, ADATE, ADIF, ADIE, ADPS2, ADPS1, ADPS0]
;                  [enable, start_conversion, auto_trigger_enable, interrupt_flag, interrupt_enable, pre-scaler2-0]