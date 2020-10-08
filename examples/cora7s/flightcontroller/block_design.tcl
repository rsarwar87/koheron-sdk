# Add PS and AXI Interconnect
set board_preset $board_path/config/board_preset.tcl
source $sdk_path/fpga/lib/starting_point.tcl

# Add config and status registers
source $sdk_path/fpga/lib/ctl_sts.tcl
add_ctl_sts
source $board_path/board_connections.tcl
source $board_path/analogue.tcl
source $board_path/pmods.tcl

# Connect 42 to status register
connect_pins [get_constant_pin 42 32] [sts_pin forty_two]



set run_autowrapper 0
set obj [get_filesets sources_1]
set files [list \
"[file normalize "$board_path/config/system_top.vhd"]"\
]
add_files -norecurse -fileset $obj $files
set file "$board_path/config/system_top.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj
set obj [get_filesets sources_1]
set_property "top" "system_top" $obj
