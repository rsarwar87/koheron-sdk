
#ifndef __DRIVERS_PSA_HPP__
#define __DRIVERS_PSA_HPP__

#include <math.h>
#include <cmath>
#include <sstream>
#include <iostream>
#include <context.hpp>

using namespace std::chrono_literals;
using std::unique_ptr;

namespace psa_regs {
constexpr uint32_t ctrl = 0x0;   // ADC Control register 

constexpr uint32_t g_baseline = 0x0;    // ADC Status register
constexpr uint32_t g_fixed    = 0x4;   // ADC0 IODELAYE3 increment bus
constexpr uint32_t g_short    = 0x8;   // ADC1 IODELAYE3 increment bus
constexpr uint32_t g_short_d  = 0xC;  // ADC2 IODELAYE3 increment bus
constexpr uint32_t g_long     = 0x10;  // ADC3 IODELAYE3 increment bus
constexpr uint32_t t_type     = 0x14;  // ADC0 IODELAYE3 decrement bus
constexpr uint32_t t_threshold= 0x18;  // ADC1 IODELAYE3 decrement bus
constexpr uint32_t t_diff_th  = 0x1C;  // ADC2 IODELAYE3 decrement bus
constexpr uint32_t t_pretrig  = 0x20;  // ADC3 IODELAYE3 decrement bus
constexpr uint32_t ch_resv0   = 0x24;  // LMK uWire Write bus

constexpr uint32_t ch_offset  = 0x28;

constexpr uint32_t dma_fullness0 = 0x1E0;  // ADC0 input 
constexpr uint32_t dma_fullness1 = 0x1E4;  // ADC0 input 
constexpr uint32_t dma_fullness2 = 0x1E8;  // ADC0 input 
constexpr uint32_t dma_fullness3 = 0x1EC;  // ADC0 input 
constexpr uint32_t dma_fullness4 = 0x1F0;  // ADC0 input 
constexpr uint32_t dma_fullness5 = 0x1F4;  // ADC0 input 
constexpr uint32_t dma_fullness6 = 0x1F8;  // ADC0 input 
constexpr uint32_t dma_fullness7 = 0x1FC;  // ADC0 input 
}  // namespace ctrl_regs


class PSACore {
 public:
  PSACore(Context& ctx_)
      : ctx(ctx_)
      , ctl(ctx.mm.get<mem::control>         () )
      , sts(ctx.mm.get<mem::status>          () )
      , psa_ctx(ctx.mm.get<mem::psa_module>  () )
      , psa_bram0(ctx.mm.get<mem::psa0_limits> () )  
      , psa_bram1(ctx.mm.get<mem::psa1_limits> () )  
      , psa_bram2(ctx.mm.get<mem::psa2_limits> () )  
      , psa_bram3(ctx.mm.get<mem::psa3_limits> () )  
      , psa_bram4(ctx.mm.get<mem::psa4_limits> () )  
  {

  } 
  ~PSACore(){};

