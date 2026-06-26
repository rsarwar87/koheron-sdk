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
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 fmc_mgt_refclk0 


# Connect 42 to status register
connect_pins [get_constant_pin 42 32] [sts_pin forty_two]

source $project_path/sfp.tcl


