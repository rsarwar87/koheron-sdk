

create_clock -period 8.138 -name pl_clk [get_ports pl_clk_p]

#Overwritting MMCM output constraints to meet highest DAC Fs
create_clock -period 1.600 -name RFDAC0_CLK [get_pins -hier tx0_u_dac/INTERNAL_FBRC_MUX*]
create_clock -period 1.600 -name RFDAC1_CLK [get_pins -hier tx1_u_dac/INTERNAL_FBRC_MUX*]
create_clock -period 1.600 -name RFDAC2_CLK [get_pins -hier tx2_u_dac/INTERNAL_FBRC_MUX*]
create_clock -period 1.600 -name RFDAC3_CLK [get_pins -hier tx3_u_dac/INTERNAL_FBRC_MUX*]

create_generated_clock -name DAC0_clkin1 -source [get_pins rfip_ex_i/clocking_block/clk_wiz_dac0/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKIN1] -divide_by 1 [get_pins rfip_ex_i/clocking_block/clk_wiz_dac0/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKOUT0]
create_generated_clock -name DAC1_clkin1 -source [get_pins rfip_ex_i/clocking_block/clk_wiz_dac1/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKIN1] -divide_by 1 [get_pins rfip_ex_i/clocking_block/clk_wiz_dac1/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKOUT0]
create_generated_clock -name DAC2_clkin1 -source [get_pins rfip_ex_i/clocking_block/clk_wiz_dac2/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKIN1] -divide_by 1 [get_pins rfip_ex_i/clocking_block/clk_wiz_dac2/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKOUT0]
create_generated_clock -name DAC3_clkin1 -source [get_pins rfip_ex_i/clocking_block/clk_wiz_dac3/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKIN1] -divide_by 1 [get_pins rfip_ex_i/clocking_block/clk_wiz_dac3/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKOUT0]

create_generated_clock -name DAC0_clkin2 -source [get_pins rfip_ex_i/clocking_block/clk_wiz_dac0/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKIN2] -divide_by 1 -add -master_clock [get_clocks pl_clk] [get_pins rfip_ex_i/clocking_block/clk_wiz_dac0/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKOUT0]
create_generated_clock -name DAC1_clkin2 -source [get_pins rfip_ex_i/clocking_block/clk_wiz_dac1/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKIN2] -divide_by 1 -add -master_clock [get_clocks pl_clk] [get_pins rfip_ex_i/clocking_block/clk_wiz_dac1/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKOUT0]
create_generated_clock -name DAC2_clkin2 -source [get_pins rfip_ex_i/clocking_block/clk_wiz_dac2/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKIN2] -divide_by 1 -add -master_clock [get_clocks pl_clk] [get_pins rfip_ex_i/clocking_block/clk_wiz_dac2/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKOUT0]
create_generated_clock -name DAC3_clkin2 -source [get_pins rfip_ex_i/clocking_block/clk_wiz_dac3/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKIN2] -divide_by 1 -add -master_clock [get_clocks pl_clk] [get_pins rfip_ex_i/clocking_block/clk_wiz_dac3/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKOUT0]

create_clock -period 3.200 -name RFADC0_CLK [get_pins -hier rx0_u_adc/INTERNAL_FBRC_DIV1_MUX*]
create_clock -period 3.200 -name RFADC1_CLK [get_pins -hier rx1_u_adc/INTERNAL_FBRC_DIV1_MUX*]
create_clock -period 3.200 -name RFADC2_CLK [get_pins -hier rx2_u_adc/INTERNAL_FBRC_DIV1_MUX*]
create_clock -period 3.200 -name RFADC3_CLK [get_pins -hier rx3_u_adc/INTERNAL_FBRC_DIV1_MUX*]

create_generated_clock -name ADC0_clkin1 -source [get_pins rfip_ex_i/clocking_block/clk_wiz_adc0/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKIN1] -divide_by 3 -multiply_by 4 [get_pins rfip_ex_i/clocking_block/clk_wiz_adc0/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKOUT0]
create_generated_clock -name ADC0_clkin2 -source [get_pins rfip_ex_i/clocking_block/clk_wiz_adc0/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKIN2] -divide_by 1 -add -master_clock [get_clocks pl_clk] [get_pins rfip_ex_i/clocking_block/clk_wiz_adc0/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKOUT0]

