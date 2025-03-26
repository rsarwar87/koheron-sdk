  set_property "ip_repo_paths" "[concat [get_property ip_repo_paths [current_project]] [file normalize $board_path/../ip]]" "[current_project]"
  update_ip_catalog -rebuild 

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 spi_rtl 
cell xilinx.com:ip:axi_quad_spi:3.2 axi_quad_spi_0 {
   C_FIFO_DEPTH {256} 
   C_SCK_RATIO {2} 
   C_SPI_MEMORY {2}
   C_SPI_MODE {2} 
} {
  AXI_LITE axi_mem_intercon_0/M[add_master_interface 0]_AXI
  ext_spi_clk $ps_name/axi_aclk
  s_axi_aclk $ps_name/axi_aclk
  s_axi_aresetn proc_sys_reset_0/peripheral_aresetn

  SPI_0 spi_rtl
}
assign_bd_address -offset [get_memory_offset qspi_0] -range [get_memory_range qspi_0] \
            -target_address_space [get_bd_addr_spaces xdma_0/M_AXI_LITE] \
            [get_bd_addr_segs axi_quad_spi_0/axi_lite/reg] 

create_bd_intf_port -mode Master -vlnv trenz.biz:user:SCF1001_bus_rtl:1.0 SCF
cell trenz.biz:user:SCF1001:1.0 SCF1001_0 {
} {
  SCF SCF
}

cell xilinx.com:ip:axi_iic:2.0 axi_iic_0 {
} {
  S_AXI axi_mem_intercon_0/M[add_master_interface 0]_AXI
  s_axi_aclk $ps_name/axi_aclk
  s_axi_aresetn proc_sys_reset_0/peripheral_aresetn

  IIC SCF1001_0/EMIO_I2C
}
assign_bd_address -offset [get_memory_offset iic_0] -range [get_memory_range iic_0] \
            -target_address_space [get_bd_addr_spaces xdma_0/M_AXI_LITE] \
            [get_bd_addr_segs axi_iic_0/s_axi/reg] 

