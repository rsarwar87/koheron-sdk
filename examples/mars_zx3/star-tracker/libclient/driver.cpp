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
  klog << __func__ << std::endl;
  client.reset();
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
  klog << __func__ << " Axis " <<  std::to_string(axis) << " isSLew: " << isSlew << "; Accel: " << use_accel << std::endl;
  client->call<op::ASCOMInterface::swp_cmd_StartMotion>(axis, isSlew, use_accel);
  auto buffer = client->recv<op::ASCOMInterface::swp_cmd_StartMotion, bool>();
  return buffer;
}
// SetStepPeriod             = 'I', //set slew speed
bool ASCOM_sky_interface::swp_set_StepPeriod(uint8_t axis, bool isSlew,
                                             uint32_t period_usec) {
  klog << __func__ << " Axis " << std::to_string(axis) << " isSLew: " << isSlew << "; period: " << period_usec << std::endl;
  client->call<op::ASCOMInterface::swp_set_StepPeriod>(axis, isSlew, period_usec);
  auto buffer = client->recv<op::ASCOMInterface::swp_set_StepPeriod, bool>();
  return buffer;
}
// SetGotoTarget             = 'S', // does nothing??
bool ASCOM_sky_interface::swp_set_GotoTarget(uint8_t axis, uint32_t target) {
  klog << __func__ << " Axis " << axis << " NCycles: " << target << std::endl;
  client->call<op::ASCOMInterface::swp_set_GotoTarget>(axis, target);
  auto buffer = client->recv<op::ASCOMInterface::swp_set_GotoTarget, bool>();
  return buffer;
}
// SetBreakStep              = 'U', // does nothing??
bool ASCOM_sky_interface::swp_set_BreakStep(uint8_t axis, uint32_t ncycles) {
  klog << __func__ << " Axis " << axis << " NCycles: " << ncycles << std::endl;
  client->call<op::ASCOMInterface::swp_set_BreakStep>(axis, ncycles);
  auto buffer = client->recv<op::ASCOMInterface::swp_set_BreakStep, bool>();
  return buffer;
}
// NOT SURE SetBreakPointIncrement    = 'M',
// does nothing ??
bool ASCOM_sky_interface::swp_set_BreakPointIncrement(uint8_t axis,
                                                      uint32_t ncycles) {
  klog << __func__ << " Axis " << axis << " NCycles: " << ncycles << std::endl;
  client->call<op::ASCOMInterface::swp_set_BreakPointIncrement>(axis, ncycles);
  auto buffer = client->recv<op::ASCOMInterface::swp_set_BreakPointIncrement, bool>();
  return buffer;
}
// set goto target - SetGotoTargetIncrement    = 'H', // set goto position
bool ASCOM_sky_interface::swp_set_GotoTargetIncrement(uint8_t axis,
                                                      uint32_t ncycles) {
  klog << __func__ << " Axis " << axis << " NCycles: " << ncycles << std::endl;
  client->call<op::ASCOMInterface::swp_set_GotoTargetIncrement>(axis, ncycles);
  auto buffer = client->recv<op::ASCOMInterface::swp_set_GotoTargetIncrement, bool>();
  return buffer;
}
// SetMotionMode             = 'G', mode and direction
bool ASCOM_sky_interface::swp_set_MotionModeDirection(uint8_t axis,
                                                      bool isForward,
                                                      bool isSlew,
                                                      bool isHighSpeed) {
  klog << __func__ << " Aaxis " << std::to_string(axis) << "; Forward " << isForward << "; isSlew "
        << isSlew << " HighSpeed " << isHighSpeed << std::endl;
  client->call<op::ASCOMInterface::swp_set_MotionModeDirection>(axis, isForward, isSlew, 
      isHighSpeed);
  auto buffer = client->recv<op::ASCOMInterface::swp_set_MotionModeDirection, bool>();
  return buffer;
}

// GetAxisStatus             = 'f',
std::array<bool, 8> ASCOM_sky_interface::swp_get_AxisStatus(uint8_t axis) {
  client->call<op::ASCOMInterface::swp_get_AxisStatus>(axis);
  auto buffer = client->recv<op::ASCOMInterface::swp_get_AxisStatus, std::array<bool, 8>>();
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
  klog << __func__ <<  ": " << value << std::endl;
  client->call<op::ASCOMInterface::swp_set_AxisPosition>(axis, value);
  auto buffer = client->recv<op::ASCOMInterface::swp_set_AxisPosition, bool>();
  return buffer;
}

