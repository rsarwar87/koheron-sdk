# Add PS and AXI Interconnect
set board_preset $board_path/config/board_preset.tcl
source $sdk_path/fpga/lib/starting_point.tcl

# Add config and status registers
source $sdk_path/fpga/lib/ctl_sts.tcl
add_ctl_sts

# Connect 42 to status register
connect_pins [get_constant_pin 42 32] [sts_pin forty_two]

# Add XADC for monitoring of Zynq temperature

create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vp_Vn

cell xilinx.com:ip:xadc_wiz:3.3 xadc_wiz_0 {
} {
  Vp_Vn Vp_Vn
  s_axi_lite axi_mem_intercon_0/M[add_master_interface 0]_AXI
  s_axi_aclk ps_0/FCLK_CLK0
  s_axi_aresetn proc_sys_reset_0/peripheral_aresetn
}
assign_bd_address [get_bd_addr_segs xadc_wiz_0/s_axi_lite/Reg]


set_property "ip_repo_paths" "[concat [get_property ip_repo_paths [current_project]] [file normalize $project_path/ip]]" "[current_project]"
 update_ip_catalog -rebuild 

set_cell_props ps_0 {
  PCW_FPGA1_PERIPHERAL_FREQMHZ {10} 
  PCW_EN_CLK1_PORT {1}
}
cell trenz.biz:user:labtools_fmeter:1.0 labtools_fmeter_0 {
   C_CHANNELS {1}
   C_REFCLK_HZ 50000000
} {
  refclk  ps_0/FCLK_CLK0
  fin  ps_0/FCLK_CLK1
}

connect_pin [sts_pin freq] labtools_fmeter_0/F0


