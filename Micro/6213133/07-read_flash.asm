.ORG 0x0100 ; the data will appear at 0x0200 (twice of the .ORG)
MYDATA:	.DB	"Alex Young"

; the address in flash memory is 0x100
; 0x100 = 0001 0000 0000
; (pad 3 bits to make total = 16 bits)000 0001 0000 0000 0(LSB = 0 means read the low byte) 
; 000 0001 0000 0000 0 convert to hex is 0x200
; 0000 0010 0000 0000 = 0x200

LDI R30, 0x00
LDI R31, 0x02
LPM R18, Z+ ; R18 = 0x41 (ascii code for 'A')
LPM R18, Z+ ; R18 = 0x6C (ascii code for 'l')
LPM R18, Z+ ; R18 = 0x65 (ascii code for 'e')
LPM R18, Z+ ; R18 = 0x78 (ascii code for 'x')

HERE: RJMP HERE