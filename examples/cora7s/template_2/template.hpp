/// Led Blinker driver
///
/// (c) Koheron

#ifndef __DRIVERS_LED_BLINKER_HPP__
#define __DRIVERS_LED_BLINKER_HPP__

#include <context.hpp>
namespace pwm_regs {
    constexpr uint32_t ctr_reg = 0x0;
    constexpr uint32_t period_reg = 0x8;
    constexpr uint32_t duty_reg = 0x40;
}
namespace pmod_regs {
    constexpr uint32_t base = 0x0;
    constexpr uint32_t direction = 0x4;
}
namespace Xadc_regs {
    constexpr uint32_t set_chan = 0x324;
    constexpr uint32_t avg_en = 0x32C;
    constexpr uint32_t read = 0x240;
    constexpr uint32_t config0 = 0x300;
}

class TemplateDriver
{
  public:
    TemplateDriver(Context& ctx)
    : ctl(ctx.mm.get<mem::control>())
    , sts(ctx.mm.get<mem::status>())
    , pwm0(ctx.mm.get<mem::led0>()),
      pwm1(ctx.mm.get<mem::led1>())
    , xadc(ctx.mm.get<mem::xadc>())

    {
      init_led(0);
      init_led(1);
    
      m_mask1 = 0;
      m_mask0 = 0;
    }
    uint32_t xadc_read(uint32_t channel) {
        return xadc.read_reg(Xadc_regs::read + 4 * channel);
    }

    void init_led(uint8_t id) {
      set_period(id, 0xffff);
      if (id == 0)
        set_rbg(id, 256, 0, 256);
      else
        set_rbg(id, 0, 0, 256);

      set_enable(id, 1);
    }

    uint64_t get_dna() {
        return sts.read<reg::dna, uint64_t>();
    }

    void set_rbg(uint32_t id, uint16_t r, uint16_t g, uint16_t b) {
      set_duty_cycle (id, 0, b);
      set_duty_cycle (id, 1, g);
      set_duty_cycle (id, 2, r);
    }

    void set_period(uint32_t id, uint32_t val) {
      if (id == 0)
        pwm0.write<pwm_regs::period_reg>(val);
      else
        pwm1.write<pwm_regs::period_reg>(val);
    };

    uint32_t get_buttons() {
        return sts.read<reg::buttons>();
    }
    uint32_t get_forty_two() {
        return sts.read<reg::forty_two>();
    }

  private:
    Memory<mem::control>& ctl;
    Memory<mem::status>& sts;
    Memory<mem::led0>& pwm0;
    Memory<mem::led1>& pwm1;
    Memory<mem::xadc>& xadc;
    uint32_t m_mask0;
    uint32_t m_mask1;
    
    void set_enable(uint32_t id, uint32_t val) {
      if (id == 0)
        pwm0.write<pwm_regs::ctr_reg>(val);
      else
        pwm1.write<pwm_regs::ctr_reg>(val);

    };

    void set_duty_cycle(uint32_t id, uint32_t ch, uint32_t val) {
      if (id == 0)
        pwm0.write_reg(pwm_regs::duty_reg + 4*ch, val);
      else
        pwm1.write_reg(pwm_regs::duty_reg + 4*ch, val);
    };
};

#endif // __DRIVERS_LED_BLINKER_HPP__
