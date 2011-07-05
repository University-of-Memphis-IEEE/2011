#define NAME IEEEbot2011

#ifdef IEEEbot2011

  #define L298
  #define LmotPosPinDef 53
  #define LmotNegPinDef 52
  #define LmotEnPinPWMDef 12
  #define RmotPosPinDef 51
  #define RmotNegPinDef 50
  #define RmotEnPinPWMDef 13
  #define MOT_CFG 0

#endif



// default pin assignments
#ifndef LmotPosPinDef
#define LmotPosPinDef 53
#endif
#ifndef LmotNegPinDef
#define LmotNegPinDef 52
#endif
#ifndef LmotEnPinPWMDef
#define LmotEnPinPWMDef 12
#endif
#ifndef RmotPosPinDef
#define RmotPosPinDef 51
#endif
#ifndef RmotNegPinDef
#define RmotNegPinDef 50
#endif
#ifndef RmotEnPinPWMDef
#define RmotEnPinPWMDef 13
#endif

/* 
The purpose of the MOT_CFG is to easilly compensate for variations in motor type, placement, and wiring 
simply choose the MOT_CFG that results in both wheels driving forward.
*/
#if MOT_CFG == 0 // both motors high and low remain unchanged
#define LHIGH HIGH
#define LLOW LOW
#define RHIGH HIGH
#define RLOW LOW
#elif MOT_CFG == 1// both motors high and low reversed
#define LHIGH LOW
#define LLOW HIGH
#define RHIGH LOW
#define RLOW HIGH
#elif MOT_CFG == 2// left normal, right reversed
#define LHIGH HIGH
#define LLOW LOW
#define RHIGH LOW
#define RLOW HIGH
#elif MOT_CFG == 3// left reversed, right normal
#define LHIGH LOW
#define LLOW HIGH
#define RHIGH HIGH
#define RLOW LOW
#endif
