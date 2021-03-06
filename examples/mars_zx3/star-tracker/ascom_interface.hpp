/// Led Blinker driver
///
/// (c) Koheron

#ifndef __DRIVERS_ASCOM_INTERFACE_HPP__
#define __DRIVERS_ASCOM_INTERFACE_HPP__

#include <context.hpp>
#include <sky-tracker.hpp>

using namespace std::chrono_literals;
class ASCOMInterface {
 public:
  ASCOMInterface(Context& ctx_)
      : ctx(ctx_),
        sti(ctx.get<SkyTrackerInterface>()) {

  }

  // Initialize                = 'F',
  bool SwpCmdInitialize(uint8_t axis) {
    bool ret = true;
    size_t i = axis;
    if (!check_axis_id(axis, __func__)) return false;
    //for (i = 0; i < 2; i++)
    {
      ret &= sti.disable_raw_tracking(i, false);
      ret &= sti.disable_raw_backlash(i);
      ret &= sti.cancel_raw_command(i, false);
      ret &= sti.set_current_position(i, sti.get_steps_per_rotation(i)/2);
    }
    if (ret)
      ctx.log<INFO>("ASCOMInteface: %s Successful\n", __func__);
    else
      ctx.log<ERROR>("ASCOMInteface: %s Failed\n", __func__);
    sti.m_params.initialized[i] = ret;
    return ret;
  }
  // InquireMotorBoardVersion  = 'e',
  uint32_t SwpGetBoardVersion() {
    ctx.log<INFO>("ASCOMInteface: %s\n", __func__);
    return sti.get_version();
  }
  // InquireGridPerRevolution  = 'a', // steps per axis revolution
  uint32_t SwpGetGridPerRevolution(uint8_t axis) {
    return sti.get_steps_per_rotation(axis);
  }

