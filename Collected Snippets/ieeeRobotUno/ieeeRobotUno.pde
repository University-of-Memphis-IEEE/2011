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

// Includes
#include <CellMap.h>
#include <stdio.c>
#include <math.c>
// TODO

// defines and global variables.

// pins
#define  pinRxFromMega 
#define  pinTxToMega
#define  pinMagnetometer
#define  pinAccelerometerX
#define  pinAccelerometerY
#define  pinAccelerometerZ
#define  pinLeftMotorPWM
#define  pinLeftMotorEnable
#define  pinRightMotorPWM
#define  pinRightMotorEnable 
#define  pinLeftFrontBumper
#define  pinRightFrontBumper
#define  pinStartSwitch
#define  pinConfigurationJumper //only to be used during testing and configuration.  Remove jumper to enter competition mode.
#define  pinLED// undetermined functionality, possibly use to indicate which routine the robot is performing.
#define  pinVictimSwitch
#define  pinLeftWheelEncoder // I am still hoping we can add this hardware
#define  pinRightWheelEncoder// 

// cardinal headings  make any comparisons to heading +/- headingTolerance
const byte  eastHeading 	=  0;  // heading divides the unit circle into 256 parts 0-255
const byte  northeastHeading 	= 256 * 1/8;
const byte  northHeading	= 256 * 2/8;
const byte  northwestHeading 	= 256 * 3/8;
const byte  westHeading 	= 256 * 4/8;
const byte  southwestHeading	= 256 * 5/8;
const byte  southHeading 	= 256 * 6/8;
const byte  southeastHeading 	= 256 * 7/8;

const byte headingTolerance = 8;

 
unsigned byte magneticHeading = analogRead(pinMagnetometer)/128; // scale from 0-1024 down to 0-255
unsigned byte compassOffset;  
unsigned byte currentHeading = magneticHeading + compassOffset; // heading overflows at 255 

Cell currentCell;
Cell destinationCell; 

const int xyUnitTime	= 900; // define the basis unit for x and y direction in terms of milliseconds at default motor speeds.  Currently an arbitrary value.  TODO determine the number of milliseconds driveStraightForward() and driveStraightReverse() must be called to drive straight 1 grid square distance.
const int LTurnUnitTime = 300; // define the basis init for rotating in place 90 degrees in terms of milliseconds at default motor speeds in oposite directions. 
const int leftDefaultSpeed = 64; // may need to be a long
const int rightDefaultSpeed = 64; 


// Utility functions
 
void zeroCompass()// defines the direction robot is currently facing as relative north
{
compassOffset = magneticHeading;
currentHeading = north;
}

void debounce(int inputPin) // TODO clean up, simplify arduino example.  Perhaps just disable the interrupt for a period after the pin change interupt is triggered.
{

}

int[] nearestCellOnLineTo(int[] inputCell)
{
  int foundLine = 0;
  int lineGrid[4]; 
	// TODO locate the nearest grid which lies on a line

  while (!foundLine)
  {
    if (mapGrid[inputCell[0],inputCell[1]].onLine) // the inputCell lies on a line
      lineGrid = {inputCell[0], inputCell[1], 0, 0}; // return the inputCell, direction and distance of 0
      else
      {// search for line in each grid square adjacent to inputCell
      
        
      }
    lineGrid[0] = tempGridX;
    lineGrid[1] = tempGridY;
    lineGrid[2] = headingToInputGrid;
    lineGrid[3] = distanceToInputGrid;
  }
  return lineGrid[];
}

void driveStraightForward(double distance)
{
	// TODO
	/*
	
	*/
}

void driveStraightReverse(double distance)
{
	// TODO
}

bool gotoGrid(int x, int y)
{
  commandedGrid[] = {x,y};
  if (nearLine(commandedGrid[])) //check if the destination lies on or near a guide line to ease navigation.
  {
  
  }
}

// Interrupt Service Routines

void startButtonPushed()
{
	zeroCompass();
	// TODO anything else required
	// check bumper states
	//
	//enter autonomous
	loop();
}

void leftFrontBumper()  
{
  stopBot();
	debounce(leftFrontBumperPin);
	// TODO  report to Kirk on pinTxToMega that an object was contacted.
        //
}

void rightFrontBumper()
{
  stopBot();
	debounce(rightFrontBumperPin);
	// TODO  report to Kirk on pinTxToMega that object was contacted.
}


void main()
{
	void setup()
	{
         CellMap courseMap;
		// TODO
	}

	void loop()
	{
		// TODO

	}
}

