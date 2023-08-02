 
# Add PS and AXI Interconnect
set board_preset $board_path/config/board_preset.tcl
source $sdk_path/fpga/lib/starting_point.tcl
source $board_path/adc_dac.tcl

# Add config and status registers
source $sdk_path/fpga/lib/ctl_sts.tcl

add_ctl_sts adc_dac/adc_clk rst_adc_clk/peripheral_aresetn
# Connect 42 to status register
connect_pins [get_constant_pin 42 32] [sts_pin forty_two]

connect_cell adc_dac {
    adc0 [sts_pin adc0]
    adc1 [sts_pin adc1]
    ctl [ctl_pin mmcm]
    cfg_data [ps_ctl_pin spi_cfg_data]
    cfg_cmd [ps_ctl_pin spi_cfg_cmd]
    cfg_sts [ps_sts_pin spi_cfg_sts]
}


# Configure Zynq Processing System
set_cell_props ps_0 {
  PCW_USE_S_AXI_HP2 1
  PCW_S_AXI_HP2_DATA_WIDTH 64
  PCW_USE_HIGH_OCM 1
  PCW_USE_S_AXI_GP0 1
  PCW_USE_FABRIC_INTERRUPT {1} 
  PCW_IRQ_F2P_INTR {1}
}

connect_pins ps_0/S_AXI_GP0_ACLK ps_0/FCLK_CLK0
connect_pins ps_0/S_AXI_HP2_ACLK ps_0/FCLK_CLK0

#connect_port_pin gpio_led  [get_slice_pin [ctl_pin led] 3 0]
set_cell_props ps_0 {
  PCW_FPGA1_PERIPHERAL_FREQMHZ {10} 
  PCW_FPGA2_PERIPHERAL_FREQMHZ {20} 
  PCW_EN_CLK1_PORT {1}
  PCW_EN_CLK2_PORT {1}
}
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
  create_bd_port -dir I exp_io_${i}_n
}
connect_pin [sts_pin io_in] [get_concat_pin [list exp_io_0_p exp_io_1_p exp_io_2_p exp_io_3_p exp_io_4_p exp_io_5_p exp_io_6_p exp_io_7_p ]]

# SPI
source $board_path/spi.tcl

connect_pins ps_0/SDIO0_CDN [get_constant_pin 0 1]
connect_pins ps_0/SDIO0_WP [get_constant_pin 0 1]


#add_files $project_path/hdl/stream_select.vhd
#update_compile_order -fileset sources_1
#create_bd_cell -type module -reference stream_select stream_select_0
#connect_bd_net [get_bd_pins stream_select_0/clk] [get_bd_pins ps_0/FCLK_CLK0]

############################################################################
# ADD CUSTOM IP
# ##########################################################################
#
# set idx [add_master_interface 0]
# cell user.org:user:fel_unit:2.0 fel_unit_0 {
# } {
#   s00_axi_aclk ps_0/FCLK_CLK0
#   s00_axi_aresetn proc_sys_reset_0/peripheral_aresetn
#   S00_AXI axi_mem_intercon_0/M${idx}_AXI
#   clk_10mhz ps_0/FCLK_CLK1
#   ext_clk ext_clk 
#   channel channel
#   ext_trigger start
#   stream_select stream_select_0/ch_select
#   m00_axis stream_select_0/s00_axis
#   m00_axis_aclk ps_0/FCLK_CLK0
#   m00_axis_aresetn proc_sys_reset_0/peripheral_aresetn
# }
# assign_bd_address [get_bd_addr_segs fel_unit_0/S00_AXI/S00_AXI_reg]
# set memory_segment  [get_bd_addr_segs /ps_0/Data/SEG_fel_unit_0_S00_AXI_reg]
# set_property offset [get_memory_offset fel_unit] $memory_segment
# set_property range [get_memory_range fel_unit] $memory_segment
# 
####################################################################
# DMA
####################################################################
#
cell xilinx.com:ip:smartconnect:1.0 dma_interconnect_omc {
  NUM_SI 1
  NUM_MI 1
} {
  aclk ${ps_name}/FCLK_CLK0
  aresetn proc_sys_reset_0/peripheral_aresetn
  M00_AXI ${ps_name}/S_AXI_GP0
}

