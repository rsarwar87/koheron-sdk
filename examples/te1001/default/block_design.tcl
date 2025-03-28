# Add PS and AXI Interconnect
set board_preset $board_path/config/board_preset.tcl
source $sdk_path/fpga/lib/starting_point_xdma.tcl

# Add config and status registers
source $sdk_path/fpga/lib/ctl_sts.tcl
add_ctl_sts


# Connect 42 to status register
connect_pins [get_constant_pin 42 32] [sts_pin forty_two]

# Add XADC for monitoring of Zynq temperature

