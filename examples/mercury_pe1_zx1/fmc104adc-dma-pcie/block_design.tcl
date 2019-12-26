# Add PS and AXI Interconnect
set board_preset $board_path/config/board_preset.tcl

source $sdk_path/fpga/lib/starting_point.tcl

# Add config and status registers
source $sdk_path/fpga/lib/ctl_sts.tcl
add_ctl_sts
source $board_path/board_only_connections.tcl
  
set_property "ip_repo_paths" "[concat [get_property ip_repo_paths [current_project]] [file normalize $project_path/ip_repo]]" "[current_project]"
update_ip_catalog -rebuild 

  set spi_sck_i [ create_bd_port -dir I spi_sck_i ]
  set spi_sck_o [ create_bd_port -dir O spi_sck_o ]
  set spi_sdi_i [ create_bd_port -dir I spi_sdi_i ]
  set spi_sdo_i [ create_bd_port -dir I spi_sdo_i ]
  set spi_sdo_o [ create_bd_port -dir O spi_sdo_o ]
  set spi_ss_i [ create_bd_port -dir I -from 7 -to 0 spi_ss_i ]
  set spi_ss_o [ create_bd_port -dir O -from 7 -to 0 spi_ss_o ]

  set adc_clock [ create_bd_port -dir I -from 4 -to 0 -type clk adc_clock ]
  set adc_data_in_a [ create_bd_port -dir I -from 13 -to 0 adc_data_in_a ]   
  set adc_data_in_b [ create_bd_port -dir I -from 13 -to 0 adc_data_in_b ]
  set adc_data_in_c [ create_bd_port -dir I -from 13 -to 0 adc_data_in_c ]
  set adc_data_in_d [ create_bd_port -dir I -from 13 -to 0 adc_data_in_d ]

  set adc_error [ create_bd_port -dir I -from 3 -to 0 adc_error ]
  set adc_valid [ create_bd_port -dir I -from 3 -to 0 adc_valid ] 
  set Clk200 [ create_bd_port -dir O -type clk  Clk200 ]
  set_property CONFIG.FREQ_HZ 200000000 [get_bd_ports Clk200]
  set ClkAdc [ create_bd_port -dir I -type clk ClkAdc ]
  set_property CONFIG.FREQ_HZ 250000000 [get_bd_ports ClkAdc]
  set adc_delay_dec [ create_bd_port -dir O -from 3 -to 0 adc_delay_dec ]
  set adc_delay_inc [ create_bd_port -dir O -from 3 -to 0 adc_delay_inc ]
  set adc_clear_error [ create_bd_port -dir O -from 3 -to 0 adc_clear_error ]
  set vco_en [create_bd_port -dir O -from 0 -to 0 VCO_PWR_EN]

connect_port_pin VCO_PWR_EN [get_slice_pin [ctl_pin vco_power_en] 0 0]
connect_port_pin adc_clear_error [get_slice_pin [ctl_pin adc_clear_error] 3 0]
connect_port_pin adc_delay_dec [get_slice_pin [ctl_pin adc_delay_dec] 3 0]
connect_port_pin adc_delay_inc [get_slice_pin [ctl_pin adc_delay_inc] 3 0]

connect_port_pin gpio [get_slice_pin [ctl_pin led] 7 0]
connect_pins [get_constant_pin 42 32] [sts_pin forty_two]
connect_pin [sts_pin adc_error] [get_concat_pin [list [get_constant_pin 0 28] adc_error]]
connect_pin [sts_pin adc_valid] [get_concat_pin [list [get_constant_pin 0 28] adc_valid]]
connect_pin [sts_pin adc_in0] [get_concat_pin [list [get_constant_pin 0 2] adc_data_in_a [get_constant_pin 0 2] adc_data_in_b]]
connect_pin [sts_pin adc_in1] [get_concat_pin [list [get_constant_pin 0 2] adc_data_in_c [get_constant_pin 0 2] adc_data_in_d]]
move_bd_cells [get_bd_cells ctl] [get_bd_cells slice_7_0_ctl_led] [get_bd_cells slice_0_0_ctl_vco_power_en] \
          [get_bd_cells slice_3_0_ctl_adc_delay_inc] [get_bd_cells slice_3_0_ctl_adc_delay_dec] \
          [get_bd_cells slice_3_0_ctl_adc_clear_error] [get_bd_cells slice_7_0_ctl_led]
