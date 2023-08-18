#include <avr/io.h>
#include <avr/interrupt.h>

ISR(ADC_vect){
	PORTD = ADCL;			//give the low byte to PORTD
	PORTB = ADCH;			//give the high byte to PORTB
	ADCSRA|=(1<<ADSC);		//start conversion
}
int main (void){
	DDRB = 0xFF;			//make Port B an output
	DDRD = 0xFF; 			//make Port D an output
	DDRC = 0;			//make Port A an input for ADC input
	ADCSRA= 0x8F;			//enable and interrupt select ck/128
	ADMUX= 0xC0;			//1.1V Vref, ADC0, right-justified
	ADCSRA|=(1<<ADSC);		//start conversion
	sei();				//enable interrupts
	while (1);			//wait forever
	return 0;
}

//  ADMUX register: [REFS1, REFS0, ADLAR, UNUSED, MUX3, MUX2, MUX1, MUX0]
//  ADCSRA register: [ADEN, ADSC, ADATE, ADIF, ADIE, ADPS2, ADPS1, ADPS0]
//                   [enable, start_conversion, auto_trigger_enable, interrupt_flag, interrupt_enable, pre-scaler2-0]