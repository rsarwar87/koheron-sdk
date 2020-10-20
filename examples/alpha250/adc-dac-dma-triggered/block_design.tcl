# Add PS and AXI Interconnect
set board_preset $board_path/config/board_preset.tcl
source $sdk_path/fpga/lib/starting_point.tcl

source $board_path/adc_dac.tcl

# Add config and status registers
source $sdk_path/fpga/lib/ctl_sts.tcl
add_ctl_sts adc_dac/adc_clk rst_adc_clk/peripheral_aresetn

connect_cell adc_dac {
    adc0 [sts_pin adc0]
    adc1 [sts_pin adc1]
    ctl [ctl_pin mmcm]
    cfg_data [ps_ctl_pin spi_cfg_data]
    cfg_cmd [ps_ctl_pin spi_cfg_cmd]
    cfg_sts [ps_sts_pin spi_cfg_sts]
}

# Add XADC for monitoring of Zynq temperature

create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vp_Vn

cell xilinx.com:ip:xadc_wiz:3.3 xadc_wiz_0 {
} {
  Vp_Vn Vp_Vn
  s_axi_lite axi_mem_intercon_0/M[add_master_interface 0]_AXI
  s_axi_aclk ps_0/FCLK_CLK0
  s_axi_aresetn proc_sys_reset_0/peripheral_aresetn
}
assign_bd_address [get_bd_addr_segs xadc_wiz_0/s_axi_lite/Reg]

# Expansion connector IOs

for {set i 0} {$i < 8} {incr i} {
  create_bd_port -dir I exp_io_${i}_p
  create_bd_port -dir O exp_io_${i}_n
}

# SPI
source $board_path/spi.tcl

connect_pins ps_0/SDIO0_CDN [get_constant_pin 0 1]
connect_pins ps_0/SDIO0_WP [get_constant_pin 0 1]

##################################################
# DMA
##################################################

# Configure Zynq Processing System
set_cell_props ps_0 {
  PCW_USE_S_AXI_HP0 1
  PCW_S_AXI_HP0_DATA_WIDTH 64
  PCW_USE_HIGH_OCM 1
  PCW_USE_FABRIC_INTERRUPT 1
  PCW_IRQ_F2P_INTR {1}
  PCW_USE_S_AXI_GP0 1
}

connect_pins ps_0/S_AXI_GP0_ACLK ps_0/FCLK_CLK0
connect_pins ps_0/S_AXI_HP0_ACLK ps_0/FCLK_CLK0

cell xilinx.com:ip:axi_interconnect:2.1 dma_interconnect {
  NUM_SI 3
  NUM_MI 2
  S01_HAS_REGSLICE 1
  S02_HAS_REGSLICE 1
} {
  ACLK ps_0/FCLK_CLK0
  ARESETN proc_sys_reset_0/peripheral_aresetn
  M00_AXI ps_0/S_AXI_GP0
  M01_AXI ps_0/S_AXI_HP0
  S00_ACLK ps_0/FCLK_CLK0
  S00_ARESETN proc_sys_reset_0/peripheral_aresetn
  S01_ACLK ps_0/FCLK_CLK0
  S01_ARESETN proc_sys_reset_0/peripheral_aresetn
  S02_ACLK ps_0/FCLK_CLK0
  S02_ARESETN proc_sys_reset_0/peripheral_aresetn
  M00_ACLK ps_0/FCLK_CLK0
  M00_ARESETN proc_sys_reset_0/peripheral_aresetn
  M01_ACLK ps_0/FCLK_CLK0
  M01_ARESETN proc_sys_reset_0/peripheral_aresetn
}

# ADC Streaming (S2MM)

cell koheron:user:bus_multiplexer:1.0 adc_mux {
  WIDTH 16
} {
  din0 adc_dac/adc0
  din1 adc_dac/adc1
  sel [get_slice_pin [ctl_pin channel_select] 0 0]
}

cell xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_0 {
  S_TDATA_NUM_BYTES 2
  M_TDATA_NUM_BYTES 8
} {
  aclk adc_dac/adc_clk
  aresetn rst_adc_clk/peripheral_aresetn
  s_axis_tdata adc_mux/dout
  s_axis_tvalid axis_dwidth_converter_0/s_axis_tready
}

cell xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 {
  TDATA_NUM_BYTES 8
} {
  s_axis_aclk adc_dac/adc_clk
  s_axis_aresetn rst_adc_clk/peripheral_aresetn
  m_axis_aclk ps_0/FCLK_CLK0
  m_axis_aresetn proc_sys_reset_0/peripheral_aresetn
  S_AXIS axis_dwidth_converter_0/M_AXIS
}

cell koheron:user:tlast_gen:1.0 tlast_gen_0 {
  TDATA_WIDTH 64
  PKT_LENGTH [expr 1024 * 1024]
} {
  aclk ps_0/FCLK_CLK0
  resetn proc_sys_reset_0/peripheral_aresetn
  s_axis axis_clock_converter_0/M_AXIS
}

# DMA

cell xilinx.com:ip:axi_dma:7.1 axi_dma_0 {
  c_include_sg 1
  c_sg_include_stscntrl_strm 0
  c_s2mm_burst_size 16
  c_m_axi_s2mm_data_width 64
  c_m_axi_mm2s_data_width 64
  c_m_axis_mm2s_tdata_width 64
  c_mm2s_burst_size 16
  c_sg_length_width 23
} {
  S_AXI_LITE axi_mem_intercon_0/M[add_master_interface]_AXI
  s_axi_lite_aclk ps_0/FCLK_CLK0
  M_AXI_SG dma_interconnect/S00_AXI
  m_axi_sg_aclk ps_0/FCLK_CLK0
  M_AXI_MM2S dma_interconnect/S01_AXI
  m_axi_mm2s_aclk ps_0/FCLK_CLK0
  M_AXI_S2MM dma_interconnect/S02_AXI
  m_axi_s2mm_aclk ps_0/FCLK_CLK0
  S_AXIS_S2MM tlast_gen_0/m_axis
  axi_resetn proc_sys_reset_0/peripheral_aresetn
}

