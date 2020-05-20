/// Led Blinker driver
///
/// (c) Koheron

#ifndef __DRIVERS_DRV8825_HPP__
#define __DRIVERS_DRV8825_HPP__

#include <context.hpp>

using namespace std::chrono_literals;
class Drv8825
{
  public:
    Drv8825(Context& ctx_)
    : ctx(ctx_)         
    , ctl(ctx.mm.get<mem::control>())
    , sts(ctx.mm.get<mem::status>())
    {}

    template<uint32_t offset>
    uint32_t get_status()
    {
      uint32_t ret = ctl.read<reg::status0 + offset*0x4>();
      ctx.log<INFO>("DRV8825-%s: %s=0x%8x\n", offset == 0 ? "SA" : "DC", __func__, ret);
      return ret; 
    }
    template<uint32_t offset>
    uint32_t get_stepcount()
    {
      uint32_t ret = ctl.read<reg::step_count0 + offset*0x4>();
      ctx.log<INFO>("DRV8825-%s: %s=0x%8x\n", offset == 0 ? "SA" : "DC", __func__, ret);
      return ret; 
    }
    template<uint32_t offset>
    void disable_backlash()
    {
      set_backlash<offset>(0,0);
    }
    template<uint32_t offset>
    void disable_tracking()
    {
      ctl.write<reg::trackctrl0 + offset*0x4>(0);
      ctx.log<INFO>("DRV8825-%s: %s\n", offset == 0 ? "SA" : "DC", __func__);
    }
    template<uint32_t offset>
    void enable_tracking(bool isCCW, uint32_t period_ticks, uint8_t mode)
    {
        ctl.write<reg::trackctrl0 + offset*0x4>(1 + (isCCW << 1) + (mode << 2) +((period_ticks) << 5));
        ctx.log<INFO>("DRV8825-%s: %s: CCW=%d, period=%d, mode=%d \n", offset == 0 ? "SA" : "DC", __func__,
            isCCW, (period_ticks), mode);
    }
    template<uint32_t offset>
    void set_backlash(uint32_t period_ticks, uint32_t n_cycle)
    {
        ctl.write<reg::backlash_tick0 + offset*0x4>(period_ticks);
        ctl.write<reg::backlash_duration0 + offset*0x4>(n_cycle); // TODO :: set mode
        ctx.log<INFO>("DRV8825-%s: %s: period=%d, cycle=%d \n", offset == 0 ? "SA" : "DC", __func__,
            (period_ticks), n_cycle);
    }

    template<uint32_t offset>
    void set_park(bool isCCW, uint32_t period_ticks, uint8_t mode)
    {
      set_command<offset>(isCCW, 0, period_ticks, mode, true);
    }
    template<uint32_t offset>
    void set_command(bool isCCW, uint32_t target, uint32_t period_ticks, uint8_t mode, bool isGoto) {
        ctl.write<reg::cmdtick0 + offset*0x4>(period_ticks);
        ctl.write<reg::cmdduration0 + offset*0x4>(target);
        ctl.write<reg::cmdcontrol0 + offset*0x4>(1 + (isGoto << 3) + (isCCW << 2) + (mode << 4));
        ctx.log<INFO>("DRV8825-%s: %s: CCW=%d, period=%d, %s=%d mode=%d \n", offset == 0 ? "SA" : "DC", __func__,
            isCCW, (period_ticks), isGoto ? "GotoTarget" : "n_cycles", target, mode);
        std::this_thread::sleep_for(1ms);
        ctl.write<reg::cmdcontrol0 + offset*0x4>(0);
    }
    template<uint32_t offset>
    void cancel_part(){cancel_command<offset>();}
    template<uint32_t offset>
    void cancel_goto(){cancel_command<offset>();}
    template<uint32_t offset>
    void cancel_command(){
        ctl.write<reg::cmdcontrol0 + offset*0x4>(0xF0000000);
        std::this_thread::sleep_for(1ms);
        ctl.write<reg::cmdcontrol0 + offset*0x4>(0);
        ctx.log<INFO>("DRV8825-%s: %s\n", offset == 0 ? "SA" : "DC", __func__);
    }

  private:
    Context& ctx;
    Memory<mem::control>& ctl;
    Memory<mem::status>& sts;

};

#endif // __DRIVERS_LED_BLINKER_HPP__
