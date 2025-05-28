# Add PS and AXI Interconnect
set board_preset $board_path/config/board_preset.tcl

source $sdk_path/fpga/lib/starting_point.tcl

# Add config and status registers
source $sdk_path/fpga/lib/ctl_sts.tcl
add_ctl_sts
source $board_path/board_only_connections.tcl

# Connect LEDs to config register
connect_port_pin Led_N [get_slice_pin [ctl_pin led] 2 0]

# Connect 42 to status register
connect_pins [get_constant_pin 42 32] [sts_pin forty_two]

# Configure Zynq Processing System

# add pcie at after adding all interfaces to the ps_0 interconnect.
set int_bus 0   
#source $board_path/pcie_mm_connections.tcl
source $board_path/pcie_streaming_connections.tcl
connect_cell xdma_0 {
    M_AXIS_H2C_0 xdma_0/S_AXIS_C2H_0
    M_AXIS_H2C_1 xdma_0/S_AXIS_C2H_1
}
# connect_pins xdma_0/M_AXIS_H2C_0 xdma_0/S_AXIS_C2H_0 
# connect_pins xdma_0/M_AXIS_H2C_1 xdma_0/S_AXIS_C2H_1 
