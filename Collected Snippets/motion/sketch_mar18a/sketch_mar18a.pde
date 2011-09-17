#include <Flash.h>

#include <EEPROM.h>

#include <Stepper.h>

#include <math.h>

// pin defines
#define Estop 2 // interrupt 0 on digital pin 2.  Testing use only.  Final configuration will use this pin for audio.  All interrupt pins already in use.
#define magAnalogPin 0
#define leftMotorGreen      23 // HIGH turns on Green LED on motor controller, pin connected to(color) logic wire and corresponds to (color) wire attached to left motor
#define leftMotorRed        22 // HIGH turns on Red   LED on motor controller, pin connected to(color) logic wire and corresponds to (color) wire attached to left motor
#define leftMotorPWMpin     13 // connected to left enable pin on motor controller with white logic wire
#define rightMotorGreen    24 // HIGH turns on Green LED on motor controller, pin connected to(red or black) logic wire and corresponds to (color) wire attached to right motor
#define rightMotorRed      25 // HIGH turns on Red   LED on motor controller, pin connected to(red or black) logic wire and corresponds to (color) wire attached to right motor
#define rightMotorPWMpin   7 // connected to right enable pin on motor controller with white logic wire
#define ledPin  9   // LED 
#define ledGnd 31
#define switchPin 32  // switch input

// other defines


#define Left 'L'  // used for int type to indicate left
#define Right 'R'  // used for int type to indicate right
#define maxSpeed 255
#define turnSpeed 192  // in case we need to slow down to take our turns.
#define lineFollowSpeed 128
#define orbitOutsideWheelSpeed 128
#define orbitInsideWheelSpeed 64
 // these need to be optimized during physical testing
#define accelStep 32   // largest instantaneous jump in speed.  Should be the largest value that does not result in wheelspin or wheelies.
#define accelLoops 8 // higher number smooths out the acceleration at the cost of time, and distance over course.  If raising accelLoops, compensate by lowering accelTimeOnLoop
#define accelTimeOnLoop 15 //milliseconds,  adjust to the shortest time that does not result in wheelspin or wheelies.

//global variables 
int MasterX;// actual position verified by spock
int MasterY;
byte MasterDir;

int DestX;// Sulu writes these to remember the final destination during subnavigation around obstacles.
int DestY;

boolean bumperTriggered = false;

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
  
   
//volatile byte magneticHeading = MasterDir; // scale from 0-1024 down to 0-255
byte compassOffset;  
//volatile byte currentHeading = magneticHeading + compassOffset; // heading overflows at 255 
const int wheelSep = 14;//cm
int vLeft; // measure the actual velocity produced at each of 256 pwm outputs
int vRight;// then create a lookup table, otherwise, measure with encoder to use actual velocities, immune to voltage or frictional changes.  Still innacurate if whhel slippage.
int theta; // angle of final orientation with respect to initial orientation.
volatile int pwmLeft;
volatile int pwmRight;
volatile boolean stopRequested = false;
volatile int leftEncoderTicsSoFar = 0;
volatile int rightEncoderTicsSoFar = 0;
const long cmTimeConstant = 600;//milliseconds
const long angleTimeConstant = 50;//milliseconds
const long orbitTime = 45000; //milliseconds

/*     Equations of some use

cosine is sine from angle+fullcircle/4
arctan(x) = x / (1 + 0.28x2) + ε(x), where |ε(x)| ≤ .005 over -1 ≤ x ≤ 1

(x,y)is the center point between the wheels
dx/dt = 1/2 * (Vleft + Vright) * cos(Theta)
dy/dt = 1/2 * (Vleft + Vright) * sin(Theta)
dTheta/dt = 1/botWidth * (Vleft - Vright)


*/

//test variables.  delete in final code
int switchCount = 0;
int buttonState = 0;         // current state of the button
int lastButtonState = 0;     // previous state of the button

void setup()
{
  //Serial.begin(9600);
  pinMode(leftMotorGreen, OUTPUT);
  pinMode(leftMotorRed, OUTPUT);
  pinMode(leftMotorPWMpin, OUTPUT);
  
  pinMode(rightMotorGreen, OUTPUT);
  pinMode(rightMotorRed, OUTPUT);
  pinMode(rightMotorPWMpin, OUTPUT);
  
  pinMode(ledPin, OUTPUT);
  pinMode(ledGnd, OUTPUT);
  digitalWrite(ledGnd, LOW);
  
   // set the switch as an input and activate internal pullup resistor
  pinMode(switchPin, INPUT); 
  digitalWrite(switchPin, HIGH);  
  //pinMode(Estop, INPUT);
 // digitalWrite(Estop, HIGH);
  
  // blink the LED 3 times when Arduino is reset, probably indicates the Arduino lost power
  blink(ledPin, 3, 500);
  //attachInterrupt(0,stopBot,FALLING);// Estop Emergency Stop on pin 2 triggers when pin is grounded.  Will not retrigger if held down.  Only triggers on falling edge.
}


