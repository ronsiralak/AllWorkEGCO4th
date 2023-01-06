// read the internal temperature sensor

#include <avr/io.h> 		
#define F_CPU 16000000UL
#include <util/delay.h>

int main (void){
	DDRB = 0xFF;		//make Port B an output
	DDRD = 0xFF; 		//make Port D an output

	ADCSRA= 0x87;		//make ADC enable and select ck/128
	ADMUX= 0xC8;		//1.1V Vref, temp. sensor, right-justified

	while(1) {
		ADCSRA |= (1<<ADSC);	//start conversion

		while((ADCSRA&(1<<ADIF))==0);//wait for conversion to finish

		ADCSRA |= (1<<ADIF);

		PORTD = ADCL;		//give the low byte to PORTD
		PORTB = ADCH;		//give the high byte to PORTB

		_delay_ms(100);
	}

	return 0;
}