move_bd_cells [get_bd_cells sts] [get_bd_cells const_v42_w32] [get_bd_cells const_v0_w28] \
          [get_bd_cells const_v0_w2] [get_bd_cells concat_dout_adc_valid] \
          [get_bd_cells concat_dout_adc_data_in_a_dout_adc_data_in_b] [get_bd_cells concat_dout_adc_error] \
          [get_bd_cells concat_dout_adc_data_in_c_dout_adc_data_in_d]  [get_bd_cells const_v42_w32]

# Connect LEDs to config register

# Connect 42 to status register

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

set idx [add_master_interface 0]
cell xilinx.com:ip:axi_quad_spi:3.2 adc_spi {
   C_NUM_SS_BITS {8} 
   C_USE_STARTUP {0} 
   C_USE_STARTUP_INT {0} 
} {
  s_axi_aclk ${ps_name}/FCLK_CLK0
  ext_spi_clk ${ps_name}/FCLK_CLK0
  s_axi_aresetn proc_sys_reset_0/peripheral_aresetn
  AXI_LITE axi_mem_intercon_0/M${idx}_AXI
  sck_i spi_sck_i 
  io1_i spi_sdi_i 
  io0_i spi_sdo_i 
  ss_i spi_ss_i 
  io0_o spi_sdo_o
  sck_o spi_sck_o 
  ss_o spi_ss_o 
}
assign_bd_address -offset [get_memory_offset adc_spi] -range [get_memory_range adc_spi] -target_address_space [get_bd_addr_spaces ps_0/Data] [get_bd_addr_segs adc_spi/AXI_LITE/Reg] -force 
cell xilinx.com:ip:proc_sys_reset:5.0 rst_ClkAdc_250M  {
} {
  slowest_sync_clk ClkAdc
  ext_reset_in ${ps_name}/FCLK_RESET0_N
}

set idx [add_master_interface 0]
# Add AXI stream FIFO
cell xilinx.com:ip:axi_clock_converter:2.1 adc_axi_clock_converter {
} {
  m_axi_aclk ClkAdc 
  m_axi_aresetn rst_ClkAdc_250M/peripheral_aresetn
  S_AXI axi_mem_intercon_0/M${idx}_AXI
  s_axi_aclk ps_0/FCLK_CLK0
  s_axi_aresetn proc_sys_reset_0/peripheral_aresetn
}
cell xilinx.com:ip:axis_dwidth_converter:1.1 adc_axis_dwidth_converter {
  S_TDATA_NUM_BYTES 2 
  M_TDATA_NUM_BYTES 4
} {
  aclk ClkAdc
  aresetn rst_ClkAdc_250M/peripheral_aresetn
}
cell xilinx.com:ip:axi_fifo_mm_s:4.1 adc_axis_fifo {
  C_USE_TX_DATA 0
  C_USE_TX_CTRL 0
  C_USE_RX_CUT_THROUGH true
  C_RX_FIFO_DEPTH 4096
  C_RX_FIFO_PF_THRESHOLD 4000
} {
  s_axi_aclk ClkAdc
  s_axi_aresetn rst_ClkAdc_250M/peripheral_aresetn
  S_AXI adc_axi_clock_converter/M_AXI
  AXI_STR_RXD adc_axis_dwidth_converter/M_AXIS
}
assign_bd_address -offset [get_memory_offset axi_fifo_mm_s] -range [get_memory_range axi_fifo_mm_s] -target_address_space [get_bd_addr_spaces ps_0/Data] [get_bd_addr_segs adc_fifo/adc_axis_fifo/S_AXI/Mem0] -force 

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
  aclk ClkAdc
  aresetn rst_ClkAdc_250M/peripheral_aresetn
  s_axis_tdata [get_concat_pin [list [get_constant_pin 0 2] adc_data_in_a [get_constant_pin 0 2] adc_data_in_b]]
  s_axis_tvalid axis_dwidth_converter_1/s_axis_tready
}
cell xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_0 {
  S_TDATA_NUM_BYTES 4
  M_TDATA_NUM_BYTES 8
} {
  aclk ClkAdc
  aresetn rst_ClkAdc_250M/peripheral_aresetn
  s_axis_tdata [get_concat_pin [list [get_constant_pin 0 2] adc_data_in_c [get_constant_pin 0 2] adc_data_in_d]]
  s_axis_tvalid axis_dwidth_converter_0/s_axis_tready
}