void loop()// test code

{
  blink(ledPin, 3, 500);
  accelTo(255,255);
  delay(1500);
  accelTo(0,0);
  delay(500);
  /*
   // read the pushbutton input pin:
  buttonState = digitalRead(switchPin);
  delay(10); // switch debounce

  // compare the buttonState to its previous state, dont keep incrementing while button is pressed
  if (buttonState != lastButtonState) 
  {
    if (buttonState == LOW) 
    {
      // then the button went from off to on, increment the counter to trigger next bot behavior.
      switchCount++;
    }
  }
  // save the current state as the last state, 
  //for next time through the loop
  lastButtonState = buttonState;
      
  if (switchCount > 10)
  switchCount = 0;
  
  switch (switchCount) // change these case statements to suit the needs of testing.
  {
  case 0:
    stopBot();
    break;
  case 1:
    accelTo(32,32);// straight line low speed
    break;
  case 2:
    accelTo(192,192); // straight line 3/4 speed
    break;
  case 3:
    stopBot(); // brake
    break;
  case 4:
    accelTo(-127,-127);// back up 1/2 speed
    break;
  case 5:
    accelTo(0, -64); // pivot in reverse on left wheel
    break;
  case 6:
    accelTo(-64, 0); // pivot in reverse on right wheel
    break;
  case 7:
    accelTo(255, 128); // zig zag forward
    delay(510);
    accelTo(128, 255);
    delay(500);// 10 ms eatten each loop by debounce + code execution.
   // monitor how closely left turns equal right turns    
    break;
  case 8:
    stopBot();
    accelTo(255, 0);//J turn
    delay(10);
    stopBot();
    accelTo(0, 255);
    break;
  case 9:
    stopBot(); // stop
    break;
  case 10:
    blink(ledPin, 12, 80); // blink LED to signal that next push starts the sequence over.
    break; 
  default: 
    stopBot();
 }
 */
}

// helper functions
byte arctan(int num)// changing our resolution from 0-24 to 0-240 will likely affect his solution to this, but even if the array is very large it can be stored in program space and not take up any ram
{
  return 0;// see jon olson for this code
}

long getCmTimeConstant(int cm, long time)
{
  long startTime = accelTo(maxSpeed,maxSpeed);
  delay((cm * time)- 2*(millis()-startTime));
  long endTime = accelTo(0,0);
  long result = endTime - startTime;
  Serial.println("input: ");
  Serial.print("centimeters: ");
  Serial.print(cm);
  Serial.print("\ntime: ");
  Serial.print(time);
  Serial.println("output: ");
  Serial.print("time it actually took : ");
  Serial.print(result);
  
  return result;
}

long getAngleTimeConstant(int binaryDegrees, long time)
{
  int startTime = accelTo(-turnSpeed,turnSpeed);
  delay((abs(binaryDegrees) * time)- 2*(millis()-startTime));
  long endTime = accelTo(0,0);
  long result = endTime - startTime;
  Serial.println("input: ");
  Serial.print("degrees of binary measure: ");
  Serial.print(binaryDegrees);
  Serial.print("\ntime: ");
  Serial.print(time);
  Serial.println("output: ");
  Serial.print("time it actually took : ");
  Serial.print(result);
  
  return result;
}

int locateQuadrant(int x, int y) {
	int room = 0;
	if (x < 1 || x > 23 || y < 1 || y > 23) room = 6; // beyond map
	else if(x < 10 && y < 10) room = 1;
	else if(x > 14 && y > 14) room = 3;
	else if(x > 14 && y < 10) room = 4;
	else if(x < 10 && y > 14) room = 2;
	else room = 5;	// hallway
	return (room);
}

int Sulu(int moveType, int TX, int TY) 
{//return codes: 0 = are we there yet? 2 = we appear to be there 3 = on victim 4 = unable to complete task 5 = warp core breach
  int room;
  int moveToReturn;
  int standardOrbitReturn = 0;
  int reverseOrbitReturn = 0;
  
  switch(moveType)
  {
  case 1://normal move
    moveToReturn = moveTo(MasterX,MasterY,TX,TY);
    break;
  case 2://clockwise room orbit
    room = locateQuadrant(TX, TY);
    moveToReturn = moveTo(MasterX,MasterY,TX,TY);
    standardOrbitReturn = standardOrbit(room);
    break;
  case 3://counterclockwise room orbit
    room = locateQuadrant(TX, TY);
    moveToReturn = moveTo(MasterX,MasterY,TX,TY);
    reverseOrbitReturn = reverseOrbit(room);
    break;
  default:
    moveToReturn = moveTo(MasterX,MasterY,TX,TY);
    break;
  }

if (standardOrbitReturn>0)  
  return standardOrbitReturn;
else if (reverseOrbitReturn>0)
  return reverseOrbitReturn;
else
  return moveToReturn;
}

