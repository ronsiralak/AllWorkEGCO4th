LDI R20, 0x00 ; initialize the sum (clear R20)
LDI R21, 10 ; loop counter (like i in C)
LDI R22, 1 ; decrement loop counter
LDI R23, 3 ; value to add for each loop

HERE: ADD R20, R23
	SUB R21, R22
	BRNE HERE
LDI R23, 0xFF
OUT DDRB, R23
OUT PORTB, R20
FOREVER: JMP FOREVER