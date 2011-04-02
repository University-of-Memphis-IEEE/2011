#include <EEPROM.h>
#include <Stepper.h>
#include <VoiceShield.h>
#include <Wire.h>					//Include I2C library
#include "ADXL345.h"
#include "officers.h"

// I2C addresses
#define viewer 0x50					//Display Panel
#define compass 0x60					//Compass

// Stepper motor
#define motorSTEPS 200
#define stepWhite 47
#define stepBrown 49
#define stepGreen 51
#define stepRed 53
#define stepRate 30					//RPM

// motor defines
#define leftMotorGreen      7 // HIGH turns on Green LED on motor controller, pin connected to(color) logic wire and corresponds to (color) wire attached to left motor
#define leftMotorRed        8 // HIGH turns on Red   LED on motor controller, pin connected to(color) logic wire and corresponds to (color) wire attached to left motor
#define leftMotorPWMpin     9 // connected to left enable pin on motor controller with white logic wire
#define rightMotorGreen    10 // HIGH turns on Green LED on motor controller, pin connected to(red or black) logic wire and corresponds to (color) wire attached to right motor
#define rightMotorRed      11 // HIGH turns on Red   LED on motor controller, pin connected to(red or black) logic wire and corresponds to (color) wire attached to right motor
#define rightMotorPWMpin   12 // connected to right enable pin on motor controller with white logic wire
#define switchPin 53  // switch input
// these need to be optimized during physical testing
#define accelStep 32   // largest instantaneous jump in speed
#define accelLoops 8 // higher number smooths out the acceleration at the cost of cycles, time, and distance over course
#define accelTimeOnLoop 15 //milliseconds
#define AVOIDANCE_DELAY 200 //milliseconds
#define AVOIDANCE_EPSILON 5 //within x units of original heading


long starDate = 2011020710;
Stepper stepper(motorSTEPS, stepWhite, stepBrown, stepGreen, stepRed);
VoiceShield SubSpace(80);
const byte viewDig3 = 0x23;                          
const byte viewDig2 = 0x22;
const byte viewDig1 = 0x21;
const byte viewDig0 = 0x20;
int launchTime = 0;
byte MasterX = 12;					//current X coordinate
byte MasterY = 1;					//current Y coordinate
byte MasterRoom = 0;					//current room
byte mapTop = 0;					//compass direction to top of map
int pwmLeft;
int pwmRight;
byte prevStep = 0;					//previous step
boolean unoInterrupt = false;
boolean megaInterrupt = false;
// Short range IR lookup table
const byte SLUT[] = {255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,99,96,93,90,88,86,84,82,80,78,77,75,74,72,71,69,68,66,65,63,62,60,59,58,56,55,54,53,52,51,50,49,48,47,46,45,44,43,43,42,42,41,41,40,40,39,39,38,38,37,37,36,36,35,35,34,34,33,33,32,32,32,31,31,30,30,29,29,29,28,28,28,27,27,27,26,26,26,26,26,25,25,25,25,25,24,24,24,24,24,24,23,23,23,23,23,22,22,22,22,22,21,21,21,21,21,20,20,20,20,20,20,19,19,19,19,19,19,18,18,18,18,18,18,17,17,17,17,17,17,17,16,16,16,16,16,16,16,15,15,15,15,15,15,15,15,15,14,14,14,14,14,14,14,14,14,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,11,11,11,11,11,11,11,11,11,11,11,11,11,10,10,10,10,10,10,10,10,10,10,10};
// Long range IR lookup table
const byte LLUT[] = {160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,156,151,147,143,139,136,133,130,127,125,123,120,118,116,114,112,111,109,107,106,104,103,102,100,99,98,96,95,94,93,92,91,90,89,88,87,86,85,84,83,82,82,81,80,79,78,78,77,76,75,75,74,73,73,72,71,71,70,69,69,68,67,67,66,66,65,65,64,64,63,62,62,61,61,60,60,59,59,58,58,58,57,57,56,56,55,55,54,54,54,53,53,52,52,51,51,51,50,50,50,49,49,48,48,48,47,47,47,46,46,46,45,45,44,44,44,43,43,43,43,42,42,42,41,41,41,40,40,40,39,39,39,39,38,3838,37,37,37,37,36,36,36,35,35,35,35,34,34,34,34,33,33,33,33,32,32,32,32,31,31,31,31,30,30,30,30,29,29,29,29,28,28,28,28,28,27,27,27,27,26,26,26,26,26,25,25,25,25,25,24,24,24,24,23,23,23,23,23,22,22,22,22,22,22,21,21,21,21,21,20,20,20};