  void set_psa_ram_at(uint8_t id, uint32_t addr, uint32_t val)
  {
    if (id == 0)
      psa_bram0.write_reg<uint32_t>(addr, val);
    else if (id == 1)
      psa_bram1.write_reg<uint32_t>(addr, val);
    else if (id == 2)
      psa_bram2.write_reg<uint32_t>(addr, val);
    else if (id == 3)
      psa_bram3.write_reg<uint32_t>(addr, val);
    else if (id == 4)
      psa_bram4.write_reg<uint32_t>(addr, val);
  }
  uint32_t get_psa_ram_at(uint8_t id, uint32_t addr)
  {
    uint32_t ret = 0;
    if (id == 0)
      ret = psa_bram0.read_reg<uint32_t>(addr);
    else if (id == 1)
      ret = psa_bram1.read_reg<uint32_t>(addr);
    else if (id == 2)
      ret = psa_bram2.read_reg<uint32_t>(addr);
    else if (id == 3)
      ret = psa_bram3.read_reg<uint32_t>(addr);
    else if (id == 4)
      ret = psa_bram4.read_reg<uint32_t>(addr);
    return ret;
  }
  void set_psa_ram(uint8_t id, std::array<uint8_t, mem::psa2_limits_range> val)
  {
    if (id == 0)
      psa_bram0.write_array<uint8_t, mem::psa0_limits_range>(val);
    else if (id == 1)
      psa_bram1.write_array<uint8_t, mem::psa1_limits_range>(val);
    else if (id == 2)
      psa_bram2.write_array<uint8_t, mem::psa2_limits_range>(val);
    else if (id == 3)
      psa_bram3.write_array<uint8_t, mem::psa3_limits_range>(val);
    else if (id == 4)
      psa_bram4.write_array<uint8_t, mem::psa4_limits_range>(val);
  }
  std::array<uint8_t, mem::psa2_limits_range> get_psa_ram(uint8_t id)
  {
    std::array<uint8_t, mem::psa2_limits_range> ret;
    if (id == 0)
      ret = psa_bram0.read_array<uint8_t, mem::psa0_limits_range>();
    else if (id == 1)
      ret = psa_bram1.read_array<uint8_t, mem::psa1_limits_range>();
    else if (id == 2)
      ret = psa_bram2.read_array<uint8_t, mem::psa2_limits_range>();
    else if (id == 3)
      ret = psa_bram3.read_array<uint8_t, mem::psa3_limits_range>();
    else if (id == 4)
      ret = psa_bram4.read_array<uint8_t, mem::psa4_limits_range>();
    return ret;
  }

  std::array<uint32_t, 8> get_dma_fullness()
  {
    std::array<uint32_t, 8> ret = { 
        psa_ctx.read<psa_regs::dma_fullness0> (), 
        psa_ctx.read<psa_regs::dma_fullness1> (),  
        psa_ctx.read<psa_regs::dma_fullness2> (),  
        psa_ctx.read<psa_regs::dma_fullness3> (), 
        psa_ctx.read<psa_regs::dma_fullness4> (), 
        psa_ctx.read<psa_regs::dma_fullness5> (),  
        psa_ctx.read<psa_regs::dma_fullness6> (),  
        psa_ctx.read<psa_regs::dma_fullness7> ()
    };
    return ret;
  }
  std::array<uint32_t, 4> get_psa_triggers(uint8_t ch)
  {
    std::array<uint32_t, 4> ret = {
        psa_ctx.read_reg<uint32_t> (ch*psa_regs::ch_offset + psa_regs::t_type     ) & 0x3,
        psa_ctx.read_reg<uint32_t> (ch*psa_regs::ch_offset + psa_regs::t_threshold) & 0xFFFF, 
        psa_ctx.read_reg<uint32_t> (ch*psa_regs::ch_offset + psa_regs::t_diff_th  ) & 0x1FF, 
        psa_ctx.read_reg<uint32_t> (ch*psa_regs::ch_offset + psa_regs::t_pretrig  ) & 0xF 
      };
    return ret;
  }
  void set_psa_triggers(uint8_t ch, std::array<uint32_t, 4> val)
  {
      psa_ctx.write_reg<uint32_t> (ch*psa_regs::ch_offset + psa_regs::t_type     , val[0] & 0x3   ); 
      psa_ctx.write_reg<uint32_t> (ch*psa_regs::ch_offset + psa_regs::t_threshold, val[1] & 0xFFFF); 
      psa_ctx.write_reg<uint32_t> (ch*psa_regs::ch_offset + psa_regs::t_diff_th  , val[2] & 0x1FF ); 
      psa_ctx.write_reg<uint32_t> (ch*psa_regs::ch_offset + psa_regs::t_pretrig  , val[3] & 0xF   ); 
  }
  std::array<uint32_t, 5> get_psa_gates(uint8_t ch)
  {
    std::array<uint32_t, 5> ret = 
      {
        psa_ctx.read_reg<uint32_t> (ch*psa_regs::ch_offset + psa_regs::g_baseline) & 0xF, 
        psa_ctx.read_reg<uint32_t> (ch*psa_regs::ch_offset + psa_regs::g_fixed   ) & 0xF, 
        psa_ctx.read_reg<uint32_t> (ch*psa_regs::ch_offset + psa_regs::g_short   ) & 0x3F, 
        psa_ctx.read_reg<uint32_t> (ch*psa_regs::ch_offset + psa_regs::g_short_d ) & 0xFF, 
        psa_ctx.read_reg<uint32_t> (ch*psa_regs::ch_offset + psa_regs::g_long    ) & 0x1FF 
      };
    return ret;
  }
  void set_psa_gates(uint8_t ch, std::array<uint32_t, 5> val)
  {
     psa_ctx.write_reg<uint32_t> (ch*psa_regs::ch_offset + psa_regs::g_baseline, val[0] & 0xF  ); 
     psa_ctx.write_reg<uint32_t> (ch*psa_regs::ch_offset + psa_regs::g_fixed   , val[1] & 0xF  ); 
     psa_ctx.write_reg<uint32_t> (ch*psa_regs::ch_offset + psa_regs::g_short   , val[2] & 0x3F ); 
     psa_ctx.write_reg<uint32_t> (ch*psa_regs::ch_offset + psa_regs::g_short_d , val[3] & 0xFF ); 
     psa_ctx.write_reg<uint32_t> (ch*psa_regs::ch_offset + psa_regs::g_long    , val[4] & 0x1FF); 
  }

