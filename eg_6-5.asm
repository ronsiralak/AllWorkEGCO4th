; example 6-5
.EQU HEX_NUM = 0x315

.EQU RMND_L = 0x322
.EQU RMND_M = 0x323
.EQU RMND_H = 0x324

.DEF NUM = R20
.DEF DENOMINATOR = R21
.DEF QUOTIENT = R22

	LDI 	R16,0xFD		
	STS 	HEX_NUM,R16		

;=====================
	LDS 	NUM, HEX_NUM ; R20 = 0xFD	
	LDI 	DENOMINATOR,10	

; 253 / 10 = 25 rem 3 (least significant digit)
L1:	INC 	QUOTIENT			
	SUB 	NUM, DENOMINATOR
	BRCC 	L1				

	DEC 	QUOTIENT ; QUOTIENT = 25
	ADD 	NUM, DENOMINATOR 
	STS 	RMND_L, NUM ; RMND_L = 3

	MOV 	NUM, QUOTIENT ; NUM = 25
	LDI 	QUOTIENT,0

; 25 / 10 = 2 rem 5 (second digit)
L2:	INC 	QUOTIENT
	SUB 	NUM, DENOMINATOR
	BRCC 	L2

	DEC 	QUOTIENT
	ADD 	NUM, DENOMINATOR
	STS 	RMND_M, NUM		

	STS 	RMND_H, QUOTIENT ; (most significant digit)

HERE:JMP 	HERE