cell xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 {
  TDATA_NUM_BYTES 8
} {
  s_axis_aclk ClkAdc
  s_axis_aresetn rst_ClkAdc_250M/peripheral_aresetn
  m_axis_aclk ps_0/FCLK_CLK0
  m_axis_aresetn proc_sys_reset_0/peripheral_aresetn
  S_AXIS axis_dwidth_converter_0/M_AXIS
}

cell xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_1 {
  TDATA_NUM_BYTES 8
} {
  s_axis_aclk ClkAdc
  s_axis_aresetn rst_ClkAdc_250M/peripheral_aresetn
  m_axis_aclk ps_0/FCLK_CLK0
  m_axis_aresetn proc_sys_reset_0/peripheral_aresetn
  S_AXIS axis_dwidth_converter_1/M_AXIS
}

cell koheron:user:tlast_gen:1.0 tlast_gen_1 {
  TDATA_WIDTH 64
  PKT_LENGTH [expr 1024 * 1024]
} {
  aclk ps_0/FCLK_CLK0
  resetn proc_sys_reset_0/peripheral_aresetn
  s_axis axis_clock_converter_1/M_AXIS
}

cell koheron:user:tlast_gen:1.0 tlast_gen_0 {
  TDATA_WIDTH 64
  PKT_LENGTH [expr 1024 * 1024]
} {
  aclk ps_0/FCLK_CLK0
  resetn proc_sys_reset_0/peripheral_aresetn
  s_axis axis_clock_converter_0/M_AXIS
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
  S_AXI_LITE axi_mem_intercon_1/M[add_master_interface 1]_AXI
  S_AXIS_S2MM tlast_gen_1/m_axis
  s_axi_lite_aclk ps_0/FCLK_CLK1
  M_AXI_SG dma_interconnect_omc/S01_AXI
  m_axi_sg_aclk ps_0/FCLK_CLK0
  M_AXI_S2MM dma_interconnect_s2mm1/S00_AXI
  m_axi_s2mm_aclk ps_0/FCLK_CLK0
  axi_resetn proc_sys_reset_0/peripheral_aresetn
}
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
  S_AXI_LITE axi_mem_intercon_1/M[add_master_interface 1]_AXI
  s_axi_lite_aclk ps_0/FCLK_CLK1
  M_AXI_SG dma_interconnect_omc/S00_AXI
  m_axi_sg_aclk ps_0/FCLK_CLK0
  M_AXI_S2MM dma_interconnect_s2mm0/S00_AXI
  S_AXIS_S2MM tlast_gen_0/m_axis
  m_axi_s2mm_aclk ps_0/FCLK_CLK0
  axi_resetn proc_sys_reset_0/peripheral_aresetn
}