cell xilinx.com:ip:smartconnect:1.0 dma_interconnect_s2mm {
  NUM_SI 1
  NUM_MI 1
  S00_AXIHAS_REGSLICE 1
} {
  aclk ${ps_name}/FCLK_CLK0
  aresetn proc_sys_reset_0/peripheral_aresetn
  M00_AXI ${ps_name}/S_AXI_HP2
}

cell xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_s2mm {
  S_TDATA_NUM_BYTES 4
  M_TDATA_NUM_BYTES 8
  HAS_TLAST.VALUE_SRC USER 
  HAS_TKEEP.VALUE_SRC USER
  HAS_TLAST {0}
  HAS_TKEEP {1}
} {
  aclk adc_dac/adc_clk
  aresetn rst_adc_clk/peripheral_aresetn
}

cell xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_s2mm {
  TDATA_NUM_BYTES 8
} {
  s_axis_aclk adc_dac/adc_clk
  s_axis_aresetn rst_adc_clk/peripheral_aresetn
  m_axis_aclk ps_0/FCLK_CLK0
  m_axis_aresetn proc_sys_reset_0/peripheral_aresetn
  S_AXIS axis_dwidth_converter_s2mm/M_AXIS
}
cell koheron:user:tlast_gen:1.0 tlast_gen_s2mm {
  TDATA_WIDTH 64
  PKT_LENGTH [expr 1024 * 1024]
} {
  aclk ps_0/FCLK_CLK0
  resetn proc_sys_reset_0/peripheral_aresetn
  s_axis axis_clock_converter_s2mm/M_AXIS
}

cell xilinx.com:ip:axi_dma:7.1 axi_dma_0 {
  c_include_sg 1
  c_sg_include_stscntrl_strm 0
  c_sg_length_width 20
  c_s2mm_burst_size 16
  c_m_axi_s2mm_data_width 64
  c_mm2s_burst_size 16
  c_sg_include_stscntrl_strm {0} 
  c_include_mm2s {0} 
  c_include_s2mm {1}
  c_sg_length_width {26}
} {
  S_AXI_LITE axi_mem_intercon_0/M[add_master_interface]_AXI
  s_axi_lite_aclk ps_0/FCLK_CLK0
  M_AXI_SG dma_interconnect_omc/S00_AXI
  m_axi_sg_aclk ps_0/FCLK_CLK0
  M_AXI_S2MM dma_interconnect_s2mm/S00_AXI
  m_axi_s2mm_aclk ps_0/FCLK_CLK0
  axi_resetn proc_sys_reset_0/peripheral_aresetn
  S_AXIS_S2MM tlast_gen_s2mm/m_axis
}

# DMA AXI Lite
assign_bd_address [get_bd_addr_segs {axi_dma_0/S_AXI_LITE/Reg }]
set_property range [get_memory_range dma] [get_bd_addr_segs {ps_0/Data/SEG_axi_dma_0_Reg}]
set_property offset [get_memory_offset dma] [get_bd_addr_segs {ps_0/Data/SEG_axi_dma_0_Reg}]

# Scatter Gather interface in On Chip Memory
assign_bd_address [get_bd_addr_segs {ps_0/S_AXI_GP0/GP0_HIGH_OCM }]
set_property range 64K [get_bd_addr_segs {axi_dma_0/Data_SG/SEG_ps_0_GP0_HIGH_OCM}]
set_property offset [get_memory_offset ocm_mm2s] [get_bd_addr_segs {axi_dma_0/Data_SG/SEG_ps_0_GP0_HIGH_OCM}]

# S2MM on HP2
assign_bd_address [get_bd_addr_segs {ps_0/S_AXI_HP2/HP2_DDR_LOWOCM }]
set_property range [get_memory_range ram_s2mm] [get_bd_addr_segs {axi_dma_0/Data_S2MM/SEG_ps_0_HP2_DDR_LOWOCM}]
set_property offset [get_memory_offset ram_s2mm] [get_bd_addr_segs {axi_dma_0/Data_S2MM/SEG_ps_0_HP2_DDR_LOWOCM}]

