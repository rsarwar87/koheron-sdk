create_bd_port -dir O -from 7 -to 0 gpio
set pl_clk1 [ create_bd_port -dir O -type clk pl_clk1 ]
set pl_resetn0 [ create_bd_port -dir O -type rst pl_resetn0 ]

connect_bd_net [get_bd_ports pl_clk1] [get_bd_pins $ps_name/pl_clk1]
connect_bd_net [get_bd_ports pl_resetn0] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins $ps_name/pl_resetn0]


cell xilinx.com:ip:system_management_wiz:1.3 xadc_wiz_0 {
  ENABLE_TEMP_BUS true
} {
  s_axi_lite axi_mem_intercon_0/M[add_master_interface]_AXI
  s_axi_aclk ${ps_name}/pl_clk0
  s_axi_aresetn proc_sys_reset_0/peripheral_aresetn
}
assign_bd_address [get_bd_addr_segs xadc_wiz_0/s_axi_lite/Reg]

