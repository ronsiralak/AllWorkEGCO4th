#include <avr/io.h>		//standard AVR header

int main (void)
{
	DDRB = 0xFF;			//make Port B an output
	DDRD = 0xFF; 			//make Port D an output
	DDRC = 0;			//make Port C an input for ADC input
	ADCSRA= 0x87;			//make ADC enable and select ck/128
	ADMUX= 0xC0;			//1.1V Vref, ADC0, right-justified 0xC0 = 1100 0000
	while (1)
	{
		ADCSRA|=(1<<ADSC);	//start conversion
		while((ADCSRA&(1<<ADIF))==0);//wait for conversion to finish
	    ADCSRA |= (1<<ADIF); // clear the interrupt flag by writing 1 to it
		
		PORTD = ADCL;		//give the low byte to PORTD
		PORTB = ADCH;		//give the high byte to PORTB
	}
	return 0;
}

//  ADMUX register: [REFS1, REFS0, ADLAR, UNUSED, MUX3, MUX2, MUX1, MUX0]
//  ADCSRA register: [ADEN, ADSC, ADATE, ADIF, ADIE, ADPS2, ADPS1, ADPS0]
//                   [enable, start_conversion, auto_trigger_enable, interrupt_flag, interrupt_enable, pre-scaler2-0]