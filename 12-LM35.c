// read LM35 on port ADC0

#include <avr/io.h> 		//standard AVR header
int main (void)
{
	DDRB = 0xFF; 			//make Port B an output
	DDRC = 0;			//make Port C an input for ADC input
	ADCSRA = 0x87;		//make ADC enable and select ck/128
	ADMUX = 0xC0;			//1.1V Vref, ADC0, right-justified
	while (1){
		ADCSRA |= (1<<ADSC);	//start conversion
		while((ADCSRA&(1<<ADIF))==0); //wait for end of conversion
		ADCSRA |= (1<<ADIF); //clear the ADIF flag
		PORTB = (ADCL|(ADCH<<8))*10/93;	//PORTB = adc value/9.3 (16 bits division)
	}
	return 0;
}
