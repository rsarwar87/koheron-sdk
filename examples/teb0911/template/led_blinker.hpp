/// Led Blinker driver
///
/// (c) Koheron

#ifndef __DRIVERS_LED_BLINKER_HPP__
#define __DRIVERS_LED_BLINKER_HPP__

#include <context.hpp>

class LedBlinker
{
  public:
    LedBlinker(Context& ctx)
    : ctl(ctx.mm.get<mem::control>())
    , sts(ctx.mm.get<mem::status>())
    {}

    void set_leds(uint32_t led_value) {
        ctl.write<reg::led>(led_value);
    }

    uint32_t get_leds() {
        return ctl.read<reg::led>();
    }

    void set_led(uint32_t index, bool status) {
        ctl.write_bit_reg(reg::led, index, status);
    }

    std::array<uint32_t, prm::nclk>  get_mgt_clocks() {
        std::array<uint32_t, prm::nclk>  ret = {
           sts.read<reg::clock0>(),
           sts.read<reg::clock1>(),
           sts.read<reg::clock2>(),
           sts.read<reg::clock3>(),
           sts.read<reg::clock4>(),
           sts.read<reg::clock5>()
        };
        return ret;
    }

    uint32_t get_forty_two() {
        return sts.read<reg::forty_two>();
    }

  private:
    Memory<mem::control>& ctl;
    Memory<mem::status>& sts;
};

#endif // __DRIVERS_LED_BLINKER_HPP__
