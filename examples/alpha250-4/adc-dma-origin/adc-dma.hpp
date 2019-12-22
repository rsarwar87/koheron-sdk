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

// System Level Control Registers
// https://www.xilinx.com/support/documentation/user_guides/ug585-Zynq-7000-TRM.pdf
namespace Sclr_regs {
    constexpr uint32_t sclr_unlock = 0x8;       // SLCR Write Protection Unlock
    constexpr uint32_t fpga0_clk_ctrl = 0x170;  // PL Clock 0 Output control
    constexpr uint32_t fpga1_clk_ctrl = 0x180;  // PL Clock 1 Output control
    constexpr uint32_t ocm_rst_ctrl = 0x238;    // OCM Software Reset Control
    constexpr uint32_t fpga_rst_ctrl = 0x240;   // FPGA Software Reset Control
    constexpr uint32_t ocm_cfg = 0x910;         // FPGA Software Reset Control
}

constexpr uint32_t n_pts = 64 * 1024; // Number of words in one descriptor
constexpr uint32_t n_desc = 64; // Number of descriptors

class AdcDma
{
  public:
    AdcDma(Context& ctx_)
    : ctx(ctx_)
    , ctl(ctx.mm.get<mem::control>())
    , dma_0(ctx.mm.get<mem::dma0>())
    , dma_1(ctx.mm.get<mem::dma1>())
    , ram_s2mm_0(ctx.mm.get<mem::ram_s2mm0>())
    , ram_s2mm_1(ctx.mm.get<mem::ram_s2mm1>())
    , axi_hp0(ctx.mm.get<mem::axi_hp0>())
    , axi_hp2(ctx.mm.get<mem::axi_hp2>())
    , ocm_s2mm_1(ctx.mm.get<mem::ocm_s2mm1>())
    , ocm_s2mm_0(ctx.mm.get<mem::ocm_s2mm0>())
    , sclr(ctx.mm.get<mem::sclr>())
    {
        // Unlock SCLR
        sclr.write<Sclr_regs::sclr_unlock>(0xDF0D);
        sclr.clear_bit<Sclr_regs::fpga_rst_ctrl, 1>();

        // Make sure that the width of the AXI HP port is 64 bit.
        axi_hp0.clear_bit<0x0, 0>();
        axi_hp0.clear_bit<0x14, 0>();
        axi_hp2.clear_bit<0x0, 0>();
        axi_hp2.clear_bit<0x14, 0>();

        // Map the last 64 kB of OCM RAM to the high address space
        sclr.write<Sclr_regs::ocm_cfg>(0b1000);

        for (uint32_t i = 0; i < n_pts * n_desc; i++) {
            ram_s2mm_0.write_reg(4*i, 0);
        }
        log_hp0();
        log_hp2();

    }


    void set_descriptor_s2mm_1(uint32_t idx, uint32_t buffer_address, uint32_t buffer_length) {
        ocm_s2mm_1.write_reg(0x40 * idx + Sg_regs::nxtdesc, mem::ocm_s2mm1_addr + 0x40 * ((idx+1) % n_desc));
        ocm_s2mm_1.write_reg(0x40 * idx + Sg_regs::buffer_address, buffer_address);
        ocm_s2mm_1.write_reg(0x40 * idx + Sg_regs::control, buffer_length);
        ocm_s2mm_1.write_reg(0x40 * idx + Sg_regs::status, 0);
    }

    void set_descriptor_s2mm_0(uint32_t idx, uint32_t buffer_address, uint32_t buffer_length) {
        ocm_s2mm_0.write_reg(0x40 * idx + Sg_regs::nxtdesc, mem::ocm_s2mm0_addr + 0x40 * ((idx+1) % n_desc));
        ocm_s2mm_0.write_reg(0x40 * idx + Sg_regs::buffer_address, buffer_address);
        ocm_s2mm_0.write_reg(0x40 * idx + Sg_regs::control, buffer_length);
        ocm_s2mm_0.write_reg(0x40 * idx + Sg_regs::status, 0);
    }

    void start_dma_0() {
        for (uint32_t i = 0; i < n_pts * n_desc; i++) {
            ram_s2mm_0.write_reg(4*i, 0);
        }
        for (uint32_t i = 0; i < n_desc; i++) 
            set_descriptor_s2mm_0(i, mem::ram_s2mm0_addr + i * 4 * n_pts, 4 * n_pts);
        // Write address of the starting descriptor
        //dma_0.write<Dma_regs::mm2s_curdesc>(mem::ocm_mm2s_addr + 0x0);
        dma_0.write<Dma_regs::s2mm_curdesc>(mem::ocm_s2mm0_addr + 0x0);
        // Set DMA to cyclic mode
        //dma.set_bit<Dma_regs::s2mm_dmacr, 4>();
        // Start S2MM channel
        //dma_0.set_bit<Dma_regs::mm2s_dmacr, 0>();
        dma_0.set_bit<Dma_regs::s2mm_dmacr, 0>();
        // Write address of the tail descriptor
        //dma.write<Dma_regs::s2mm_taildesc>(0x50);
        //dma_0.write<Dma_regs::mm2s_taildesc>(mem::ocm_s2mm1_addr + (n_desc-1) * 0x40);
        dma_0.write<Dma_regs::s2mm_taildesc>(mem::ocm_s2mm0_addr + (n_desc-1) * 0x40);

        log_dma();
    }

