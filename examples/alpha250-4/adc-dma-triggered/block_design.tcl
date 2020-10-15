# Add PS and AXI Interconnect
set board_preset $board_path/config/board_preset.tcl
source $sdk_path/fpga/lib/starting_point.tcl

source $board_path/adc.tcl

# Add config and status registers
source $sdk_path/fpga/lib/ctl_sts.tcl
add_ctl_sts adc/adc_clk rst_adc_clk/peripheral_aresetn

connect_cell adc {
    adc00 [sts_pin adc00]
    adc01 [sts_pin adc01]
    adc10 [sts_pin adc10]
    adc11 [sts_pin adc11]
    ctl [ctl_pin mmcm]
    cfg_data [ctl_pin spi_cfg_data]
    cfg_cmd [ctl_pin spi_cfg_cmd]
    cfg_sts [sts_pin spi_cfg_sts]
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

connect_pins [sts_pin digital_inputs] [get_concat_pin [list exp_io_0_p exp_io_1_p exp_io_2_p exp_io_3_p exp_io_4_p exp_io_5_p exp_io_6_p exp_io_7_p]]

for {set i 0} {$i < 8} {incr i} {
    connect_pins  [get_slice_pin [ctl_pin digital_outputs] $i $i] exp_io_${i}_n
}
##################################################
# DMA
##################################################

# Configure Zynq Processing System
set_cell_props ps_0 {
  PCW_USE_S_AXI_HP0 1
  PCW_S_AXI_HP0_DATA_WIDTH 64
  PCW_USE_S_AXI_HP2 1
  PCW_S_AXI_HP2_DATA_WIDTH 64
  PCW_USE_HIGH_OCM 1
  PCW_USE_S_AXI_GP0 1
}

connect_pins ps_0/S_AXI_GP0_ACLK ps_0/FCLK_CLK0
connect_pins ps_0/S_AXI_HP0_ACLK ps_0/FCLK_CLK0
connect_pins ps_0/S_AXI_HP2_ACLK ps_0/FCLK_CLK0

cell xilinx.com:ip:smartconnect:1.0 dma_interconnect_omc {
  NUM_SI 2
  NUM_MI 1
} {
  aclk ${ps_name}/FCLK_CLK0
  aresetn proc_sys_reset_0/peripheral_aresetn
  M00_AXI ${ps_name}/S_AXI_GP0
}

cell xilinx.com:ip:smartconnect:1.0 dma_interconnect_s2mm0 {
  NUM_SI 1
  NUM_MI 1
  S00_AXIHAS_REGSLICE 1
} {
  aclk ${ps_name}/FCLK_CLK0
  aresetn proc_sys_reset_0/peripheral_aresetn
  M00_AXI ${ps_name}/S_AXI_HP0
}

cell xilinx.com:ip:smartconnect:1.0 dma_interconnect_s2mm1 {
  NUM_SI 1
  NUM_MI 1
  S00_AXIHAS_REGSLICE 1
} {
  aclk ${ps_name}/FCLK_CLK0
  aresetn proc_sys_reset_0/peripheral_aresetn
  M00_AXI ${ps_name}/S_AXI_HP2
}

cell xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_1 {
  S_TDATA_NUM_BYTES 4
  M_TDATA_NUM_BYTES 8
} {
  aclk adc/adc_clk
  aresetn rst_adc_clk/peripheral_aresetn
  s_axis_tdata [get_concat_pin [list adc/adc10 adc/adc11]]
  s_axis_tvalid axis_dwidth_converter_1/s_axis_tready
}
cell xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_0 {
  S_TDATA_NUM_BYTES 4
  M_TDATA_NUM_BYTES 8
} {
  aclk adc/adc_clk
  aresetn rst_adc_clk/peripheral_aresetn
  s_axis_tdata [get_concat_pin [list adc/adc00 adc/adc01]]
  s_axis_tvalid axis_dwidth_converter_0/s_axis_tready
}

cell xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 {
  TDATA_NUM_BYTES 8
} {
  s_axis_aclk adc/adc_clk
  s_axis_aresetn rst_adc_clk/peripheral_aresetn
  m_axis_aclk ps_0/FCLK_CLK0
  m_axis_aresetn proc_sys_reset_0/peripheral_aresetn
  S_AXIS axis_dwidth_converter_0/M_AXIS
}

cell xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_1 {
  TDATA_NUM_BYTES 8
} {
  s_axis_aclk adc/adc_clk
  s_axis_aresetn rst_adc_clk/peripheral_aresetn
  m_axis_aclk ps_0/FCLK_CLK0
  m_axis_aresetn proc_sys_reset_0/peripheral_aresetn
  S_AXIS axis_dwidth_converter_1/M_AXIS
}

cell koheron:user:tlast_gen:1.0 tlast_gen_0 {
  TDATA_WIDTH 64
  PKT_LENGTH [expr 1024 * 1024]
} {
  aclk ps_0/FCLK_CLK0
  resetn proc_sys_reset_0/peripheral_aresetn
  s_axis axis_clock_converter_0/M_AXIS
}

cell koheron:user:tlast_gen:1.0 tlast_gen_1 {
  TDATA_WIDTH 64
  PKT_LENGTH [expr 1024 * 1024]
} {
  aclk ps_0/FCLK_CLK0
  resetn proc_sys_reset_0/peripheral_aresetn
  s_axis axis_clock_converter_1/M_AXIS
}

# DMA

cell xilinx.com:ip:axi_dma:7.1 axi_dma_0 {
  c_include_sg 1
  c_sg_include_stscntrl_strm 0
  c_sg_length_width 20
  c_s2mm_burst_size 16
  c_include_mm2s {0}
  c_include_s2mm {1}
  c_m_axi_s2mm_data_width 64
  c_mm2s_burst_size 16
} {
  S_AXI_LITE axi_mem_intercon_0/M[add_master_interface]_AXI
  s_axi_lite_aclk ps_0/FCLK_CLK0
  M_AXI_SG dma_interconnect_omc/S00_AXI
  m_axi_sg_aclk ps_0/FCLK_CLK0
  M_AXI_S2MM dma_interconnect_s2mm0/S00_AXI
  m_axi_s2mm_aclk ps_0/FCLK_CLK0
  S_AXIS_S2MM tlast_gen_0/m_axis
  axi_resetn proc_sys_reset_0/peripheral_aresetn
}
cell xilinx.com:ip:axi_dma:7.1 axi_dma_1 {
  c_include_sg 1
  c_sg_include_stscntrl_strm 0
  c_sg_length_width 20
  c_s2mm_burst_size 16
  c_include_mm2s {0}
  c_include_s2mm {1}
  c_m_axi_s2mm_data_width 64
  c_mm2s_burst_size 16
} {
  S_AXI_LITE axi_mem_intercon_0/M[add_master_interface]_AXI
  s_axi_lite_aclk ps_0/FCLK_CLK0
  M_AXI_SG dma_interconnect_omc/S01_AXI
  m_axi_sg_aclk ps_0/FCLK_CLK0
  M_AXI_S2MM dma_interconnect_s2mm1/S00_AXI
  m_axi_s2mm_aclk ps_0/FCLK_CLK0
  S_AXIS_S2MM tlast_gen_1/m_axis
  axi_resetn proc_sys_reset_0/peripheral_aresetn
}

set idx [add_master_interface 0]
# Add AXI stream FIFO
cell xilinx.com:ip:axi_clock_converter:2.1 psa_axis_clock_converter {
} {
  m_axi_aclk adc/adc_clk
  m_axi_aresetn rst_adc_clk/peripheral_aresetn
  S_AXI axi_mem_intercon_0/M${idx}_AXI
  s_axi_aclk ps_0/FCLK_CLK0
  s_axi_aresetn proc_sys_reset_0/peripheral_aresetn
}
cell xilinx.com:ip:axis_dwidth_converter:1.1 psa_axis_dwidth_converter {
  S_TDATA_NUM_BYTES 2 
  M_TDATA_NUM_BYTES 4
} {
  aclk adc/adc_clk
  aresetn rst_adc_clk/peripheral_aresetn
}
cell xilinx.com:ip:axi_fifo_mm_s:4.1 psa_axis_fifo {
  C_USE_TX_DATA 0
  C_USE_TX_CTRL 0
  C_USE_RX_CUT_THROUGH true
  C_RX_FIFO_DEPTH 4096
  C_RX_FIFO_PF_THRESHOLD 4000
} {
  s_axi_aclk adc/adc_clk
  s_axi_aresetn rst_adc_clk/peripheral_aresetn
  S_AXI psa_axis_clock_converter/M_AXI
  AXI_STR_RXD psa_axis_dwidth_converter/M_AXIS
}
assign_bd_address [get_bd_addr_segs psa_axis_fifo/S_AXI/Mem0]
set memory_segment  [get_bd_addr_segs /ps_0/Data/SEG_psa_axis_fifo_Mem0]
set_property offset [get_memory_offset psa_fifo] $memory_segment
set_property range [get_memory_range psa_fifo] $memory_segment

# DMA AXI Lite
assign_bd_address [get_bd_addr_segs {axi_dma_0/S_AXI_LITE/Reg }]
set_property range [get_memory_range dma0] [get_bd_addr_segs {ps_0/Data/SEG_axi_dma_0_Reg}]
set_property offset [get_memory_offset dma0] [get_bd_addr_segs {ps_0/Data/SEG_axi_dma_0_Reg}]
assign_bd_address [get_bd_addr_segs {axi_dma_1/S_AXI_LITE/Reg }]
set_property range [get_memory_range dma1] [get_bd_addr_segs {ps_0/Data/SEG_axi_dma_1_Reg}]
set_property offset [get_memory_offset dma1] [get_bd_addr_segs {ps_0/Data/SEG_axi_dma_1_Reg}]

# Scatter Gather interface in On Chip Memory
assign_bd_address [get_bd_addr_segs {ps_0/S_AXI_GP0/GP0_HIGH_OCM }]
set_property range 32K [get_bd_addr_segs {axi_dma_1/Data_SG/SEG_ps_0_GP0_HIGH_OCM}]
set_property offset [get_memory_offset ocm_s2mm1] [get_bd_addr_segs {axi_dma_1/Data_SG/SEG_ps_0_GP0_HIGH_OCM}]
set_property range 32K [get_bd_addr_segs {axi_dma_0/Data_SG/SEG_ps_0_GP0_HIGH_OCM}]
set_property offset [get_memory_offset ocm_s2mm0] [get_bd_addr_segs {axi_dma_0/Data_SG/SEG_ps_0_GP0_HIGH_OCM}]

# S2MM on HP0
assign_bd_address [get_bd_addr_segs {ps_0/S_AXI_HP0/HP0_DDR_LOWOCM }]
set_property range [get_memory_range ram_s2mm0] [get_bd_addr_segs {axi_dma_0/Data_S2MM/SEG_ps_0_HP0_DDR_LOWOCM}]
set_property offset [get_memory_offset ram_s2mm0] [get_bd_addr_segs {axi_dma_0/Data_S2MM/SEG_ps_0_HP0_DDR_LOWOCM}]
assign_bd_address [get_bd_addr_segs {ps_0/S_AXI_HP2/HP2_DDR_LOWOCM }]
set_property range [get_memory_range ram_s2mm1] [get_bd_addr_segs {axi_dma_1/Data_S2MM/SEG_ps_0_HP2_DDR_LOWOCM}]
set_property offset [get_memory_offset ram_s2mm1] [get_bd_addr_segs {axi_dma_1/Data_S2MM/SEG_ps_0_HP2_DDR_LOWOCM}]

# Unmap unused segments
delete_bd_objs [get_bd_addr_segs axi_dma_0/Data_SG/SEG_ps_0_HP0_DDR_LOWOCM]
delete_bd_objs [get_bd_addr_segs axi_dma_0/Data_MM2S/SEG_ps_0_GP0_HIGH_OCM]
delete_bd_objs [get_bd_addr_segs axi_dma_0/Data_S2MM/SEG_ps_0_GP0_HIGH_OCM]
delete_bd_objs [get_bd_addr_segs axi_dma_0/Data_S2MM/SEG_ps_0_HP0_DDR_LOWOCM]


exclude_bd_addr_seg [get_bd_addr_segs ps_0/S_AXI_GP0/GP0_DDR_LOWOCM] -target_address_space [get_bd_addr_spaces axi_dma_0/Data_SG]
exclude_bd_addr_seg [get_bd_addr_segs ps_0/S_AXI_GP0/GP0_QSPI_LINEAR] -target_address_space [get_bd_addr_spaces axi_dma_0/Data_SG]
exclude_bd_addr_seg [get_bd_addr_segs ps_0/S_AXI_GP0/GP0_DDR_LOWOCM] -target_address_space [get_bd_addr_spaces axi_dma_1/Data_SG]
exclude_bd_addr_seg [get_bd_addr_segs ps_0/S_AXI_GP0/GP0_QSPI_LINEAR] -target_address_space [get_bd_addr_spaces axi_dma_1/Data_SG]
exclude_bd_addr_seg [get_bd_addr_segs ps_0/S_AXI_HP2/HP2_HIGH_OCM] -target_address_space [get_bd_addr_spaces axi_dma_1/Data_S2MM]
assign_bd_address [get_bd_addr_segs {ps_0/S_AXI_HP0/HP0_DDR_LOWOCM }]
set_property range [get_memory_range ram_s2mm0] [get_bd_addr_segs {axi_dma_0/Data_S2MM/SEG_ps_0_HP0_DDR_LOWOCM}]
set_property offset [get_memory_offset ram_s2mm0] [get_bd_addr_segs {axi_dma_0/Data_S2MM/SEG_ps_0_HP0_DDR_LOWOCM}]

move_bd_cells [get_bd_cells ctl] [get_bd_cells slice_3_3_ctl_digital_outputs] [get_bd_cells slice_5_5_ctl_digital_outputs] [get_bd_cells slice_2_2_ctl_digital_outputs] [get_bd_cells slice_1_1_ctl_digital_outputs] [get_bd_cells slice_7_7_ctl_digital_outputs] [get_bd_cells slice_4_4_ctl_digital_outputs] [get_bd_cells slice_6_6_ctl_digital_outputs] [get_bd_cells slice_0_0_ctl_digital_outputs]

add_files -norecurse {/home/rsarwar/workspace/fpga/koheron-sdk-orig/examples/alpha250-4/adc-dma-triggered/trigger2.vhd /home/rsarwar/workspace/fpga/koheron-sdk-orig/examples/alpha250-4/adc-dma-triggered/trigger.vhd}
update_compile_order -fileset sources_1
create_bd_cell -type module -reference trigger trigger_0
create_bd_cell -type module -reference trigger2 trigger2_0
delete_bd_objs [get_bd_nets concat_adc00_adc01_dout]
connect_bd_net [get_bd_pins concat_adc00_adc01/dout] [get_bd_pins trigger_0/ADC_INPUT]
delete_bd_objs [get_bd_nets axis_dwidth_converter_0_s_axis_tready]
connect_bd_intf_net [get_bd_intf_pins trigger_0/S] [get_bd_intf_pins axis_dwidth_converter_0/S_AXIS]
connect_bd_net [get_bd_pins trigger_0/CLK] [get_bd_pins adc/adc_clk]
connect_bd_net [get_bd_pins trigger2_0/CLK] [get_bd_pins adc/adc_clk]
connect_bd_net [get_bd_pins trigger2_0/ADC_INPUT] [get_bd_pins adc/adc00]
connect_bd_intf_net [get_bd_intf_pins trigger2_0/S] [get_bd_intf_pins psa_axis_dwidth_converter/S_AXIS]
connect_bd_net [get_bd_pins const_v0_w1/dout] [get_bd_pins trigger2_0/NEGATIVE]
connect_bd_net [get_bd_pins trigger_0/NEGATIVE] [get_bd_pins const_v0_w1/dout]
connect_bd_net [get_bd_pins trigger2_0/THRESHOLD] [get_bd_pins trigger_0/THRESHOLD] 
connect_pins trigger2_0/THRESHOLD [get_constant_pin 2024 16]

# Hack to change the 32 bit auto width in AXI_DMA S_AXI_S2MM
validate_bd_design