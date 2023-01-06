; example 6-4
.DEF NUM = R20
.DEF DENOMINATOR = R21
.DEF QUOTIENT = R22 ; result

	LDI 	NUM, 95 ; R20 = 95
	LDI 	DENOMINATOR, 10 ; R21 = 10
;=====================
L1:	INC 	QUOTIENT
	SUB 	NUM, DENOMINATOR
	BRCC	L1 ; branch if result not negative

	DEC 	QUOTIENT ; subtracted one time too many so undo
	ADD 	NUM, DENOMINATOR ; remainder

HERE:JMP 	HERE