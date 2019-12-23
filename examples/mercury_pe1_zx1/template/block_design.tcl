# Add PS and AXI Interconnect
set board_preset $board_path/config/board_preset.tcl

source $sdk_path/fpga/lib/starting_point.tcl

# Add config and status registers
source $sdk_path/fpga/lib/ctl_sts.tcl
add_ctl_sts
source $board_path/board_only_connections.tcl

# Connect LEDs to config register
connect_port_pin gpio [get_slice_pin [ctl_pin led] 7 0]

# Connect 42 to status register
connect_pins [get_constant_pin 42 32] [sts_pin forty_two]

# Configure Zynq Processing System

set run_autowrapper 0
set extension pcie_
set obj [get_filesets sources_1]
set files [list \
"[file normalize "$board_path/config/system_top_${extension}PE1.vhd"]"\
]
add_files -norecurse -fileset $obj $files
set file "$board_path/config/system_top_${extension}PE1.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj
set obj [get_filesets sources_1]
set_property "top" "system_top" $obj

# add pcie at after adding all interfaces to the ps_0 interconnect.
set int_bus 0   
# source $board_path/pcie_mm_connections.tcl
source $board_path/pcie_streaming_connections.tcl
connect_cell xdma_0 {
    M_AXIS_H2C_0 xdma_0/S_AXIS_C2H_0
    M_AXIS_H2C_1 xdma_0/S_AXIS_C2H_1
}
# connect_pins xdma_0/M_AXIS_H2C_0 xdma_0/S_AXIS_C2H_0 
# connect_pins xdma_0/M_AXIS_H2C_1 xdma_0/S_AXIS_C2H_1 
