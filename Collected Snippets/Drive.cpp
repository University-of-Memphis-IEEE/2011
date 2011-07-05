#include "WProgram.h"
#include "Drive.h"
#include "config.h"

Drive::Drive(const char *NAME) // constructor takes the name of robot and uses it to open a text file of same name which contains all needed parameters.  Thus avoiding big gnarly parameter list
{
  LmotPosPin = LmotPosPinDef ; 
  LmotNegPin = LmotNegPinDef;
  LmotEnPinPWM = LmotEnPinPWMDef;
  RmotPosPin = RmotPosPinDef;
  RmotNegPin = RmotNegPinDef;
  RmotEnPinPWM = RmotEnPinPWMDef;
}

//motor controller only
Drive::Drive(int LmotPosPinParam, int LmotNegPinParam, int LmotEnPinPWMParam, int RmotPosPinParam, int RmotNegPinParam, int RmotEnPinPWMParam)
{
  LmotPosPin = LmotPosPinParam;
  LmotNegPin = LmotNegPinParam;
  LmotEnPinPWM = LmotEnPinPWMParam;
  RmotPosPin = RmotPosPinParam;
  RmotNegPin = RmotNegPinParam;
  RmotEnPinPWM = RmotEnPinPWMParam;
}

//motor controller and wheel encoders
Drive::Drive(int LmotPosPinParam, int LmotNegPinParam, int LmotEnPinPWMParam, int RmotPosPinParam, int RmotNegPinParam, int RmotEnPinPWMParam, int LwhEncoderAPin, int LwhEncoderBPin, int RwhEncoderAPin, int RwhEncoderBPin)
{
  LmotPosPin = LmotPosPinParam;
  LmotNegPin = LmotNegPinParam;
  LmotEnPinPWM = LmotEnPinPWMParam;
  RmotPosPin = RmotPosPinParam;
  RmotNegPin = RmotNegPinParam;
  RmotEnPinPWM = RmotEnPinPWMParam;
}

//motor controller, wheel encoders, and magnetometer on analog pin
Drive::Drive(int LmotPosPinParam, int LmotNegPinParam, int LmotEnPinPWMParam, int RmotPosPinParam, int RmotNegPinParam, int RmotEnPinPWMParam, int LwhEncoderAPin, int LwhEncoderBPin, int RwhEncoderAPin, int RwhEncoderBPin, int magAnalogPin)
{
  LmotPosPin = LmotPosPinParam;
  LmotNegPin = LmotNegPinParam;
  LmotEnPinPWM = LmotEnPinPWMParam;
  RmotPosPin = RmotPosPinParam;
  RmotNegPin = RmotNegPinParam;
  RmotEnPinPWM = RmotEnPinPWMParam;
}

//motor controller, wheel encoders, and magnetometer on i2c
Drive::Drive(int LmotPosPinParam, int LmotNegPinParam, int LmotEnPinPWMParam, int RmotPosPinParam, int RmotNegPinParam, int RmotEnPinPWMParam, int LwhEncoderAPin, int LwhEncoderBPin, int RwhEncoderAPin, int RwhEncoderBPin, boolean magI2CPin)//I2C uses the Wire library on pins 4 and 5
{
  LmotPosPin = LmotPosPinParam;
  LmotNegPin = LmotNegPinParam;
  LmotEnPinPWM = LmotEnPinPWMParam;
  RmotPosPin = RmotPosPinParam;
  RmotNegPin = RmotNegPinParam;
  RmotEnPinPWM = RmotEnPinPWMParam;
}



void Drive::forwardIn(double inches)
{
  digitalWrite(LmotPosPin, LHIGH);// set direction
  digitalWrite(LmotNegPin,LLOW);
  digitalWrite(RmotPosPin, RHIGH);
  digitalWrite(RmotNegPin,RLOW);
  analogWrite(LmotEnPinPWMDef,255);// set speed
  analogWrite(RmotEnPinPWMDef,255);
  
}

void Drive::forwardCm(double centimeters)
{
  digitalWrite(LmotPosPin, LHIGH);
  digitalWrite(LmotNegPin,LLOW);
  digitalWrite(RmotPosPin, RHIGH);
  digitalWrite(RmotNegPin,RLOW);
  analogWrite(LmotEnPinPWMDef,255);// set speed
  analogWrite(RmotEnPinPWMDef,255);
}

void Drive::forwardS(int seconds)
{
  digitalWrite(LmotPosPin, LHIGH);
  digitalWrite(LmotNegPin,LLOW);
  digitalWrite(RmotPosPin, RHIGH);
  digitalWrite(RmotNegPin,RLOW);
  analogWrite(LmotEnPinPWMDef,255);// set speed
  analogWrite(RmotEnPinPWMDef,255);
}

