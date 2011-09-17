
/* 
 Stepper Motor Control =scan
 
 This program drives a unipolar or bipolar stepper motor. 
 The motor is attached to digital pins 47,49, 51, and 53 of the Arduino mega 1280.
 
 The motor should revolve one revolution in one direction, stopping at regular intervals, then
 repeat in the other direction.  
 */

#include <Stepper.h>

const int stepsPerRevolution = 200;  // this is a property of our motor and does not change, each step is 1.8 degrees
const int scansPerRevolution = 25; // adjust this to suit your data gathering needs, best if a factor of 200
const int stepsBetweenScans = stepsPerRevolution/scansPerRevolution; //must be integer math
int currentScan;                                     

// initialize the stepper library on pins 8 through 11:
Stepper myStepper(stepsPerRevolution, 53,49,51,47);   //red brown green white 53,49,51,47         

void setup() {
  // set the speed at 60 rpm:
  myStepper.setSpeed(60);
  // initialize the serial port:
  Serial.begin(9600);
}

void loop() {
  
  // one revolution in one direction stopping at intervals to run scan  
  
   Serial.println("clockwise");
   for (currentScan = 0; currentScan <= scansPerRevolution; currentScan++)
   {
  Serial.print("Currently scanning position #");
  Serial.println(currentScan);
  // call scan here
  delay(15);   
  myStepper.step(stepsBetweenScans);// move to next position
   }
   
   // one revolution in the other direction:
  Serial.println("counterclockwise");
  for (; currentScan >=0; currentScan--)
   {
  Serial.print("Currently scanning position #");
  Serial.println(currentScan);
  // call scan here
  delay(15);
  myStepper.step(-stepsBetweenScans);
   }
}

