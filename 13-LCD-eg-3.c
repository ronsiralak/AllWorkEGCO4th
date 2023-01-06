// write data to LCD (4-bit mode, single port)
// use circuit in LCD examples 3.pcf

#include <avr/io.h>

#define F_CPU 16000000UL
#include <util/delay.h>

#define	LCD_PRT  PORTD
#define	LCD_DDR  DDRD
#define	LCD_PIN  PIND

#define	LCD_RS  0
#define	LCD_RW  1
#define	LCD_EN  2

void lcdCommand( unsigned char cmnd ){
	LCD_PRT = (LCD_PRT & 0x0F) | (cmnd & 0xF0);
	LCD_PRT &= ~ (1<<LCD_RS);
	LCD_PRT &= ~ (1<<LCD_RW);
	LCD_PRT |= (1<<LCD_EN);
	_delay_us(1);
	LCD_PRT &= ~ (1<<LCD_EN);
	_delay_us(100);

	LCD_PRT = (LCD_PRT & 0x0F) | (cmnd << 4);
	LCD_PRT |= (1<<LCD_EN);
	_delay_us(1);
	LCD_PRT &= ~ (1<<LCD_EN);
	_delay_us(100);
}

void lcdData( unsigned char data )
{
	LCD_PRT = (LCD_PRT & 0x0F) | (data & 0xF0);
	LCD_PRT |= (1<<LCD_RS);
	LCD_PRT &= ~ (1<<LCD_RW);
	LCD_PRT |= (1<<LCD_EN);
	_delay_us(1);
	LCD_PRT &= ~ (1<<LCD_EN);
	
	LCD_PRT = (LCD_PRT & 0x0F) | (data << 4);
	LCD_PRT |= (1<<LCD_EN);
	_delay_us(1);
	LCD_PRT &= ~ (1<<LCD_EN);
	_delay_us(100);
}

void lcd_init(){
	LCD_DDR = 0xFF;
	
	LCD_PRT &=~(1<<LCD_EN);
	_delay_us(2000);
	lcdCommand(0x33);
	lcdCommand(0x32);
	lcdCommand(0x28);
	lcdCommand(0x0e);
	lcdCommand(0x01);

	_delay_us(2000);
}

void lcd_gotoxy(unsigned char x, unsigned char y)
{
	unsigned char firstCharAdr[] = {0x80, 0xC0, 0x94, 0xD4};

	lcdCommand(firstCharAdr[y-1] + x - 1);
	_delay_us(100);
}

void lcd_print( char * str )
{
	unsigned char i = 0 ;

	while(str[i]!=0)
	{
		lcdData(str[i]);
		i++ ;
	}
}

int main(void)
{
	lcd_init();
	while(1)
	{
		lcd_gotoxy(1,1);
		lcd_print("The world is but");
		lcd_gotoxy(1,2);
		lcd_print("one country     ");
		_delay_ms(3000);
		lcd_gotoxy(1,1);
		lcd_print("and mankind its ");
		lcd_gotoxy(1,2);
		lcd_print("citizens        ");
		_delay_ms(3000);
	}
	return 0;
}