#DAC BUFG
#set_property LOC BUFGCE_X0Y78  [get_cells rfip_ex_i/clocking_block/clk_wiz_dac0/inst/CLK_CORE_DRP_I/clk_inst/clkf_buf]
#set_property LOC BUFGCE_X0Y80  [get_cells rfip_ex_i/clocking_block/clk_wiz_dac0/inst/CLK_CORE_DRP_I/clk_inst/clkout1_buf]
#set_property LOC BUFGCE_X0Y108 [get_cells rfip_ex_i/clocking_block/clk_wiz_dac1/inst/CLK_CORE_DRP_I/clk_inst/clkf_buf]
#set_property LOC BUFGCE_X0Y114 [get_cells rfip_ex_i/clocking_block/clk_wiz_dac1/inst/CLK_CORE_DRP_I/clk_inst/clkout1_buf]
#set_property LOC BUFGCE_X0Y144 [get_cells rfip_ex_i/clocking_block/clk_wiz_dac2/inst/CLK_CORE_DRP_I/clk_inst/clkf_buf]
#set_property LOC BUFGCE_X0Y149 [get_cells rfip_ex_i/clocking_block/clk_wiz_dac2/inst/CLK_CORE_DRP_I/clk_inst/clkout1_buf]
#set_property LOC BUFGCE_X0Y189 [get_cells rfip_ex_i/clocking_block/clk_wiz_dac3/inst/CLK_CORE_DRP_I/clk_inst/clkf_buf]
#set_property LOC BUFGCE_X0Y181 [get_cells rfip_ex_i/clocking_block/clk_wiz_dac3/inst/CLK_CORE_DRP_I/clk_inst/clkout1_buf]

#set_property LOC BUFGCE_X0Y6 [get_cells rfip_ex_i/clocking_block/bufg_adc_fb/U0/USE_BUFG.GEN_BUFG[0].BUFG_U]

set_property LOC MMCM_X0Y4 [get_cells rfip_ex_i/clocking_block/clk_wiz_dac0/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst]
set_property LOC MMCM_X0Y3 [get_cells rfip_ex_i/clocking_block/clk_wiz_dac1/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst]
set_property LOC MMCM_X0Y6 [get_cells rfip_ex_i/clocking_block/clk_wiz_dac2/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst]
set_property LOC MMCM_X0Y7 [get_cells rfip_ex_i/clocking_block/clk_wiz_dac3/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst]

set_property LOC MMCM_X0Y1 [get_cells rfip_ex_i/clocking_block/clk_wiz_adc0/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst]
#set_property LOC PLL_X0Y2  [get_cells rfip_ex_i/clocking_block/clk_wiz_adc1/inst/CLK_CORE_DRP_I/clk_inst/plle4_adv_inst]
#set_property LOC PLL_X0Y3  [get_cells rfip_ex_i/ADC_DDR_DMA/ddr4_adc/inst/u_ddr4_mem_intfc/u_mig_ddr4_phy/inst/u_ddr4_phy_pll/plle_loop[0].gen_plle4.PLLE4_BASE_INST_OTHER]
#set_property LOC PLL_X0Y4  [get_cells rfip_ex_i/clocking_block/clk_wiz_adc2/inst/CLK_CORE_DRP_I/clk_inst/plle4_adv_inst]
#set_property LOC PLL_X0Y5  [get_cells rfip_ex_i/ADC_DDR_DMA/ddr4_adc/inst/u_ddr4_mem_intfc/u_mig_ddr4_phy/inst/u_ddr4_phy_pll/plle_loop[1].gen_plle4.PLLE4_BASE_INST_OTHER]
#set_property LOC PLL_X0Y6  [get_cells rfip_ex_i/clocking_block/clk_wiz_adc3/inst/CLK_CORE_DRP_I/clk_inst/plle4_adv_inst]
#set_property LOC PLL_X0Y9  [get_cells rfip_ex_i/DAC_DDR_DMA/ddr4_0/inst/u_ddr4_mem_intfc/u_mig_ddr4_phy/inst/u_ddr4_phy_pll/plle_loop[0].gen_plle4.PLLE4_BASE_INST_OTHER]
#set_property LOC PLL_X0Y11 [get_cells rfip_ex_i/DAC_DDR_DMA/ddr4_0/inst/u_ddr4_mem_intfc/u_mig_ddr4_phy/inst/u_ddr4_phy_pll/plle_loop[1].gen_plle4.PLLE4_BASE_INST_OTHER]

