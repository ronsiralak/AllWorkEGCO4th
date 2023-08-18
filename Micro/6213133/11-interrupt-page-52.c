#include "avr/io.h"
#include "avr/interrupt.h"

ISR (TIMER0_OVF_vect)	//ISR for Timer0 overflow
{
	TCNT0 = -32;
	PORTB ^= (1<<5);	//toggle PORTB.5
}

int main ()
{
	DDRB |= (1<<5);		//DDRB.5 = output

	TCNT0 = -32;		//timer value for 2 µs
	TCCR0A = 0x00;		
	TCCR0B = 0x01;		//Normal mode, int clk, no prescaler

	TIMSK0 = (1<<TOIE0);	//enable Timer0 overflow interrupt
	sei ();			//enable interrupts

	DDRC = 0x00;		//make PORTC input
	PORTC = 0xFF;		//enable pull-up resistors
	DDRD = 0xFF;		//make PORTD output

	while (1)			//wait here
		PORTD = PINC;
}