/// DMA driver
///
/// (c) Koheron

#ifndef __DRIVERS_ADC_DAC_DMA_HPP__
#define __DRIVERS_ADC_DAC_DMA_HPP__

#include <context.hpp>

// AXI DMA Registers
// https://www.xilinx.com/support/documentation/ip_documentation/axi_dma/v7_1/pg021_axi_dma.pdf
namespace Dma_regs {
    constexpr uint32_t mm2s_dmacr = 0x0;     // MM2S DMA Control register
    constexpr uint32_t mm2s_dmasr = 0x4;     // MM2S DMA Status register
    constexpr uint32_t mm2s_curdesc = 0x8;   // MM2S DMA Current Descriptor Pointer register
    constexpr uint32_t mm2s_taildesc = 0x10; // MM2S DMA Tail Descriptor Pointer register

    constexpr uint32_t s2mm_dmacr = 0x30;    // S2MM DMA Control register
    constexpr uint32_t s2mm_dmasr = 0x34;    // S2MM DMA Status register
    constexpr uint32_t s2mm_curdesc = 0x38;  // S2MM DMA Current Descriptor Pointer register
    constexpr uint32_t s2mm_taildesc = 0x40; // S2MM DMA Tail Descriptor Pointer register
}

// Scatter Gather Descriptor
namespace Sg_regs {
    constexpr uint32_t nxtdesc = 0x0;        // Next Descriptor Pointer
    constexpr uint32_t buffer_address = 0x8; // Buffer address
    constexpr uint32_t control = 0x18;       // Control
    constexpr uint32_t status = 0x1C;        // Status
}

namespace axi_regs {
    constexpr uint32_t rdctrl  = 0x00000000;     //  0x000003B0  Read Channel Control Register
    constexpr uint32_t rdissue = 0x00000004;     //  0x00000007  Read Issuing Capability Register
    constexpr uint32_t rdqOs   = 0x00000008;     //  0x00000007  QoS Read Channel Register
    constexpr uint32_t rddebug = 0x00000010;     //  0x40000000  Read Channel Debug Register
    constexpr uint32_t wrctrl  = 0x00000014;     //  0x000003B0  Write Channel Control Register
    constexpr uint32_t wrissue = 0x00000018;     //  0x00000007  Write Issuing Capability Register
    constexpr uint32_t wrqOs   = 0x0000001C;     //  0x00000007  QoS Write Channel Register
    constexpr uint32_t i_sts   = 0x00000E00;     //  0x00000000  Interrupt Status Register
    constexpr uint32_t i_en    = 0x00000E04;     //  0x00000000  Interrupt Enable
    constexpr uint32_t i_dis   = 0x00000E08;     //  0x00000000  Interrupt Disable
    constexpr uint32_t i_mask  = 0x00000E0C;     //  0x00000001  Interrupt Mask
    constexpr uint32_t control = 0x00000F04;     //  0x00000000  General Control Register
    constexpr uint32_t safety_chk = 0x00000F0C;  //  0x00000000  Safety endpoint connectivity check Register
}

constexpr uint32_t n_bits = 64; // Number of words in one descriptor
constexpr uint32_t n_pts = n_bits * 1024; // Number of words in one descriptor
constexpr uint32_t n_desc = 16 * 1024 * 1024 / (n_pts * 4) ; // Number of descriptors

