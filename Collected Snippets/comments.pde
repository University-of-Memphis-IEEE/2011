// Author: Dustin Maki
// February 18 2011
// Source to be run on Arduino Uno  can be tested at home on a teensy++, proMini, bare 168, 328, 644, 0r stk600 w/mega2560 
// remember to change pin assignments to appropriate board

/*
Uno Hardware
Microcontroller	ATmega328
Operating Voltage	5V
Input Voltage (recommended)	7-12V
Input Voltage (limits)	6-20V
Digital I/O Pins	14 (of which 6 provide PWM output)
Analog Input Pins	6
DC Current per I/O Pin	40 mA
DC Current for 3.3V Pin	50 mA
Flash Memory	32 KB (ATmega328) of which 0.5 KB used by bootloader
SRAM	2 KB (ATmega328)
EEPROM	1 KB (ATmega328)
Clock Speed	16 MHz
*/

/*
firmware overview
ieeeRobotMega duties // NOT THIS FIRMWARE

input
-read input from IR sensors, bump sensors, sonar?, radio location, ?

process
-extrapolate sensor data into conclusions about type and location of objects on the course

output
-send data about found objects to Uno to be added to the map.  encoded into 
-send confirmed data to 8 segment display



ieeeRobotUno duties // THIS FIRMWARE
input
-read input from ir line sensors, wheel encoders, motor current, magnetometer

process
-output PWM to wheel motors
-hold static map of course
-serve data from map
-update map with data learned during course of 

output

*/