void setup() {
    Serial.begin(9600);
    Serial3.begin(9600);
    // start button
    pinMode(32, INPUT);
    // set the pin high for assert low
    digitalWrite(32, HIGH);			//Start Button
    pinMode(20, OUTPUT);			//I2C transmit pin
    Wire.begin();			        //Join I2C bus
    viewerOn();
    activateCompass();
    stepper.setSpeed(stepRate);
    attachInterrupt(4, uno, RISING);
    attachInterrupt(5, mega, RISING);
}

void loop() {
    byte whenReady = 0;
    if (starDate == 2011020710) { //initialization sequence
        //starMap();
        //delay(3000);
        //displayMap();
        starDate++;
        SubSpace.ISDPLAY_to_EOM(17);
        onScreen('\0', viewDig3);
        onScreen('\0', viewDig2);
        onScreen('\0', viewDig1);
        onScreen('\0', viewDig0);
    }
    
    whenReady = digitalRead(32);
    if (whenReady == LOW && starDate > 2011020710) {
        launchTime = micros();
        Kirk();
    }
}

void uno() {
    unoInterrupt = true;
}

void mega() {
    megaInterrupt = true;
}

/*	Kirk	*/
void Kirk () {
    int clock = 0;
    byte foundVic;
    SubSpace.ISDPLAY_to_EOM(40);		// Play Star Trek Theme Intro
    warp1();
    spin(false); // turn right
    delay(5); // in milliseconds
    while(getHeading() < 64);
    fullStop();
    searchPass();
    while(getHeading() < 127);
    fullStop();
    searchPass();
    softR();
    while(getHeading() <= 5);
    fullStop();
    searchPass();
    softL();
    fullStop();
    delay(5);
    while(getHeading() <= 128);
    searchPass();
    softR();
    while(getHeading() <= 5);
    fullStop();
    searchPass();
    spin(true);
    delay(5);
    while(getHeading() > 192);
    searchPass();
    spin(true);
    while(getHeading() > 128);    
    fullStop();
    searchPass();
    softL();
    while(getHeading() < 250);
    fullStop();
    searchPass();
    softR();
    delay(5);
    while(getHeading() < 128);
    fullStop();
    searchPass();
    softL();
    while(getHeading() < 250);
    fullStop();
    searchPass();
    spin(false);
    delay(5);
    while(getHeading() < 64);
    fullStop();
    while (irL() > 120) {
        forwardR(255);
        forwardL(255);
        if (irS() < 15) {
            avoidObstacle();
        }
    }
    spin(false);
    while(getHeading() < 128);
    fullStop();
    while (irL() > 120) {
        forwardR(255);
        forwardL(255);
        if (irS() < 15) {
            avoidObstacle();
        }
    }
    spin(false);
    while(getHeading() < 192);
    fullStop();
    warp1();
    spin(true);
    searchPass();
    spin(true);
    while(getHeading() > 64);
    fullStop();
    searchPass();
    softL();
    while(getHeading() < 127 || getHeading() > 192);
    fullStop();
    searchPass();
    softR();
    while(getHeading() > 180 || getHeading() < 64);
    fullStop();
    searchPass();
    softL();
    while(getHeading() < 127 || getHeading() > 192);
    fullStop();
    searchPass();
    spin(false);
    while(getHeading() > 127);
    fullStop();
    warp1();
    spin(false);
    delay(5);
    while(getHeading() < 64);
    fullStop();
    warp1();
    spin(false);
    while(getHeading() < 127);
    fullStop();
    searchPass();
    spin(false);
    while(getHeading() < 192);
    fullStop();
    searchPass();
    softR();
    while(getHeading() > 197 || getHeading() < 64);
    fullStop();
    searchPass();
    softL();
    while(getHeading() < 69 || getHeading() > 192);
    fullStop();
    searchPass();
    softR();
    while(getHeading() > 197 || getHeading() < 64);
    fullStop();
    searchPass();
}

void warp1(){
    while (irL() > 20) {
        forwardR(255);
        forwardL(255);
        if (irS() < 15) {
            avoidObstacle();
        }
    }
}

void searchPass() {
    while (irL() > 20) {
        forwardR(255);
        forwardL(255);
        if (megaInterrupt) {
            scanVictim();
        }
        if (irS() < 15) {
            avoidObstacle();
        }
    }
}

byte trimCoord(byte bigC) {
    return ((bigC + 5) / 10);
}

void activateCompass(){
    Wire.beginTransmission(compass);
    Wire.send(1);
    Wire.requestFrom(compass, 1);	//Give me 1 byte
    while(Wire.available() < 1);	//Wait until byte is available
    mapTop = Wire.receive();
    Wire.endTransmission();
    //	Serial.println(int(mapTop));
}