#set_property LOC BUFGCE_X0Y146 [get_cells dbg_hub/inst/BSCANID.u_xsdbm_id/SWITCH_N_EXT_BSCAN.u_bufg_icon_tck]
#ddr bufg
#set_property LOC BUFGCE_X0Y142 [get_cells rfip_ex_i/DAC_DDR_DMA/ddr4_0/inst/u_ddr4_infrastructure/u_bufg_divClk]
#set_property LOC BUFGCE_X0Y126 [get_cells rfip_ex_i/DAC_DDR_DMA/ddr4_0/inst/u_ddr4_infrastructure/u_bufg_inst]
#set_property LOC BUFGCE_X0Y134 [get_cells rfip_ex_i/DAC_DDR_DMA/ddr4_0/inst/u_ddr4_infrastructure/u_bufg_riuClk]
#set_property LOC BUFGCE_X0Y55  [get_cells rfip_ex_i/ADC_DDR_DMA/ddr4_adc/inst/u_ddr4_infrastructure/u_bufg_dbg_clk]
#set_property LOC BUFGCE_X0Y66  [get_cells rfip_ex_i/ADC_DDR_DMA/ddr4_adc/inst/u_ddr4_infrastructure/u_bufg_divClk]
#set_property LOC BUFGCE_X0Y68  [get_cells rfip_ex_i/ADC_DDR_DMA/ddr4_adc/inst/u_ddr4_infrastructure/u_bufg_inst]
#set_property LOC BUFGCE_X0Y67  [get_cells rfip_ex_i/ADC_DDR_DMA/ddr4_adc/inst/u_ddr4_infrastructure/u_bufg_riuClk]

#set_property LOC BUFG_GT_X1Y9  [get_cells rfip_ex_i/ex_design/rfip/inst/i_rfdc_ex_rfip_0_bufg_gt_ctrl/adc0_bufg_gt]
#set_property LOC BUFG_GT_X1Y47 [get_cells rfip_ex_i/ex_design/rfip/inst/i_rfdc_ex_rfip_0_bufg_gt_ctrl/adc1_bufg_gt]
#set_property LOC BUFG_GT_X1Y51 [get_cells rfip_ex_i/ex_design/rfip/inst/i_rfdc_ex_rfip_0_bufg_gt_ctrl/adc2_bufg_gt]
#set_property LOC BUFG_GT_X1Y95 [get_cells rfip_ex_i/ex_design/rfip/inst/i_rfdc_ex_rfip_0_bufg_gt_ctrl/adc3_bufg_gt]
#set_property LOC BUFGCE_X0Y66  [get_cells rfip_ex_i/ADC_DDR_DMA/ddr4_adc/inst/u_ddr4_infrastructure/u_bufg_divClk]
#set_property LOC BUFGCTRL_X0Y48  [get_cells rfip_ex_i/clocking_block/bufgmux_adc0/inst/BUFGMUX_inst]
#set_property LOC BUFGCTRL_X0Y9   [get_cells rfip_ex_i/clocking_block/bufgmux_adc1/inst/BUFGMUX_inst]
#set_property LOC BUFGCTRL_X0Y23  [get_cells rfip_ex_i/clocking_block/bufgmux_adc2/inst/BUFGMUX_inst]
#set_property LOC BUFGCTRL_X0Y25  [get_cells rfip_ex_i/clocking_block/bufgmux_adc3/inst/BUFGMUX_inst]
#set_property LOC BUFG_PS_X0Y62 [get_cells rfip_ex_i/PS_Subsystem/zynq_ps/inst/buffer_pl_clk_0.PL_CLK_0_BUFG]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets rfip_ex_i/clocking_block/clk_wiz_adc0/inst/CLK_CORE_DRP_I/clk_inst/clk_out1]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets rfip_ex_i/clocking_block/clk_wiz_adc2/inst/CLK_CORE_DRP_I/clk_inst/clk_out1]
#create_pblock adc_bufgmux
#add_cells_to_pblock [get_pblocks adc_bufgmux] [get_cells -quiet [list rfip_ex_i/clocking_block/bufgmux_adc0/inst/BUFGMUX_inst rfip_ex_i/clocking_block/bufgmux_adc1/inst/BUFGMUX_inst rfip_ex_i/clocking_block/bufgmux_adc2/inst/BUFGMUX_inst rfip_ex_i/clocking_block/bufgmux_adc3/inst/BUFGMUX_inst]]
#resize_pblock [get_pblocks adc_bufgmux] -add {CLOCKREGION_X4Y0:CLOCKREGION_X4Y1}
create_pblock pblock_dac_source_i
resize_pblock pblock_dac_source_i -add CLOCKREGION_X4Y4:CLOCKREGION_X5Y7
add_cells_to_pblock pblock_dac_source_i [get_cells [list rfip_ex_i/ex_design/dac_source_i]]



