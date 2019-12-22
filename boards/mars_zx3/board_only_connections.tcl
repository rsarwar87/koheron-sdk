set fpga_part              xc7z020clg484-2
regexp (.*?)(f.g) ${fpga_part} whole_match part fpga_package
set is_1_speedgrade [regexp -- "-1" ${fpga_part}]

if {$is_1_speedgrade} {
   set speedgrade 1
} else {
   set speedgrade 2
}

# End of write_mig_file_MercuryZX1_SDRAM_0()
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_0 
set FCLK_CLK1 [ create_bd_port -dir O -type clk FCLK_CLK1 ]
set RESET_N [ create_bd_port -dir O RESET_N ]
set SDIO0_CDN [ create_bd_port -dir I SDIO0_CDN ]
set SDIO0_WP [ create_bd_port -dir I SDIO0_WP ]
set UART_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART_0 ]


create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vp_Vn

cell xilinx.com:ip:xadc_wiz:3.3 xadc_wiz_0 {
  ENABLE_TEMP_BUS true
} {
  Vp_Vn Vp_Vn
  s_axi_lite axi_mem_intercon_0/M[add_master_interface]_AXI
  s_axi_aclk ${ps_name}/FCLK_CLK0
  s_axi_aresetn proc_sys_reset_0/peripheral_aresetn
}
assign_bd_address [get_bd_addr_segs xadc_wiz_0/s_axi_lite/Reg]


create_bd_port -dir O -from 7 -to 0 gpio
connect_bd_intf_net -intf_net processing_system7_1_iic_0 [get_bd_intf_ports IIC_0] [get_bd_intf_pins ${ps_name}/IIC_0]
connect_bd_net [get_bd_ports FCLK_CLK1] [get_bd_pins ${ps_name}/FCLK_CLK1]
connect_bd_net [get_bd_ports RESET_N] [get_bd_pins ${ps_name}/FCLK_RESET0_N]
connect_bd_net -net SDIO0_CDN_1 [get_bd_ports SDIO0_CDN] [get_bd_pins ${ps_name}/SDIO0_CDN]
connect_bd_net -net SDIO0_WP_1 [get_bd_ports SDIO0_WP] [get_bd_pins ${ps_name}/SDIO0_WP]
connect_bd_intf_net -intf_net processing_system7_0_UART_0 [get_bd_intf_ports UART_0] [get_bd_intf_pins ${ps_name}/UART_0]