# DMA AXI Lite
assign_bd_address [get_bd_addr_segs {axi_dma_1/S_AXI_LITE/Reg }]
set_property range [get_memory_range dma1] [get_bd_addr_segs {ps_0/Data/SEG_axi_dma_1_Reg}]
set_property offset [get_memory_offset dma1] [get_bd_addr_segs {ps_0/Data/SEG_axi_dma_1_Reg}]
# DMA AXI Lite
assign_bd_address [get_bd_addr_segs {axi_dma_0/S_AXI_LITE/Reg }]
set_property range [get_memory_range dma0] [get_bd_addr_segs {ps_0/Data/SEG_axi_dma_0_Reg}]
set_property offset [get_memory_offset dma0] [get_bd_addr_segs {ps_0/Data/SEG_axi_dma_0_Reg}]

# Scatter Gather interface in On Chip Memory
assign_bd_address [get_bd_addr_segs {ps_0/S_AXI_GP0/GP0_HIGH_OCM }]
set_property range 32K [get_bd_addr_segs {axi_dma_0/Data_SG/SEG_ps_0_GP0_HIGH_OCM}]
set_property offset [get_memory_offset ocm_s2mm0] [get_bd_addr_segs {axi_dma_0/Data_SG/SEG_ps_0_GP0_HIGH_OCM}]
assign_bd_address [get_bd_addr_segs {ps_0/S_AXI_GP0/GP0_HIGH_OCM }]
set_property range 32K [get_bd_addr_segs {axi_dma_1/Data_SG/SEG_ps_0_GP0_HIGH_OCM}]
set_property offset [get_memory_offset ocm_s2mm1] [get_bd_addr_segs {axi_dma_1/Data_SG/SEG_ps_0_GP0_HIGH_OCM}]

# MM2S on HP2
assign_bd_address [get_bd_addr_segs {ps_0/S_AXI_HP0/HP0_DDR_LOWOCM }]
set_property range [get_memory_range ram_s2mm0] [get_bd_addr_segs {axi_dma_0/Data_S2MM/SEG_ps_0_HP0_DDR_LOWOCM}]
set_property offset [get_memory_offset ram_s2mm0] [get_bd_addr_segs {axi_dma_0/Data_S2MM/SEG_ps_0_HP0_DDR_LOWOCM}]

# S2MM on HP0
assign_bd_address [get_bd_addr_segs {ps_0/S_AXI_HP2/HP2_DDR_LOWOCM }]
set_property range [get_memory_range ram_s2mm1] [get_bd_addr_segs {axi_dma_1/Data_S2MM/SEG_ps_0_HP2_DDR_LOWOCM}]
set_property offset [get_memory_offset ram_s2mm1] [get_bd_addr_segs {axi_dma_1/Data_S2MM/SEG_ps_0_HP2_DDR_LOWOCM}]
group_bd_cells adc_dma [get_bd_cells tlast_gen_0] [get_bd_cells tlast_gen_1] [get_bd_cells axis_clock_converter_0] [get_bd_cells axi_dma_0] [get_bd_cells axi_dma_1] [get_bd_cells axis_clock_converter_1] [get_bd_cells concat_dout_adc_data_in_c_dout_adc_data_in_d] [get_bd_cells dma_interconnect_omc] [get_bd_cells const_v0_w2] [get_bd_cells axis_dwidth_converter_0] [get_bd_cells dma_interconnect_s2mm1] [get_bd_cells axis_dwidth_converter_1] [get_bd_cells concat_dout_adc_data_in_a_dout_adc_data_in_b] [get_bd_cells dma_interconnect_s2mm0]


set run_autowrapper 0
set obj [get_filesets sources_1]
set files [list \
"[file normalize "$project_path/trigger_single_ch.vhd"]"\
]
add_files -norecurse -fileset $obj $files
set run_autowrapper 0
set obj [get_filesets sources_1]
set files [list \
"[file normalize "$project_path/system_top_PE1.vhd"]"\
]
add_files -norecurse -fileset $obj $files
set files [list \
"[file normalize "$project_path/adc_data_fmc104.vhd"]"\
]
add_files -norecurse -fileset $obj $files
set file "$project_path/system_top_PE1.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj
set obj [get_filesets sources_1]
set_property "top" "system_top" $obj

