


set_cell_props ps_0 {
  PSU__USE__S_AXI_GP0 1
  PSU__SAXIGP0__DATA_WIDTH {128} 
  PSU__USE__S_AXI_GP1 1
  PSU__SAXIGP1__DATA_WIDTH {128} 
}
connect_pins ps_0/saxihpc1_fpd_aclk ps_0/pl_clk0
connect_pins ps_0/saxihpc0_fpd_aclk ps_0/pl_clk0

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 gt_serial_port_0 
set gt_ref_clk_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 gt_ref_clk_0 ]
set_property -dict [ list \
 CONFIG.FREQ_HZ {156250000} \
 ] $gt_ref_clk_0

cell xilinx.com:ip:xxv_ethernet:3.2 xxv_ethernet_0 {
   BASE_R_KR {BASE-R} 
   DIFFCLK_BOARD_INTERFACE {Custom} 
   ENABLE_TIME_STAMPING {0} 
   GT_GROUP_SELECT {Quad_X1Y3} 
   INCLUDE_AXI4_INTERFACE 1
   INCLUDE_STATISTICS_COUNTERS {1} 
   ADD_GT_CNTRL_STS_PORTS {0}
   INCLUDE_USER_FIFO {1} 
   LANE1_GT_LOC {X1Y13} 
   LANE2_GT_LOC {X1Y15} 
   NUM_OF_CORES {2} 
} {
  gt_ref_clk gt_ref_clk_0
  gt_serial_port gt_serial_port_0
  rx_clk_out_0 xxv_ethernet_0/rx_core_clk_0 
  rx_clk_out_1 xxv_ethernet_0/rx_core_clk_1 
  rxoutclksel_in_0 [get_constant_pin 0 3]
  rxoutclksel_in_1 [get_constant_pin 0 3]
  txoutclksel_in_0 [get_constant_pin 0 3]
  txoutclksel_in_1 [get_constant_pin 0 3]
  sys_reset proc_sys_reset_0/peripheral_reset
  s_axi_aresetn_0 proc_sys_reset_0/peripheral_aresetn
  s_axi_aresetn_1 proc_sys_reset_0/peripheral_aresetn
  dclk ps_0/pl_clk0
  s_axi_aclk_0 ps_0/pl_clk0
  s_axi_aclk_1 ps_0/pl_clk0
  s_axi_0 axi_mem_intercon_0/M[add_master_interface]_AXI
}
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_mem_intercon_0/M[add_master_interface]_AXI] [get_bd_intf_pins xxv_ethernet_0/s_axi_1]
assign_bd_address [get_bd_addr_segs {xxv_ethernet_0/s_axi_0/Reg }]
set_property offset [get_memory_offset eth0_0] [get_bd_addr_segs {ps_0/Data/SEG_xxv_ethernet_0_Reg}]
set_property range [get_memory_range eth0_0] [get_bd_addr_segs {ps_0/Data/SEG_xxv_ethernet_0_Reg}]
assign_bd_address [get_bd_addr_segs {xxv_ethernet_0/s_axi_1/Reg }]
set_property offset [get_memory_offset eth0_1] [get_bd_addr_segs {ps_0/Data/SEG_xxv_ethernet_0_Reg1}]
set_property range [get_memory_range eth0_1] [get_bd_addr_segs {ps_0/Data/SEG_xxv_ethernet_0_Reg1}]
# connect_pins xxv_ethernet_0/rx_core_clk_0 xxv_ethernet_0/rx_clk_out_0
# connect_pins xxv_ethernet_0/rx_core_clk_1 xxv_ethernet_0/rx_clk_out_1
cell xilinx.com:ip:smartconnect:1.0 dma_interconnect_eth_0 {
  NUM_SI 3
  NUM_MI 1
  NUM_CLKS 3
} {
  aclk ps_0/pl_clk0
  aresetn proc_sys_reset_0/peripheral_aresetn
  M00_AXI ps_0/S_AXI_HPC0_FPD
  aclk1 xxv_ethernet_0/tx_clk_out_0
  aclk2 xxv_ethernet_0/rx_clk_out_0
}
cell xilinx.com:ip:smartconnect:1.0 dma_interconnect_eth_1 {
  NUM_SI 3
  NUM_MI 1
  NUM_CLKS 3
} {
  aclk ps_0/pl_clk0
  aresetn proc_sys_reset_0/peripheral_aresetn
  M00_AXI ps_0/S_AXI_HPC1_FPD
  aclk1 xxv_ethernet_0/tx_clk_out_1
  aclk2 xxv_ethernet_0/rx_clk_out_1
}
cell xilinx.com:ip:axi_dma:7.1 axi_mcdma_0 {
   c_group1_mm2s {0000000000000011} 
   c_group1_s2mm {0000000000000011} 
   c_m_axi_mm2s_data_width {64} 
   c_m_axis_mm2s_tdata_width {64} 
   c_mm2s_burst_size {16} 
   c_num_mm2s_channels {2} 
   c_num_s2mm_channels {2} 
   c_prmry_is_aclk_async {1} 
} {
  S_AXI_LITE axi_mem_intercon_0/M[add_master_interface]_AXI
  s_axi_lite_aclk ps_0/pl_clk0
  M_AXI_SG dma_interconnect_eth_0/S00_AXI
  m_axi_sg_aclk xxv_ethernet_0/tx_clk_out_0
  M_AXI_MM2S dma_interconnect_eth_0/S01_AXI
  m_axi_mm2s_aclk xxv_ethernet_0/tx_clk_out_0
  M_AXI_S2MM dma_interconnect_eth_0/S02_AXI
  m_axi_s2mm_aclk xxv_ethernet_0/rx_clk_out_0
  S_AXIS_S2MM xxv_ethernet_0/axis_rx_0
  M_AXIS_MM2S xxv_ethernet_0/axis_tx_0
  axi_resetn proc_sys_reset_0/peripheral_aresetn
}
cell xilinx.com:ip:axi_dma:7.1 axi_mcdma_1 {
   c_group1_mm2s {0000000000000011} 
   c_group1_s2mm {0000000000000011} 
   c_m_axi_mm2s_data_width {64} 
   c_m_axis_mm2s_tdata_width {64} 
   c_mm2s_burst_size {16} 
   c_num_mm2s_channels {2} 
   c_num_s2mm_channels {2} 
   c_prmry_is_aclk_async {1} 
} {
  S_AXI_LITE axi_mem_intercon_0/M[add_master_interface]_AXI
  s_axi_lite_aclk ps_0/pl_clk0
  M_AXI_SG dma_interconnect_eth_1/S00_AXI
  m_axi_sg_aclk xxv_ethernet_0/tx_clk_out_1
  M_AXI_MM2S dma_interconnect_eth_1/S01_AXI
  m_axi_mm2s_aclk xxv_ethernet_0/tx_clk_out_1
  M_AXI_S2MM dma_interconnect_eth_1/S02_AXI
  m_axi_s2mm_aclk xxv_ethernet_0/rx_clk_out_1
  S_AXIS_S2MM xxv_ethernet_0/axis_rx_1
  M_AXIS_MM2S xxv_ethernet_0/axis_tx_1
  axi_resetn proc_sys_reset_0/peripheral_aresetn
}

