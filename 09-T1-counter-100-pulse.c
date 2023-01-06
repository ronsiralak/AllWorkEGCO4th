#include <avr/io.h>

int main ( )
{
	DDRD &= ~(1<<5);
    DDRC |= 1<<0;
    TCCR1A = 0;
    TCCR1B = 0X0E;
    OCR1A = 99;
    while(1) {
        while((TIFR1 & (1<<OCF1A)) == 0)
        {}
        TIFR1 = (1<<OCF1A);
        PORTC |= (1<<0);
        PORTC &= ~(1<<0);
    }
	return 0;
}
