# Add PS and AXI Interconnect
set board_preset $board_path/config/board_preset.tcl

source $sdk_path/fpga/lib/starting_point_zynqmp.tcl
set_property "ip_repo_paths" "[concat [get_property ip_repo_paths [current_project]] [file normalize $project_path/ip_cores]]" "[current_project]"
update_ip_catalog -rebuild 

# Add config and status registers
source $sdk_path/fpga/lib/ctl_sts.tcl
add_ctl_sts
source $board_path/board_only_connections.tcl

# Connect LEDs to config register
connect_port_pin led [get_slice_pin [ctl_pin led] 1 0]

create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 PL_MGT_CLK 


# Connect 42 to status register
connect_pins [get_constant_pin 42 32] [sts_pin forty_two]

# Configure Zynq Processing System
cell xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_0 {
    C_BUF_TYPE {IBUFDSGTE} 
    C_SIZE {6} 
} {
  CLK_IN_D PL_MGT_CLK
}
cell xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_1 {
    C_BUF_TYPE {BUFG_GT} 
    C_SIZE {6} 
} {
  BUFG_GT_I util_ds_buf_0/IBUF_DS_ODIV2
  BUFG_GT_CE [get_constant_pin 63 6]
}

cell trenz.biz:user:labtools_fmeter:1.0 labtools_fmeter_0 {
      C_REFCLK_HZ {[get_parameter fclk0]}
   C_CHANNELS {[get_parameter nclk]}
} {
  refclk  ps_0/pl_clk0
  fin util_ds_buf_1/BUFG_GT_O
  F0 [sts_pin clock0]
  F1 [sts_pin clock1]
  F2 [sts_pin clock2]
  F3 [sts_pin clock3]
  F4 [sts_pin clock4]
  F5 [sts_pin clock5]
}