// InstantAxisStop (L) + NotInstantAxisStop (K)
bool ASCOM_sky_interface::swp_cmd_StopAxis(uint8_t axis, bool instant) {
  klog << __func__ << std::endl;
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
  client->call<op::ASCOMInterface::swp_get_TimerInterruptFreq>();
  auto buffer = client->recv<op::ASCOMInterface::swp_get_TimerInterruptFreq, uint32_t>();
  return buffer;
}
// InquireGridPerRevolution  = 'a', // steps per axis revolution
uint32_t ASCOM_sky_interface::swp_get_GridPerRevolution(uint8_t axis) {
  client->call<op::ASCOMInterface::swp_get_GridPerRevolution>(axis);
  auto buffer = client->recv<op::ASCOMInterface::swp_get_GridPerRevolution, uint32_t>();
  klog <<  __func__ << ":" << buffer << std::endl;
  return buffer;
}
// InquireMotorBoardVersion  = 'e',
uint32_t ASCOM_sky_interface::swp_get_BoardVersion() {
  client->call<op::ASCOMInterface::swp_get_BoardVersion>();
  auto buffer = client->recv<op::ASCOMInterface::swp_get_BoardVersion, uint32_t>();
  klog << __func__ << ": " << buffer << std::endl;
  return buffer;
}
// Initialize                = 'F',
bool ASCOM_sky_interface::swp_cmd_Initialize(uint8_t axis) {
  client->call<op::ASCOMInterface::swp_cmd_Initialize>(axis);
  auto buffer = client->recv<op::ASCOMInterface::swp_cmd_Initialize, bool>();
  klog << __func__ << std::endl;
  return buffer;
}
bool ASCOM_sky_interface::cmd_enable_backlash(uint8_t axis, bool enable) {
  client->call<op::ASCOMInterface::enable_backlash>(axis, enable);
  auto buffer = client->recv<op::ASCOMInterface::enable_backlash, bool>();
  klog  << __func__ << " enabled: " << enable << std::endl;
  return buffer;
}
bool ASCOM_sky_interface::cmd_set_backlash_period(uint8_t axis, uint32_t ticks) {
  client->call<op::ASCOMInterface::set_backlash_period>(axis, ticks);
  auto buffer = client->recv<op::ASCOMInterface::set_backlash_period, bool>();
  klog << __func__ << ": " << ticks << std::endl;
  return buffer;
}
bool ASCOM_sky_interface::cmd_set_backlash_cycles(uint8_t axis, uint32_t ticks) {
  client->call<op::ASCOMInterface::set_backlash_cycles>(axis, ticks);
  auto buffer = client->recv<op::ASCOMInterface::set_backlash_cycles, bool>();
  klog << __func__ << ": " << ticks << std::endl;
  return buffer;
}

uint32_t ASCOM_sky_interface::get_forty_two() {
  client->call<op::Common::get_forty_two>();
  auto buffer = client->recv<op::Common::get_forty_two, uint32_t>();
  return buffer;
}
uint32_t ASCOM_sky_interface::get_maximum_period(uint8_t axis) {
  client->call<op::SkyTrackerInterface::get_max_period_ticks>(axis);
  auto buffer = client->recv<op::SkyTrackerInterface::get_max_period_ticks, uint32_t>();
  klog << __func__ << ": " << buffer << " Axis: " << std::to_string(axis) << std::endl;
  return buffer;
}
uint32_t ASCOM_sky_interface::get_minimum_period(uint8_t axis) {
  client->call<op::SkyTrackerInterface::get_min_period_ticks>(axis);
  auto buffer = client->recv<op::SkyTrackerInterface::get_min_period_ticks, uint32_t>();
  klog << __func__ << ": " << buffer << " Axis: " << std::to_string(axis) << std::endl;
  return buffer;
}
uint64_t ASCOM_sky_interface::get_dna() {
  client->call<op::Common::get_dna>();
  auto buffer = client->recv<op::Common::get_dna, uint64_t>();
  return buffer;
}
void ASCOM_sky_interface::print_status(std::string fname, std::string str) {
  klog << "STATUS " << fname << "(): " << str << std::endl;
}
void ASCOM_sky_interface::print_log(std::string fname, std::string str) {
  klog << "ERROR " << fname << "(): " << str << std::endl;
}

