/// Led Blinker driver
///
/// (c) Koheron

#ifndef __DRIVERS_ASCOM_INTERFACE_HPP__
#define __DRIVERS_ASCOM_INTERFACE_HPP__

#include <context.hpp>
#include <drv8825.hpp>

enum t_status {Idle = 0, Slew, GoTo};

typedef struct{        
    //class variables
    double       period_time    [2]; // time period in us
    uint32_t     period_ticks   [2]; // time period in 20ns ticks
    uint32_t     motorSpeed     [2]; // speed of motor
    uint8_t      motorModeSlew  [2]; // microsteps
    uint8_t      motorModeGoto  [2]; // microsteps
    t_status     motorStatus    [2]; //_GVal: slew/goto mode
    bool         motorDirectionS[2];
    bool         motorDirectionG[2];
    bool         highSpeedMode  [2];
    uint32_t     normalGotoSpeed[2]; //IVal for normal goto movement.
    double       versionNumber  [2]; //_eVal: Version number
    uint32_t     stepPerRotation[2]; //_aVal: Steps per axis revolution
    uint32_t     highspeedSlew  [2]; //_gVal: Speed scalar for highspeed slew
    uint32_t     stepsPerWorm   [2]; //_sVal: Steps per worm gear revolution
    uint32_t     minPeriod      [2]; //slowest speed allowed
    uint32_t     maxPeriod      [2]; //Speed at which mount should stop. May be lower than minSpeed if doing a very slow IVal.
    uint32_t     backlash_period[2]; //Speed at which mount should stop. May be lower than minSpeed if doing a very slow IVal.
    uint32_t     backlash_ticks [2]; //Speed at which mount should stop. May be lower than minSpeed if doing a very slow IVal.
    uint32_t     backlash_ncycle[2]; //Speed at which mount should stop. May be lower than minSpeed if doing a very slow IVal.
} parameters;


using namespace std::chrono_literals;
class ASCOMInterface
{
  public:
    ASCOMInterface(Context& ctx_)
    : ctx(ctx_)         
    , ctl(ctx.mm.get<mem::control>())
    , sts(ctx.mm.get<mem::status>())
    , stepper(ctx.get<Drv8825>())
    {
      for (size_t i = 0; i < 2; i++){
        m_params.period_time    [i] = 100; // time period in us
        m_params.period_ticks   [i] = 100*(prm::fclk0/1000000); // time period in 20ns ticks
        m_params.minPeriod      [i] = 0x1; //slowest speed allowed
        m_params.maxPeriod      [i] = 0x30000; //Speed at which mount should stop. May be lower than minSpeed if doing a very slow IVal.
        m_params.motorSpeed     [i] = 445; // speed of motor
        m_params.motorStatus    [i] = Idle; //_GVal: slew/goto mode
        m_params.motorDirectionG[i] = true;
        m_params.motorDirectionS[i] = true;
        m_params.motorModeGoto  [i] = 0x07; // microsteps
        m_params.motorModeSlew  [i] = 0x07; // microsteps
        m_params.normalGotoSpeed[i] = 0x3000; //IVal for normal goto movement.
        m_params.highSpeedMode  [i] = false;
        m_params.highspeedSlew  [i] = 455; //_gVal: Speed scalar for highspeed slew
        m_params.versionNumber  [i] = 1.01; //_eVal: Version number
        m_params.stepPerRotation[i] = 0x3000; //_aVal: Steps per axis revolution
        m_params.backlash_period[i] = 0x300; //_sVal: Steps per worm gear revolution
        m_params.backlash_ticks [i] = 0x300; //_eVal: Version number
        m_params.backlash_ncycle[i] = 0x3000; //_aVal: Steps per axis revolution
      }
    }