class AdcDacDma
{
  public:
    AdcDacDma(Context& ctx_)
    : ctx(ctx_)
    , ctl(ctx.mm.get<mem::control>())
    , dma(ctx.mm.get<mem::dma>())
    , ram_s2mm(ctx.mm.get<mem::ram_s2mm>())
    , ram_mm2s(ctx.mm.get<mem::ram_mm2s>())
    , ocm_mm2s(ctx.mm.get<mem::ocm_mm2s>())
    , ocm_s2mm(ctx.mm.get<mem::ocm_s2mm>())
    , axi_hmp(ctx.mm.get<mem::axi_m_hpm_fpd>())
    , axi_slpd(ctx.mm.get<mem::axi_s_lpd>())
    , axi_hp0(ctx.mm.get<mem::axi_s_hp0>())
    , axi_hp1(ctx.mm.get<mem::axi_s_hp1>())
    , ocm_backup(ctx.mm.get<mem::ocm_backup>())
    {
        for (uint32_t i = 0; i < n_pts * n_desc; i++) {
            ram_s2mm.write_reg(4*i, 0);
        }

        if (ocm_backup.read<0>() != 0x123456) 
        {
          ctx.log<INFO>("swaping memory LOG \n");
          std::array<uint32_t, 64*1024/4> tmp = ocm_mm2s.read_array<uint32_t, 64*1024/4>();
          for (uint32_t i = 0; i < 64*1024/4; i++) {
            ocm_mm2s.write_reg(4*i+0x4, 0);
            ocm_backup.write_reg(4*i+0x4, tmp[i]);
          }
          ocm_backup.write<0>(0x123456);
        }

    }
    void restore_ocma() {
        if (ocm_backup.read<0>() != 0x123456) return; 
        std::array<uint32_t, 64*1024/4 + 1> tmp = ocm_backup.read_array<uint32_t, 64*1024/4 + 1>();
        for (uint32_t i = 0; i < 64*1024/4; i++) {
            ocm_mm2s.write_reg(4*i, tmp[i+1]);
        }
    }

    void set_dac_data(const std::vector<uint32_t>& dac_data) {
        for (uint32_t i = 0; i < dac_data.size(); i++) {
            ram_mm2s.write_reg(4*i, dac_data[i]);
        }
    }

    void set_descriptor_mm2s(uint32_t idx, uint32_t buffer_address, uint32_t buffer_length) {
        ocm_mm2s.write_reg(0x40 * idx + Sg_regs::nxtdesc, mem::ocm_mm2s_addr + 0x40 * ((idx+1) % n_desc));
        ocm_mm2s.write_reg(0x40 * idx + Sg_regs::buffer_address, buffer_address);
        ocm_mm2s.write_reg(0x40 * idx + Sg_regs::control, buffer_length);
        ocm_mm2s.write_reg(0x40 * idx + Sg_regs::status, 0);
    }

    void set_descriptor_s2mm(uint32_t idx, uint32_t buffer_address, uint32_t buffer_length) {
        ocm_s2mm.write_reg(0x40 * idx + Sg_regs::nxtdesc, mem::ocm_s2mm_addr + 0x40 * ((idx+1) % n_desc));
        ocm_s2mm.write_reg(0x40 * idx + Sg_regs::buffer_address, buffer_address);
        ocm_s2mm.write_reg(0x40 * idx + Sg_regs::control, buffer_length);
        ocm_s2mm.write_reg(0x40 * idx + Sg_regs::status, 0);
    }

    void set_descriptors() {
        for (uint32_t i = 0; i < n_desc; i++) {
            set_descriptor_mm2s(i, mem::ram_mm2s_addr + i * 4 * n_pts, 4 * n_pts);
            set_descriptor_s2mm(i, mem::ram_s2mm_addr + i * 4 * n_pts, 4 * n_pts);
        }
    }

    void start_dma() {
        set_descriptors();
        // Write address of the starting descriptor
        dma.write<Dma_regs::mm2s_curdesc>(mem::ocm_mm2s_addr + 0x0);
        dma.write<Dma_regs::s2mm_curdesc>(mem::ocm_s2mm_addr + 0x0);
        // Set DMA to cyclic mode
        //dma.set_bit<Dma_regs::s2mm_dmacr, 4>();
        // Start S2MM channel
        dma.set_bit<Dma_regs::mm2s_dmacr, 0>();
        dma.set_bit<Dma_regs::s2mm_dmacr, 0>();
        // Write address of the tail descriptor
        //dma.write<Dma_regs::s2mm_taildesc>(0x50);
        dma.write<Dma_regs::mm2s_taildesc>(mem::ocm_mm2s_addr + (n_desc-1) * 0x40);
        dma.write<Dma_regs::s2mm_taildesc>(mem::ocm_s2mm_addr + (n_desc-1) * 0x40);

        //log_dma();
        //log_hp0();
    }

