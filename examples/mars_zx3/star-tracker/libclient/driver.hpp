/// (c) Koheron

#ifndef __DRIVER_HPP__
#define __DRIVER_HPP__
#include <stdint.h>
#include <stdio.h>


class ASCOM_sky_interface {
 public:
  ASCOM_sky_interface(const char* host, int port);
  ~ASCOM_sky_interface();

  // SetPolarScopeLED          = 'V',
  bool swp_set_PolarScopeLED();
  uint32_t swp_get_Feature(uint8_t axis);
  // SetFeatureCmd             = 'W', // EQ8/AZEQ6/AZEQ5 only
  bool swp_set_Feature(uint8_t axis, uint8_t cmd);
  // GetFeatureCmd             = 'q', // EQ8/AZEQ6/AZEQ5 only
  // InquireAuxEncoder         = 'd', // EQ8/AZEQ6/AZEQ5 only
  uint32_t swp_get_AuxEncoder(uint8_t axis);
  // GetHomePosition           = 'd', // Get Home position encoder count
  // (default at startup)
  // not used in eqmod
  uint32_t swp_get_HomePosition(uint8_t axis);
  // StartMotion               = 'J', // start
  bool swp_cmd_StartMotion(uint8_t axis, bool isSlew, bool use_accel);
  // SetStepPeriod             = 'I', //set slew speed
  bool swp_set_StepPeriod(uint8_t axis, bool isSlew, uint32_t period_usec);
  // SetGotoTarget             = 'S', // does nothing??
  bool swp_set_GotoTarget(uint8_t axis, uint32_t target);
  // SetBreakStep              = 'U', // does nothing??
  bool swp_set_BreakStep(uint8_t axis, uint32_t ncycles);
  // NOT SURE SetBreakPointIncrement    = 'M',
  // does nothing ??
  bool swp_set_BreakPointIncrement(uint8_t axis, uint32_t ncycles);
  // set goto target - SetGotoTargetIncrement    = 'H', // set goto position
  bool swp_set_GotoTargetIncrement(uint8_t axis, uint32_t ncycles);
  // SetMotionMode             = 'G', mode and direction
  bool swp_set_MotionModeDirection(uint8_t axis, bool isForward, bool isSlew,
                                   bool isHighSpeed);
  // GetAxisStatus             = 'f',
  uint32_t swp_get_AxisStatus(uint8_t axis);
  // GetAxisPosition           = 'j', // current position
  uint32_t swp_get_AxisPosition(uint8_t axis); 
  // SetAxisPositionCmd        = 'E', set current position
  bool swp_set_AxisPosition(uint8_t axis, uint32_t value);
  // InstantAxisStop (L) + NotInstantAxisStop (K)
  bool swp_cmd_StopAxis(uint8_t axis, bool instant);
  // Encoder stuff (g) // speed scalar for high speed skew
  // InquireHighSpeedRatio     = 'g',
  double swp_get_HighSpeedRatio(uint8_t axis);
  // InquireTimerInterruptFreq = 'b', // sidereal rate of axis   steps per
  // worm???
  uint32_t swp_get_TimerInterruptFreq();
  // InquireGridPerRevolution  = 'a', // steps per axis revolution
  uint32_t swp_get_GridPerRevolution(uint8_t axis);
  // InquireMotorBoardVersion  = 'e',
  uint32_t swp_get_BoardVersion();
  // Initialize                = 'F',
  bool swp_cmd_Initialize(uint8_t axis);
  uint32_t get_forty_two();
  uint64_t get_dna();

 private:
};

#endif  // __DRIVER_HPP__
