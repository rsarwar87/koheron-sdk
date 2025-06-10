# Add PS and AXI Interconnect
set board_preset $board_path/config/board_preset.tcl

source $sdk_path/fpga/lib/starting_point_zynqmp.tcl
#source $board_path/board_only_connections_rf.tcl
#source $board_path/board_only_connections_ram_c0.tcl
#source $board_path/board_only_connections_ram_c1.tcl

create_bd_port -dir O -from 7 -to 0 led
# Add config and status registers
source $sdk_path/fpga/lib/ctl_sts.tcl
add_ctl_sts

# Connect 42 to status register
connect_port_pin led [get_slice_pin [ctl_pin led] 7 0]
connect_pins [get_constant_pin 42 32] [sts_pin forty_two]
# connect_pins xdma_0/M_AXIS_H2C_0 xdma_0/S_AXIS_C2H_0 
# connect_pins xdma_0/M_AXIS_H2C_1 xdma_0/S_AXIS_C2H_1 