#set_property IOSTANDARD LVDCI_18 [get_ports pl_clk_p]
set_property IOSTANDARD LVDS_25 [get_ports pl_clk_p]
set_property IOSTANDARD LVDS_25 [get_ports pl_clk_n]
#set_property IOSTANDARD LVDCI_18 [get_ports pl_sysref_p]
set_property IOSTANDARD LVDS_25 [get_ports pl_sysref_p]
set_property IOSTANDARD LVDS_25 [get_ports pl_sysref_n]

set_property PACKAGE_PIN B8 [get_ports pl_clk_p]

set_property PACKAGE_PIN B10 [get_ports pl_sysref_p]



set_input_delay -clock [get_clocks pl_clk] -min -add_delay 8.068 [get_ports pl_sysref_p]
set_input_delay -clock [get_clocks pl_clk] -max -add_delay 8.123 [get_ports pl_sysref_p]




set_property PACKAGE_PIN AP20 [get_ports C1_SYS_CLK_clk_p]
set_property PACKAGE_PIN AP19 [get_ports C1_SYS_CLK_clk_n]

set_property DQS_BIAS FALSE [get_ports C1_SYS_CLK_clk_p]
set_property DQS_BIAS FALSE [get_ports C1_SYS_CLK_clk_n]
set_property PACKAGE_PIN AM20 [get_ports {c1_ddr4_ck_t[0]}]
set_property PACKAGE_PIN AN20 [get_ports {c1_ddr4_ck_c[0]}]
set_property PACKAGE_PIN AF19 [get_ports {c1_ddr4_cke[0]}]
set_property PACKAGE_PIN AF20 [get_ports c1_ddr4_reset_n]
set_property IOSTANDARD LVCMOS12 [get_ports c1_ddr4_reset_n]

set_property PACKAGE_PIN AG18 [get_ports {c1_ddr4_cs_n[0]}]
set_property PACKAGE_PIN AU17 [get_ports {c1_ddr4_cs_n[1]}]

set_property PACKAGE_PIN AK21 [get_ports c1_ddr4_act_n]
set_property PACKAGE_PIN AK22 [get_ports {c1_ddr4_odt[0]}]

set_property PACKAGE_PIN AJ18 [get_ports {c1_ddr4_adr[0]}]
set_property PACKAGE_PIN AN22 [get_ports {c1_ddr4_adr[1]}]
set_property PACKAGE_PIN AL20 [get_ports {c1_ddr4_adr[2]}]
set_property PACKAGE_PIN AL21 [get_ports {c1_ddr4_adr[3]}]
set_property PACKAGE_PIN AM19 [get_ports {c1_ddr4_adr[4]}]
set_property PACKAGE_PIN AL19 [get_ports {c1_ddr4_adr[5]}]
set_property PACKAGE_PIN AM22 [get_ports {c1_ddr4_adr[6]}]
set_property PACKAGE_PIN AL22 [get_ports {c1_ddr4_adr[7]}]
set_property PACKAGE_PIN AN18 [get_ports {c1_ddr4_adr[8]}]
set_property PACKAGE_PIN AM18 [get_ports {c1_ddr4_adr[9]}]
set_property PACKAGE_PIN AP21 [get_ports {c1_ddr4_adr[10]}]
set_property PACKAGE_PIN AN21 [get_ports {c1_ddr4_adr[11]}]
set_property PACKAGE_PIN AT21 [get_ports {c1_ddr4_adr[12]}]
set_property PACKAGE_PIN AR21 [get_ports {c1_ddr4_adr[13]}]

