#include <koheron-client.hpp>

#include "driver.hpp"

static KoheronClient* client;

ASCOM_sky_interface::ASCOM_sky_interface(const char* host, int port) {
  client = new KoheronClient(host, port);
  client->connect();
}
ASCOM_sky_interface::~ASCOM_sky_interface(){
  if (client != NULL) delete client;
}
// SetPolarScopeLED          = 'V',
bool ASCOM_sky_interface::swp_set_PolarScopeLED() {
  client->call<op::ASCOMInterface::swp_set_PolarScopeLED>();
  auto buffer = client->recv<op::ASCOMInterface::swp_set_PolarScopeLED, bool>();
  return buffer;
}
// GetFeatureCmd             = 'q', // EQ8/AZEQ6/AZEQ5 only
uint32_t ASCOM_sky_interface::swp_get_Feature(uint8_t axis) {
  client->call<op::ASCOMInterface::swp_get_Feature>(axis);
  auto buffer = client->recv<op::ASCOMInterface::swp_get_Feature, uint32_t>();
  return buffer;
}
// SetFeatureCmd             = 'W', // EQ8/AZEQ6/AZEQ5 only
bool ASCOM_sky_interface::swp_set_Feature(uint8_t axis,
                                          uint8_t cmd) {  // not used
  client->call<op::ASCOMInterface::swp_set_Feature>(axis, cmd);
  auto buffer = client->recv<op::ASCOMInterface::swp_set_Feature, bool>();
  return buffer;
}
// GetFeatureCmd             = 'q', // EQ8/AZEQ6/AZEQ5 only
// InquireAuxEncoder         = 'd', // EQ8/AZEQ6/AZEQ5 only
uint32_t ASCOM_sky_interface::swp_get_AuxEncoder(uint8_t axis) {
  client->call<op::ASCOMInterface::swp_get_AuxEncoder>(axis);
  auto buffer = client->recv<op::ASCOMInterface::swp_get_AuxEncoder, uint32_t>();
  return buffer;
}
// GetHomePosition           = 'd', // Get Home position encoder count
// (default at startup)
// not used in eqmod
uint32_t ASCOM_sky_interface::swp_get_HomePosition(uint8_t axis) {
  client->call<op::ASCOMInterface::swp_get_HomePosition>(axis);
  auto buffer = client->recv<op::ASCOMInterface::swp_get_HomePosition, uint32_t>();
  return buffer;
}
// StartMotion               = 'J', // start
bool ASCOM_sky_interface::swp_cmd_StartMotion(uint8_t axis, bool isSlew,
                                              bool use_accel) {
  client->call<op::ASCOMInterface::swp_cmd_StartMotion>(axis, isSlew, use_accel);
  auto buffer = client->recv<op::ASCOMInterface::swp_cmd_StartMotion, bool>();
  return buffer;
}
// SetStepPeriod             = 'I', //set slew speed
bool ASCOM_sky_interface::swp_set_StepPeriod(uint8_t axis, bool isSlew,
                                             uint32_t period_usec) {
  client->call<op::ASCOMInterface::swp_set_StepPeriod>(axis, isSlew, period_usec);
  auto buffer = client->recv<op::ASCOMInterface::swp_set_StepPeriod, bool>();
  return buffer;
}
// SetGotoTarget             = 'S', // does nothing??
bool ASCOM_sky_interface::swp_set_GotoTarget(uint8_t axis, uint32_t target) {
  client->call<op::ASCOMInterface::swp_set_GotoTarget>(axis, target);
  auto buffer = client->recv<op::ASCOMInterface::swp_set_GotoTarget, bool>();
  return buffer;
}
// SetBreakStep              = 'U', // does nothing??
bool ASCOM_sky_interface::swp_set_BreakStep(uint8_t axis, uint32_t ncycles) {
  client->call<op::ASCOMInterface::swp_set_BreakStep>(axis, ncycles);
  auto buffer = client->recv<op::ASCOMInterface::swp_set_BreakStep, bool>();
  return buffer;
}
// NOT SURE SetBreakPointIncrement    = 'M',
// does nothing ??
bool ASCOM_sky_interface::swp_set_BreakPointIncrement(uint8_t axis,
                                                      uint32_t ncycles) {
  client->call<op::ASCOMInterface::swp_set_BreakPointIncrement>(axis, ncycles);
  auto buffer = client->recv<op::ASCOMInterface::swp_set_BreakPointIncrement, bool>();
  return buffer;
}
// set goto target - SetGotoTargetIncrement    = 'H', // set goto position
bool ASCOM_sky_interface::swp_set_GotoTargetIncrement(uint8_t axis,
                                                      uint32_t ncycles) {
  client->call<op::ASCOMInterface::swp_set_GotoTargetIncrement>(axis, ncycles);
  auto buffer = client->recv<op::ASCOMInterface::swp_set_GotoTargetIncrement, bool>();
  return buffer;
}
// SetMotionMode             = 'G', mode and direction
bool ASCOM_sky_interface::swp_set_MotionModeDirection(uint8_t axis,
                                                      bool isForward,
                                                      bool isSlew,
                                                      bool isHighSpeed) {
  client->call<op::ASCOMInterface::swp_set_MotionModeDirection>(axis, isForward, isSlew, 
      isHighSpeed);
  auto buffer = client->recv<op::ASCOMInterface::swp_set_MotionModeDirection, bool>();
  return buffer;
}

