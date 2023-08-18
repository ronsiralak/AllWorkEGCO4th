; write data to flash memory

DATA1: .DB 28      			;DECIMAL(1C in hex)
DATA2: .DB 0b00110101	;BINARY (35 in hex)
DATA3: .DB 0x39			;HEX
DATA4: .DB 'Y' 		  	;single ASCII char 
DATA6: .DB "Hello ALI"	;ASCII string

HERE: RJMP HERE