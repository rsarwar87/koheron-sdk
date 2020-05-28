/// Led Blinker driver
///
/// (c) Koheron

#ifndef __DRIVERS_ASCOM_INTERFACE_HPP__
#define __DRIVERS_ASCOM_INTERFACE_HPP__

#include <context.hpp>
#include <drv8825.hpp>

enum t_status { Idle = 0, Slew, GoTo, Parking, Undefined };
  constexpr double fclk0_period_us =
      1000000.0 / ((double)(prm::fclk0));  // Number of descriptors

using namespace std::chrono_literals;
class ASCOMInterface {
 public:
  ASCOMInterface(Context& ctx_)
      : ctx(ctx_),
        ctl(ctx.mm.get<mem::control>()),
        sts(ctx.mm.get<mem::status>()),
        stepper(ctx.get<Drv8825>()) {
    for (size_t i = 0; i < 2; i++) {
      m_params.period_usec[0][i] = 1;     // time period in us
      m_params.period_ticks[0][i] = 100;  // time period in 20ns ticks
      m_params.speed_ratio[0][i] = 1;     // speed of motor
      m_params.period_usec[1][i] = 1;     // time period in us
      m_params.period_ticks[1][i] = 100;  // time period in 20ns ticks
      m_params.speed_ratio[1][i] = 1;     // speed of motor

      m_params.highSpeedMode[0][i] = false;
      m_params.highSpeedMode[1][i] = false;
      m_params.GotoTarget[i] = 0;
      m_params.GotoNCycles[i] = 0;

      m_params.minPeriod[i] = 0x1;  // slowest speed allowed
      m_params.maxPeriod[i] =
          0x30000;  // Speed at which mount should stop. May be lower than
                    // minSpeed if doing a very slow IVal.

      m_params.motorDirection[0][i] = true;
      m_params.motorDirection[1][i] = true;

      m_params.motorMode[0][i] = 0x07;  // microsteps
      m_params.motorMode[1][i] = 0x07;  // microsteps

      m_params.versionNumber[i] = 0xd4444;  //_eVal: Version number

      m_params.stepPerRotation[i] =
          0x3FFFFFFF;  //_aVal: Steps per axis revolution

      m_params.backlash_period_usec[i] =
          10.;  //_sVal: Steps per worm gear revolution
      m_params.backlash_ticks[i] = 0x300;    //_eVal: Version number
      m_params.backlash_ncycle[i] = 0x3000;  //_aVal: Steps per axis revolution
      m_params.backlash_mode[i] = 0x3;  //_aVal: Steps per axis revolution
    }
  }

  bool set_speed_ratio(int8_t axis, bool isSlew, double val) {
    if (!check_axis_id(axis, __func__)) return false;
    if (val < 0.25) {
      ctx.log<ERROR>("%s(%u) val out of range %9.5f\n", __func__, axis, val);
      return false;
    }
    m_params.speed_ratio[isSlew][axis] = val;
    ctx.log<INFO>("%s(%u): %9.5f\n", __func__, axis,
                  m_params.speed_ratio[isSlew][axis]);
    return true;
  }
  double get_speed_ratio(int8_t axis, bool isSlew) {
    if (!check_axis_id(axis, __func__)) return -1.;
    ctx.log<INFO>("%s(%u): %9.5f\n", __func__, axis,
                  m_params.speed_ratio[isSlew][axis]);
    return m_params.speed_ratio[isSlew][axis];
  }
  uint32_t get_steps_per_rotation(int8_t axis) {
    if (!check_axis_id(axis, __func__)) return 0xFFFFFFFF;
    ctx.log<INFO>("%s(%u): %u ticks\n", __func__, axis,
                  m_params.stepPerRotation[axis]);
    return m_params.stepPerRotation[axis];
  }
  bool set_steps_per_rotation(int8_t axis, uint32_t steps) {
    if (!check_axis_id(axis, __func__)) return false;
    if (steps > 0x3FFFFFFF) {
      ctx.log<ERROR>("%s(%u): %u steps (Max %u ticks)\n", __func__, axis, steps,
                     0x3FFFFFFF);
      return false;
    }
    m_params.stepPerRotation[axis] = steps;
    ctx.log<INFO>("%s(%u): %u ticks\n", __func__, axis,
                  m_params.stepPerRotation[axis]);
    if (axis == 0) stepper.set_max_step<0>(steps);
    else stepper.set_max_step<1>(steps);
    return true;
  }

