#include <Boards.h>
#include <Firmata.h>

#include <Flash.h>

#include <avr/pgmspace.h>

#include "WProgram.h"

#include <EEPROM.h>

#include <Stepper.h>

#include <Servo.h> 

// change this to the number of steps on your motor
#define STEPS 200  // 360degrees/1.8degrees per step
#define LED_PIN 13
#define INTERRUPT_PIN 2
#define LEFT_SERVO_POT_PIN A4
#define RIGHT_SERVO_POT_PIN A5
#define STEPPER_POT_PIN A3
#define LEFT_SERVO_PIN 10
#define RIGHT_SERVO_PIN 11
#define STEPPER_PIN_0 6
#define STEPPER_PIN_1 7
#define STEPPER_PIN_2 8
#define STEPPER_PIN_3 9
#define LEFT_LINE_SENSOR_PIN 14 // A0
#define CENTER_LINE_SENSOR_PIN 15 // A1
#define RIGHT_LINE_SENSOR_PIN 16 // A2
// #define MAGNETOMETER_PIN  // problem, ran out of analog pins on proMini
#define HIGH_LINE_SENSOR_THRESHOLD 512//ADJUST THIS TO COURSE
#define LOW_LINE_SENSOR_THRESHOLD 512
#define LEFT_MOTOR_PIN 10 // verify if using servos or h bridge
#define RIGHT_MOTOR_PIN 11

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
  
   
// byte magneticHeading = analogRead(MAGNETOMETER_PIN)/128; // scale from 0-1024 down to 0-255
byte magneticHeading = getMagHeading();
byte compassOffset;  
byte currentHeading = magneticHeading + compassOffset; // heading overflows at 255 
  
byte currentCellX;
byte currentCellY;
byte destinationCellX; 
byte destinationCellY;
  
const int xyUnitTime	= 900; // define the time in milliseconds at default motor speeds it takes to move exactly 1 grid square.  Currently an arbitrary value.  TODO determine the number of milliseconds driveStraightForward() and driveStraightReverse() must be called to drive straight 1 grid square distance.
const int LTurnUnitTime = 300; // define the basis init for rotating in place 90 degrees in terms of milliseconds at default motor speeds in oposite directions. TODO determine if ther is a difference for left or right turns
//const int leftDefaultSpeed = 64; // may need to be a long
//const int rightDefaultSpeed = 64;
int maxSpeed = 64;
int leftSpeed;
int rightSpeed;
double Kp = 1; // pid constants
double Ki = 1;
double Kd = 1;

// create an instance of the stepper class, specifying
// the number of steps of the motor and the pins it's
// attached to
Stepper stepper(STEPS, STEPPER_PIN_0, STEPPER_PIN_1, STEPPER_PIN_2, STEPPER_PIN_3); 
Servo leftServo;
Servo rightServo;// create servo object to control a servo
int leftServoVal;    // variable to read the value from the analog pin 
int rightServoVal;
int stepperVal;
int previousStepperVal = 0;
long lineSensorsAverage;
int lineSensorsSum;
int linePlacement;
double proportional, setPoint, integral, derivative, lastProportional;
int errorValue;
long lineSensors[] = {0, 0, 0}; // Array used to store readings for 3 sensors.

// PROGMEM  prog_uint32_t  cellGridMap[24][24]; // replaced with Flash library functions
FLASH_TABLE(unsigned long, flashMap, 24, // TODO write this very tedious map, possibly change to ints or even bytes
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{}
);
//       dynamic data/objects in cell  byte 0: bit 7 = victimStateBit1, bit 6 = victimStateBit0, bit 5 = ,            bit 4 = obstaclePresent, bit 3 = obstacleLarge, bit 2 = hazardPresent, bit 1 = visited,     bit 0 = clearToNavigateThrough
//X,Y coordinates of cell within room  byte 1: bit 7 = subMapXBCD3,     bit 6 = subMapXBCD2,     bit 5 = subMapXBCD1, bit 4 = subMapXBCD0,     bit 3 = subMapYBCD3,   bit 2 = subMapYBCD2,   bit 1 = subMapYBCD1, bit 0 = subMapYBCD0
//         static data about cell      byte 2: bit 7 = ,                bit 6 = ,                bit 5 = ,            bit 4 = ,                bit 3 = isDoorway,     bit 2 = isRoom,        bit 1 = roomNumBit1, bit 0 = roomNumBit0 
//         static data about cell      byte 3: bit 7 = eastLine         bit 6 = northLine,       bit 5 = westLine,    bit 4 = southLine,       bit 3 = eastWall,      bit 2 = northWall,     bit 1 = westWall,    bit 0 = southWall 


void setup() 
{ 
  Serial.begin(9600);
  leftServo.attach(LEFT_SERVO_PIN);  // attaches the servo on pin 9 to the servo object 
  rightServo.attach(RIGHT_SERVO_PIN);
  // set the speed of the stepper motor in RPMs
  stepper.setSpeed(30);

} 
 
