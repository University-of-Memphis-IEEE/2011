


#include <EEPROM.h>

#include <Stepper.h>

#include <math.h>

// pin defines
#define Estop 2 // interrupt 0 on digital pin 2.  Testing use only.  Final configuration will use this pin for audio.  All interrupt pins already in use.
#define magAnalogPin 0
#define leftMotorGreen      7 // HIGH turns on Green LED on motor controller, pin connected to(color) logic wire and corresponds to (color) wire attached to left motor
#define leftMotorRed        8 // HIGH turns on Red   LED on motor controller, pin connected to(color) logic wire and corresponds to (color) wire attached to left motor
#define leftMotorPWMpin     9 // connected to left enable pin on motor controller with white logic wire
#define rightMotorGreen    10 // HIGH turns on Green LED on motor controller, pin connected to(red or black) logic wire and corresponds to (color) wire attached to right motor
#define rightMotorRed      11 // HIGH turns on Red   LED on motor controller, pin connected to(red or black) logic wire and corresponds to (color) wire attached to right motor
#define rightMotorPWMpin   12 // connected to right enable pin on motor controller with white logic wire
#define ledPin 30     // LED 
#define ledGnd 31
#define switchPin 53  // switch input

//test variables.  delete in final code
int switchCount = 0;
int buttonState = 0;         // current state of the button
int lastButtonState = 0;     // previous state of the button


void setup()
{
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
  pinMode(Estop, INPUT);
  digitalWrite(Estop, HIGH);
  
  // blink the LED 3 times when Arduino is reset, probably indicates the Arduino lost power
  blink(ledPin, 3, 500);
  attachInterrupt(0,stopBot,FALLING);// Estop Emergency Stop on pin 2 triggers when pin is grounded.  Will not retrigger if held down.  Only triggers on falling edge.
}


void loop()// test code
{
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
}
