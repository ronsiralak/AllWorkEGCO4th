.ORG 0
	LDI 	R21, 0		
	LDI 	R20, 0		
	LDI 	R16, 0x79	
	ADD 	R20, R16	; 0 + 0x79 = 0x79 so C=0
	BRSH	N_1		; branch if C=0 (so it branches)	
	INC 	R21		; this line is skipped	
N_1:LDI 	R16, 0xF5 
	ADD 	R20, R16 ; 0x79 + 0xF5 = 16E (so C = 1)	
	BRSH	N_2		; do not branch since C = 0	
	INC 	R21		; increment 1 to the high byte	
N_2:LDI 	R16, 0xE2 
	ADD 	R20, R16 	; 0x6E + 0xE2 = 0x150 (so C = 1)
	BRSH	OVER	; 	do not branch since C = 0	
	INC 	R21		; increment 1 to the high byte		
OVER:					
	JMP 	OVER 

; 0x79 + 0xF5 + 0xE2 = 250
; R21 should = 2
; R20 should = 50