create_bd_cell -type module -reference trigger_single_ch trigger_fifo
connect_cell trigger_fifo {
    CLK ClkAdc
    ADC_INPUT [get_concat_pin [list [get_constant_pin 0 2] adc_data_in_a]] 
    NEGATIVE [get_constant_pin 1 1] 
    THRESHOLD  [get_slice_pin [ctl_pin trigger_threshold0] 15 0]
    S adc_axis_dwidth_converter/S_AXIS

}
group_bd_cells adc_fifo [get_bd_cells slice_15_0_ctl_trigger_threshold0] [get_bd_cells const_v1_w1] [get_bd_cells adc_axis_fifo] [get_bd_cells concat_dout_adc_data_in_a] [get_bd_cells adc_axis_dwidth_converter] [get_bd_cells trigger_fifo] [get_bd_cells adc_axi_clock_converter] [get_bd_cells const_v0_w2]
# add pcie at after adding all interfaces to the ps_0 interconnect.
set int_bus 0   
# source $board_path/pcie_mm_connections.tcl
source $board_path/pcie_streaming_connections.tcl
set_cell_props xdma_0 {
    axilite_master_en {true} 
    axilite_master_size {16} 
    xdma_rnum_chnl {2} 
    xdma_wnum_chnl {2} 
    dsc_bypass_rd {0011} 
    dsc_bypass_wr {0011} 
    pf0_msix_cap_table_bir {BAR_1} 
    pf0_msix_cap_pba_bir {BAR_1}
}
cell xilinx.com:ip:axis_dwidth_converter:1.1 pcie_dwidth_converter_0 {
  S_TDATA_NUM_BYTES 4
  M_TDATA_NUM_BYTES 16
} {
  aclk ClkAdc
  aresetn rst_ClkAdc_250M/peripheral_aresetn
  s_axis_tdata adc_dma/concat_dout_adc_data_in_a_dout_adc_data_in_b/dout
  s_axis_tvalid pcie_dwidth_converter_0/s_axis_tready
}

cell xilinx.com:ip:axis_clock_converter:1.1 pcie_clock_converter_0 {
  TDATA_NUM_BYTES 16
} {
  s_axis_aclk ClkAdc
  s_axis_aresetn rst_ClkAdc_250M/peripheral_aresetn
  m_axis_aclk xdma_0/axi_aclk
  m_axis_aresetn xdma_0/axi_aresetn
  S_AXIS pcie_dwidth_converter_0/M_AXIS
  M_AXIS xdma_0/S_AXIS_C2H_0
}
cell xilinx.com:ip:axis_dwidth_converter:1.1 pcie_dwidth_converter_1 {
  S_TDATA_NUM_BYTES 4
  M_TDATA_NUM_BYTES 16
} {
  aclk ClkAdc
  aresetn rst_ClkAdc_250M/peripheral_aresetn
  s_axis_tdata adc_dma/concat_dout_adc_data_in_c_dout_adc_data_in_d/dout  
  s_axis_tvalid pcie_dwidth_converter_1/s_axis_tready
}