    double get_version()
    {
      return (m_params.versionNumber[0]);
    }
    uint32_t get_backlash_period(int8_t axis)
    {
      if (!check_axis_id(axis, __func__)) return 0xFFFFFFFF;
      ctx.log<INFO>("%s(%d): %d us\n", __func__, axis, 
        m_params.backlash_period[axis]);
      return m_params.backlash_period[axis];
    }
    uint32_t get_backlash_ncycles(int8_t axis)
    {
      if (!check_axis_id(axis, __func__)) return 0xFFFFFFFF;
      ctx.log<INFO>("%s(%d): %d cycles\n", __func__, axis, 
        m_params.backlash_ncycle[axis]);
      return m_params.backlash_ncycle[axis];
    }
    bool set_backlash(int8_t axis, bool period, uint8_t cycles)
    {
      if (!check_axis_id(axis, __func__)) return false;
      if (period > m_params.maxPeriod[axis] || period < m_params.minPeriod[axis])
      {
        ctx.log<INFO>("%s(%d): out of range %d\n", __func__, axis, period);
        return false;
      }

      m_params.backlash_period[axis] = period;
      m_params.backlash_ticks[axis] = period*(prm::fclk0/1000000);
      m_params.backlash_ncycle[axis] = cycles;
      ctx.log<INFO>("%s(%d): backlash period set to %d us for %d cycles\n", __func__, axis, 
        period, cycles);
      return true;
    }
    bool set_motor_mode(int8_t axis, bool isSlew, uint8_t val)
    {
      if (!check_axis_id(axis, __func__)) return false;
      if (val > 7) {
        ctx.log<WARNING>("%s(%d): invalid mode for %s (%d)\n", __func__, axis, 
          isSlew ? "Slew" : "GoTo", val);
        return false;
      }

      if (isSlew)
        m_params.motorModeSlew[axis] = val;
      else 
        m_params.motorModeGoto[axis] = val;
      ctx.log<INFO>("%s(%d): %s mode set to %s\n", __func__, axis, 
        isSlew ? "Slew" : "GoTo", val);
      return true;
    }
    bool get_motor_mode(int8_t axis, bool isSlew)
    {
      if (!check_axis_id(axis, __func__)) return false;
      bool ret = isSlew ? m_params.motorModeSlew[axis] : m_params.motorModeGoto[axis];
      ctx.log<INFO>("%s(%d): %s is in %d mode\n", __func__, axis, 
        isSlew ? "Slew" : "GoTo", ret);
      return (ret);
    }
    bool set_motor_direction(int8_t axis, bool isSlew, bool isForward)
    {
      if (!check_axis_id(axis, __func__)) return false;
      if (isSlew)
        m_params.motorDirectionS[axis] = isForward;
      else 
        m_params.motorDirectionG[axis] = isForward;
      ctx.log<INFO>("%s(%d): %s is in %s direction\n", __func__, axis, 
        isSlew ? "Slew" : "GoTo", isForward ? "Forward" : "Backward");
      return true;
    }
    bool get_motor_direction(int8_t axis, bool isSlew)
    {
      if (!check_axis_id(axis, __func__)) return false;
      bool ret = isSlew ? m_params.motorDirectionS[axis] : m_params.motorDirectionG[axis];
      ctx.log<INFO>("%s(%d): %s is in %s direction\n", __func__, axis, 
        isSlew ? "Slew" : "GoTo", ret ? "Forward" : "Backward");
      return (ret);
    }
    uint32_t get_motor_status(int8_t axis)
    {
      if (!check_axis_id(axis, __func__)) return 0xFFFFFFFF;
      ctx.log<INFO>("%s(%d): %d\n", __func__, axis, m_params.motorStatus[axis]);
      return (m_params.motorStatus[axis]);
    }
    bool set_min_period(int8_t axis, uint32_t val)
    {
      if (!check_axis_id(axis, __func__)) return false;
      m_params.minPeriod[axis] = val;
      ctx.log<INFO>("%s(%d): %d\n", __func__, axis, m_params.minPeriod[axis]);
      return true;
    }
    bool set_max_period(int8_t axis, uint32_t val)
    {
      if (!check_axis_id(axis, __func__)) return false;
      m_params.maxPeriod[axis] = val;
      ctx.log<INFO>("%s(%d): %d\n", __func__, axis, m_params.maxPeriod[axis]);
      return true;
    }
    uint32_t get_min_period(int8_t axis)
    {
      if (!check_axis_id(axis, __func__)) return 0xFFFFFFFF;
      ctx.log<INFO>("%s(%d): %d\n", __func__, axis, m_params.minPeriod[axis]);
      return (m_params.minPeriod[axis]);
    }
    uint32_t get_max_period(int8_t axis)
    {
      if (!check_axis_id(axis, __func__)) return 0xFFFFFFFF;
      ctx.log<INFO>("%s(%d): %d\n", __func__, axis, m_params.maxPeriod[axis]);
      return (m_params.maxPeriod[axis]);
    }
    uint32_t get_motor_speed(int8_t axis)
    {
      if (!check_axis_id(axis, __func__)) return 0xFFFFFFFF;
      ctx.log<INFO>("%s(%d): %d\n", __func__, axis, m_params.period_ticks[axis]);
      return (m_params.period_ticks[axis]);
    }
    uint32_t get_period_ticks(int8_t axis)
    {
      if (!check_axis_id(axis, __func__)) return 0xFFFFFFFF;
      ctx.log<INFO>("%s(%d): %d\n", __func__, axis, m_params.period_ticks[axis]);
      return (m_params.period_ticks[axis]);
    }
    uint32_t get_period_time(int8_t axis)
    {
      if (!check_axis_id(axis, __func__)) return 0xFFFFFFFF;
      ctx.log<INFO>("%s(%d): %d\n", __func__, axis, m_params.period_time[axis]);
      return (m_params.period_time[axis]);
    }
    bool set_period_time(int8_t axis, uint32_t val)
    {
      if (!check_axis_id(axis, __func__)) return false;
      if (val > m_params.maxPeriod[axis] || val < m_params.minPeriod[axis])
      {
        ctx.log<INFO>("%s(%d): out of range %d\n", __func__, axis, val);
        return false;
      }
      m_params.period_time[axis] = val;
      m_params.period_ticks[axis] = val*(prm::fclk0/1000000);
      m_params.motorSpeed[axis] = 360; 
      ctx.log<INFO>("%s(%d): %d\n", __func__, axis, m_params.period_time[axis]);
      return true;
    }