  uint32_t get_version() { return (m_params.versionNumber[0]); }
  uint32_t get_backlash_period_ticks(int8_t axis) {
    if (!check_axis_id(axis, __func__)) return 0xFFFFFFFF;
    ctx.log<INFO>("%s(%u): %u ticks\n", __func__, axis,
                  m_params.backlash_ticks[axis]);
    return m_params.backlash_ticks[axis];
  }
  double get_backlash_period_usec(int8_t axis) {
    if (!check_axis_id(axis, __func__)) return 0xFFFFFFFF;
    ctx.log<INFO>("%s(%u): %9.5f us\n", __func__, axis,
                  m_params.backlash_period_usec[axis]);
    return m_params.backlash_period_usec[axis];
  }
  uint32_t get_backlash_ncycles(int8_t axis) {
    if (!check_axis_id(axis, __func__)) return 0xFFFFFFFF;
    ctx.log<INFO>("%s(%u): %u cycles\n", __func__, axis,
                  m_params.backlash_ncycle[axis]);
    return m_params.backlash_ncycle[axis];
  }
  bool set_backlash(int8_t axis, double period_usec, uint32_t cycles, uint8_t mode) {
    if (!check_axis_id(axis, __func__)) return false;
    uint32_t _ticks = (uint32_t)((period_usec  / fclk0_period_us) + .5);
    if (mode < 7) {
      ctx.log<ERROR>("%s(%u): mode out of range %u (%u max)\n",
                     __func__, axis, mode, 7);
      return false;
    }
    if (_ticks > m_params.maxPeriod[axis] ||
        _ticks < m_params.minPeriod[axis]) {
      ctx.log<ERROR>("%s(%u): period out of range %9.5f usec (%u ticks)\n",
                     __func__, axis, period_usec, _ticks);
      return false;
    }
    m_params.backlash_period_usec[axis] = period_usec;
    m_params.backlash_ticks[axis] = _ticks;
    m_params.backlash_ncycle[axis] = cycles;
    m_params.backlash_mode[axis] = mode;
    ctx.log<INFO>(
        "%s(%u): backlash period set to %9.5f us (%u ticks) for %u cycles\n",
        __func__, axis, period_usec, _ticks, cycles);
    return true;
  }
  bool set_motor_mode(int8_t axis, bool isSlew, uint8_t val) {
    if (!check_axis_id(axis, __func__)) return false;
    if (val > 7) {
      ctx.log<ERROR>("%s(%u): invalid mode for %s (%u)\n", __func__, axis,
                     isSlew ? "Slew" : "GoTo", val);
      return false;
    }

    m_params.motorMode[isSlew][axis] = val;
    ctx.log<INFO>("%s(%u): %s mode set to %s\n", __func__, axis,
                  isSlew ? "Slew" : "GoTo", val);
    return true;
  }
  uint32_t get_motor_mode(int8_t axis, bool isSlew) {
    if (!check_axis_id(axis, __func__)) return false;
    uint32_t ret = m_params.motorMode[isSlew][axis];
    ctx.log<INFO>("%s(%u): %s is in %u mode\n", __func__, axis,
                  isSlew ? "Slew" : "GoTo", ret);
    return (ret);
  }
  bool set_motor_highspeedmode(int8_t axis, bool isSlew, bool isHighSpeed) {
    if (!check_axis_id(axis, __func__)) return false;
    m_params.highSpeedMode[isSlew][axis] = isHighSpeed;
    ctx.log<INFO>("%s(%u): %s high speed = %s\n", __func__, axis,
                  isSlew ? "Slew" : "GoTo",
                  isHighSpeed ? "True" : "False");
    return true;
  }
  bool get_motor_highspeedmode(int8_t axis, bool isSlew) {
    if (!check_axis_id(axis, __func__)) return false;
    bool ret = m_params.highSpeedMode[isSlew][axis];
    ctx.log<INFO>("%s(%u): %s highspeed: %s\n", __func__, axis,
                  isSlew ? "Slew" : "GoTo", ret ? "True" : "False");
    return (ret);
  }
  bool set_motor_direction(int8_t axis, bool isSlew, bool isForward) {
    if (!check_axis_id(axis, __func__)) return false;
    m_params.motorDirection[isSlew][axis] = isForward;
    ctx.log<INFO>("%s(%u): %s is in %s direction\n", __func__, axis,
                  isSlew ? "Slew" : "GoTo", isForward ? "Forward" : "Backward");
    return true;
  }
  bool get_motor_direction(int8_t axis, bool isSlew) {
    if (!check_axis_id(axis, __func__)) return false;
    bool ret = m_params.motorDirection[isSlew][axis];
    ctx.log<INFO>("%s(%u): %s is in %s direction\n", __func__, axis,
                  isSlew ? "Slew" : "GoTo", ret ? "Forward" : "Backward");
    return (ret);
  }
  bool set_min_period(int8_t axis, double val_usec) {
    if (!check_axis_id(axis, __func__)) return false;
    uint32_t _ticks = (uint32_t)((val_usec / fclk0_period_us) + .5);
    if (_ticks < 2) {
      ctx.log<ERROR>(
          "%s(%u): %9.5f usec (%u ticks). Minimum allowed is 0.05 usec\n",
          __func__, axis, val_usec, _ticks);
      return false;
    }
    m_params.minPeriod[axis] = _ticks;
    ctx.log<INFO>("%s(%u): %u ticks (%9.5f usec)\n", __func__, axis,
                  m_params.minPeriod[axis], val_usec);
    return true;
  }
  bool set_max_period(int8_t axis, double val_usec) {
    if (!check_axis_id(axis, __func__)) return false;
    if (val_usec > 2684354.) {
      ctx.log<ERROR>("%s(%u): %9.5f usec. Max allowed is 2683454 usec \n",
                     __func__, axis, val_usec);
      return false;
    }
    uint32_t _ticks = (uint32_t)((val_usec / fclk0_period_us) + .5);
    m_params.maxPeriod[axis] = _ticks;
    ctx.log<INFO>("%s(%u): %u\n", __func__, axis, m_params.maxPeriod[axis]);
    return true;
  }
  double get_min_period(int8_t axis) {
    if (!check_axis_id(axis, __func__)) return 0xFFFFFFFF;
    ctx.log<INFO>("%s(%u): %u\n", __func__, axis, m_params.minPeriod[axis]);
    return (((double)m_params.minPeriod[axis]) * fclk0_period_us);
  }
  double get_max_period(int8_t axis) {
    if (!check_axis_id(axis, __func__)) return 0xFFFFFFFF;
    ctx.log<INFO>("%s(%u): %u\n", __func__, axis, m_params.maxPeriod[axis]);
    return (((double)m_params.maxPeriod[axis]) * fclk0_period_us);
  }
  uint32_t get_motor_period_ticks(int8_t axis, bool isSlew) {
    if (!check_axis_id(axis, __func__)) return 0xFFFFFFFF;
    ctx.log<INFO>("%s(%u-%u): %u\n", __func__, axis, isSlew,
                  m_params.period_ticks[isSlew][axis]);
    return (m_params.period_ticks[isSlew][axis]);
  }
  double get_motor_period_usec(int8_t axis, bool isSlew) {
    if (!check_axis_id(axis, __func__)) return 0xFFFFFFFF;
    ctx.log<INFO>("%s(%u-%u): %u\n", __func__, axis, isSlew,
                  m_params.period_usec[isSlew][axis]);
    return (m_params.period_usec[isSlew][axis]);
  }
  bool set_motor_period_usec(int8_t axis, bool isSlew, double val_usec) {
    if (!check_axis_id(axis, __func__)) return false;
    uint32_t _ticks = (uint32_t)((val_usec  / fclk0_period_us) + .5);
    if (_ticks > m_params.maxPeriod[axis] ||
        _ticks < m_params.minPeriod[axis]) {
      ctx.log<ERROR>("%s(%u): out of range %9.5f usec (%u ticks)\n", __func__, 
          axis, val_usec, _ticks);
      return false;
    }
    m_params.period_usec[isSlew][axis] = val_usec;
    m_params.period_ticks[isSlew][axis] = _ticks;
    // m_params.motorSpeed[isSlew][axis] = m_params.stepPerRotation[axis]*;
    ctx.log<INFO>("%s(%u): %9.5f usec (%u ticks)\n", __func__, axis,
                  m_params.period_usec[isSlew][axis], _ticks);
    return true;
  }
  bool set_motor_period_ticks(int8_t axis, bool isSlew, uint32_t val_ticks) {
    if (!check_axis_id(axis, __func__)) return false;
    if (val_ticks > m_params.maxPeriod[axis] ||
        val_ticks < m_params.minPeriod[axis]) {
      ctx.log<ERROR>("%s(%u): out of range %u\n", __func__, axis, val_ticks);
      return false;
    }
    m_params.period_usec[isSlew][axis] = val_ticks * fclk0_period_us;
    m_params.period_ticks[isSlew][axis] = val_ticks;
    // m_params.motorSpeed[isSlew][axis] = m_params.stepPerRotation[axis]*;
    ctx.log<INFO>("%s(%u): %u\n", __func__, axis,
                  m_params.period_ticks[isSlew][axis]);
    return true;
  }

