
cell xilinx.com:ip:system_management_wiz:1.3 xadc_wiz_0 {
  ENABLE_TEMP_BUS true
} {
  s_axi_lite axi_mem_intercon_0/M[add_master_interface]_AXI
  s_axi_aclk ${ps_name}/pl_clk0
  s_axi_aresetn proc_sys_reset_0/peripheral_aresetn
}
assign_bd_address [get_bd_addr_segs xadc_wiz_0/s_axi_lite/Reg]