int moveTo(int startX, int startY, int endX, int endY)
{// calculate
  byte startAngle = currentHeading;
  int distanceX = endX - startX;
  int distanceY = endY - startY;
  int distance = (int)sqrt((distanceX*distanceX)+(distanceY*distanceY));
  byte endAngle = arctan(distanceY/distanceX);
  /* uncomment these lines and comment the following line if magnetometer does not work.
 int turnAngle = (int)endAngle - (int)startAngle;
 turnTime(int turnAngle); 
 */
  turnTo(endAngle);  
  forwardTime(distance);// use forwardDistance(distance) if wheel encoders work.
  
  return 0;// TODO 
}

int lineFollow(byte heading)
{
  long startTime = accelTo(lineFollowSpeed,lineFollowSpeed);
}

int standardOrbit(int room)
{
  byte startAngle = currentHeading;
  long startTime = accelTo(orbitOutsideWheelSpeed, orbitInsideWheelSpeed);// circular orbit, no line following required
}

int reverseOrbit(int room)
{
  
  byte startAngle = currentHeading;
  long startTime = accelTo(orbitInsideWheelSpeed, orbitOutsideWheelSpeed);  
  while (millis()-startTime < orbitTime)
  {}
  
}

#define leftFrontBumperPin
#define rightFrontBumperPin
#define rearBumperPin

void handleBumperInterrupt()
{
 // Spock(false);
}

void avoidObstacle()
{
  boolean onObstacle;
  backwardTime(5);
  while (onObstacle)
  turnTime(-64);
   turnTime(-64);
  
}

void stopBot()
{
  accelTo(0,0);
}

int turnTime(int angle)
{int startTime;
  if (angle < 0) // left turn
    startTime = accelTo(-turnSpeed,turnSpeed);
  else if (angle > 0)// right turn
    startTime = accelTo(turnSpeed,-turnSpeed);  
  else // no turn
  
  delay((abs(angle) * angleTimeConstant)- 2*(millis()-startTime));  
}

long forwardTime(int cm)// moves forward estimated cm centimeters based on motor run time.
{/*
  long startTime = accelTo(maxSpeed,maxSpeed);
  delay((cm * cmTimeConstant)- 2*(millis()-startTime));
  //
  long now = timestamp;
  long target = now + (delayTime);
  while (now < target) {
    now = timestamp;
    if (interupt) break;
  }
  if (interupt) handleInterupt;
  //
  stopBot;
  
  */
  long runTime;
  long endTime;
  long now;
  long startTime = accelTo(maxSpeed,maxSpeed);
  long target = ((cm * cmTimeConstant)- 2 * (millis()-startTime));
  while ((now = millis()) < target)
  {
    if (bumperTriggered)
     break;
  }
  endTime = accelTo(0,0);
  return (endTime - startTime) * -1 - bumperTriggered; 
}

int backwardTime(int cm)// moves backward estimated cm centimeters based on motor run time.
{
  long startTime = accelTo(-maxSpeed,-maxSpeed);
  delay((cm * cmTimeConstant)- 2*(millis()-startTime));
  stopBot;
}

void leftWheelEncoderTick()
{
  leftEncoderTicsSoFar++;
}

void rightWheelEncoderTick()
{
  rightEncoderTicsSoFar++;
}

unsigned long forwardDistance(int encoderTics) // each encoder tick should be some known 1/integer fraction of a grid square distance.  
{   // Measure circumference of wheel and lay out encoder markings accordingly.
  attachInterrupt(1,leftWheelEncoderTick,CHANGE);
  attachInterrupt(2,rightWheelEncoderTick,CHANGE);
  leftEncoderTicsSoFar = 0;
  rightEncoderTicsSoFar = 0;
  long startTime = accelTo(255,255);
  while ((leftEncoderTicsSoFar + rightEncoderTicsSoFar)/2 < encoderTics && !stopRequested) // we have not yet gone the requested distance.
    {}// keep going
  long endTime = accelTo(0,0); // fell through while loop, at requested position, stop
  detachInterrupt(1);
  detachInterrupt(2);
  return endTime - startTime; // travel time
}

unsigned long backwardDistance(int encoderTics)
{
  attachInterrupt(1,leftWheelEncoderTick,CHANGE);
  attachInterrupt(2,rightWheelEncoderTick,CHANGE);
  leftEncoderTicsSoFar = 0;
  rightEncoderTicsSoFar = 0;
  long startTime = accelTo(-255,-255);
  while ((leftEncoderTicsSoFar + rightEncoderTicsSoFar)/2 < encoderTics && !stopRequested) // we have not yet gone the requested distance.
    {}// keep going
  long endTime = accelTo(0,0); // fell through while loop, at requested position, stop
  detachInterrupt(1);
  detachInterrupt(2);
  return endTime - startTime; // travel time
}