cell xilinx.com:ip:axis_clock_converter:1.1 pcie_clock_converter_1 {
  TDATA_NUM_BYTES 16
} {
  s_axis_aclk ClkAdc
  s_axis_aresetn rst_ClkAdc_250M/peripheral_aresetn
  m_axis_aclk xdma_0/axi_aclk
  m_axis_aresetn xdma_0/axi_aresetn
  S_AXIS pcie_dwidth_converter_1/M_AXIS
  M_AXIS xdma_0/S_AXIS_C2H_1
}
cell user.org:user:bypass_controller:1.0 bypass_controller_0 {
} {
  s00_axi_aclk  xdma_0/axi_aclk
  s00_axi_aresetn xdma_0/axi_aresetn
  dsc_byp_ready xdma_0/c2h_dsc_byp_ready_0
  dsc_byp_src_addr xdma_0/c2h_dsc_byp_src_addr_0
  dsc_byp_load xdma_0/c2h_dsc_byp_load_0
  dsc_byp_length xdma_0/c2h_dsc_byp_len_0
  dsc_byp_dst_addr  xdma_0/c2h_dsc_byp_dst_addr_0
  dsc_byp_ctl xdma_0/c2h_dsc_byp_ctl_0
}
cell user.org:user:bypass_controller:1.0 bypass_controller_1 {
} {
  s00_axi_aclk  xdma_0/axi_aclk
  s00_axi_aresetn xdma_0/axi_aresetn
  dsc_byp_ready xdma_0/c2h_dsc_byp_ready_1
  dsc_byp_src_addr xdma_0/c2h_dsc_byp_src_addr_1
  dsc_byp_load xdma_0/c2h_dsc_byp_load_1
  dsc_byp_length xdma_0/c2h_dsc_byp_len_1
  dsc_byp_dst_addr  xdma_0/c2h_dsc_byp_dst_addr_1
  dsc_byp_ctl xdma_0/c2h_dsc_byp_ctl_1
}
cell user.org:user:bypass_controller:1.0 bypass_controller_2 {
} {
  s00_axi_aclk  xdma_0/axi_aclk
  s00_axi_aresetn xdma_0/axi_aresetn
  dsc_byp_ready xdma_0/h2c_dsc_byp_ready_0
  dsc_byp_src_addr xdma_0/h2c_dsc_byp_src_addr_0
  dsc_byp_load xdma_0/h2c_dsc_byp_load_0
  dsc_byp_length xdma_0/h2c_dsc_byp_len_0
  dsc_byp_dst_addr  xdma_0/h2c_dsc_byp_dst_addr_0
  dsc_byp_ctl xdma_0/h2c_dsc_byp_ctl_0
}
cell user.org:user:bypass_controller:1.0 bypass_controller_3 {
} {
  s00_axi_aclk  xdma_0/axi_aclk
  s00_axi_aresetn xdma_0/axi_aresetn
  dsc_byp_ready xdma_0/h2c_dsc_byp_ready_1
  dsc_byp_src_addr xdma_0/h2c_dsc_byp_src_addr_1
  dsc_byp_load xdma_0/h2c_dsc_byp_load_1
  dsc_byp_length xdma_0/h2c_dsc_byp_len_1
  dsc_byp_dst_addr  xdma_0/h2c_dsc_byp_dst_addr_1
  dsc_byp_ctl xdma_0/h2c_dsc_byp_ctl_1
}

cell xilinx.com:ip:axi_gpio:2.0 pcie_gpio {
   C_ALL_INPUTS 1
   C_ALL_OUTPUTS_2 1
   C_IS_DUAL 1
} {
  s_axi_aclk  xdma_0/axi_aclk
  s_axi_aresetn xdma_0/axi_aresetn
  gpio_io_i [ctl_pin gpio_to_pcie]
}
connect_bd_net [get_bd_pins pcie_gpio/gpio2_io_o] [get_bd_pins sts/gpio_from_pcie]

cell xilinx.com:ip:axi_interconnect:2.1 pcie_interconnect {
   NUM_MI {5} 
} {
  S00_AXI     xdma_0/M_AXI_LITE
  M00_AXI     pcie_gpio/S_AXI
  M01_AXI     bypass_controller_0/S00_AXI
  M02_AXI     bypass_controller_1/S00_AXI
  M03_AXI     bypass_controller_2/S00_AXI
  M04_AXI     bypass_controller_3/S00_AXI
  ACLK xdma_0/axi_aclk
  S00_ACLK xdma_0/axi_aclk
  M00_ACLK xdma_0/axi_aclk
  M01_ACLK xdma_0/axi_aclk
  M02_ACLK xdma_0/axi_aclk
  M03_ACLK xdma_0/axi_aclk
  M04_ACLK xdma_0/axi_aclk
  ARESETN xdma_0/axi_aresetn
  S00_ARESETN xdma_0/axi_aresetn
  M00_ARESETN xdma_0/axi_aresetn
  M01_ARESETN xdma_0/axi_aresetn
  M02_ARESETN xdma_0/axi_aresetn
  M03_ARESETN xdma_0/axi_aresetn
  M04_ARESETN xdma_0/axi_aresetn
}