set_property PACKAGE_PIN AH20 [get_ports {c1_ddr4_adr[14]}]
set_property PACKAGE_PIN AH18 [get_ports {c1_ddr4_adr[15]}]
set_property PACKAGE_PIN AK18 [get_ports {c1_ddr4_adr[16]}]

set_property PACKAGE_PIN AT22 [get_ports {c1_ddr4_ba[0]}]
set_property PACKAGE_PIN AR22 [get_ports {c1_ddr4_ba[1]}]
set_property PACKAGE_PIN AJ19 [get_ports {c1_ddr4_bg[0]}]
set_property PACKAGE_PIN AJ20 [get_ports {c1_ddr4_bg[1]}]

set_property PACKAGE_PIN AN8 [get_ports {c1_ddr4_dqs_t[0]}]
set_property PACKAGE_PIN AN7 [get_ports {c1_ddr4_dqs_c[0]}]
set_property PACKAGE_PIN AJ14 [get_ports {c1_ddr4_dqs_t[1]}]
set_property PACKAGE_PIN AK14 [get_ports {c1_ddr4_dqs_c[1]}]
set_property PACKAGE_PIN AM13 [get_ports {c1_ddr4_dqs_t[2]}]
set_property PACKAGE_PIN AN13 [get_ports {c1_ddr4_dqs_c[2]}]
set_property PACKAGE_PIN AT12 [get_ports {c1_ddr4_dqs_t[3]}]
set_property PACKAGE_PIN AT11 [get_ports {c1_ddr4_dqs_c[3]}]

set_property PACKAGE_PIN AM8 [get_ports {c1_ddr4_dq[0]}]
set_property PACKAGE_PIN AP9 [get_ports {c1_ddr4_dq[1]}]
set_property PACKAGE_PIN AL9 [get_ports {c1_ddr4_dq[2]}]
set_property PACKAGE_PIN AM7 [get_ports {c1_ddr4_dq[3]}]
set_property PACKAGE_PIN AM9 [get_ports {c1_ddr4_dq[4]}]
set_property PACKAGE_PIN AR9 [get_ports {c1_ddr4_dq[5]}]
set_property PACKAGE_PIN AL8 [get_ports {c1_ddr4_dq[6]}]
set_property PACKAGE_PIN AL7 [get_ports {c1_ddr4_dq[7]}]
set_property PACKAGE_PIN AK12 [get_ports {c1_ddr4_dq[8]}]
set_property PACKAGE_PIN AH13 [get_ports {c1_ddr4_dq[9]}]
set_property PACKAGE_PIN AM14 [get_ports {c1_ddr4_dq[10]}]
set_property PACKAGE_PIN AJ13 [get_ports {c1_ddr4_dq[11]}]
set_property PACKAGE_PIN AG12 [get_ports {c1_ddr4_dq[12]}]
set_property PACKAGE_PIN AH12 [get_ports {c1_ddr4_dq[13]}]
set_property PACKAGE_PIN AJ12 [get_ports {c1_ddr4_dq[14]}]
set_property PACKAGE_PIN AL14 [get_ports {c1_ddr4_dq[15]}]
set_property PACKAGE_PIN AR12 [get_ports {c1_ddr4_dq[16]}]
set_property PACKAGE_PIN AN11 [get_ports {c1_ddr4_dq[17]}]
set_property PACKAGE_PIN AP10 [get_ports {c1_ddr4_dq[18]}]
set_property PACKAGE_PIN AL10 [get_ports {c1_ddr4_dq[19]}]
set_property PACKAGE_PIN AR11 [get_ports {c1_ddr4_dq[20]}]
set_property PACKAGE_PIN AM10 [get_ports {c1_ddr4_dq[21]}]
set_property PACKAGE_PIN AN10 [get_ports {c1_ddr4_dq[22]}]
set_property PACKAGE_PIN AP11 [get_ports {c1_ddr4_dq[23]}]
set_property PACKAGE_PIN AT10 [get_ports {c1_ddr4_dq[24]}]
set_property PACKAGE_PIN AW9 [get_ports {c1_ddr4_dq[25]}]
set_property PACKAGE_PIN AU10 [get_ports {c1_ddr4_dq[26]}]
set_property PACKAGE_PIN AW8 [get_ports {c1_ddr4_dq[27]}]
set_property PACKAGE_PIN AW11 [get_ports {c1_ddr4_dq[28]}]
set_property PACKAGE_PIN AV12 [get_ports {c1_ddr4_dq[29]}]
set_property PACKAGE_PIN AV11 [get_ports {c1_ddr4_dq[30]}]
set_property PACKAGE_PIN AU12 [get_ports {c1_ddr4_dq[31]}]