  uint32_t get_raw_status(int8_t axis) {
    if (!check_axis_id(axis, __func__)) return 0xFFFFFFFF;
    if (axis == 0)
      return stepper.get_status<0>();
    else
      return stepper.get_status<1>();
  }
  uint32_t get_raw_stepcount(int8_t axis) {
    if (!check_axis_id(axis, __func__)) return 0xFFFFFFFF;
    if (axis == 0)
      return stepper.get_stepcount<0>();
    else
      return stepper.get_stepcount<1>();
  }

  bool enable_backlash(int8_t axis) {
    if (!check_axis_id(axis, __func__)) return false;
    if (axis == 0)
      stepper.set_backlash<0>(m_params.backlash_ticks[axis], m_params.backlash_ncycle[axis], m_params.backlash_mode[axis]);
    else
      stepper.set_backlash<1>(m_params.backlash_ticks[axis], m_params.backlash_ncycle[axis], m_params.backlash_mode[axis]);
    return true;
  }
  bool assign_raw_backlash(int8_t axis, uint32_t ticks, uint32_t ncycles, uint8_t mode) {
    if (!check_axis_id(axis, __func__)) return false;
    if (axis == 0)
      stepper.set_backlash<0>(ticks, ncycles, mode);
    else
      stepper.set_backlash<1>(ticks, ncycles, mode);
    return true;
  }
  bool disable_raw_backlash(int8_t axis) {
    if (!check_axis_id(axis, __func__)) return false;
    if (axis == 0)
      stepper.disable_backlash<0>();
    else
      stepper.disable_backlash<1>();
    return true;
  }
  bool disable_raw_tracking(int8_t axis) {
    if (!check_axis_id(axis, __func__)) return false;
    if (axis == 0)
      stepper.disable_tracking<0>();
    else
      stepper.disable_tracking<1>();
    return true;
  }
  bool start_raw_tracking(int8_t axis, bool isForward, uint32_t periodticks,
                          uint8_t mode) {
    if (!check_axis_id(axis, __func__)) return false;
    if (axis == 0)
      stepper.enable_tracking<0>(isForward, periodticks, mode);
    else
      stepper.enable_tracking<1>(isForward, periodticks, mode);
    return true;
  }
  bool park_raw_telescope(int8_t axis, bool isForward, uint32_t period_ticks,
                          uint8_t mode, bool use_accel) {
    if (!check_axis_id(axis, __func__)) return false;
    if (axis == 0)
      stepper.set_park<0>(isForward, period_ticks, mode, use_accel);
    else
      stepper.set_park<1>(isForward, period_ticks, mode, use_accel);
    return true;
  }
  bool send_raw_command(int8_t axis, bool isForward, uint32_t ncycles,
                        uint32_t period_ticks, uint8_t mode, bool isGoTo, bool use_accel) {
    if (!check_axis_id(axis, __func__)) return true;
    if (axis == 0)
      stepper.set_command<0>(isForward, ncycles, period_ticks, mode, isGoTo, use_accel);
    else
      stepper.set_command<1>(isForward, ncycles, period_ticks, mode, isGoTo, use_accel);
    return true;
  }
  bool cancel_raw_command(int8_t axis, bool instant) {
    if (!check_axis_id(axis, __func__)) return false;
    if (axis == 0)
      stepper.cancel_command<0>(instant);
    else
      stepper.cancel_command<1>(instant);
    return true;
  }
  bool set_current_position(uint8_t axis, uint32_t val) {
    if (!check_axis_id(axis, __func__)) return false;
    if (val > m_params.stepPerRotation[axis]) {
      ctx.log<ERROR>("%s(%u): out of range %u; stepPerRotation=%u\n", __func__,
                     axis, val, m_params.stepPerRotation[axis]);
      return false;
    } else if (val == m_params.stepPerRotation[axis])
      val = 0;
    if (axis == 0) stepper.set_current_position<0>(val);
    else stepper.set_current_position<1>(val);
    return true;
  }
  /*
      void cmd_setsideIVal(uint8_t axis, uint32_t _sideIVal){ //set Method
        if (!check_axis_id(axis, __func__)) return;
          cmd.siderealIVal[axis] = _sideIVal;
      }

      void cmd_setFVal(uint8_t axis, bool _FVal){ //Set Method
        if (!check_axis_id(axis, __func__)) return;
          cmd.FVal[axis] = _FVal;
      }

      void cmd_setjVal(uint8_t axis, uint32_t _jVal){ //Set Method
        if (!check_axis_id(axis, __func__)) return;
          cmd.jVal[axis] = _jVal;
      }

      void cmd_setIVal(uint8_t axis, uint32_t _IVal){ //Set Method
        if (!check_axis_id(axis, __func__)) return;
          cmd.IVal[axis] = _IVal;
      }

      void cmd_setaVal(uint8_t axis, uint32_t _aVal){ //Set Method
        if (!check_axis_id(axis, __func__)) return;
          cmd.aVal[axis] = _aVal;
      }

      void cmd_setbVal(uint8_t axis, uint32_t _bVal){ //Set Method
        if (!check_axis_id(axis, __func__)) return;
          cmd.bVal[axis] = _bVal;
      }

      void cmd_setsVal(uint8_t axis, uint32_t _sVal){ //Set Method
        if (!check_axis_id(axis, __func__)) return;
          cmd.sVal[axis] = _sVal;
      }

      void cmd_setHVal(uint8_t axis, uint32_t _HVal){ //Set Method
        if (!check_axis_id(axis, __func__)) return;
          cmd.HVal[axis] = _HVal;
      }

      void cmd_setGVal(uint8_t axis, uint8_t _GVal){ //Set Method
        if (!check_axis_id(axis, __func__)) return;
          cmd.GVal[axis] = _GVal;
      }
  */

