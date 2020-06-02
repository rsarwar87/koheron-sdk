#include <koheron-client.hpp>

#include "fpgaskytracker.hpp"
#include "log.hpp"
namespace sky_driver {
static std::unique_ptr<KoheronClient> client;
static syslog_stream klog;
}
using namespace sky_driver;

ASCOM_sky_interface::ASCOM_sky_interface(const char* host, int port) {
  klog << "Initializing driver - connecting to koheron server@" << host << ":" << port << std::endl;
  client = std::make_unique<KoheronClient>(host, port);
  client->connect();
  klog << "Initialization completed" << std::endl;
}
ASCOM_sky_interface::~ASCOM_sky_interface(){
  klog << "calling from " << __func__ << std::endl;
  client.reset();
}
// SetPolarScopeLED          = 'V',
bool ASCOM_sky_interface::swp_set_PolarScopeLED() {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::ASCOMInterface::swp_set_PolarScopeLED>();
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::ASCOMInterface::swp_set_PolarScopeLED, bool>();
  return buffer;
}
// GetFeatureCmd             = 'q', // EQ8/AZEQ6/AZEQ5 only
uint32_t ASCOM_sky_interface::swp_get_Feature(uint8_t axis) {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::ASCOMInterface::swp_get_Feature>(axis);
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::ASCOMInterface::swp_get_Feature, uint32_t>();
  return buffer;
}
// SetFeatureCmd             = 'W', // EQ8/AZEQ6/AZEQ5 only
bool ASCOM_sky_interface::swp_set_Feature(uint8_t axis,
                                          uint8_t cmd) {  // not used
  klog << "calling from " << __func__ << std::endl;
  client->call<op::ASCOMInterface::swp_set_Feature>(axis, cmd);
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::ASCOMInterface::swp_set_Feature, bool>();
  return buffer;
}
// GetFeatureCmd             = 'q', // EQ8/AZEQ6/AZEQ5 only
// InquireAuxEncoder         = 'd', // EQ8/AZEQ6/AZEQ5 only
uint32_t ASCOM_sky_interface::swp_get_AuxEncoder(uint8_t axis) {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::ASCOMInterface::swp_get_AuxEncoder>(axis);
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::ASCOMInterface::swp_get_AuxEncoder, uint32_t>();
  return buffer;
}
// GetHomePosition           = 'd', // Get Home position encoder count
// (default at startup)
// not used in eqmod
uint32_t ASCOM_sky_interface::swp_get_HomePosition(uint8_t axis) {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::ASCOMInterface::swp_get_HomePosition>(axis);
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::ASCOMInterface::swp_get_HomePosition, uint32_t>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}
// StartMotion               = 'J', // start
bool ASCOM_sky_interface::swp_cmd_StartMotion(uint8_t axis, bool isSlew,
                                              bool use_accel) {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::ASCOMInterface::swp_cmd_StartMotion>(axis, isSlew, use_accel);
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::ASCOMInterface::swp_cmd_StartMotion, bool>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}
// SetStepPeriod             = 'I', //set slew speed
bool ASCOM_sky_interface::swp_set_StepPeriod(uint8_t axis, bool isSlew,
                                             uint32_t period_usec) {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::ASCOMInterface::swp_set_StepPeriod>(axis, isSlew, period_usec);
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::ASCOMInterface::swp_set_StepPeriod, bool>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}
// SetGotoTarget             = 'S', // does nothing??
bool ASCOM_sky_interface::swp_set_GotoTarget(uint8_t axis, uint32_t target) {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::ASCOMInterface::swp_set_GotoTarget>(axis, target);
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::ASCOMInterface::swp_set_GotoTarget, bool>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}
// SetBreakStep              = 'U', // does nothing??
bool ASCOM_sky_interface::swp_set_BreakStep(uint8_t axis, uint32_t ncycles) {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::ASCOMInterface::swp_set_BreakStep>(axis, ncycles);
  klog << "retrieving from " << __func__  << std::endl;
  auto buffer = client->recv<op::ASCOMInterface::swp_set_BreakStep, bool>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}
// NOT SURE SetBreakPointIncrement    = 'M',
// does nothing ??
bool ASCOM_sky_interface::swp_set_BreakPointIncrement(uint8_t axis,
                                                      uint32_t ncycles) {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::ASCOMInterface::swp_set_BreakPointIncrement>(axis, ncycles);
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::ASCOMInterface::swp_set_BreakPointIncrement, bool>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}
// set goto target - SetGotoTargetIncrement    = 'H', // set goto position
bool ASCOM_sky_interface::swp_set_GotoTargetIncrement(uint8_t axis,
                                                      uint32_t ncycles) {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::ASCOMInterface::swp_set_GotoTargetIncrement>(axis, ncycles);
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::ASCOMInterface::swp_set_GotoTargetIncrement, bool>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}
// SetMotionMode             = 'G', mode and direction
bool ASCOM_sky_interface::swp_set_MotionModeDirection(uint8_t axis,
                                                      bool isForward,
                                                      bool isSlew,
                                                      bool isHighSpeed) {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::ASCOMInterface::swp_set_MotionModeDirection>(axis, isForward, isSlew, 
      isHighSpeed);
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::ASCOMInterface::swp_set_MotionModeDirection, bool>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}

