# Add PS and AXI Interconnect
set board_preset $board_path/config/board_preset.tcl

source $sdk_path/fpga/lib/starting_point_zynqmp.tcl

# Add config and status registers
source $sdk_path/fpga/lib/ctl_sts.tcl
add_ctl_sts
source $board_path/board_only_connections.tcl

# Connect LEDs to config register
connect_port_pin led [get_slice_pin [ctl_pin led] 2 0]

# Connect 42 to status register
connect_pins [get_constant_pin 42 32] [sts_pin forty_two]

# Configure Zynq Processing System

