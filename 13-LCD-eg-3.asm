; write data to LCD (4-bit mode, single port)

.EQU	LCD_PRT = PORTD 
.EQU	LCD_DDR = DDRD	
.EQU	LCD_PIN = PIND
.EQU	LCD_RS = 0 		
.EQU	LCD_RW = 1 		
.EQU	LCD_EN = 2 		

	LDI	R21,HIGH(RAMEND)
	OUT	SPH,R21
	LDI	R21,LOW(RAMEND)
	OUT	SPL,R21

	LDI	R21,0xFF;		
	OUT LCD_DDR, R21	

	LDI	 R16,0x33		
	CALL CMNDWRT		
	CALL DELAY_2ms		
	LDI	 R16,0x32		
	CALL CMNDWRT		
	CALL DELAY_2ms		
	LDI	 R16,0x28		
	CALL CMNDWRT		
	CALL DELAY_2ms		
	LDI	 R16,0x0E		
	CALL CMNDWRT		
	LDI	 R16,0x01		
	CALL CMNDWRT		
	CALL DELAY_2ms		
	LDI	R16,0x06		
	CALL	CMNDWRT		
	LDI	 R16,'H'		
	CALL DATAWRT		
	LDI	 R16,'i'		
	CALL DATAWRT		
HERE:
	JMP	 HERE			

;-------------------------------------------------------
CMNDWRT:
	MOV	 R27,R16
	ANDI R27,0xF0
    OUT LCD_PRT,R27
	CBI	 LCD_PRT,LCD_RS		
	CBI	 LCD_PRT,LCD_RW		
	SBI	 LCD_PRT,LCD_EN		
	CALL SDELAY				
	CBI	 LCD_PRT,LCD_EN		
	CALL DELAY_100us		

	MOV	 R27,R16
	SWAP R27
	ANDI R27,0xF0

	IN	 R26,LCD_PRT
	ANDI R26,0x0F
	OR	 R26,R27
	OUT  LCD_PRT,R26

	SBI	 LCD_PRT,LCD_EN		
	CALL SDELAY				
	CBI	 LCD_PRT,LCD_EN		

	CALL DELAY_100us		
	RET

;-------------------------------------------------------
DATAWRT:
	MOV	R27,R16
	ANDI R27,0xF0
    OUT LCD_PRT,R27
	SBI	LCD_PRT,LCD_RS		
	CBI	LCD_PRT,LCD_RW		
	SBI	LCD_PRT,LCD_EN		
	CALL	SDELAY			
	CBI	LCD_PRT,LCD_EN		
	
	MOV	 R27,R16
	SWAP R27
	ANDI R27,0xF0

	IN	 R26,LCD_PRT
	ANDI R26,0x0F
	OR	 R26,R27
	OUT  LCD_PRT,R26

	SBI	 LCD_PRT,LCD_EN		
	CALL SDELAY				
	CBI	 LCD_PRT,LCD_EN		
	
	CALL DELAY_100us		
	RET

;-------------------------------------------------------
SDELAY:
	NOP
	NOP
	RET

;-------------------------------------------------------
DELAY_100us:
	PUSH	R17
	LDI		R17,120
DR0:CALL	SDELAY
	DEC		R17
	BRNE	DR0
	POP		R17
	RET

;-------------------------------------------------------
DELAY_2ms:
	PUSH	R17
	LDI		R17,20
LDR0:	
	CALL	DELAY_100us
	DEC		R17
	BRNE	LDR0
	POP		R17
	RET