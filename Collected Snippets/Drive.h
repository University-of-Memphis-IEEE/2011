#ifndef Drive_h
#define Drive_h

#include "WProgram.h"


class Drive
{
  public:
  Drive(const char *NAME);
  //motor controller only
  Drive(int LmotPosPinInt, int LmotNegPinInt, int LmotEnPinPWMint, int RmotPosPinInt, int RmotNegPinInt, int RmotEnPinPWMint);
  //motor controller and wheel encoders
  Drive(int LmotPosPinParam, int LmotNegPinParam, int LmotEnPinPWMParam, int RmotPosPinParam, int RmotNegPinParam, int RmotEnPinPWMParam, int LwhEncoderAPin, int LwhEncoderBPin, int RwhEncoderAPin, int RwhEncoderBPin);
  //motor controller, wheel encoders, and magnetometer on analog pin
  Drive(int LmotPosPinParam, int LmotNegPinParam, int LmotEnPinPWMParam, int RmotPosPinParam, int RmotNegPinParam, int RmotEnPinPWMParam, int LwhEncoderAPin, int LwhEncoderBPin, int RwhEncoderAPin, int RwhEncoderBPin, int magAnalogPin);
  //motor controller, wheel encoders, and magnetometer on i2c
  Drive(int LmotPosPinParam, int LmotNegPinParam, int LmotEnPinPWMParam, int RmotPosPinParam, int RmotNegPinParam, int RmotEnPinPWMParam, int LwhEncoderAPin, int LwhEncoderBPin, int RwhEncoderAPin, int RwhEncoderBPin, boolean magI2CPin);//I2C uses the Wire library on pins 4 and 5

  void forwardTicks(long ticks);// encoder ticks
  void forwardIn(double inches);
  void forwardCm(double centimeters);
  
  //does not require wheel encoders
  void forwardS(int seconds);
  void forwardMS(long milliseconds);
  
  void backwardTicks(long ticks);// encoder ticks
  void backwardIn(double inches);
  void backwardCm(double centimeters);
  
  //does not require wheel encoders
  void backwardS(int seconds);
  void backwardMS(long milliseconds);
  
  //requires wheel encoders
  void leftRadiusIn(double inches, byte angle);// makes a turn of the specified radius, through the specified binary angle 0-255
  void leftRadiusCm(double centimeters, byte angle);
  void rightRadiusIn(double inches, byte angle);
  void rightRadiusCm(double centimeters, byte angle);
  
  void rotateLeft(byte angle); // rotate a predefined angle
  void rotateRight(byte angle);// based on encoder ticks
  
  //requires magnetometer or other means to fix heading.  
  //must provide byte heading() function wich returns a binary angle measure representing the current heading
  void rotateLeftTo(byte bearing);// rotate until heading() = bearing
  void rotateRightTo(byte bearing);
  
  byte heading();// returns current heading relative to artificial north configured at startup
  byte magHeading();// returns current magnetometer heading
  private:
  char *name;
  int LmotPosPin;
  int LmotNegPin;
  int LmotEnPinPWM;
  int RmotPosPin;
  int RmotNegPin;
  int RmotEnPinPWM;
  int LwhEncoderAPin;
  int LwhEncoderBPin;
  int RwhEncoderAPin;
  int RwhEncoderBPin;
  int magAnalogPin;
  int magI2CPin;
  byte _heading;
  
};
#endif