void Drive::forwardMS(long milliseconds)
{
  digitalWrite(LmotPosPin, LHIGH);
  digitalWrite(LmotNegPin,LLOW);
  digitalWrite(RmotPosPin, RHIGH);
  digitalWrite(RmotNegPin,RLOW);
  analogWrite(LmotEnPinPWMDef,255);// set speed
  analogWrite(RmotEnPinPWMDef,255);
}

void Drive::backwardIn(double inches)
{
  digitalWrite(LmotPosPin, LLOW);
  digitalWrite(LmotNegPin,LHIGH);
  digitalWrite(RmotPosPin, RLOW);
  digitalWrite(RmotNegPin,RHIGH);
  analogWrite(LmotEnPinPWMDef,255);// set speed
  analogWrite(RmotEnPinPWMDef,255);
}

void Drive::backwardCm(double centimeters)
{
  digitalWrite(LmotPosPin, LLOW);
  digitalWrite(LmotNegPin,LHIGH);
  digitalWrite(RmotPosPin, RLOW);
  digitalWrite(RmotNegPin,RHIGH);
  analogWrite(LmotEnPinPWMDef,255);// set speed
  analogWrite(RmotEnPinPWMDef,255);
}

void Drive::backwardS(int seconds)
{
  digitalWrite(LmotPosPin, LLOW);
  digitalWrite(LmotNegPin,LHIGH);
  digitalWrite(RmotPosPin, RLOW);
  digitalWrite(RmotNegPin,RHIGH);
  analogWrite(LmotEnPinPWMDef,255);// set speed
  analogWrite(RmotEnPinPWMDef,255);
}

void Drive::backwardMS(long milliseconds)
{
  digitalWrite(LmotPosPin, LLOW);
  digitalWrite(LmotNegPin,LHIGH);
  digitalWrite(RmotPosPin, RLOW);
  digitalWrite(RmotNegPin,RHIGH);
  analogWrite(LmotEnPinPWMDef,255);// set speed
  analogWrite(RmotEnPinPWMDef,255);
}

void Drive::leftRadiusIn(double inches, byte angle)// makes a turn of the specified radius, through the specified binary angle 0-255
{
  digitalWrite(LmotPosPin, LLOW);//slower speed
  digitalWrite(LmotNegPin,LHIGH);
  analogWrite(LmotEnPinPWMDef,127);// set speed
  
  
  digitalWrite(RmotPosPin, RLOW);//faster speed
  digitalWrite(RmotNegPin,RHIGH);
  analogWrite(RmotEnPinPWMDef,255);
}

void Drive::leftRadiusCm(double centimeters, byte angle)
{
 
}

void Drive::rightRadiusIn(double inches, byte angle)
{

}

void Drive::rightRadiusCm(double centimeters, byte angle)
{

}

void Drive::rotateLeft(byte angle) // rotate a predefined amount
{
  digitalWrite(LmotPosPin, LLOW);
  digitalWrite(LmotNegPin,LHIGH);
  digitalWrite(RmotPosPin, RHIGH);
  digitalWrite(RmotNegPin,RLOW);
  analogWrite(LmotEnPinPWMDef,255);// set speed
  analogWrite(RmotEnPinPWMDef,255);
}

void Drive::rotateRight(byte angle)
{
  digitalWrite(LmotPosPin, LHIGH);
  digitalWrite(LmotNegPin,LLOW);
  digitalWrite(RmotPosPin, RLOW);
  digitalWrite(RmotNegPin,RHIGH);
  analogWrite(LmotEnPinPWMDef,255);// set speed
  analogWrite(RmotEnPinPWMDef,255);
}

void Drive::rotateLeftTo(byte bearing)// rotate until heading() = bearing
{
  digitalWrite(LmotPosPin, LLOW);
  digitalWrite(LmotNegPin,LHIGH);
  digitalWrite(RmotPosPin, RHIGH);
  digitalWrite(RmotNegPin,RLOW);
  
  digitalWrite(LmotPosPin, LHIGH);
  digitalWrite(LmotNegPin,LLOW);
  digitalWrite(RmotPosPin, RLOW);
  digitalWrite(RmotNegPin,RHIGH);
}

void Drive::rotateRightTo(byte bearing)
{
  digitalWrite(LmotPosPin, LLOW);
  digitalWrite(LmotNegPin,LHIGH);
  digitalWrite(RmotPosPin, RHIGH);
  digitalWrite(RmotNegPin,RLOW);  
}

byte Drive::heading()// returns current heading relative to artificial north configured at startup
{

}

byte Drive::magHeading()// returns current magnetometer heading
{

}

