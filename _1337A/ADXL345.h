//  Type and enumeration information for the ADXL345 chipset.
//  (C) Copyright 2011 Jon Olson
//  This is open source without any warranty, explicit or implied.

#ifndef _ADXL345_H_
#define _ADXL345_H_

#include <WProgram.h>

const byte ADXL345_ADDRESS = 0xE5;


typedef enum
{
  TapThreshold = 0x1D,          //RW
  OffsetX,                      //RW
  OffsetY,                      //RW
  OffsetZ,                      //RW
  TapDuration,                  //RW
  TapLatency,                   //RW
  TapWindow,                    //RW
  ActivityThreshold,            //RW
  InactivityThreshold,          //RW
  InactivityTime,               //RW
  ActivityInactivityControl,    //RW
  FreeFallThreshold,            //RW
  FreeFallTime,                 //RW
  TapAxes,                      //RW
  TapStatus,                    //R
  DataRatePowerModeControl,     //RW - Resets to 0x0A
  PowerSavingFeaturesControl,   //RW
  InterruptEnableControl,       //RW
  InterruptMappingControl,      //RW
  SourceOfInterrupts,           //R - Resets to 0x02
  DataFormatControl,            //RW
  XAxisData0,                   //R
  XAxisData1,                   //R
  YAxisData0,                   //R
  YAxisData1,                   //R
  ZAxisData0,                   //R
  ZAxisData1,                   //R
  FIFOControl,                  //RW
  FIFOStatus,                   //RW
} ADXL345_Register;


typedef union
{
  struct
  {
    byte ActivityCoupledOperation:1;    // 0 for DC, 1 for AC
    byte ActivityXEnable:1;
    byte ActivityYEnable:1;
    byte ActivityZEnable:1;
    byte InactivityCoupledOperation:1;  // 0 for DC, 1 for AC
    byte InactivityXEnable:1;
    byte InactivityYEnable:1;
    byte InactivityZEnable:1;
  };
  byte value;
} ActivityInactivityControlBits;


typedef union
{
  struct
  {
    byte data:4;
    byte Suppress:1;
    byte TapEnableX:1;
    byte TapEnableY:1;
    byte TapEnableZ:1;
  };
  byte value;
} TapAxesBits;


typedef union
{
  struct
  {
    byte unused:1;
    byte ActivitySourceX:1;
    byte ActivitySourceY:1;
    byte ActivitySourceZ:1;
    byte Asleep:1;
    byte TapSourceX:1;
    byte TapSourceY:1;
    byte TapSourceZ:1;
  };
  byte value;
} TapStatusBits;


typedef union
{
  struct
  {
    byte unused:3;
    byte LowPower:1;
    byte Rate:4;
  };
  byte value;
} DataRatePowerModeControlBits;


typedef union
{
  struct
  {
    byte unused:2;
    byte Link:1;
    byte AutoSleep:1;
    byte Measure:1;
    byte Sleep:1;
    byte Wakeup:2;
  };
  byte value;
} PowerSavingFeaturesControlBits;


typedef union
{
  struct
  {
    byte DataReady:1;
    byte SingleTap:1;
    byte DoubleTap:1;
    byte Activity:1;
    byte Inactivity:1;
    byte FreeFall:1;
    byte Watermark:1;
    byte Overrun:1;
  };
  byte value;
} InterruptEnableMappingAndSourceBits;


typedef union
{
  struct
  {
    byte SelfTest:1;
    byte SPIMode:1;         // 1 for 3-wire mode, 0 for 4-wire mode
    byte InterruptInvert:1; // 0 assert high, 1 assert low.
    byte unused:1;
    byte FullResolution:1;
    byte Justify:1;
    byte Range:2;
  };
  byte value;
} DataFormatControlBits;


typedef union
{
  struct
  {
    byte FIFOMode:2;
    byte Trigger:1;
    byte Samples:5;
  };
  byte value;
} FIFOControlBits;


typedef union
{
  struct
  {
    byte FIFOTrigger:1;
    byte unused:1;
    byte Entries:6;
  };
  byte value;
} FIFOStatusBits;

#endif