set_property PACKAGE_PIN AP8 [get_ports {c1_ddr4_dm_n[0]}]
set_property PACKAGE_PIN AK13 [get_ports {c1_ddr4_dm_n[1]}]
set_property PACKAGE_PIN AM12 [get_ports {c1_ddr4_dm_n[2]}]
set_property PACKAGE_PIN AV10 [get_ports {c1_ddr4_dm_n[3]}]




set_property PACKAGE_PIN J19 [get_ports C0_SYS_CLK_clk_p]
set_property PACKAGE_PIN J18 [get_ports C0_SYS_CLK_clk_n]
set_property DQS_BIAS FALSE [get_ports C0_SYS_CLK_clk_n]
set_property DQS_BIAS FALSE [get_ports C0_SYS_CLK_clk_p]

set_property PACKAGE_PIN G17 [get_ports {c0_ddr4_ck_t[0]}]
set_property PACKAGE_PIN F17 [get_ports {c0_ddr4_ck_c[0]}]
set_property PACKAGE_PIN A16 [get_ports {c0_ddr4_cke[0]}]
set_property PACKAGE_PIN A17 [get_ports c0_ddr4_reset_n]
set_property IOSTANDARD LVCMOS12 [get_ports c0_ddr4_reset_n]

set_property PACKAGE_PIN D16 [get_ports {c0_ddr4_cs_n[0]}]
set_property PACKAGE_PIN L15 [get_ports {c0_ddr4_cs_n[1]}]

set_property PACKAGE_PIN A19 [get_ports c0_ddr4_act_n]
set_property PACKAGE_PIN B19 [get_ports {c0_ddr4_odt[0]}]

set_property PACKAGE_PIN D18 [get_ports {c0_ddr4_adr[0]}]
set_property PACKAGE_PIN E19 [get_ports {c0_ddr4_adr[1]}]
set_property PACKAGE_PIN E17 [get_ports {c0_ddr4_adr[2]}]
set_property PACKAGE_PIN E18 [get_ports {c0_ddr4_adr[3]}]
set_property PACKAGE_PIN E16 [get_ports {c0_ddr4_adr[4]}]
set_property PACKAGE_PIN F16 [get_ports {c0_ddr4_adr[5]}]
set_property PACKAGE_PIN F19 [get_ports {c0_ddr4_adr[6]}]
set_property PACKAGE_PIN G19 [get_ports {c0_ddr4_adr[7]}]
set_property PACKAGE_PIN F15 [get_ports {c0_ddr4_adr[8]}]
set_property PACKAGE_PIN G15 [get_ports {c0_ddr4_adr[9]}]
set_property PACKAGE_PIN G18 [get_ports {c0_ddr4_adr[10]}]
set_property PACKAGE_PIN H18 [get_ports {c0_ddr4_adr[11]}]
set_property PACKAGE_PIN K17 [get_ports {c0_ddr4_adr[12]}]
set_property PACKAGE_PIN L17 [get_ports {c0_ddr4_adr[13]}]

set_property PACKAGE_PIN B17 [get_ports {c0_ddr4_adr[14]}]
set_property PACKAGE_PIN D15 [get_ports {c0_ddr4_adr[15]}]
set_property PACKAGE_PIN C18 [get_ports {c0_ddr4_adr[16]}]

set_property PACKAGE_PIN K18 [get_ports {c0_ddr4_ba[0]}]
set_property PACKAGE_PIN K19 [get_ports {c0_ddr4_ba[1]}]
set_property PACKAGE_PIN C16 [get_ports {c0_ddr4_bg[0]}]
set_property PACKAGE_PIN C17 [get_ports {c0_ddr4_bg[1]}]