    uint32_t get_raw_status(int8_t axis)
    {
      if (!check_axis_id(axis, __func__)) return 0xFFFFFFFF;
      if (axis == 0) return stepper.get_status<0>();
      else return stepper.get_status<1>();
    }
    uint32_t get_raw_stepcount(int8_t axis)
    {
      if (!check_axis_id(axis, __func__)) return 0xFFFFFFFF;
      if (axis == 0) return stepper.get_stepcount<0>();
      else return stepper.get_stepcount<1>();
    }
    void disable_raw_tracking(int8_t axis)
    {
      if (!check_axis_id(axis, __func__)) return;
      if (axis == 0) return stepper.disable_tracking<0>();
      else return stepper.disable_tracking<1>();
    }
    void start_raw_tracking(int8_t axis, bool isForward, uint32_t periodticks, uint8_t mode)
    {
      if (!check_axis_id(axis, __func__)) return;
      if (axis == 0) return stepper.enable_tracking<0>(isForward, periodticks, mode);
      else return stepper.enable_tracking<1>(isForward, periodticks, mode);
    }
    void set_raw_backlash(int8_t axis, uint32_t ticks, uint32_t ncycles)
    {
      if (!check_axis_id(axis, __func__)) return;
      if (axis == 0) return stepper.set_backlash<0>(ticks, ncycles);
      else return stepper.set_backlash<1>(ticks, ncycles);
    }
    void park_raw_telescope(int8_t axis, bool isForward, uint32_t ticks, uint8_t mode)
    {
      if (!check_axis_id(axis, __func__)) return;
      if (axis == 0) return stepper.set_park<0>(isForward, ticks, mode);
      else return stepper.set_park<1>(isForward, ticks, mode);
    }
    void park_raw_command(int8_t axis, bool isForward, uint32_t ticks, uint32_t period, uint8_t mode, bool isGoTo)
    {
      if (!check_axis_id(axis, __func__)) return;
      if (axis == 0) return stepper.set_command<0>(isForward, ticks, period, mode, isGoTo);
      else return stepper.set_command<1>(isForward, ticks, period, mode, isGoTo);
    }
    void cancel_raw_command(int8_t axis){
      if (!check_axis_id(axis, __func__)) return;
      if (axis == 0) return stepper.cancel_command<0>();
      else return stepper.cancel_command<1>();
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

    void swp_cmd_Initialize(uint8_t axis){ 
      if (!check_axis_id(axis, __func__)) return;
    }
    double swp_get_BoardVersion(uint8_t axis){ 
      if (!check_axis_id(axis, __func__)) return -1.;
      return m_params.versionNumber[axis];
    }
    void swp_get_GridPerRevolution(uint8_t axis){ 
      if (!check_axis_id(axis, __func__)) return;
    }
    void swp_get_TimerInterruptFreq(uint8_t axis){ 
      if (!check_axis_id(axis, __func__)) return;
    }
    void swp_get_HighSpeedRatio(uint8_t axis){ 
      if (!check_axis_id(axis, __func__)) return;
    }
    uint32_t swp_get_AxisPosition(uint8_t axis){ 
      return get_raw_stepcount(axis);
    }
    uint32_t swp_get_AxisStatus(uint8_t axis){ 
      return get_raw_status(axis);
    }
    void swp_set_AxisPosition(uint8_t axis){ 
      if (!check_axis_id(axis, __func__)) return;
    }
    void swp_cmd_StopAxis(uint8_t axis, bool instant){ 
      if (instant || !check_axis_id(axis, __func__)) return;
      
    }
    void swp_set_MotionMode(uint8_t axis){ 
      if (!check_axis_id(axis, __func__)) return;
    }
    void swp_set_BreakPointIncrement(uint8_t axis){ 
      if (!check_axis_id(axis, __func__)) return;
    }
    void swp_set_BreakStep(uint8_t axis){ 
      if (!check_axis_id(axis, __func__)) return;
    }
    void swp_set_GotoTargetIncrement(uint8_t axis){ 
      if (!check_axis_id(axis, __func__)) return;
    }
    void swp_set_GotoTarget(uint8_t axis){ 
      if (!check_axis_id(axis, __func__)) return;
    }
    void swp_cmd_StartMotion(uint8_t axis){ 
      if (!check_axis_id(axis, __func__)) return;
          //issue command
    }
    void swp_cmd_ActivateMotor(uint8_t axis){ 
      if (!check_axis_id(axis, __func__)) return;
    }
    uint32_t swp_get_HomePosition(uint8_t axis){ 
      if (!check_axis_id(axis, __func__)) return 0;
      return 0;
    }
    uint8_t swp_get_HasAuxEncoder(uint8_t axis){  // steps per 360 degree
      if (!check_axis_id(axis, __func__)) return 0xFF;
      return get_motor_mode(axis, m_params.motorStatus[axis] == GoTo ? false : true );
    }
    void swp_set_Feature(uint8_t axis){  // steps per 360 degree
      if (!check_axis_id(axis, __func__)) return;
      return;
    }
    uint32_t swp_get_Feature(uint8_t axis){  // steps per 360 degree
      if (!check_axis_id(axis, __func__)) return 0x0;
      return 1;
    }
    void swp_set_PolarScopeLED(){ 
      return;
    }

  private:
    Context& ctx;
    Memory<mem::control>& ctl;
    Memory<mem::status>& sts;
    Drv8825 &stepper;

    parameters m_params;

    bool check_axis_id(int8_t axis, std::string str)
    {
      if (axis > 1)
      {
        ctx.log<INFO>("ASCOMInteface: %s- Invalid axis:\n", str, axis);
        return false;
      }
      return true; 
    }

};

#endif // __DRIVERS_LED_BLINKER_HPP__