byte getHeading(){
    byte heading;

    Wire.beginTransmission(compass);
    Wire.send(1);
    Wire.requestFrom(compass, 1);	//Give me 1 byte
    while(Wire.available() < 1);	//Wait until byte is available
    heading = Wire.receive();
    Wire.endTransmission();
    heading -= mapTop;
    return (heading);
}

byte irS(){
     return SLUT[map(analogRead(A1), 0, 1024, 0, 255)];
}

byte irL(){
     return LLUT[map(analogRead(A0), 0, 1024, 0, 255)];
}
/*	Kirk end	*/

void warpDriveOnline() {
    pinMode(leftMotorGreen, OUTPUT);
    pinMode(leftMotorRed, OUTPUT);
    pinMode(leftMotorPWMpin, OUTPUT);

    pinMode(rightMotorGreen, OUTPUT);
    pinMode(rightMotorRed, OUTPUT);
    pinMode(rightMotorPWMpin, OUTPUT);
}

/*	Uhura	*/
void Uhura (byte x, byte y, byte found) {
    byte direc = getHeading();
    if (direc < 64) {  // 1st Quadrant
        x += 3;
        y += 3;
    }
    else if (direc < 128) {  // 2nd Quadrant
        x += 3;
        y -= 3;
    }
    else if (direc < 192) {  // 3rd Quadrant
        x -= 3;
        y -= 3;
    }
    else {  // 4th Quadrant
        x -= 3;
        y += 3;
    }
    x = trimCoord(x);
    y = trimCoord(y);

    transmitSignal (found, MasterRoom, x, y);
    openChannel (found, MasterRoom, x, y);
}

void openChannel (byte found, byte room, byte x, byte y) {
    SubSpace.ISDPLAY_to_EOM(found + 12);
    SubSpace.ISDPLAY_to_EOM(room);
    if (found != 4) {
        SubSpace.ISDPLAY_to_EOM(11);
        SubSpace.ISDPLAY_to_EOM(x);
        SubSpace.ISDPLAY_to_EOM(y);
    }
}

void transmitSignal (byte found, byte room, byte x, byte y) {	// Display Panel
    onScreen(room, viewDig3);
    if (found != 4) {
        onScreen(x, viewDig2);
        onScreen(y, viewDig1);
        onScreen(found, viewDig0);
    }
    else {
        onScreen('\0', viewDig2);
        onScreen('\0', viewDig1);
        onScreen('\0', viewDig0);
    }
}

void onScreen(byte value, byte disp)
{
    Wire.beginTransmission(viewer);
    Wire.send(disp);			// which panel?  3 = left, 0 = right
    if (value == '\0') Wire.send(' ');
    else Wire.send(value);
    Wire.endTransmission();
}

void viewerOn() {
    Wire.beginTransmission(viewer);
    Wire.send(0x04);			// select configuration register
    Wire.send(0x01);			// disable shutdown;
    Wire.endTransmission();
    Wire.beginTransmission(viewer);
    Wire.send(0x01);			// Digits 0 and 2 intensity
    Wire.send(0x33);			//10 ma
    Wire.endTransmission();
    Wire.beginTransmission(viewer);
    Wire.send(0x02);			//Digits Digit 1 and 3 intensity
    Wire.send(0x33);			//10 ma
    Wire.endTransmission();
    Wire.beginTransmission(viewer);
    Wire.send(0x07);			//all segments test
    Wire.send(0x01);			//all on
    Wire.endTransmission();
    delay(250);
    Wire.beginTransmission(viewer);
    Wire.send(0x07);		//all segments test
    Wire.send(0x00);		//all off
    Wire.endTransmission();
}
/*	Uhura end	*/

void avoidObstacle()
{
    fullStop();
    int originalHeading = getHeading();
    byte center = irS();
    spin(false);
    delay(AVOIDANCE_DELAY);
    fullStop();
    byte right = irS();
    spin(true);
    delay(2*AVOIDANCE_DELAY);
    fullStop();
    byte left = irS();
    byte best = max(max(center, right),left);
    // do we go left?
    if (best != left)
    {
        spin(false);
        delay(2*AVOIDANCE_DELAY);
        fullStop();
    }
    forwardR(255);
    forwardL(255);
    delay(500);
    fullStop();
    spin(best != left);
    delay(2*AVOIDANCE_DELAY);
    forwardR(255);
    forwardL(255);
    delay(250);
    fullStop();
    spin(best == left);
    while((getHeading() > ((originalHeading + AVOIDANCE_EPSILON) % 255)) || (getHeading() < ((originalHeading - AVOIDANCE_EPSILON) % 255)));
}

void scanVictim()
{
}