set_property PACKAGE_PIN E13 [get_ports {c0_ddr4_dqs_t[0]}]
set_property PACKAGE_PIN E12 [get_ports {c0_ddr4_dqs_c[0]}]
set_property PACKAGE_PIN H8 [get_ports {c0_ddr4_dqs_t[1]}]
set_property PACKAGE_PIN G8 [get_ports {c0_ddr4_dqs_c[1]}]
set_property PACKAGE_PIN C15 [get_ports {c0_ddr4_dqs_t[2]}]
set_property PACKAGE_PIN B15 [get_ports {c0_ddr4_dqs_c[2]}]
set_property PACKAGE_PIN J14 [get_ports {c0_ddr4_dqs_t[3]}]
set_property PACKAGE_PIN J13 [get_ports {c0_ddr4_dqs_c[3]}]

set_property PACKAGE_PIN E11 [get_ports {c0_ddr4_dq[0]}]
set_property PACKAGE_PIN G14 [get_ports {c0_ddr4_dq[1]}]
set_property PACKAGE_PIN F12 [get_ports {c0_ddr4_dq[2]}]
set_property PACKAGE_PIN D14 [get_ports {c0_ddr4_dq[3]}]
set_property PACKAGE_PIN H12 [get_ports {c0_ddr4_dq[4]}]
set_property PACKAGE_PIN E14 [get_ports {c0_ddr4_dq[5]}]
set_property PACKAGE_PIN H13 [get_ports {c0_ddr4_dq[6]}]
set_property PACKAGE_PIN F14 [get_ports {c0_ddr4_dq[7]}]

set_property PACKAGE_PIN H7 [get_ports {c0_ddr4_dq[8]}]
set_property PACKAGE_PIN K9 [get_ports {c0_ddr4_dq[9]}]
set_property PACKAGE_PIN G6 [get_ports {c0_ddr4_dq[10]}]
set_property PACKAGE_PIN F9 [get_ports {c0_ddr4_dq[11]}]
set_property PACKAGE_PIN H6 [get_ports {c0_ddr4_dq[12]}]
set_property PACKAGE_PIN G9 [get_ports {c0_ddr4_dq[13]}]
set_property PACKAGE_PIN G7 [get_ports {c0_ddr4_dq[14]}]
set_property PACKAGE_PIN J9 [get_ports {c0_ddr4_dq[15]}]

set_property PACKAGE_PIN B14 [get_ports {c0_ddr4_dq[16]}]
set_property PACKAGE_PIN A12 [get_ports {c0_ddr4_dq[17]}]
set_property PACKAGE_PIN B13 [get_ports {c0_ddr4_dq[18]}]
set_property PACKAGE_PIN C13 [get_ports {c0_ddr4_dq[19]}]
set_property PACKAGE_PIN A15 [get_ports {c0_ddr4_dq[20]}]
set_property PACKAGE_PIN A11 [get_ports {c0_ddr4_dq[21]}]
set_property PACKAGE_PIN A14 [get_ports {c0_ddr4_dq[22]}]
set_property PACKAGE_PIN D13 [get_ports {c0_ddr4_dq[23]}]

set_property PACKAGE_PIN K11 [get_ports {c0_ddr4_dq[24]}]
set_property PACKAGE_PIN H10 [get_ports {c0_ddr4_dq[25]}]
set_property PACKAGE_PIN F10 [get_ports {c0_ddr4_dq[26]}]
set_property PACKAGE_PIN H11 [get_ports {c0_ddr4_dq[27]}]
set_property PACKAGE_PIN K10 [get_ports {c0_ddr4_dq[28]}]
set_property PACKAGE_PIN J10 [get_ports {c0_ddr4_dq[29]}]
set_property PACKAGE_PIN F11 [get_ports {c0_ddr4_dq[30]}]
set_property PACKAGE_PIN J11 [get_ports {c0_ddr4_dq[31]}]

set_property PACKAGE_PIN G13 [get_ports {c0_ddr4_dm_n[0]}]
set_property PACKAGE_PIN J8 [get_ports {c0_ddr4_dm_n[1]}]
set_property PACKAGE_PIN C12 [get_ports {c0_ddr4_dm_n[2]}]
set_property PACKAGE_PIN K13 [get_ports {c0_ddr4_dm_n[3]}]