# Unmap unused segments
exclude_bd_addr_seg [get_bd_addr_segs axi_dma_0/Data_SG/SEG_ps_0_GP0_M_AXI_GP0]
exclude_bd_addr_seg [get_bd_addr_segs axi_dma_0/Data_SG/SEG_ps_0_GP0_IOP]
exclude_bd_addr_seg [get_bd_addr_segs axi_dma_0/Data_SG/SEG_ps_0_GP0_DDR_LOWOCM]
exclude_bd_addr_seg [get_bd_addr_segs axi_dma_0/Data_SG/SEG_ps_0_GP0_QSPI_LINEAR]
exclude_bd_addr_seg [get_bd_addr_segs axi_dma_0/Data_S2MM/SEG_ps_0_GP0_HIGH_OCM]
exclude_bd_addr_seg [get_bd_addr_segs axi_dma_0/Data_S2MM/SEG_ps_0_HP0_DDR_LOWOCM]



#################################################################
## ADD REPO
#################################################################
connect_pin ps_0/IRQ_F2P [get_concat_pin [list axi_dma_0/s2mm_introut xadc_wiz_0/ip2intc_irpt]]

set_property "ip_repo_paths" "[concat [get_property ip_repo_paths [current_project]] [file normalize $project_path/ip_repo]]" "[current_project]"
 update_ip_catalog -rebuild 

cell user.org:user:adc_dataq_alpha:1.0 adc_dataq_alpha_0 {
} {
  M_AXIS axis_dwidth_converter_s2mm/S_AXIS
  
  clk_adc adc_dac/adc_clk
  clk_adc_rst_n rst_adc_clk/peripheral_aresetn
  clk_ip ps_0/FCLK_CLK0
  clk_ip_rst_n proc_sys_reset_0/peripheral_aresetn
  
  ext_trigger exp_io_5_p 

  adc_ch0 adc_dac/adc0
  adc_ch1 adc_dac/adc1
  adc_ch2 adc_dac/adc0
  adc_ch3 adc_dac/adc1

  unit_control [ctl_pin unit_control]
  datac_delay [ctl_pin datac_delay]
  datac_window [ctl_pin datac_window]

  adc_freq [sts_pin adc_freq] 
  up_time [sts_pin up_time] 
  unit_status_in [sts_pin unit_status_in] 
  bus_error_count [sts_pin bus_error_count] 
  bus_error_integrator [sts_pin bus_error_integrator] 
  tick_counter [sts_pin tick_counter] 
  datac_processed [sts_pin datac_processed] 


}


# cell user.org:user:adc_triggered_dataq:1.0 adc_triggered_dataq_0 {
# } {
#   S00_AXI axi_mem_intercon_0/M[add_master_interface]_AXI
#   clk_ref ps_0/FCLK_CLK0
#   s00_axi_aclk ps_0/FCLK_CLK0
#   s00_axi_aresetn proc_sys_reset_0/peripheral_aresetn
#   M00_AXIS axis_dwidth_converter_s2mm/S_AXIS
#   adc_clk adc_dac/adc_clk
#   adc_rst_n rst_adc_clk/peripheral_aresetn
#   ext_trigger exp_io_0_p
#   adc_ch0 adc_dac/adc0
#   adc_ch1 adc_dac/adc1
#   adc_ch2 adc_dac/adc0
#   adc_ch3 adc_dac/adc1
# 
# }
# assign_bd_address [get_bd_addr_segs {adc_triggered_dataq_0/S00_AXI/S00_AXI_reg }]
# set_property range [get_memory_range daqc_interface] [get_bd_addr_segs {ps_0/Data/SEG_adc_triggered_dataq_0_S00_AXI_reg}]
# set_property offset [get_memory_offset daqc_interface] [get_bd_addr_segs {ps_0/Data/SEG_adc_triggered_dataq_0_S00_AXI_reg}]

validate_bd_design



