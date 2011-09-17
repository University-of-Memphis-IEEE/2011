#include <LCD_Optrex.h>

/*
  LCD_Optrex Library - Serial Input
 
 Demonstrates the use a 20x4 LCD display.  The LCD_Optrex
 library works with the Hitachi HD44780 driver. There are many of them out there, and you
 can usually tell them by the 16-pin interface.
 
 This sketch displays text sent over the serial port 
 (e.g. from the Serial Monitor) on an attached LCD.
 
 The circuit:
 * LCD RS pin to digital pin 31
 * LCD Enable pin to digital pin 30
 * LCD D4 pin to digital pin 32
 * LCD D5 pin to digital pin 33
 * LCD D6 pin to digital pin 34
 * LCD D7 pin to digital pin 35
 * LCD R/W pin to ground
 * 10K resistor:
 * ends to +5V and ground
 * wiper to LCD VO pin (pin 3)
 
 Library originally added 18 Apr 2008
 by David A. Mellis
 library modified 5 Jul 2009
 by Limor Fried (http://www.ladyada.net)
 example added 9 Jul 2009
 by Tom Igoe 
 modified 22 Nov 2010
 by Tom Igoe
 
 This example code is in the public domain.
 
 http://www.arduino.cc/en/Tutorial/LCD_Optrex
 */

// include the library code:
#include <LCD_Optrex.h>

// initialize the library with the numbers of the interface pins
LCD_Optrex lcd(31, 30, 32, 33, 34, 35);

void setup(){
    // set up the LCD's number of columns and rows: 
  // lcd.begin(20, 4);
  delayMicroseconds(16000);       // mandatory delay for Vcc stabilization
sendraw4(0x30);                 // set 8-bit mode (yes, it's true!)
delayMicroseconds(5000);        // mandatory delay
sendraw4(0x30);
delayMicroseconds(200);
sendraw4(0x30);
delayMicroseconds(40);          // command delay
sendraw4(0x20);                 // finally set 4-bit mode
delayMicroseconds(40);          // command delay
 
command(0x28);            // 4-bit, 2-line, 5x7 char set
command(0x08);            // display off
command(0x01);            // clear display
delayMicroseconds(16000);
command(0x06);            // increment, no shift
command(0x0c);            // display on, no cursor, no blink
  // initialize the serial communications:
  Serial.begin(9600);
}

void loop()
{
  // when characters arrive over the serial port...
  if (Serial.available()) {
    // wait a bit for the entire message to arrive
    delay(100);
    // clear the screen
    lcd.clear();
    // read all the available characters
    while (Serial.available() > 0) {
      // display each character to the LCD
      lcd.write(Serial.read());
    }
  }
}
