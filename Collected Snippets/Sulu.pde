// other defines


#define Left 'L'  // used for int type to indicate left
#define Right 'R'  // used for int type to indicate right
#define maxSpeed 255
#define turnSpeed 192  // in case we need to slow down to take our turns.
 // not yet implimented

// these need to be optimized during physical testing
#define accelStep 32   // largest instantaneous jump in speed.  Should be the largest value that does not result in wheelspin or wheelies.
#define accelLoops 8 // higher number smooths out the acceleration at the cost of time, and distance over course.  If raising accelLoops, compensate by lowering accelTimeOnLoop
#define accelTimeOnLoop 15 //milliseconds,  adjust to the shortest time that does not result in wheelspin or wheelies.

//global variables 
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
  
   
byte magneticHeading = analogRead(pinMagnetometer)/128; // scale from 0-1024 down to 0-255
byte compassOffset;  
byte currentHeading = magneticHeading + compassOffset; // heading overflows at 255 
const int wheelSep = 18;//cm
int vLeft; // measure the actual velocity produced at each of 256 pwm outputs
int vRight;// then create a lookup table.
int theta; // angle of final orientation with respect to initial orientation.
int pwmLeft;
int pwmRight;

/*     Equations of some use

cosine is sine from angle+fullcircle/4
arctan(x) = x / (1 + 0.28x2) + ε(x), where |ε(x)| ≤ .005 over -1 ≤ x ≤ 1

(x,y)is the center point between the wheels
dx/dt = 1/2 * (Vleft + Vright) * cos(Theta)
dy/dt = 1/2 * (Vleft + Vright) * sin(Theta)
dTheta/dt = 1/botWidth * (Vleft - Vright)
dVleft/dt = pwmLeft
dVright/dt = pwmRight

*/



// helper functions
void stopBot()
{
  accelTo(0,0);
}

void forward(int encoderTics) // each encoder tick should be some known 1/integer fraction of a grid square distance.  
{                             // Measure circumference of wheel and lay out encoder markings accordingly. 
  
}

void backward(int encoderTics)
{
  
}

void turnTo(int angle) // angle between -255 and +255
{                     // negative values indicate counterclockwise spin, positive values clockwise
  if (
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

void accelTo(int leftReq, int rightReq) // parameters represent requested ending speed for each side
{
  int leftDifference,rightDifference;
  // init differences, and check if the accel is so big there is a need to run the loop
  if (abs(leftDifference = leftReq - pwmLeft) >= accelStep && abs(rightDifference = rightReq - pwmRight) >= accelStep)
  {
    for (int loops = accelLoops; loops >= 1; loops--) // every acceleration except those less than accelStep will occur in a fixed time interval (accelLoops * accelTimeOnLoop)
    {      
      pwmLeft += leftDifference/accelLoops;      // on each loop increment the wheel speed a fraction of the difference between 
      pwmRight += rightDifference/accelLoops;    // target speed and current speed
      setMotorSpeed();
      delay(accelTimeOnLoop); //milliseconds, adjust to the shortest time that does not result in wheelspin or wheelies.
    }
  }
  
  pwmLeft = leftReq;
  pwmRight = rightReq;
  setMotorSpeed();
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