unsigned long turnTo(int angle) // angle between -255 and +255
{  /*                   // negative values indicate counterclockwise spin, positive values clockwise
  attachInterrupt(1,leftWheelEncoderTick,CHANGE);
  attachInterrupt(2,rightWheelEncoderTick,CHANGE);
  leftEncoderTicsSoFar = 0;
  rightEncoderTicsSoFar = 0;
  */
  int reqHeading = currentHeading + angle;
  long startTime;
  if (angle < 0) // left turn
    startTime = accelTo(-turnSpeed,turnSpeed);
  else if (angle > 0)// right turn
    startTime = accelTo(turnSpeed,-turnSpeed);  
  else // no turn
    {return 0;}
    
  while ((!(currentHeading >= reqHeading - headingTolerance && currentHeading <= reqHeading + headingTolerance) && !stopRequested)) // we have not yet gone the requested angle. TODO double check this logic.
    {}// keep going
    
  long endTime = accelTo(0,0); // fell through while loop, at requested position, stop
//  detachInterrupt(1);
//  detachInterrupt(2);
  return endTime - startTime; // travel time
}

void setMotorSpeed()
{
  constrain(pwmLeft, -255,255);
  constrain(pwmRight, -255,255);
/*  
  if (pwmLeft < -255)// catch and fix any out of bounds values
    pwmLeft = -255;
  if (pwmLeft > 255)
    pwmLeft = 255;
  if (pwmRight < -255)
    pwmRight = -255;
  if (pwmRight > 255)
    pwmRight = 255;// catch and fix any out of bounds values
*/    
    
/* 
Please double check this following section of code against actual bot operation.  
I forgot which signals result in which direction
*/


// this block sets the left motor direction    
  if (pwmLeft > 0)  //left motor should go forward
  {
    digitalWrite(leftMotorGreen, LOW);
    digitalWrite(leftMotorRed, HIGH);
  }
  else if (pwmLeft < 0)//left motor should go backward
  {
    digitalWrite(leftMotorGreen, HIGH);
    digitalWrite(leftMotorRed, LOW);
  }
  else // braking required to stop bot
  {
    digitalWrite(leftMotorGreen, LOW);
    digitalWrite(leftMotorRed, LOW);
  }
  
 // this block sets the right motor direction    
  if (pwmRight > 0)  //right motor should go forward
  {
    digitalWrite(rightMotorGreen, LOW);
    digitalWrite(rightMotorRed, HIGH);
  }
  else if (pwmRight < 0)//right motor should go backward
  {
    digitalWrite(rightMotorGreen, HIGH);
    digitalWrite(rightMotorRed, LOW);
  }
  else // braking required to stop bot
  {
    digitalWrite(rightMotorGreen, LOW);
    digitalWrite(rightMotorRed, LOW);
  }
  
  // this block sets the motors speed
  analogWrite(leftMotorPWMpin, abs(pwmLeft));
  analogWrite(rightMotorPWMpin, abs(pwmRight));
}

unsigned long accelTo(int leftReq, int rightReq) // parameters represent requested ending speed for each side
{
  unsigned long startMove;
  boolean looped = false;
  int leftDifference,rightDifference;
  // init differences, and check if the accel is so big there is a need to run the loop
  if (abs(leftDifference = leftReq - pwmLeft) >= accelStep && abs(rightDifference = rightReq - pwmRight) >= accelStep)
  {
    for (int loops = accelLoops; loops >= 1; loops--) // every acceleration except those less than accelStep will occur in a fixed time interval (accelLoops * accelTimeOnLoop)
    { 
      if (loops == accelLoops/2) // halfway through the acceleration start the clock
        {startMove = millis();}
      pwmLeft += leftDifference/accelLoops;      // on each loop increment the wheel speed a fraction of the difference between 
      pwmRight += rightDifference/accelLoops;    // target speed and current speed
      setMotorSpeed();
      delay(accelTimeOnLoop); //milliseconds, adjust to the shortest time that does not result in wheelspin or wheelies.
    }
  }
  else 
  {  startMove = millis();  }
  
  pwmLeft = leftReq;
  pwmRight = rightReq;
  setMotorSpeed();
  
  return startMove;
}


/*
    blinks an LED for diagnostic purposes
   */
  void blink(int whatPin, int howManyTimes, int milliSecs) 
  {
    for (int i = 0; i < howManyTimes; i++) 
    {
      digitalWrite(whatPin, HIGH);
      delay(milliSecs/2);
      digitalWrite(whatPin, LOW);
      delay(milliSecs/2);
    }
  }

