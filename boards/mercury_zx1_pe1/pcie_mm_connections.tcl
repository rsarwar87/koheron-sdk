  set PCIE_MGT [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 PCIE_MGT ]
  set PCIE_PERST [ create_bd_port -dir I -type rst PCIE_PERST ]
  set MGT_RCLK0_PCIE_REFCLK [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 MGT_RCLK0_PCIE_REFCLK ]
cell xilinx.com:ip:util_ds_buf:2.1 util_ds_buf {
   C_BUF_TYPE {IBUFDSGTE}
} {
   CLK_IN_D MGT_RCLK0_PCIE_REFCLK
}
set idx1 [add_slave_interface $int_lbus]
set idx2 [add_slave_interface $int_mbus]
cell xilinx.com:ip:xdma:4.1 xdma_0 {
   axi_data_width 128_bit 
   axilite_master_en true
   axisten_freq 125 
   pciebar2axibar_axist_bypass 0x0000000000000000
   pf0_msi_enabled false 
   axilite_master_size {16} 
   pciebar2axibar_axil_master {0x40000000} 
   pf0_msix_cap_table_bir {BAR_1}
   pf0_msix_cap_pba_bir {BAR_1}
   pl_link_cap_max_link_speed 5.0_GT/s 
   pl_link_cap_max_link_width X4
   ref_clk_freq 100_MHz
   xdma_axi_intf_mm AXI_Memory_Mapped
   xdma_axilite_slave false 
   xdma_rnum_chnl 2 
   xdma_wnum_chnl 2
} {
   axi_aclk axi_mem_intercon_${int_lbus}/S${idx1}_ACLK
   axi_aresetn axi_mem_intercon_${int_lbus}/S${idx1}_ARESETN
   M_AXI_LITE axi_mem_intercon_0/S${idx1}_AXI
   M_AXI axi_mem_intercon_1/S${idx2}_AXI
   pcie_mgt PCIE_MGT
   sys_clk util_ds_buf/IBUF_OUT
   usr_irq_req [get_constant_pin 0 1] 
   sys_rst_n PCIE_PERST
}
connect_cell xdma_0 {
   axi_aclk axi_mem_intercon_${int_mbus}/S${idx2}_ACLK
   axi_aresetn axi_mem_intercon_${int_mbus}/S${idx2}_ARESETN
}

assign_bd_address