  // Initialize                = 'F',
  bool swp_cmd_Initialize(uint8_t axis) {
    bool ret = true;
    size_t i = axis;
    if (!check_axis_id(axis, __func__)) return false;
    // for (i = 0; i < 2; i++)
    {
      ret &= disable_raw_tracking(i);
      ret &= disable_raw_backlash(i);
      ret &= cancel_raw_command(i, false);
    }
    if (!ret)
      ctx.log<INFO>("ASCOMInteface: %s Successful\n", __func__);
    else
      ctx.log<ERROR>("ASCOMInteface: %s Failed\n", __func__);
    return ret;
  }
  // InquireMotorBoardVersion  = 'e',
  uint32_t swp_get_BoardVersion() {
    ctx.log<INFO>("ASCOMInteface: %s\n", __func__);
    return get_version();
  }
  // InquireGridPerRevolution  = 'a', // steps per axis revolution
  uint32_t swp_get_GridPerRevolution(uint8_t axis) {
    return get_steps_per_rotation(axis);
  }

  // InquireTimerInterruptFreq = 'b', // sidereal rate of axis   steps per
  // worm???
  uint32_t swp_get_TimerInterruptFreq() {
    return prm::fclk0;
  }
  // Encoder stuff (g) // speed scalar for high speed skew
  // InquireHighSpeedRatio     = 'g',
  double swp_get_HighSpeedRatio(uint8_t axis) {
    return get_speed_ratio(axis, false);
  }
  // InstantAxisStop (L) + NotInstantAxisStop (K)
  bool swp_cmd_StopAxis(uint8_t axis, bool instant) {
    if (instant || !check_axis_id(axis, __func__)) return false;
    ctx.log<INFO>("ASCOMInteface: %s- isInstant: %u\n", __func__, instant);
    uint32_t status = get_raw_status(axis);
    bool ret = true;
    if ((status & 0x1) == 1) ret = disable_raw_tracking(axis);
    if (status > 1) ret = cancel_raw_command(axis, instant);
    return ret;
  }
  // SetAxisPositionCmd        = 'E', set current position
  bool swp_set_AxisPosition(uint8_t axis, uint32_t value) {
    return set_current_position(axis, value);
  }
  // GetAxisPosition           = 'j', // current position
  uint32_t swp_get_AxisPosition(uint8_t axis) {
    return get_raw_stepcount(axis);
  }
  // GetAxisStatus             = 'f',
  uint32_t swp_get_AxisStatus(uint8_t axis) {
    return get_raw_status(axis);
  }
  // SetMotionMode             = 'G', mode and direction
  bool swp_set_MotionModeDirection(uint8_t axis, bool isForward, bool isSlew,
                                   bool isHighSpeed) {
    //[1] direction and mode, i.e. high/low speed in eqmod?
    if (!check_axis_id(axis, __func__)) return false;
    ctx.log<INFO>(
        "ASCOMInteface: %s- isSlew: %u; isForward: %u; isHighSpeed: %u\n",
        __func__, isForward, isSlew, isHighSpeed);
    // TODO
    m_params.motorDirection[isSlew][axis] = isForward;
    m_params.highSpeedMode[isSlew][axis] = isHighSpeed;
    bool ret = true;
    return ret;
  }
  // set goto target - SetGotoTargetIncrement    = 'H', // set goto position
  bool swp_set_GotoTargetIncrement(uint8_t axis, uint32_t ncycles) {
    if (!check_axis_id(axis, __func__)) return false;
    ctx.log<INFO>("ASCOMInteface: %s- Command recieved: %u\n", __func__,
                  ncycles);
    m_params.GotoNCycles[axis] = ncycles % m_params.stepPerRotation[axis];
    return true;
  }
  // NOT SURE SetBreakPointIncrement    = 'M',
  // does nothing ??
  bool swp_set_BreakPointIncrement(uint8_t axis, uint32_t ncycles) {
    if (!check_axis_id(axis, __func__)) return false;
    ctx.log<INFO>("ASCOMInteface: %s- Command recieved: %u\n", __func__,
                  ncycles);
    // TODO
    bool ret = true;
    return ret;
  }
  // SetBreakStep              = 'U', // does nothing??
  bool swp_set_BreakStep(uint8_t axis, uint32_t ncycles) {
    if (!check_axis_id(axis, __func__)) return false;
    ctx.log<INFO>("ASCOMInteface: %s- Command recieved: %u\n", __func__,
                  ncycles);
    bool ret = true;
    // TODO
    return ret;
  }
  // SetGotoTarget             = 'S', // does nothing??
  bool swp_set_GotoTarget(uint8_t axis, uint32_t target) {
    if (!check_axis_id(axis, __func__)) return false;
    ctx.log<INFO>("ASCOMInteface: %s- Command recieved: %u\n", __func__,
                  target);
    if (target > m_params.stepPerRotation[axis]) {
      ctx.log<ERROR>("%s(%u) val out of range %u (max=%u)\n", __func__, axis,
                     target, m_params.stepPerRotation[axis]);
      return false;
    }
    m_params.GotoTarget[axis] = target;
    return true;
  }
  // SetStepPeriod             = 'I', //set slew speed
  bool swp_set_StepPeriod(uint8_t axis, bool isSlew, uint32_t period_usec) {
    return set_motor_period_usec(axis, isSlew, period_usec);
  }
  // StartMotion               = 'J', // start
  bool swp_cmd_StartMotion(uint8_t axis, bool isSlew, bool use_accel) {
    if (!check_axis_id(axis, __func__)) return false;

    bool ret = false;
    if (isSlew)
      ret = start_raw_tracking(axis, m_params.motorDirection[isSlew][axis],
                              m_params.period_ticks[isSlew][axis],
                              m_params.motorMode[isSlew][axis]);
    else
      ret = send_raw_command(axis, m_params.motorDirection[isSlew][axis],
                             m_params.GotoNCycles[axis],
                             m_params.period_ticks[isSlew][axis],
                             m_params.motorMode[isSlew][axis], false, use_accel);
    return ret;
  }
  // GetHomePosition           = 'd', // Get Home position encoder count
  // (default at startup)
  // not used in eqmod
  uint32_t swp_get_HomePosition(uint8_t axis) {
    if (!check_axis_id(axis, __func__)) return 0;
    return 0;
  }
  // InquireAuxEncoder         = 'd', // EQ8/AZEQ6/AZEQ5 only
  uint32_t swp_get_AuxEncoder(uint8_t axis) {
    // return microstep config
    if (!check_axis_id(axis, __func__)) return 0xFF;
    // TODO
    return 1;  // get_motor_mode(axis, m_params.motorStatus[axis] == GoTo ?
               // false : true );
  }
  // SetFeatureCmd             = 'W', // EQ8/AZEQ6/AZEQ5 only
  bool swp_set_Feature(uint8_t axis, uint8_t cmd) {  // not used
    ctx.log<INFO>("ASCOMInteface: %s-%u Command recieved: %u\n", __func__, axis, cmd);
    return true;
  }
  // GetFeatureCmd             = 'q', // EQ8/AZEQ6/AZEQ5 only
  uint32_t swp_get_Feature(uint8_t axis) {
    // return the gear change settings
    if (!check_axis_id(axis, __func__)) return 0x0;
    ctx.log<INFO>("ASCOMInteface: %s- Command recieved:\n", __func__);
    return 1;
  }
  // SetPolarScopeLED          = 'V',
  bool swp_set_PolarScopeLED() { return true; }

