    LDI	R16,0xFF
	OUT	DDRB, R16		;make Port B an output
	OUT	DDRD, R16		;make Port D an output
	LDI	R16,0
	OUT	DDRC, R16		;make Port C an input for ADC
	LDI	R16,0x87		;enable ADC and select ck/128 (1000 0111)
	STS	ADCSRA, R16
	LDI	R16,0xC0		;1.1V Vref, ADC0 single ended (1100 0000): REFS1:0 = 11 = internal 1.1V, MUX3:0 = 0000 = select ADC0, ADLAR = 0 = right-justified
	STS	ADMUX, R16		;input, right-justified data
READ_ADC:
	LDI	R16,0x87|(1<<ADSC) ; 1000 0111 | 0100 0000 = 1100 0111
	STS	ADCSRA,R16		;start conversion
KEEP_POLLING:			;wait for end of conversion 
	LDS	R16,ADCSRA
	SBRS R16,ADIF		;is it end of conversion yet? (SBRS is the same as SBIS but for GPRs)
	RJMP KEEP_POLLING	;keep polling end of conversion	
	LDI	R16,(1<<ADIF)
    ; ADCH and ADCL hold the conversion result
	STS	ADCSRA,R16		;write 1 to clear ADIF flag
	LDS	R16,ADCL		;YOU HAVE TO READ ADCL FIRST 
	OUT	PORTD,R16		;give the low byte to PORTD
	LDS	R16,ADCH		;READ ADCH AFTER ADCL 
	OUT	PORTB,R16		;give the high byte to PORTB
	RJMP	READ_ADC		;keep repeating it

; ADMUX register: [REFS1, REFS0, ADLAR, UNUSED, MUX3, MUX2, MUX1, MUX0]
; ADCSRA register: [ADEN, ADSC, ADATE, ADIF, ADIE, ADPS2, ADPS1, ADPS0]
;                  [enable, start_conversion, auto_trigger_enable, interrupt_flag, interrupt_enable, pre-scaler2-0] 