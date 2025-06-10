create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 C1_DDR4
set C1_SYS_CLK_1_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 C1_SYS_CLK ]
set_property -dict [ list \
   CONFIG.FREQ_HZ {299940000} \
] $C1_SYS_CLK_1_0

cell xilinx.com:ip:ddr4:2.2 ddr4_1 {
  C0.BANK_GROUP_WIDTH {2} \
  C0.CS_WIDTH {2} \
  C0.DDR4_AxiAddressWidth {32} \
  C0.DDR4_AxiDataWidth {256} \
  C0.DDR4_CasLatency {19} \
  C0.DDR4_Clamshell {true} \
  C0.DDR4_DataWidth {32} \
  C0.DDR4_InputClockPeriod {3334} \
  C0.DDR4_MemoryPart {MT40A1G8SA-075} \

} {
  C0_DDR4 C1_DDR4
  C0_SYS_CLK C1_SYS_CLK
}

cell xilinx.com:ip:axi_interconnect:2.1 ddr_interconnect_1 {
  NUM_MI {1} \
  NUM_SI {2} \
} {
 aclk ps_0/pl_clk0
 aresetn proc_sys_reset_0/peripheral_aresetn
 M00_aclk ddr4_1/c0_ddr4_ui_clk
 M00_aresetn ddr4_1/c0_init_calib_complete
 M00_AXI ddr4_1/C0_DDR4_S_AXI
 S00_ACLK ${ps_name}/pl_clk0
 S00_AXI axi_mem_intercon_0/M[add_master_interface]_AXI
 S00_ARESETN proc_sys_reset_0/peripheral_aresetn
 S01_ACLK ddr4_1/c0_ddr4_ui_clk
 S01_ARESETN ddr4_0/c0_init_calib_complete
}


cell xilinx.com:ip:axi_dma:7.1 ddr4_dma_1 {
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
  M_AXI_SG dma_interconnect_omc/S01_AXI
  m_axi_sg_aclk ps_0/pl_clk0
  m_axi_s2mm_aclk ddr4_1/c0_ddr4_ui_clk
  m_axi_mm2s_aclk ddr4_0/c0_ddr4_ui_clk
  M_AXI_S2MM ddr_interconnect_1/S01_AXI
  s2mm_prmry_reset_out_n ddr4_1/c0_ddr4_aresetn
}

