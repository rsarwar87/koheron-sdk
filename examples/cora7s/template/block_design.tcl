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

# Connect LEDs to config register
connect_port_pin ck_outer_io_t [get_slice_pin [ctl_pin ck_outer_out] 15 0]
connect_port_pin ck_outer_io_o [get_slice_pin [ctl_pin ck_outer_t] 15 0]
connect_port_pin user_io_t [get_slice_pin [ctl_pin user_io_out] 12 0]
connect_port_pin user_io_o [get_slice_pin [ctl_pin user_io_t] 12 0]
connect_port_pin ck_inner_io_t [get_slice_pin [ctl_pin ck_inner_out] 13 0]
connect_port_pin ck_inner_io_o [get_slice_pin [ctl_pin ck_inner_t] 13 0]

connect_port_pin ck_outer_io_i [sts_pin ck_outer_in ]
connect_port_pin user_io_i [sts_pin user_io_in] 
connect_port_pin ck_inner_io_i [sts_pin ck_inner_in] 
connect_port_pin btns [sts_pin buttons]



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

move_bd_cells [get_bd_cells ctl] [get_bd_cells slice_15_0_ctl_ck_outer_t] [get_bd_cells slice_12_0_ctl_user_io_t] [get_bd_cells slice_15_0_ctl_ck_outer_out] [get_bd_cells slice_12_0_ctl_user_io_out] [get_bd_cells slice_13_0_ctl_ck_inner_out] [get_bd_cells slice_13_0_ctl_ck_inner_t]
