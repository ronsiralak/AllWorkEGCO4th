.EQU	MYLOC = 0x200
	LDS	R30, MYLOC
	TST	R30 ; test if the value is zero
	BRNE	NEXT ; if not zero branch to the end
	LDI	R30,0x55 ; if reached here then R30 was 0 on line 3
	STS	MYLOC,R30
NEXT:
	JMP	NEXT