  void set_debug_one(bool isEnabled)
  {
    if (isEnabled)
       psa_ctx.set_bit<psa_regs::ctrl, 10>();
    else
       psa_ctx.clear_bit<psa_regs::ctrl, 10>();
  }
  bool get_debug_one() 
  {
    bool ret = psa_ctx.get_bit<psa_regs::ctrl, 10>() ;
    return ret;
  }
  uint32_t get_channel_active() 
  {
    uint32_t ret = psa_ctx.read<psa_regs::ctrl>() & 0xFF;
    return ret;
  }
  void set_channel_active(uint8_t ch, bool isActive) 
  {
    if (isActive)
    {
      psa_ctx.set_bit_reg(psa_regs::ctrl, ch);
    }
    else
    {
      psa_ctx.clear_bit_reg(psa_regs::ctrl, ch);
    }
  }
  
  void set_list_mode(bool isEnabled)
  {
    if (isEnabled)
       psa_ctx.set_bit<psa_regs::ctrl, 8>();
    else
       psa_ctx.clear_bit<psa_regs::ctrl, 8>();
  }
  bool get_list_mode()
  {
    bool ret = psa_ctx.get_bit<psa_regs::ctrl, 8>() ;
    return ret;
  }
  void set_tx_debug(bool isEnabled)
  {
    if (isEnabled)
       psa_ctx.set_bit<psa_regs::ctrl, 9>();
    else
       psa_ctx.clear_bit<psa_regs::ctrl, 9>();
  }
  bool get_tx_debug()
  {
    bool ret = psa_ctx.get_bit<psa_regs::ctrl, 9>() ;
    return ret;
  }

 private:
  Context& ctx;
  Memory<mem::control>& ctl;
  Memory<mem::status>& sts;
  Memory<mem::psa_module>& psa_ctx;
  Memory<mem::psa0_limits>& psa_bram0;
  Memory<mem::psa1_limits>& psa_bram1;
  Memory<mem::psa2_limits>& psa_bram2;
  Memory<mem::psa3_limits>& psa_bram3;
  Memory<mem::psa4_limits>& psa_bram4;
};

#endif  // __DRIVERS_ADC_DAC_DMA_HPP__
