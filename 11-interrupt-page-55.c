#include <avr/io.h>
#include <avr/interrupt.h>

int main ()
{
	DDRB = 1<<5;		//PB5 as an output
	PORTD = 1<<2;		//pull-up activated
	
	EIMSK = (1<<INT0);	//enable external interrupt 0
	sei ();			//enable interrupts

	while (1);			//wait here
}

ISR (INT0_vect)			//ISR for external interrupt 0
{
	PORTB ^= (1<<5);		//toggle PORTB.5
}