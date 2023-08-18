; write data to LCD (8-bit mode)

.EQU	LCD_DPRT = PORTD ; LCD data port
.EQU	LCD_DDDR = DDRD	 ; LCD data direction
.EQU	LCD_DPIN = PIND ; LCD data pin	
.EQU	LCD_CPRT = PORTB ; LCD command port	
.EQU	LCD_CDDR = DDRB ; LCD command direction	
.EQU	LCD_CPIN = PINB ; LCD command pin	
.EQU	LCD_RS = 0 ; LCD RS			
.EQU	LCD_RW = 1 ; LCD RW			
.EQU	LCD_EN = 2 ; LCD EN			

	LDI	R21,HIGH(RAMEND) ; setup stack
	OUT	SPH,R21
	LDI	R21,LOW(RAMEND)
	OUT	SPL,R21

	LDI	R21,0xFF		
	OUT LCD_DDDR, R21	; LCD data port is output
	OUT LCD_CDDR, R21	; LCD command port is output
	CBI	LCD_CPRT,LCD_EN	; LCD_EN = 0
	CALL DELAY_2ms	; wait for power ON	
	LDI	R16,0x38	; init LCD 2 lines 5x7 matrix
	CALL CMNDWRT	; write command to LCD	
	CALL DELAY_2ms	; wait for 2 ms	
	LDI	R16,0x0E	; display on, cursor on	
	CALL CMNDWRT	; write command	
	LDI	R16,0x01	; clear LCD	
	CALL CMNDWRT	; write command	
	CALL DELAY_2ms	; wait 2 ms	
	LDI	R16,0x06	; shift cursor right	
	CALL CMNDWRT	; write command	
	LDI	R16,'H'		; display letter	
	CALL DATAWRT	; write data	
	LDI	R16,'i'		; display letter	
	CALL DATAWRT	; wrtie data	
HERE:	JMP HERE	; stay here	
;-------------------------------------------------------
CMNDWRT:
	OUT 	LCD_DPRT,R16 ; LCD data port = R16 (command inside R16 before subroutine is called)
	CBI	LCD_CPRT,LCD_RS	; RS = 0 for command
	CBI	LCD_CPRT,LCD_RW	; RW = 0 for write
	SBI	LCD_CPRT,LCD_EN	; EN = 1
	CALL	SDELAY		; make a wide EN pulse
	CBI	LCD_CPRT,LCD_EN	; EN = 0 for H-L pulse
	CALL	DELAY_100us	; wait for 100 us
	RET
DATAWRT:
	OUT 	LCD_DPRT,R16 ; LCD dataport = R16 (data inside R16 before subroutine is called)
	SBI	LCD_CPRT,LCD_RS	; RS = 1 for data (this line is different from CMNDWRT)
	CBI	LCD_CPRT,LCD_RW	; RW = 0 for write
	SBI	LCD_CPRT,LCD_EN	; EN = 1
	CALL	SDELAY		; make a wide EN pulse
	CBI	LCD_CPRT,LCD_EN	; EN = 0 for H-L pulse
	CALL	DELAY_100us	; wait for 100 us
	RET
;-------------------------------------------------------
SDELAY:	NOP
	NOP
	RET
;-------------------------------------------------------
DELAY_100us:
	PUSH	R17
	LDI	R17,120
DR0:	
	CALL	SDELAY
	DEC	R17
	BRNE	DR0
	POP	R17
	RET
;-------------------------------------------------------
DELAY_2ms:
	PUSH	R17
	LDI	R17,20
LDR0:	
	CALL	DELAY_100US
	DEC	R17
	BRNE	LDR0
	POP	R17
	RET