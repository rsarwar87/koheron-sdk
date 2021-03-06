
#ifndef __DRIVERS_ADC_DAC_DMA_HPP__
#define __DRIVERS_ADC_DAC_DMA_HPP__

#include <context.hpp>
#include <AdcQspiDriver.hpp>
#include <math.h>
#include <cmath>

using std::unique_ptr;
class TopLevel
{
  public:
    TopLevel(Context& ctx_)
    : ctx(ctx_)
    , ctl(ctx.mm.get<mem::control>())
    , sts(ctx.mm.get<mem::status>())
    , m_adc_qspi(ctx.get<AdcQspiDriver>())
    {
      set_vco(true);
      adcSpiInitialize();
    }
    
    ~TopLevel()
    {
    }

    uint32_t adcSpiInitialize()
    {
      ctx.log<INFO>("Starting initial initialization of the ClockTree. \n");
      using namespace std::chrono_literals;
      qSpiWrite(0x00, 0x30); // reset clock tree
      ctx.log<INFO>("Reset ClockTree. \n");
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x00, 0x10); // pull it out of reset
      ctx.log<INFO>("Pull out of reset. \n");
      std::this_thread::sleep_for(1ms);

        //set output for C
      qSpiWrite(0x3C, 0x0C);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x3D, 0x0C);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x3E, 0x0C);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x3F, 0x0C);
      std::this_thread::sleep_for(1ms);

      //enable channel 5 a
      qSpiWrite(0x40, 0x03);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x41, 0x02);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x42, 0x02);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x43, 0x03);
      std::this_thread::sleep_for(1ms);
      //set high/low cycle
      qSpiWrite(0x48, 0x21);// low[7:4] high[3:0]
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x49, 0x00);// phase[3:0 bypass[7]]
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x4A, 0x21);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x4B, 0x00);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x4C, 0x21);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x4D, 0x00);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x4E, 0x21);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x4F, 0x00);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x50, 0x21);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x51, 0x00);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x52, 0x21);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x53, 0x00);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x54, 0x21);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x55, 0x00);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x56, 0x21);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x57, 0x00);
      std::this_thread::sleep_for(1ms);
      // global params
      qSpiWrite(0x04, 0x05); // A counter [5:0]
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x05, 0x00); // B counter[4:0 - > 12:8]
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x06, 0x0F); // B counter [7:0]
      std::this_thread::sleep_for(1ms);
      //qSpiWrite(0x07, 0xUE); // loss of ref settings
      qSpiWrite(0x08, 0x4F); // CP mode[1:0]; MUX[5:2]; PFD[6]
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x09, 0x70); //[counter resets{Rn N All}[2:0]] CP curren[6:4]
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x0A, (0x2 << 2)); //prescaller[4:2] Powerdown [1:0]
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x0B, 0x00); // R divider[13:8 . 5:0]
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x0C, 0x10); // R divider[7:0]
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x45, 0x02); // clock power down
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x5A, 0x01); // update registers
      std::this_thread::sleep_for(1ms);
      ctx.log<INFO>("Finished initial initialization of the ClockTree. \n");

      return 1;
    }

    uint64_t get_dna()
    {
      return sts.read<reg::dna>();
    }

    uint32_t get_gpiopcie()
    {
      return sts.read<reg::gpio_from_pcie>();
    }
    uint32_t get_adc_error()
    {
      return (sts.read<reg::adc_error>() >> 28);
    }
    uint32_t get_adc_valid()
    {
      return (sts.read<reg::adc_valid>() >> 28);
    }
    uint32_t get_fortytwo()
    {
      return sts.read<reg::forty_two>();
    }
    std::array<uint32_t, 4> get_adc_clocks() {
      return { sts.read<reg::adc_clk0, uint32_t>(),
               sts.read<reg::adc_clk1, uint32_t>(), 
               sts.read<reg::adc_clk2, uint32_t>(), 
               sts.read<reg::adc_clk3, uint32_t>() 
             };
    }
    std::array<uint32_t, 4> get_adc_raw_data() {
      uint32_t adc0 = sts.read<reg::adc_in0, uint32_t>();
      uint32_t adc1 = sts.read<reg::adc_in1, uint32_t>();
      return { adc0 & 0xFFFF, (adc0 >> 16) & 0xFFFF,
               adc1 & 0xFFFF, (adc1 >> 16) & 0xFFFF };
    }

    void set_adc_delay_inc(uint32_t val)
    {
      ctl.write<reg::adc_delay_inc>(val);
      ctl.write<reg::adc_delay_inc>(0);
    }
    void set_adc_delay_dec(uint32_t val)
    {
      ctl.write<reg::adc_delay_dec>(val);
      ctl.write<reg::adc_delay_dec>(0);
    }
    void set_adc_clear_error(uint32_t val)
    {
      ctl.write<reg::adc_clear_error>(val);
      ctl.write<reg::adc_clear_error>(0);
    }
    void set_vco(bool enable)
    {
        if (enable) ctl.write<reg::vco_power_en>(0xf);
        else ctl.write<reg::vco_power_en>(0x0);
    }
    void set_threashold(uint8_t idx, uint32_t val)
    {
      if (idx == 0) ctl.write<reg::trigger_threshold0>(val);
      else if (idx == 1) ctl.write<reg::trigger_threshold1>(val);
      else if (idx == 2) ctl.write<reg::trigger_threshold2>(val);
    }
    void set_pciegpio(uint32_t val)
    {
      ctl.write<reg::gpio_to_pcie>(val);
    }
    void set_gpio(uint32_t val)
    {
      ctl.write<reg::led>(val);
    }
  private:
    Context& ctx;
    Memory<mem::control>& ctl;
    Memory<mem::status>& sts;
    AdcQspiDriver& m_adc_qspi;
    void qSpiWrite(uint8_t addr, uint8_t data)
    {
      m_adc_qspi.write_spi(addr, data, false);
    }
    uint32_t qSpiRead(uint8_t addr)
    {
      return m_adc_qspi.read_spi(addr, false);
    }
} ;

#endif // __DRIVERS_ADC_DAC_DMA_HPP__
