.ORG 0
	LDI	R16,0x0
	OUT	DDRC,R16	
	LDI	R16,0xFF	
	OUT	DDRD,R16	
	LDI	ZH,HIGH(ASCII_TABLE<<1) ; must left shift 1 bit because LSB of Z is used to select low or high byte (we always select low byte)
BEGIN:
	IN	R16,PINC	
	ANDI R16,0b00000111	; only care about the right 3 bits of PINC

	LDI	ZL,LOW(ASCII_TABLE<<1)	
	ADD	ZL,R16 ; increment Z to point to the right address e.g. if want '0' don't increment, if want '1' increment by 1 ,...			
	LPM	R17,Z ; e.g. if PORTC is 00000111, R17 will be 0x37 (ascii code for '7')			
	OUT	PORTD,R17		
	RJMP BEGIN

.ORG	0x100 ; appear in debugger at 0x200 (twice of the .ORG, because flash is 16K x 16)
ASCII_TABLE:
.DB '0','1','2','3','4','5','6','7'  