// GetAxisStatus             = 'f',
uint32_t ASCOM_sky_interface::swp_get_AxisStatus(uint8_t axis) {
  client->call<op::ASCOMInterface::swp_get_AxisStatus>(axis);
  auto buffer = client->recv<op::ASCOMInterface::swp_get_AxisStatus, uint32_t>();
  return buffer;
}

// GetAxisPosition           = 'j', // current position
uint32_t ASCOM_sky_interface::swp_get_AxisPosition(uint8_t axis) {
  client->call<op::ASCOMInterface::swp_get_AxisPosition>(axis);
  auto buffer = client->recv<op::ASCOMInterface::swp_get_AxisPosition, uint32_t>();
  return buffer;
}

// SetAxisPositionCmd        = 'E', set current position
bool ASCOM_sky_interface::swp_set_AxisPosition(uint8_t axis, uint32_t value) {
  client->call<op::ASCOMInterface::swp_set_AxisPosition>(axis, value);
  auto buffer = client->recv<op::ASCOMInterface::swp_set_AxisPosition, bool>();
  return buffer;
}

// InstantAxisStop (L) + NotInstantAxisStop (K)
bool ASCOM_sky_interface::swp_cmd_StopAxis(uint8_t axis, bool instant) {
  client->call<op::ASCOMInterface::swp_cmd_StopAxis>(axis, instant);
  auto buffer = client->recv<op::ASCOMInterface::swp_cmd_StopAxis, bool>();
  return buffer;
}
// Encoder stuff (g) // speed scalar for high speed skew
// InquireHighSpeedRatio     = 'g',
double ASCOM_sky_interface::swp_get_HighSpeedRatio(uint8_t axis) {
  client->call<op::ASCOMInterface::swp_get_HighSpeedRatio>(axis);
  auto buffer = client->recv<op::ASCOMInterface::swp_get_HighSpeedRatio, double>();
  return buffer;
}
// InquireTimerInterruptFreq = 'b', // sidereal rate of axis   steps per
// worm???
uint32_t ASCOM_sky_interface::swp_get_TimerInterruptFreq() {
  auto buffer = client
      ->recv<op::ASCOMInterface::swp_get_TimerInterruptFreq, uint32_t>();
  client->call<op::ASCOMInterface::swp_get_TimerInterruptFreq>();
  return buffer;
}
// InquireGridPerRevolution  = 'a', // steps per axis revolution
uint32_t ASCOM_sky_interface::swp_get_GridPerRevolution(uint8_t axis) {
  client->call<op::ASCOMInterface::swp_get_GridPerRevolution>(axis);
  auto buffer = client->recv<op::ASCOMInterface::swp_get_GridPerRevolution, uint32_t>();
  return buffer;
}
// InquireMotorBoardVersion  = 'e',
uint32_t ASCOM_sky_interface::swp_get_BoardVersion() {
  client->call<op::ASCOMInterface::swp_get_BoardVersion>();
  auto buffer = client->recv<op::ASCOMInterface::swp_get_BoardVersion, uint32_t>();
  return buffer;
}
// Initialize                = 'F',
bool ASCOM_sky_interface::swp_cmd_Initialize(uint8_t axis) {
  client->call<op::ASCOMInterface::swp_cmd_Initialize>(axis);
  auto buffer = client->recv<op::ASCOMInterface::swp_cmd_Initialize, bool>();
  return buffer;
}

uint32_t ASCOM_sky_interface::get_forty_two() {
  client->call<op::Common::get_forty_two>();
  auto buffer = client->recv<op::Common::get_forty_two, uint32_t>();
  return buffer;
}
uint64_t ASCOM_sky_interface::get_dna() {
  client->call<op::Common::get_dna>();
  auto buffer = client->recv<op::Common::get_dna, uint64_t>();
  return buffer;
}