group_bd_cells xdma [get_bd_cells bypass_controller_2] [get_bd_cells bypass_controller_3] [get_bd_cells pcie_clock_converter_0] [get_bd_cells pcie_clock_converter_1] [get_bd_cells xdma_0] [get_bd_cells pcie_dwidth_converter_0] [get_bd_cells pcie_gpio] [get_bd_cells pcie_dwidth_converter_1] [get_bd_cells bypass_controller_0] [get_bd_cells bypass_controller_1] [get_bd_cells pcie_interconnect]
move_bd_cells [get_bd_cells xdma] [get_bd_cells util_ds_buf]
move_bd_cells [get_bd_cells xdma] [get_bd_cells const_v0_w1]
# connect_pins xdma_0/M_AXIS_H2C_0 xdma_0/S_AXIS_C2H_0 
# connect_pins xdma_0/M_AXIS_H2C_1 xdma_0/S_AXIS_C2H_1 
# Unmap unused segments
assign_bd_address -offset [get_memory_offset pcie_bypass_0] -range [get_memory_range pcie_bypass_0] -target_address_space [get_bd_addr_spaces xdma/xdma_0/M_AXI_LITE] [get_bd_addr_segs xdma/bypass_controller_0/S00_AXI/S00_AXI_reg] -force
assign_bd_address -offset [get_memory_offset pcie_bypass_1] -range [get_memory_range pcie_bypass_1] -target_address_space [get_bd_addr_spaces xdma/xdma_0/M_AXI_LITE] [get_bd_addr_segs xdma/bypass_controller_1/S00_AXI/S00_AXI_reg] -force
assign_bd_address -offset [get_memory_offset pcie_bypass_2] -range [get_memory_range pcie_bypass_2] -target_address_space [get_bd_addr_spaces xdma/xdma_0/M_AXI_LITE] [get_bd_addr_segs xdma/bypass_controller_2/S00_AXI/S00_AXI_reg] -force
assign_bd_address -offset [get_memory_offset pcie_bypass_3] -range [get_memory_range pcie_bypass_3] -target_address_space [get_bd_addr_spaces xdma/xdma_0/M_AXI_LITE] [get_bd_addr_segs xdma/bypass_controller_3/S00_AXI/S00_AXI_reg] -force
assign_bd_address -offset [get_memory_offset pcie_gpio] -range [get_memory_range pcie_gpio] -target_address_space [get_bd_addr_spaces xdma/xdma_0/M_AXI_LITE] [get_bd_addr_segs xdma/pcie_gpio/S_AXI/Reg] -force


cell xilinx.com:ip:clk_wiz:6.0 delay_refclk_200 {
   CLKOUT1_REQUESTED_OUT_FREQ {200.000} 
   MMCM_CLKOUT0_DIVIDE_F {5.000} 
   CLKOUT1_JITTER {114.829}
} {
  clk_in1  ps_0/FCLK_CLK1
  reset rst_mig_7series_0_100M/peripheral_reset
  clk_out1 Clk200
}


cell trenz.biz:user:labtools_fmeter:1.0 labtools_fmeter_0 {
   C_CHANNELS {10}
} {
  refclk  ps_0/FCLK_CLK1
}
connect_pin [sts_pin adc_clk0] labtools_fmeter_0/F0
connect_pin [sts_pin adc_clk1] labtools_fmeter_0/F1
connect_pin [sts_pin adc_clk2] labtools_fmeter_0/F2
connect_pin [sts_pin adc_clk3] labtools_fmeter_0/F3