void loop() 
{ 
  digitalWrite(LED_PIN, LOW);
  delay(100);
  digitalWrite(LED_PIN, HIGH);
 // Serial.print(stepperVal = analogRead(STEPPER_POT_PIN));// read line sensors to determine threshold values
 // Serial.print("stepper pot\n");
 // Serial.print(leftServoVal = analogRead(LEFT_SERVO_POT_PIN));
 // Serial.print("left servo\n");
  //Serial.print(rightServoVal = analogRead(RIGHT_SERVO_POT_PIN));  
 // Serial.print("right servo\n");
  Serial.println(' ');
  Serial.print(analogRead(LEFT_LINE_SENSOR_PIN));
  Serial.print("left line\n");
  Serial.print(analogRead(CENTER_LINE_SENSOR_PIN));
  Serial.print("center line\n");
  Serial.print(analogRead(RIGHT_LINE_SENSOR_PIN));
  Serial.print("right line\n");
  Serial.println(' ');
  Serial.println(' ');
  

  // move a number of steps equal to the change in the
  // sensor reading
  stepper.step(stepperVal - previousStepperVal);

  // remember the previous value of the sensor
  previousStepperVal = stepperVal;
  
  
  leftServoVal = analogRead(LEFT_SERVO_POT_PIN);            // reads the value of the potentiometer (value between 0 and 1023) 
  leftServoVal = map(leftServoVal, 0, 1023, 0, 179);     // scale it to use it with the servo (value between 0 and 180) 
  rightServoVal = analogRead(RIGHT_SERVO_POT_PIN);            // reads the value of the potentiometer (value between 0 and 1023) 
  rightServoVal = map(rightServoVal, 0, 1023, 0, 179);     // scale it to use it with the servo (value between 0 and 180) 

  leftServo.write(leftServoVal);  // sets the servo position according to the scaled value 
  rightServo.write(rightServoVal);
  delay(15);                           // waits for the servo to get there 
}

boolean hasWall(byte x, byte y)
{
  return (flashMap[x][y] & 0xf000000);// compare cell with bitmask for walls 0000 1111  0000 0000  0000 0000  0000 0000
}

boolean hasLine(byte x, byte y)
{
  return (flashMap[x][y] & 0xf0000000);// compare cell with bitmask for lines 1111 0000  0000 0000  0000 0000  0000 0000
}

void findLine(byte heading)
{
  boolean foundLine = false;
  byte tempCellX;
  byte tempCellY;
  byte layer=0;
  
  // TODO locate the nearest grid which lies on a line
  while (!foundLine)
  {
    if (hasLine(currentCellX, currentCellX)) // the inputCell lies on a line
      foundLine = true; // drop through to line follow
      else
      {// search for line in each grid square layer adjacent to currentCell
        
        
      }
   //TODO zig zag till line is visible under sensors 
  followLine(heading);
}
}

void followLine(int heading)
{
  //TODO given heading select which line to follow
  //
  // begin temporary code while tuning pid loop
  while(1)
  {
  lineSensorsAverage = 0;
  lineSensorsSum = 0;
  
  for (int i = 0; i < 3; i++)
  {
    lineSensors[i] = analogRead(i);// A0 == digital pin 14
    lineSensorsAverage += lineSensors[i] * i * 1000; //Calculating the weighted mean
    lineSensorsSum += int(lineSensors[i]);
  } //Calculating sum of sensor readings
  linePlacement = int(lineSensorsAverage / lineSensorsSum);
  Serial.print(lineSensorsAverage);
  Serial.print(' ');
  Serial.print(lineSensorsSum);
  Serial.print(' ');
  Serial.print(linePlacement);
  Serial.println();
  delay(2000);
  }

  //end temporary code
  //
  
{ // final code
  sensorsRead(); //Reads sensor values and computes sensor sum and weighted average
  pidCalc(); //Calculates position[set point] and computes Kp,Ki and Kd
  calcTurn(); //Computes the error to be corrected
  motorDrive(rightSpeed, leftSpeed); //Sends PWM signals to the motors
}

}

void sensorsRead()
{
  lineSensorsAverage = 0;
  lineSensorsSum = 0;
  for (int i = 0; i < 3; i++)
  {
    lineSensors[i] = analogRead(i);
    // Readings outside threshold are filtered out for noise
  //  if (lineSensors[i] < HIGH_LINE_SENSOR_THRESHOLD && lineSensors[i] > LOW_LINE_SENSOR_THRESHOLD)
    lineSensors[i] = 0;
    lineSensorsAverage += lineSensors[i] * i * 1000; //Calculating the weighted mean of the sensor readings
    lineSensorsSum += int(lineSensors[i]); //Calculating sum of sensor readings
  }
}

void pidCalc()
{ 
  linePlacement = int(lineSensorsAverage / lineSensorsSum);
  proportional = linePlacement - setPoint;
  integral = integral + proportional;
  derivative = proportional - lastProportional;
  lastProportional = proportional;
  errorValue = int(proportional * Kp + integral * Ki + derivative * Kd);
}

void calcTurn()
{ //Restricting the error value between +256.
if (errorValue< -256)
{
errorValue = -256;
}
if (errorValue> 256)
{
errorValue = 256;
}
// If errorValue is less than zero calculate right turn speed values
if (errorValue< 0)
{
rightSpeed = maxSpeed + errorValue;
leftSpeed = maxSpeed;
}
// IferrorValue is greater than zero calculate left turn values
else
{
rightSpeed = maxSpeed;
leftSpeed = maxSpeed - errorValue;
}
}

void motorDrive(int rightSpeed, int leftSpeed)
{ // Drive motors according to the calculated values for a turn
analogWrite(RIGHT_MOTOR_PIN, rightSpeed);
analogWrite(LEFT_MOTOR_PIN, leftSpeed);
delay(50); // Optional
}

void zeroCompass()// defines the direction robot is currently facing as relative north
{
  compassOffset = magneticHeading;
  currentHeading = northHeading;
}

byte getMagHeading()
{
  byte megaMag; // storage for byte received from Mega
  // ask Mega for magnetometer heading scaled to 0-255, north == 64
  return (megaMag);
}