// GetAxisStatus             = 'f',
std::array<bool, 8> ASCOM_sky_interface::swp_get_AxisStatus(uint8_t axis) {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::ASCOMInterface::swp_get_AxisStatus>(axis);
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::ASCOMInterface::swp_get_AxisStatus, std::array<bool, 8>>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}

// GetAxisPosition           = 'j', // current position
uint32_t ASCOM_sky_interface::swp_get_AxisPosition(uint8_t axis) {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::ASCOMInterface::swp_get_AxisPosition>(axis);
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::ASCOMInterface::swp_get_AxisPosition, uint32_t>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}

// SetAxisPositionCmd        = 'E', set current position
bool ASCOM_sky_interface::swp_set_AxisPosition(uint8_t axis, uint32_t value) {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::ASCOMInterface::swp_set_AxisPosition>(axis, value);
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::ASCOMInterface::swp_set_AxisPosition, bool>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}

// InstantAxisStop (L) + NotInstantAxisStop (K)
bool ASCOM_sky_interface::swp_cmd_StopAxis(uint8_t axis, bool instant) {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::ASCOMInterface::swp_cmd_StopAxis>(axis, instant);
  klog << "retrieving from " << __func__  << std::endl;
  auto buffer = client->recv<op::ASCOMInterface::swp_cmd_StopAxis, bool>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}
// Encoder stuff (g) // speed scalar for high speed skew
// InquireHighSpeedRatio     = 'g',
double ASCOM_sky_interface::swp_get_HighSpeedRatio(uint8_t axis) {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::ASCOMInterface::swp_get_HighSpeedRatio>(axis);
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::ASCOMInterface::swp_get_HighSpeedRatio, double>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}
// InquireTimerInterruptFreq = 'b', // sidereal rate of axis   steps per
// worm???
uint32_t ASCOM_sky_interface::swp_get_TimerInterruptFreq() {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::ASCOMInterface::swp_get_TimerInterruptFreq>();
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::ASCOMInterface::swp_get_TimerInterruptFreq, uint32_t>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}
// InquireGridPerRevolution  = 'a', // steps per axis revolution
uint32_t ASCOM_sky_interface::swp_get_GridPerRevolution(uint8_t axis) {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::ASCOMInterface::swp_get_GridPerRevolution>(axis);
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::ASCOMInterface::swp_get_GridPerRevolution, uint32_t>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}
// InquireMotorBoardVersion  = 'e',
uint32_t ASCOM_sky_interface::swp_get_BoardVersion() {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::ASCOMInterface::swp_get_BoardVersion>();
  klog << "retrieving from " << __func__  << std::endl;
  auto buffer = client->recv<op::ASCOMInterface::swp_get_BoardVersion, uint32_t>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}
// Initialize                = 'F',
bool ASCOM_sky_interface::swp_cmd_Initialize(uint8_t axis) {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::ASCOMInterface::swp_cmd_Initialize>(axis);
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::ASCOMInterface::swp_cmd_Initialize, bool>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}
bool ASCOM_sky_interface::cmd_enable_backlash(uint8_t axis, bool enable) {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::ASCOMInterface::enable_backlash>(axis, enable);
  klog << "retrieving from " << __func__  << std::endl;
  auto buffer = client->recv<op::ASCOMInterface::enable_backlash, bool>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}
bool ASCOM_sky_interface::cmd_set_backlash_period(uint8_t axis, uint32_t ticks) {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::ASCOMInterface::set_backlash_period>(axis, ticks);
  klog << "retrieving from " << __func__  << std::endl;
  auto buffer = client->recv<op::ASCOMInterface::set_backlash_period, bool>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}
bool ASCOM_sky_interface::cmd_set_backlash_cycles(uint8_t axis, uint32_t ticks) {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::ASCOMInterface::set_backlash_cycles>(axis, ticks);
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::ASCOMInterface::set_backlash_cycles, bool>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}

uint32_t ASCOM_sky_interface::get_forty_two() {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::Common::get_forty_two>();
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::Common::get_forty_two, uint32_t>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}
uint64_t ASCOM_sky_interface::get_dna() {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::Common::get_dna>();
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::Common::get_dna, uint64_t>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}

