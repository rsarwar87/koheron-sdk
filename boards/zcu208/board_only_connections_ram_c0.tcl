create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 C0_DDR4
set C1_SYS_CLK_0_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 C0_SYS_CLK ]
set_property -dict [ list \
   CONFIG.FREQ_HZ {299940000} \
] $C1_SYS_CLK_0_0

cell xilinx.com:ip:ddr4:2.2 ddr4_0 {
  C0.BANK_GROUP_WIDTH {2} \
  C0.CS_WIDTH {2} \
  C0.DDR4_AxiAddressWidth {32} \
  C0.DDR4_AxiDataWidth {256} \
  C0.DDR4_CasLatency {19} \
  C0.DDR4_Clamshell {true} \
  C0.DDR4_DataWidth {32} \
  C0.DDR4_InputClockPeriod {3334} \
  C0.DDR4_MemoryPart {MT40A1G8SA-075} \
  ADDN_UI_CLKOUT1_FREQ_HZ {100} \
  C0_CLOCK_BOARD_INTERFACE {default_sysclk_c0_300mhz} \
  C0_DDR4_BOARD_INTERFACE {ddr4_sdram_c0} \

} {
  C0_SYS_CLK C0_SYS_CLK
  C0_DDR4 C0_DDR4
  sys_rst proc_sys_reset_0/peripheral_reset
}

cell xilinx.com:ip:axi_interconnect:2.1 ddr4_interconnect_0 {
  NUM_MI {1} \
  NUM_SI {3} \
} {
 aclk ps_0/pl_clk0
 aresetn proc_sys_reset_0/peripheral_aresetn
 M00_aclk ddr4_0/c0_ddr4_ui_clk
 M00_aresetn ddr4_0/c0_init_calib_complete
 M00_AXI ddr4_0/C0_DDR4_S_AXI
 S00_AXI axi_mem_intercon_0/M[add_master_interface]_AXI
 S00_ACLK ${ps_name}/pl_clk0
 S00_ARESETN proc_sys_reset_0/peripheral_aresetn
 S01_ACLK ddr4_0/c0_ddr4_ui_clk
 S01_ARESETN ddr4_0/c0_init_calib_complete
 S02_ACLK ddr4_0/c0_ddr4_ui_clk
 S02_ARESETN ddr4_0/c0_init_calib_complete
}

set_cell_props ps_0 {
  PSU__USE__S_AXI_GP6 {1} 
  PSU__SAXIGP6__DATA_WIDTH {32}
}
connect_pins ps_0/saxi_lpd_aclk ps_0/pl_clk0
cell xilinx.com:ip:smartconnect:1.0 dma_interconnect_omc {
  NUM_SI 2
  NUM_MI 1
} {
  aclk ${ps_name}/pl_clk0
  aresetn proc_sys_reset_0/peripheral_aresetn
  M00_AXI ${ps_name}/S_AXI_LPD
}

cell xilinx.com:ip:axi_dma:7.1 ddr4_dma_0 {
   c_addr_width {64} \
   c_include_mm2s {1} \
   c_include_s2mm {1} \
   c_m_axi_s2mm_data_width {512} \
   c_s2mm_burst_size {64} \
   c_s_axis_s2mm_tdata_width {512} \
   c_sg_include_stscntrl_strm {0} \
   c_sg_length_width {26} \
} {
  S_AXI_LITE axi_mem_intercon_0/M[add_master_interface]_AXI
  s_axi_lite_aclk ps_0/pl_clk0
  M_AXI_SG dma_interconnect_omc/S00_AXI
  m_axi_sg_aclk ps_0/pl_clk0
  m_axi_s2mm_aclk ddr4_0/c0_ddr4_ui_clk
  m_axi_mm2s_aclk ddr4_0/c0_ddr4_ui_clk
  M_AXI_S2MM ddr4_interconnect_0/S01_AXI
  M_AXI_MM2S ddr4_interconnect_0/S02_AXI
  s2mm_prmry_reset_out_n ddr4_0/c0_ddr4_aresetn
}

assign_bd_address -offset [get_memory_offset dma_c0] -range \
      [get_memory_range dma_c0] -target_address_space \
      [get_bd_addr_spaces ps_0/Data] [get_bd_addr_segs ddr4_dma_0/S_AXI_LITE/Reg]  
assign_bd_address -target_address_space /ddr4_dma_0/Data_SG [get_bd_addr_segs ps_0/SAXIGP6/LPD_DDR_LOW] -force
assign_bd_address -target_address_space /ddr4_dma_0/Data_SG [get_bd_addr_segs ps_0/SAXIGP6/LPD_DDR_HIGH] -force


assign_bd_address -offset [get_memory_offset ddr4_0] -range \
      [get_memory_range ddr4_0] -target_address_space \
      [get_bd_addr_spaces /ddr4_dma_0/Data_MM2S] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK]  
assign_bd_address -offset [get_memory_offset ddr4_0] -range \
      [get_memory_range ddr4_0] -target_address_space \
      [get_bd_addr_spaces /ddr4_dma_0/Data_S2MM] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK]  

assign_bd_address -offset [get_memory_offset ddr4_0] -range \
      [get_memory_range ddr4_0] -target_address_space \
      [get_bd_addr_spaces /ddr4_dma_0/Data_S2MM] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK]  

#assign_bd_address -offset [get_memory_offset ddr4_0] -range \
#      [get_memory_range ddr4_0] -target_address_space \
#      [get_bd_addr_spaces ps_0/Data] [get_bd_addr_segs ps_0/Data/SEG_ddr4_0_C0_DDR4_ADDRESS_BLOCK]  
#
