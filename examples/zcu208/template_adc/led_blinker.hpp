/// Led Blinker driver
///
/// (c) Koheron

#ifndef __DRIVERS_LED_BLINKER_HPP__
#define __DRIVERS_LED_BLINKER_HPP__

#include <context.hpp>

class LedBlinker
{
  public:
    LedBlinker(Context& ctx_)
    : ctx(ctx_),
      ctl(ctx_.mm.get<mem::control>())
    , sts(ctx_.mm.get<mem::status>())
    {}

  std::array<uint32_t, 8> get_rfsoc_clocks() {
    std::array<uint32_t, 8> ret = {
        sts.read<reg::adc_clk0, uint32_t>(),
        sts.read<reg::adc_clk1, uint32_t>(),
        sts.read<reg::adc_clk2, uint32_t>(),
        sts.read<reg::adc_clk3, uint32_t>(),
        sts.read<reg::dac_clk0, uint32_t>(),
        sts.read<reg::dac_clk1, uint32_t>(),
        sts.read<reg::dac_clk2, uint32_t>(),
        sts.read<reg::dac_clk3, uint32_t>()};
    for (size_t i = 0; i < 8; i++)
      ctx.log<INFO>("Print RF%d clocks: %d", i, ret[i]);
    return ret;
  }
  std::array<uint32_t, 8> get_adc_raw_data() {
    std::array<uint32_t, 8> ret = {
        sts.read<reg::adc_sample0, uint32_t>(),
        sts.read<reg::adc_sample1, uint32_t>(),
        sts.read<reg::adc_sample2, uint32_t>(),
        sts.read<reg::adc_sample3, uint32_t>(),
        sts.read<reg::adc_sample4, uint32_t>(),
        sts.read<reg::adc_sample5, uint32_t>(),
        sts.read<reg::adc_sample6, uint32_t>(),
        sts.read<reg::adc_sample7, uint32_t>()};
    for (size_t i = 0; i < 8; i++)
      ctx.log<INFO>("Print ADC%d sample: %d", i, ret[i]);
    return ret;
  }
    void set_leds(uint32_t led_value) {
        ctl.write<reg::led>(led_value);
    }

    uint32_t get_leds() {
        return ctl.read<reg::led>();
    }

    void set_led(uint32_t index, bool status) {
        ctl.write_bit_reg(reg::led, index, status);
    }

    uint32_t get_forty_two() {
        return sts.read<reg::forty_two>();
    }

  private:
  Context& ctx;
    Memory<mem::control>& ctl;
    Memory<mem::status>& sts;
};

#endif // __DRIVERS_LED_BLINKER_HPP__