    void stop_dma() {
        dma.clear_bit<Dma_regs::mm2s_dmacr, 0>();
        dma.clear_bit<Dma_regs::s2mm_dmacr, 0>();
        dma.write<Dma_regs::mm2s_taildesc>(mem::ocm_mm2s_addr + (n_desc-1) * 0x40);
        dma.write<Dma_regs::s2mm_taildesc>(mem::ocm_s2mm_addr + (n_desc-1) * 0x40);
    }

    auto& get_adc_data() {
      log_dma();
      ctx.log<INFO>("%s \n", __func__);
        data = ram_s2mm.read_array<uint32_t, n_desc * n_pts>();
        return data;
    }

    void set_axi_widths() {
      ctx.log<INFO>("%s \n", __func__);
      if (n_bits == 128)
      {
        axi_hp0.clear_bit <axi_regs::wrctrl, 0>();
        axi_hp0.clear_bit <axi_regs::wrctrl, 1>();
        axi_hp1.clear_bit <axi_regs::wrctrl, 0>();
        axi_hp1.clear_bit <axi_regs::wrctrl, 1>();
        axi_slpd.clear_bit<axi_regs::wrctrl, 0>();
        axi_slpd.clear_bit<axi_regs::wrctrl, 1>();
      }
      else if (n_bits == 64) 
      {
        axi_hp0.set_bit    <axi_regs::wrctrl, 0>();
        axi_hp0.clear_bit  <axi_regs::wrctrl, 1>();
        axi_hp1.set_bit    <axi_regs::wrctrl, 0>();
        axi_hp1.clear_bit  <axi_regs::wrctrl, 1>();
        axi_slpd.set_bit   <axi_regs::wrctrl, 0>();
        axi_slpd.clear_bit <axi_regs::wrctrl, 1>();
      }
      else if (n_bits == 32){
        axi_hp0.set_bit   <axi_regs::wrctrl, 1>();
        axi_hp0.clear_bit <axi_regs::wrctrl, 0>();
        axi_hp1.set_bit   <axi_regs::wrctrl, 1>();
        axi_hp1.clear_bit <axi_regs::wrctrl, 0>();
        axi_slpd.set_bit  <axi_regs::wrctrl, 1>();
        axi_slpd.clear_bit<axi_regs::wrctrl, 0>();
      }
        log_axi_widths();
      ctx.log<INFO>("%s \n", __func__);
    }
    void log_axi_widths() {
      ctx.log<INFO>("%s \n", __func__);
        ctx.log<INFO>("AXI_S_HP0 LOG \n");
        ctx.log<INFO>("WRCHAN_WIDTH = %x \n"     , axi_hp0.read<axi_regs::wrctrl>() & 0x3);
        ctx.log<INFO>("WRCHAN_ISSUINGCAP = %x \n", axi_hp0.read<axi_regs::wrissue>());
        ctx.log<INFO>("WRQOS = %x \n"            , axi_hp0.read<axi_regs::wrqOs>());
        ctx.log<INFO>("RDCHAN_WIDTH = %x \n"     , axi_hp0.read<axi_regs::rdctrl>() & 0x3);
        ctx.log<INFO>("RDCHAN_ISSUINGCAP = %x \n", axi_hp0.read<axi_regs::rdissue>());
        ctx.log<INFO>("RDQOS = %x \n"            , axi_hp0.read<axi_regs::rdqOs>());
        ctx.log<INFO>("\n");
        ctx.log<INFO>("AXI_S_HP1 LOG \n");
        ctx.log<INFO>("WRCHAN_WIDTH = %x \n"     , axi_hp1.read<axi_regs::wrctrl>() & 0x3);
        ctx.log<INFO>("WRCHAN_ISSUINGCAP = %x \n", axi_hp1.read<axi_regs::wrissue>());
        ctx.log<INFO>("WRQOS = %x \n"            , axi_hp1.read<axi_regs::wrqOs>());
        ctx.log<INFO>("RDCHAN_WIDTH = %x \n"     , axi_hp1.read<axi_regs::rdctrl>() & 0x3);
        ctx.log<INFO>("RDCHAN_ISSUINGCAP = %x \n", axi_hp1.read<axi_regs::rdissue>());
        ctx.log<INFO>("RDQOS = %x \n"            , axi_hp1.read<axi_regs::rdqOs>());
        ctx.log<INFO>("\n");
        ctx.log<INFO>("AXI_S_LPD LOG \n");
        ctx.log<INFO>("WRCHAN_WIDTH = %x \n"     , axi_slpd.read<axi_regs::wrctrl>() & 0x3);
        ctx.log<INFO>("WRCHAN_ISSUINGCAP = %x \n", axi_slpd.read<axi_regs::wrissue>());
        ctx.log<INFO>("WRQOS = %x \n"            , axi_slpd.read<axi_regs::wrqOs>());
        ctx.log<INFO>("RDCHAN_WIDTH = %x \n"     , axi_slpd.read<axi_regs::rdctrl>() & 0x3);
        ctx.log<INFO>("RDCHAN_ISSUINGCAP = %x \n", axi_slpd.read<axi_regs::rdissue>());
        ctx.log<INFO>("RDQOS = %x \n"            , axi_slpd.read<axi_regs::rdqOs>());
        ctx.log<INFO>("\n");
        ctx.log<INFO>("AXI_M_HPM LOG \n");
        ctx.log<INFO>("WRCHAN_WIDTH = %x \n"     , axi_hmp.read<axi_regs::wrctrl>() & 0x3);
        ctx.log<INFO>("WRCHAN_ISSUINGCAP = %x \n", axi_hmp.read<axi_regs::wrissue>());
        ctx.log<INFO>("WRQOS = %x \n"            , axi_hmp.read<axi_regs::wrqOs>());
        ctx.log<INFO>("RDCHAN_WIDTH = %x \n"     , axi_hmp.read<axi_regs::rdctrl>() & 0x3);
        ctx.log<INFO>("RDCHAN_ISSUINGCAP = %x \n", axi_hmp.read<axi_regs::rdissue>());
        ctx.log<INFO>("RDQOS = %x \n"            , axi_hmp.read<axi_regs::rdqOs>());
        ctx.log<INFO>("\n");
    }
  private:
    Context& ctx;
    Memory<mem::control>& ctl;
    Memory<mem::dma>& dma;
    Memory<mem::ram_s2mm>& ram_s2mm;
    Memory<mem::ram_mm2s>& ram_mm2s;
    Memory<mem::ocm_mm2s>& ocm_mm2s;
    Memory<mem::ocm_s2mm>& ocm_s2mm;
    Memory<mem::axi_m_hpm_fpd>& axi_hmp;
    Memory<mem::axi_s_lpd>& axi_slpd;
    Memory<mem::axi_s_hp0>&  axi_hp0;
    Memory<mem::axi_s_hp1>& axi_hp1;
    Memory<mem::ocm_backup>& ocm_backup;