# DAC Streaming (MM2S)

cell xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_1 {
  TDATA_NUM_BYTES 8
} {
  S_AXIS axi_dma_0/M_AXIS_MM2S
  s_axis_aclk ps_0/FCLK_CLK0
  s_axis_aresetn proc_sys_reset_0/peripheral_aresetn
  m_axis_aclk adc_dac/adc_clk
  m_axis_aresetn rst_adc_clk/peripheral_aresetn
}

cell xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_1 {
  S_TDATA_NUM_BYTES 8
  M_TDATA_NUM_BYTES 2
} {
  aclk adc_dac/adc_clk
  aresetn rst_adc_clk/peripheral_aresetn
  S_AXIS axis_clock_converter_1/M_AXIS
  m_axis_tvalid axis_dwidth_converter_1/m_axis_tready
}

connect_pins adc_dac/dac0 axis_dwidth_converter_1/m_axis_tdata
connect_pins adc_dac/dac1 axis_dwidth_converter_1/m_axis_tdata

# DMA AXI Lite
assign_bd_address [get_bd_addr_segs {axi_dma_0/S_AXI_LITE/Reg }]
set_property range [get_memory_range dma] [get_bd_addr_segs {ps_0/Data/SEG_axi_dma_0_Reg}]
set_property offset [get_memory_offset dma] [get_bd_addr_segs {ps_0/Data/SEG_axi_dma_0_Reg}]

# Scatter Gather interface in On Chip Memory
assign_bd_address [get_bd_addr_segs {ps_0/S_AXI_GP0/GP0_HIGH_OCM }]
set_property range 64K [get_bd_addr_segs {axi_dma_0/Data_SG/SEG_ps_0_GP0_HIGH_OCM}]
set_property offset [get_memory_offset ocm_mm2s] [get_bd_addr_segs {axi_dma_0/Data_SG/SEG_ps_0_GP0_HIGH_OCM}]

# MM2S on HP2
assign_bd_address [get_bd_addr_segs {ps_0/S_AXI_HP0/HP0_DDR_LOWOCM }]
set_property range [get_memory_range ram_mm2s] [get_bd_addr_segs {axi_dma_0/Data_MM2S/SEG_ps_0_HP0_DDR_LOWOCM}]
set_property offset [get_memory_offset ram_mm2s] [get_bd_addr_segs {axi_dma_0/Data_MM2S/SEG_ps_0_HP0_DDR_LOWOCM}]

# S2MM on HP0
assign_bd_address [get_bd_addr_segs {ps_0/S_AXI_HP0/HP0_DDR_LOWOCM }]
set_property range [get_memory_range ram_s2mm] [get_bd_addr_segs {axi_dma_0/Data_S2MM/SEG_ps_0_HP0_DDR_LOWOCM}]
set_property offset [get_memory_offset ram_s2mm] [get_bd_addr_segs {axi_dma_0/Data_S2MM/SEG_ps_0_HP0_DDR_LOWOCM}]
# Unmap unused segments
delete_bd_objs [get_bd_addr_segs axi_dma_0/Data_SG/SEG_ps_0_HP0_DDR_LOWOCM]
delete_bd_objs [get_bd_addr_segs axi_dma_0/Data_MM2S/SEG_ps_0_GP0_HIGH_OCM]
delete_bd_objs [get_bd_addr_segs axi_dma_0/Data_S2MM/SEG_ps_0_GP0_HIGH_OCM]

# Hack to change the 32 bit auto width in AXI_DMA S_AXI_S2MM
#
#
set files [glob -nocomplain $project_path/*.vhd]
if {[llength $files] > 0} {
  add_files -norecurse $files
}
update_compile_order -fileset sources_1
create_bd_cell -type module -reference trigger_module trigger_module_0
connect_bd_net [get_bd_ports exp_io_0_p] [get_bd_pins trigger_module_0/trigger_in]
delete_bd_objs [get_bd_nets adc_mux_dout]
connect_bd_net [get_bd_pins trigger_module_0/data_in] [get_bd_pins adc_mux/dout]
connect_bd_net [get_bd_pins trigger_module_0/clk] [get_bd_pins adc_dac/adc_clk]
connect_bd_net [get_bd_pins trigger_module_0/nrst] [get_bd_pins rst_adc_clk/peripheral_aresetn]
delete_bd_objs [get_bd_nets axis_dwidth_converter_0_s_axis_tready]
connect_bd_intf_net [get_bd_intf_pins trigger_module_0/s_axis] [get_bd_intf_pins axis_dwidth_converter_0/S_AXIS]
connect_bd_net [get_bd_pins ctl/channel_trigger] [get_bd_pins trigger_module_0/config_in]
connect_bd_net [get_bd_ports exp_io_7_n] [get_bd_pins trigger_module_0/led_out]

cell xilinx.com:ip:xlconcat:2.1 f2a_interrupt {
  NUM_PORTS 3
} {
  dout ps_0/IRQ_F2P
  In0 xadc_wiz_0/ip2intc_irpt
  In1 axi_dma_0/s2mm_introut
  In2 axi_dma_0/mm2s_introut
}
validate_bd_design