cell xilinx.com:ip:vio:3.0 vio_0 {
   C_NUM_PROBE_IN {10} 
   C_PROBE_IN9_WIDTH {32} 
   C_PROBE_IN8_WIDTH {32} 
   C_PROBE_IN7_WIDTH {32} 
   C_PROBE_IN6_WIDTH {32} 
   C_PROBE_IN5_WIDTH {32} 
   C_PROBE_IN4_WIDTH {32} 
   C_PROBE_IN3_WIDTH {32} 
   C_PROBE_IN2_WIDTH {32} 
   C_PROBE_IN1_WIDTH {32} 
   C_PROBE_IN0_WIDTH {32} 
   C_NUM_PROBE_OUT {0} 
} {
  clk  ps_0/FCLK_CLK1
  probe_in0 labtools_fmeter_0/F0
  probe_in1 labtools_fmeter_0/F1
  probe_in2 labtools_fmeter_0/F2
  probe_in3 labtools_fmeter_0/F3
  probe_in4 labtools_fmeter_0/F4
  probe_in5 labtools_fmeter_0/F5
  probe_in6 labtools_fmeter_0/F6
  probe_in7 labtools_fmeter_0/F7
  probe_in8 labtools_fmeter_0/F8
  probe_in9 labtools_fmeter_0/F9
}

cell xilinx.com:ip:xlconcat:2.1 xlconcat_1 {
   IN0_WIDTH.VALUE_SRC USER
   NUM_PORTS {6} 
   IN0_WIDTH {5}
} {
  dout  labtools_fmeter_0/fin
  In0   adc_clock
  In1   ps_0/FCLK_CLK0
  In2   ps_0/FCLK_CLK1
  In3   xdma/xdma_0/axi_aclk
  In4   delay_refclk_200/clk_out1
  In5   SDRAM/ui_clk
}
group_bd_cells freq_counter [get_bd_cells xlconcat_1] [get_bd_cells labtools_fmeter_0] [get_bd_cells vio_0]



delete_bd_objs [get_bd_addr_segs adc_dma/axi_dma_0/Data_SG/SEG_ps_0_GP0_QSPI_LINEAR] [get_bd_addr_segs adc_dma/axi_dma_0/Data_SG/SEG_ps_0_GP0_DDR_LOWOCM]
delete_bd_objs [get_bd_addr_segs -excluded adc_dma/axi_dma_0/Data_SG/SEG_ps_0_GP0_M_AXI_GP1] [get_bd_addr_segs -excluded adc_dma/axi_dma_0/Data_SG/SEG_ps_0_GP0_IOP] [get_bd_addr_segs -excluded adc_dma/axi_dma_0/Data_SG/SEG_ps_0_GP0_M_AXI_GP0] [get_bd_addr_segs adc_dma/axi_dma_1/Data_SG/SEG_ps_0_GP0_QSPI_LINEAR] [get_bd_addr_segs adc_dma/axi_dma_1/Data_SG/SEG_ps_0_GP0_DDR_LOWOCM] [get_bd_addr_segs adc_dma/axi_dma_1/Data_S2MM/SEG_ps_0_HP2_HIGH_OCM] [get_bd_addr_segs adc_dma/axi_dma_0/Data_S2MM/SEG_ps_0_HP0_HIGH_OCM] [get_bd_addr_segs -excluded adc_dma/axi_dma_1/Data_SG/SEG_ps_0_GP0_M_AXI_GP1] [get_bd_addr_segs -excluded adc_dma/axi_dma_1/Data_SG/SEG_ps_0_GP0_M_AXI_GP0] [get_bd_addr_segs -excluded adc_dma/axi_dma_1/Data_SG/SEG_ps_0_GP0_IOP]

source  $project_path/debug.tcl
#
# Hack to change the 32 bit auto width in AXI_DMA S_AXI_S2MM
validate_bd_design
#