    void stop_dma_0() {
        //dma_0.clear_bit<Dma_regs::mm2s_dmacr, 0>();
        dma_0.clear_bit<Dma_regs::s2mm_dmacr, 0>();
        //dma_0.write<Dma_regs::mm2s_taildesc>(mem::ocm_mm2s_addr + (n_desc-1) * 0x40);
        dma_0.write<Dma_regs::s2mm_taildesc>(mem::ocm_s2mm0_addr + (n_desc-1) * 0x40);
    }

    void start_dma_1() {
        for (uint32_t i = 0; i < n_pts * n_desc; i++) {
            ram_s2mm_1.write_reg(4*i, 0);
        }
        for (uint32_t i = 0; i < n_desc; i++) 
            set_descriptor_s2mm_1(i, mem::ram_s2mm1_addr + i * 4 * n_pts, 4 * n_pts);
        // Write address of the starting descriptor
        //dma_0.write<Dma_regs::mm2s_curdesc>(mem::ocm_mm2s_addr + 0x0);
        dma_1.write<Dma_regs::s2mm_curdesc>(mem::ocm_s2mm1_addr + 0x0);
        // Set DMA to cyclic mode
        //dma.set_bit<Dma_regs::s2mm_dmacr, 4>();
        // Start S2MM channel
        //dma_0.set_bit<Dma_regs::mm2s_dmacr, 0>();
        dma_1.set_bit<Dma_regs::s2mm_dmacr, 0>();
        // Write address of the tail descriptor
        //dma.write<Dma_regs::s2mm_taildesc>(0x50);
        //dma_0.write<Dma_regs::mm2s_taildesc>(mem::ocm_s2mm1_addr + (n_desc-1) * 0x40);
        dma_1.write<Dma_regs::s2mm_taildesc>(mem::ocm_s2mm1_addr + (n_desc-1) * 0x40);

        log_dma();
    }

    void stop_dma_1() {
        //dma_0.clear_bit<Dma_regs::mm2s_dmacr, 0>();
        dma_1.clear_bit<Dma_regs::s2mm_dmacr, 0>();
        //dma_0.write<Dma_regs::mm2s_taildesc>(mem::ocm_mm2s_addr + (n_desc-1) * 0x40);
        dma_1.write<Dma_regs::s2mm_taildesc>(mem::ocm_s2mm0_addr + (n_desc-1) * 0x40);
    }

    auto& get_adc1_data() {
        data = ram_s2mm_1.read_array<uint32_t, n_desc * n_pts>();
        return data;
    }

    auto& get_adc0_data() {
        data = ram_s2mm_0.read_array<uint32_t, n_desc * n_pts>();
        return data;
    }

  private:
    Context& ctx;
    Memory<mem::control>& ctl;
    Memory<mem::dma0>& dma_0;
    Memory<mem::dma1>& dma_1;
    Memory<mem::ram_s2mm0>& ram_s2mm_0;
    Memory<mem::ram_s2mm1>& ram_s2mm_1;
    Memory<mem::axi_hp0>& axi_hp0;
    Memory<mem::axi_hp2>& axi_hp2;
    Memory<mem::ocm_s2mm1>& ocm_s2mm_1;
    Memory<mem::ocm_s2mm0>& ocm_s2mm_0;
    Memory<mem::sclr>& sclr;

    std::array<uint32_t, n_desc * n_pts> data;

