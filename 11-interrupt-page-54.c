#include <avr/io.h>
#include <avr/interrupt.h>

int main () {
	DDRB |= (1<<5);		//make DDRB.5 output

	OCR1A = 15624;  // the value for 1s. with 1024 prescaler
	TCCR1A = 0x00;	//CTC mode, internal clk, prescaler=1024
	TCCR1B = 0x0D;
	TIMSK1 = (1<<OCIE1A);	//enable Timer1 compare match A int.
	sei ();			//enable interrupts

	DDRC = 0x00;		//make PORTC input
	PORTC = 0xFF;		//enable pull-up
	DDRD = 0xFF;		//make PORTD output
	
	while (1)			//wait here
		PORTD = PINC;
}
ISR (TIMER1_COMPA_vect)		//ISR for Timer1 compare match A
{
	PORTB ^= (1<<5);		//toggle PORTB.5
}