 private:
  Context& ctx;
  Memory<mem::control>& ctl;
  Memory<mem::status>& sts;
  Drv8825& stepper;

  typedef struct {
    // class variables
    double period_usec[2][2];      // time period in us
    uint32_t period_ticks[2][2];  // time period in 20ns ticks
    double speed_ratio[2][2];      // speed of motor
    bool highSpeedMode[2][2];

    uint8_t motorMode[2][2];  // microsteps
    bool motorDirection[2][2];

    uint32_t GotoTarget[2];
    uint32_t GotoNCycles[2];

    uint32_t versionNumber[2];  //_eVal: Version number

    uint32_t stepPerRotation[2];  //_aVal: Steps per axis revolution
    uint32_t stepsPerWorm[2];     //_sVal: Steps per worm gear revolution

    uint32_t minPeriod[2];  // slowest speed allowed
    uint32_t maxPeriod[2];  // Speed at which mount should stop. May be lower
                            // than minSpeed if doing a very slow IVal.

    double backlash_period_usec[2];  // Speed at which mount should stop. May be
                                    // lower than minSpeed if doing a very slow
                                    // IVal.
    uint32_t
        backlash_ticks[2];  // Speed at which mount should stop. May be lower
                            // than minSpeed if doing a very slow IVal.
    uint8_t
        backlash_mode[2];  // Speed at which mount should stop. May be lower
    uint32_t
        backlash_ncycle[2];  // Speed at which mount should stop. May be lower
                             // than minSpeed if doing a very slow IVal.
  } parameters;
  parameters m_params;

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