connect_pins xxv_ethernet_0/rx_reset_0 [get_not_pin axi_mcdma_0/s2mm_prmry_reset_out_n]
connect_pins xxv_ethernet_0/rx_reset_1 [get_not_pin axi_mcdma_1/s2mm_prmry_reset_out_n]
connect_pins xxv_ethernet_0/tx_reset_0 [get_not_pin axi_mcdma_0/mm2s_prmry_reset_out_n]
connect_pins xxv_ethernet_0/tx_reset_1 [get_not_pin axi_mcdma_1/mm2s_prmry_reset_out_n]

assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_SG]   [get_bd_addr_segs ps_0/SAXIGP0/HPC0_DDR_LOW] 
assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_MM2S] [get_bd_addr_segs ps_0/SAXIGP0/HPC0_DDR_LOW] 
assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_S2MM] [get_bd_addr_segs ps_0/SAXIGP0/HPC0_DDR_LOW] 
assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_SG]   [get_bd_addr_segs ps_0/SAXIGP0/HPC0_PCIE_LOW]
assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_MM2S] [get_bd_addr_segs ps_0/SAXIGP0/HPC0_PCIE_LOW]
assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_S2MM] [get_bd_addr_segs ps_0/SAXIGP0/HPC0_PCIE_LOW]
assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_SG]   [get_bd_addr_segs ps_0/SAXIGP0/HPC0_QSPI] 
assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_MM2S] [get_bd_addr_segs ps_0/SAXIGP0/HPC0_QSPI] 
assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_S2MM] [get_bd_addr_segs ps_0/SAXIGP0/HPC0_QSPI] 
assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces axi_mcdma_1/Data_SG]   [get_bd_addr_segs ps_0/SAXIGP1/HPC1_DDR_LOW] 
assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces axi_mcdma_1/Data_MM2S] [get_bd_addr_segs ps_0/SAXIGP1/HPC1_DDR_LOW] 
assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces axi_mcdma_1/Data_S2MM] [get_bd_addr_segs ps_0/SAXIGP1/HPC1_DDR_LOW] 
assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces axi_mcdma_1/Data_SG]   [get_bd_addr_segs ps_0/SAXIGP1/HPC1_PCIE_LOW]
assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces axi_mcdma_1/Data_MM2S] [get_bd_addr_segs ps_0/SAXIGP1/HPC1_PCIE_LOW]
assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces axi_mcdma_1/Data_S2MM] [get_bd_addr_segs ps_0/SAXIGP1/HPC1_PCIE_LOW]
assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces axi_mcdma_1/Data_SG]   [get_bd_addr_segs ps_0/SAXIGP1/HPC1_QSPI] 
assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces axi_mcdma_1/Data_MM2S] [get_bd_addr_segs ps_0/SAXIGP1/HPC1_QSPI] 
assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces axi_mcdma_1/Data_S2MM] [get_bd_addr_segs ps_0/SAXIGP1/HPC1_QSPI] 

group_bd_cells eth1 [get_bd_cells axi_mcdma_1] [get_bd_cells not_axi_mcdma_0_s2mm_prmry_reset_out_n] [get_bd_cells not_axi_mcdma_1_s2mm_prmry_reset_out_n] [get_bd_cells not_axi_mcdma_0_mm2s_prmry_reset_out_n] [get_bd_cells not_axi_mcdma_1_mm2s_prmry_reset_out_n] [get_bd_cells const_v0_w3] [get_bd_cells dma_interconnect_eth_0] [get_bd_cells axi_mcdma_0] [get_bd_cells dma_interconnect_eth_1] [get_bd_cells xxv_ethernet_0]