  // InquireTimerInterruptFreq = 'b', // sidereal rate of axis   steps per
  // worm???
  uint32_t SwpGetTimerInterruptFreq() {
    return prm::fclk0;
  }
  // Encoder stuff (g) // speed scalar for high speed skew
  // InquireHighSpeedRatio     = 'g',
  double SwpGetHighSpeedRatio(uint8_t axis) {
    return sti.get_speed_ratio(axis, false);
  }
  // InstantAxisStop (L) + NotInstantAxisStop (K)
  bool SwpCmdStopAxis(uint8_t axis, bool instant) {
    if (instant || !check_axis_id(axis, __func__)) return false;
    ctx.log<INFO>("ASCOMInteface: %s(%u)- isInstant: %u\n", __func__, axis, instant);
    uint32_t status = sti.get_raw_status(axis);
    bool ret = true;
    if ((status & 0x1) == 1) ret = sti.disable_raw_tracking(axis, instant);
    if (status > 1) ret = sti.cancel_raw_command(axis, instant);
    return ret;
  }
  // SetAxisPositionCmd        = 'E', set current position
  bool SwpSetAxisPosition(uint8_t axis, uint32_t value) {
    return sti.set_current_position(axis, value);
  }
  // GetAxisPosition           = 'j', // current position
  uint32_t SwpGetAxisPosition(uint8_t axis) {
    return sti.get_raw_stepcount(axis);
  }
  // GetAxisStatus             = 'f',
  std::array<bool, 8> SwpGetAxisStatus(uint8_t axis) {
    // Initialized, running, direction, speedmode, isGoto, isSlew
    uint32_t status = sti.get_raw_status(axis);
    bool isGoto = (status >> 1) & 0x1;
    bool isSlew = status & 0x1;
    bool fault = (status >> 3) & 0x1;
    bool backlash = (status >> 4) & 0x1;
    bool direction = sti.get_motor_direction(axis, !isGoto);
    bool running = isGoto || isSlew;
    bool speedmode = sti.get_motor_highspeedmode(axis, isSlew);
    std::array<bool, 8> ret = { sti.m_params.initialized[axis],  running,
      direction, speedmode, isGoto, isSlew, backlash, fault
    };
    return ret;
  }
  // SetMotionMode             = 'G', mode and direction
  bool SwpSetMotionModeDirection(uint8_t axis, bool isForward, bool isSlew,
                                   bool isHighSpeed) {
    //[1] direction and mode, i.e. high/low speed in eqmod?
    if (!check_axis_id(axis, __func__)) return false;
    ctx.log<INFO>(
        "ASCOMInteface: %s(%u)- isSlew: %u; isForward: %u; isHighSpeed: %u\n",
        __func__, axis, isSlew,isForward,  isHighSpeed);
    // TODO
    sti.set_motor_direction(axis, isSlew, isForward);
    sti.m_params.highSpeedMode[isSlew][axis] = isHighSpeed;
    bool ret = true;
    return ret;
  }
  // set goto target - SetGotoTargetIncrement    = 'H', // set goto position
  bool SwpSetGotoTargetIncrement(uint8_t axis, uint32_t ncycles) {
    return sti.set_goto_increment(axis, ncycles);
  }
  // NOT SURE SetBreakPointIncrement    = 'M',
  // does nothing ??
  bool SwpSetBreakPointIncrement(uint8_t axis, uint32_t ncycles) {
    if (!check_axis_id(axis, __func__)) return false;
    ctx.log<INFO>("ASCOMInteface: %s(%u)- Command recieved: %u\n", __func__,
                  axis, ncycles);
    // TODO
    bool ret = true;
    return ret;
  }
  // SetBreakStep              = 'U', // does nothing??
  bool SwpSetBreakStep(uint8_t axis, uint32_t ncycles) {
    if (!check_axis_id(axis, __func__)) return false;
    ctx.log<INFO>("ASCOMInteface: %s(%u)- Command recieved: %u\n", __func__,
                  axis, ncycles);
    bool ret = true;
    // TODO
    return ret;
  }
  // SetGotoTarget             = 'S', // does nothing??
  bool SwpSetGotoTarget(uint8_t axis, uint32_t target) {
    return sti.set_goto_target(axis, target);
  }
  // SetStepPeriod             = 'I', //set slew speed
  bool SwpSetStepPeriod(uint8_t axis, bool isSlew, uint32_t period_ticks) {
    return sti.set_motor_period_ticks(axis, isSlew, period_ticks);
  }
  // StartMotion               = 'J', // start
  bool SwpCmdStartMotion(uint8_t axis, bool isSlew, bool use_accel, bool isGoto) {
    if (!check_axis_id(axis, __func__)) return false;

    bool ret = false;
    if (isSlew)
      ret = sti.start_raw_tracking(axis, sti.m_params.motorDirection[isSlew][axis],
                              sti.m_params.period_ticks[isSlew][axis],
                              sti.m_params.motorMode[isSlew][axis]);
    else
      ret = sti.send_raw_command(axis, sti.m_params.motorDirection[isSlew][axis],
                             isGoto ? sti.m_params.GotoTarget[axis] : sti.m_params.GotoNCycles[axis],
                             sti.m_params.period_ticks[isSlew][axis],
                             sti.m_params.motorMode[isSlew][axis], isGoto, use_accel);
    return ret;
  }
  // GetHomePosition           = 'd', // Get Home position encoder count
  // (default at startup)
  // not used in eqmod
  uint32_t SwpGetHomePosition(uint8_t axis) {
    if (!check_axis_id(axis, __func__)) return 0;
    return 0;
  }
  // InquireAuxEncoder         = 'd', // EQ8/AZEQ6/AZEQ5 only
  uint32_t SwpGetAuxEncoder(uint8_t axis) {
    // return microstep config
    if (!check_axis_id(axis, __func__)) return 0xFF;
    // TODO
    return 1;  // get_motor_mode(axis, m_params.motorStatus[axis] == GoTo ?
               // false : true );
  }
  // SetFeatureCmd             = 'W', // EQ8/AZEQ6/AZEQ5 only
  bool SwpSetFeature(uint8_t axis, uint8_t cmd) {  // not used
    ctx.log<INFO>("ASCOMInteface: %s-%u Command recieved: %u\n", __func__, axis, cmd);
    return true;
  }
  // GetFeatureCmd             = 'q', // EQ8/AZEQ6/AZEQ5 only
  uint32_t SwpGetFeature(uint8_t axis) {
    // return the gear change settings
    if (!check_axis_id(axis, __func__)) return 0x1000;
    ctx.log<INFO>("ASCOMInteface: %s- Command recieved:\n", __func__);
    return 1;
  }
  // SetPolarScopeLED          = 'V',
  bool SwpSetPolarScopeLED(uint8_t value) { return sti.set_led_pwm(value); }


  bool enable_backlash(uint8_t axis, bool enable) {
    if (enable) return sti.enable_backlash(axis);
    else return sti.disable_raw_backlash(axis);
  }
  bool set_backlash_period(uint8_t axis, uint32_t ticks)
  {
    sti.m_params.backlash_ticks[axis] = ticks;
    return true; 
  }
  bool set_backlash_cycles(uint8_t axis, uint32_t cycles)
  {
    sti.m_params.backlash_ncycle[axis] = cycles;
    return true; 
  }
 private:
  Context& ctx;
  SkyTrackerInterface& sti;

  bool check_axis_id(int8_t axis, std::string str) {
    if (axis > 1) {
      ctx.log<ERROR>("ASCOMInteface: %s- Invalid axis: %u\n", str, axis);
      return false;
    }
    ctx.log<INFO>("ASCOMInteface: %s\n", str);
    return true;
  }




    
};

#endif  // __DRIVERS_LED_BLINKER_HPP__
