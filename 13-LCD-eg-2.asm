; write data to LCD (4-bit mode)

.EQU	LCD_DPRT = PORTD ; LCD data port
.EQU	LCD_DDDR = DDRD	 ; LCD data direction
.EQU	LCD_DPIN = PIND ; LCD data pin	
.EQU	LCD_CPRT = PORTB ; LCD command port	
.EQU	LCD_CDDR = DDRB ; LCD command direction	
.EQU	LCD_CPIN = PINB ; LCD command pin	
.EQU	LCD_RS = 0 ; LCD RS			
.EQU	LCD_RW = 1 ; LCD RW			
.EQU	LCD_EN = 2 ; LCD EN

	LDI	R21,HIGH(RAMEND)
	OUT	SPH,R21
	LDI	R21,LOW(RAMEND)
	OUT	SPL,R21

	LDI	 R21,0xFF;		
	OUT  LCD_DDDR, R21	; LCD data port is output
	OUT  LCD_CDDR, R21	; LCD command port is output
	LDI	 R16,0x33	; write sequence of 0x33, 0x32 and 0x28 to activate 4-bit mode	
	CALL CMNDWRT		
	CALL DELAY_2ms		
	LDI	 R16,0x32		
	CALL CMNDWRT		
	CALL DELAY_2ms		
	LDI	 R16,0x28		
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
HERE: JMP HERE			
;-------------------------------------------------------
CMNDWRT:						
	MOV	 R27,R16
	ANDI R27,0xF0 ; get the left half of R16
	OUT  LCD_DPRT,R27	; send the high nibble (left half of the byte)	
	CBI	LCD_CPRT,LCD_RS	; RS = 0 for command
	CBI	LCD_CPRT,LCD_RW	; RW = 0 for write
	SBI	LCD_CPRT,LCD_EN	; EN = 1
	CALL	SDELAY		; make a wide EN pulse
	CBI	LCD_CPRT,LCD_EN	; EN = 0 for H-L pulse
	CALL	DELAY_100us	; wait for 100 us		

	MOV	 R27,R16
	SWAP R27		; Swaps high and low nibbles in a register		
	ANDI R27,0xF0			
	OUT  LCD_DPRT,R27	; send the high nibble (originally right half of the byte)	
	SBI	 LCD_CPRT,LCD_EN	
	CALL SDELAY				
	CBI	 LCD_CPRT,LCD_EN	
	CALL DELAY_100us		
	RET
;-------------------------------------------------------
DATAWRT:
	MOV	R27,R16
	ANDI R27,0xF0 ; get the left half of R16
	OUT  LCD_DPRT,R27 ; send the high nibble (left half of the byte)		
	SBI	 LCD_CPRT,LCD_RS	; RS = 1 for data (this line is different from CMNDWRT)
	CBI	LCD_CPRT,LCD_RW	; RW = 0 for write
	SBI	LCD_CPRT,LCD_EN	; EN = 1	
	CALL SDELAY				
	CBI	 LCD_CPRT,LCD_EN	
	
	MOV	 R27,R16
	SWAP R27				
	ANDI R27,0xF0			
	OUT  LCD_DPRT,R27		
	SBI	 LCD_CPRT,LCD_EN	
	CALL SDELAY				
	CBI	 LCD_CPRT,LCD_EN	
	
	CALL DELAY_100us		
	RET

;-------------------------------------------------------
SDELAY:	NOP
	NOP
	RET
;-------------------------------------------------------
DELAY_100us:
	PUSH R17
	LDI	 R17,120
DR0:	
	CALL SDELAY
	DEC	 R17
	BRNE DR0
	POP	 R17
	RET
;-------------------------------------------------------
DELAY_2ms:
	PUSH R17
	LDI	 R17,20
LDR0:	
	CALL DELAY_100US
	DEC	 R17
	BRNE LDR0
	POP	 R17
	RET