    void log_dma() {

        ctx.log<INFO>("S2MM_1 LOG \n");
        ctx.log<INFO>("DMAHalted = %d \n", dma_1.read_bit<Dma_regs::s2mm_dmasr, 0>());
        ctx.log<INFO>("DMAIdle = %d \n", dma_1.read_bit<Dma_regs::s2mm_dmasr, 1>());
        ctx.log<INFO>("DMASDInc = %d \n", dma_1.read_bit<Dma_regs::s2mm_dmasr, 3>());
        ctx.log<INFO>("DMAIntErr = %d \n", dma_1.read_bit<Dma_regs::s2mm_dmasr, 4>());
        ctx.log<INFO>("DMASlvErr = %d \n", dma_1.read_bit<Dma_regs::s2mm_dmasr, 5>());
        ctx.log<INFO>("DMADecErr = %d \n", dma_1.read_bit<Dma_regs::s2mm_dmasr, 6>());
        ctx.log<INFO>("SGIntErr = %d \n", dma_1.read_bit<Dma_regs::s2mm_dmasr, 8>());
        ctx.log<INFO>("SGSlvErr = %d \n", dma_1.read_bit<Dma_regs::s2mm_dmasr, 9>());
        ctx.log<INFO>("SGDecErr = %d \n", dma_1.read_bit<Dma_regs::s2mm_dmasr, 10>());
        ctx.log<INFO>("CURDESC = %u \n", (dma_1.read<Dma_regs::s2mm_curdesc>() - mem::ocm_s2mm1_addr)/0x40);
        ctx.log<INFO>("\n");

        ctx.log<INFO>("S2MM_0 LOG \n");
        ctx.log<INFO>("DMAHalted = %d \n", dma_0.read_bit<Dma_regs::s2mm_dmasr, 0>());
        ctx.log<INFO>("DMAIdle = %d \n", dma_0.read_bit<Dma_regs::s2mm_dmasr, 1>());
        ctx.log<INFO>("DMASDInc = %d \n", dma_0.read_bit<Dma_regs::s2mm_dmasr, 3>());
        ctx.log<INFO>("DMAIntErr = %d \n", dma_0.read_bit<Dma_regs::s2mm_dmasr, 4>());
        ctx.log<INFO>("DMASlvErr = %d \n", dma_0.read_bit<Dma_regs::s2mm_dmasr, 5>());
        ctx.log<INFO>("DMADecErr = %d \n", dma_0.read_bit<Dma_regs::s2mm_dmasr, 6>());
        ctx.log<INFO>("SGIntErr = %d \n", dma_0.read_bit<Dma_regs::s2mm_dmasr, 8>());
        ctx.log<INFO>("SGSlvErr = %d \n", dma_0.read_bit<Dma_regs::s2mm_dmasr, 9>());
        ctx.log<INFO>("SGDecErr = %d \n", dma_0.read_bit<Dma_regs::s2mm_dmasr, 10>());
        ctx.log<INFO>("CURDESC = %u \n", (dma_0.read<Dma_regs::s2mm_curdesc>() - mem::ocm_s2mm0_addr)/0x40);
        ctx.log<INFO>("\n");

        ctx.log<INFO>("S2MM_1_STATUS DMAIntErr = %d \n", ocm_s2mm_1.read_bit<Sg_regs::status, 28>());
        ctx.log<INFO>("S2MM_1_STATUS DMASlvErr = %d \n", ocm_s2mm_1.read_bit<Sg_regs::status, 29>());
        ctx.log<INFO>("S2MM_1_STATUS DMADecErr = %d \n", ocm_s2mm_1.read_bit<Sg_regs::status, 30>());
        ctx.log<INFO>("S2MM_1_STATUS Cmplt = %d \n", ocm_s2mm_1.read_bit<Sg_regs::status, 31>());
        ctx.log<INFO>("\n");
        ctx.log<INFO>("S2MM_0_STATUS DMAIntErr = %d \n", ocm_s2mm_0.read_bit<Sg_regs::status, 28>());
        ctx.log<INFO>("S2MM_0_STATUS DMASlvErr = %d \n", ocm_s2mm_0.read_bit<Sg_regs::status, 29>());
        ctx.log<INFO>("S2MM_0_STATUS DMADecErr = %d \n", ocm_s2mm_0.read_bit<Sg_regs::status, 30>());
        ctx.log<INFO>("S2MM_0_STATUS Cmplt = %d \n", ocm_s2mm_0.read_bit<Sg_regs::status, 31>());
        ctx.log<INFO>("\n");
    }

    void log_hp2() {
        ctx.log<INFO>("AXI_HP2 LOG \n");
        ctx.log<INFO>("AFI_WRCHAN_CTRL = %x \n", axi_hp2.read<0x14>());
        ctx.log<INFO>("AFI_WRCHAN_ISSUINGCAP = %x \n", axi_hp2.read<0x18>());
        ctx.log<INFO>("AFI_WRQOS = %x \n", axi_hp2.read<0x1C>());
        ctx.log<INFO>("AFI_WRDATAFIFO_LEVEL = %x \n", axi_hp2.read<0x20>());
        ctx.log<INFO>("AFI_WRDEBUG = %x \n", axi_hp2.read<0x24>());
        ctx.log<INFO>("\n");
    }
    void log_hp0() {
        ctx.log<INFO>("AXI_HP0 LOG \n");
        ctx.log<INFO>("AFI_WRCHAN_CTRL = %x \n", axi_hp0.read<0x14>());
        ctx.log<INFO>("AFI_WRCHAN_ISSUINGCAP = %x \n", axi_hp0.read<0x18>());
        ctx.log<INFO>("AFI_WRQOS = %x \n", axi_hp0.read<0x1C>());
        ctx.log<INFO>("AFI_WRDATAFIFO_LEVEL = %x \n", axi_hp0.read<0x20>());
        ctx.log<INFO>("AFI_WRDEBUG = %x \n", axi_hp0.read<0x24>());
        ctx.log<INFO>("\n");
    }

} ;

#endif // __DRIVERS_ADC_DAC_DMA_HPP__