    std::array<uint32_t, n_desc * n_pts> data;

    void log_dma() {

        ctx.log<INFO>("MM2S LOG \n");
        ctx.log<INFO>("DMAIntErr = %d \n", dma.read_bit<Dma_regs::mm2s_dmasr, 4>());
        ctx.log<INFO>("DMASlvErr = %d \n", dma.read_bit<Dma_regs::mm2s_dmasr, 5>());
        ctx.log<INFO>("DMADecErr = %d \n", dma.read_bit<Dma_regs::mm2s_dmasr, 6>());
        ctx.log<INFO>("SGIntErr = %d \n", dma.read_bit<Dma_regs::mm2s_dmasr, 8>());
        ctx.log<INFO>("SGSlvErr = %d \n", dma.read_bit<Dma_regs::mm2s_dmasr, 9>());
        ctx.log<INFO>("SGDecErr = %d \n", dma.read_bit<Dma_regs::mm2s_dmasr, 10>());
        ctx.log<INFO>("CURDESC = 0x%08x (%u) \n", 
              dma.read<Dma_regs::mm2s_curdesc>(), (
              dma.read<Dma_regs::mm2s_curdesc>() - 
              mem::ocm_mm2s_addr)/0x40);
        ctx.log<INFO>("\n");

        ctx.log<INFO>("S2MM LOG \n");
        ctx.log<INFO>("DMAIntErr = %d \n", dma.read_bit<Dma_regs::s2mm_dmasr, 4>());
        ctx.log<INFO>("DMASlvErr = %d \n", dma.read_bit<Dma_regs::s2mm_dmasr, 5>());
        ctx.log<INFO>("DMADecErr = %d \n", dma.read_bit<Dma_regs::s2mm_dmasr, 6>());
        ctx.log<INFO>("SGIntErr = %d \n", dma.read_bit<Dma_regs::s2mm_dmasr, 8>());
        ctx.log<INFO>("SGSlvErr = %d \n", dma.read_bit<Dma_regs::s2mm_dmasr, 9>());
        ctx.log<INFO>("SGDecErr = %d \n", dma.read_bit<Dma_regs::s2mm_dmasr, 10>());
        ctx.log<INFO>("CURDESC = 0x%08x (%u) \n", dma.read<Dma_regs::s2mm_curdesc>(), (
              dma.read<Dma_regs::s2mm_curdesc>() 
                - mem::ocm_s2mm_addr)/0x40);
        ctx.log<INFO>("\n");

        if (dma.read_bit<Dma_regs::s2mm_dmasr, 6>())
        {
          uint32_t id = (dma.read<Dma_regs::s2mm_curdesc>() - mem::ocm_s2mm_addr)/0x40;
          ctx.log<INFO>("S2MM Descriptor (%u) LOG \n", id);
          ctx.log<INFO>("S2MM Next Address: x0%08x \n", ocm_s2mm.read_reg(0x40 * id + Sg_regs::nxtdesc));
          ctx.log<INFO>("S2MM buffer Address: x0%08x \n", ocm_s2mm.read_reg(0x40 * id + Sg_regs::buffer_address));
        }

        ctx.log<INFO>("S2MM_STATUS DMAIntErr = %d \n", ocm_s2mm.read_bit<Sg_regs::status, 28>());
        ctx.log<INFO>("S2MM_STATUS DMASlvErr = %d \n", ocm_s2mm.read_bit<Sg_regs::status, 29>());
        ctx.log<INFO>("S2MM_STATUS DMADecErr = %d \n", ocm_s2mm.read_bit<Sg_regs::status, 30>());
        ctx.log<INFO>("S2MM_STATUS Cmplt = %d \n", ocm_s2mm.read_bit<Sg_regs::status, 31>());

        ctx.log<INFO>("MM2S_STATUS DMAIntErr = %d \n", ocm_mm2s.read_bit<Sg_regs::status, 28>());
        ctx.log<INFO>("MM2S_STATUS DMASlvErr = %d \n", ocm_mm2s.read_bit<Sg_regs::status, 29>());
        ctx.log<INFO>("MM2S_STATUS DMADecErr = %d \n", ocm_mm2s.read_bit<Sg_regs::status, 30>());
        ctx.log<INFO>("MM2S_STATUS Cmplt = %d \n"    , ocm_mm2s.read_bit<Sg_regs::status, 31>());
        ctx.log<INFO>("\n");
    }


} ;

#endif // __DRIVERS_ADC_DAC_DMA_HPP__
