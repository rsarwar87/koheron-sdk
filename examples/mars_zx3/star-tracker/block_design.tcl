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
# create_bd_port -dir I drv8825_fault_n_ra
create_bd_port -dir O drv8825_direction_ra
create_bd_port -dir O drv8825_step_ra
create_bd_port -dir O -from 2 -to 0 drv8825_mode_ra
create_bd_port -dir O drv8825_enable_n_ra
create_bd_port -dir O drv8825_sleep_n_ra
create_bd_port -dir O -type rst drv8825_rst_n_ra
# create_bd_port -dir I drv8825_fault_n_dc
create_bd_port -dir O drv8825_direction_dc
create_bd_port -dir O drv8825_step_dc
create_bd_port -dir O -from 2 -to 0 drv8825_mode_dc
create_bd_port -dir O drv8825_enable_n_dc
create_bd_port -dir O drv8825_sleep_n_dc
create_bd_port -dir O -type rst drv8825_rst_n_dc

add_files $project_path/hdl/drv8825.vhd
update_compile_order -fileset sources_1
add_files -fileset sim_1 $project_path/hdl/tb_drv8825.vhd
update_compile_order -fileset sim_1
create_bd_cell -type module -reference drv8825 drv8825_ra
create_bd_cell -type module -reference drv8825 drv8825_dc
add_files -fileset sim_1 -norecurse $project_path/hdl/tb_drv8825_behav.wcfg
set_property xsim.view $project_path/hdl/tb_drv8825_behav.wcfg [get_filesets sim_1]

connect_port_pin drv8825_rst_n_ra     drv8825_ra/drv8825_rst_n    
connect_port_pin drv8825_sleep_n_ra   drv8825_ra/drv8825_sleep_n  
connect_port_pin drv8825_enable_n_ra  drv8825_ra/drv8825_enable_n 
connect_port_pin drv8825_mode_ra      drv8825_ra/drv8825_mode     
connect_port_pin drv8825_step_ra      drv8825_ra/drv8825_step     
connect_port_pin drv8825_direction_ra drv8825_ra/drv8825_direction
# connect_port_pin drv8825_fault_n_ra   drv8825_ra/drv8825_fault_n  
connect_port_pin drv8825_rst_n_dc     drv8825_dc/drv8825_rst_n    
connect_port_pin drv8825_sleep_n_dc   drv8825_dc/drv8825_sleep_n  
connect_port_pin drv8825_enable_n_dc  drv8825_dc/drv8825_enable_n 
connect_port_pin drv8825_mode_dc      drv8825_dc/drv8825_mode     
connect_port_pin drv8825_step_dc      drv8825_dc/drv8825_step     
connect_port_pin drv8825_direction_dc drv8825_dc/drv8825_direction
# connect_port_pin drv8825_fault_n_dc   drv8825_dc/drv8825_fault_n  

connect_pins drv8825_ra/ctrl_cmdcontrol [ctl_pin cmdcontrol0]
connect_pins drv8825_ra/ctrl_trackctrl [ctl_pin trackctrl0]
connect_pins drv8825_ra/ctrl_backlash_duration [ctl_pin backlash_duration0]
connect_pins drv8825_ra/ctrl_backlash_tick [ctl_pin backlash_tick0]
connect_pins drv8825_ra/ctrl_cmdduration [ctl_pin cmdduration0]
connect_pins drv8825_ra/ctrl_cmdtick [ctl_pin cmdtick0]
connect_pins drv8825_ra/ctrl_status [sts_pin status0]
connect_pins drv8825_ra/ctrl_step_count [sts_pin step_count0]

connect_pins drv8825_dc/ctrl_cmdcontrol [ctl_pin cmdcontrol1]
connect_pins drv8825_dc/ctrl_trackctrl [ctl_pin trackctrl1]
connect_pins drv8825_dc/ctrl_backlash_duration [ctl_pin backlash_duration1]
connect_pins drv8825_dc/ctrl_backlash_tick [ctl_pin backlash_tick1]
connect_pins drv8825_dc/ctrl_cmdduration [ctl_pin cmdduration1]
connect_pins drv8825_dc/ctrl_cmdtick [ctl_pin cmdtick1]
connect_pins drv8825_dc/ctrl_status [sts_pin status1]
connect_pins drv8825_dc/ctrl_step_count [sts_pin step_count1]



set run_autowrapper 0
set obj [get_filesets sources_1]
set files [list \
"[file normalize "$project_path/hdl/system_top_PM3.vhd"]"\
]
add_files -norecurse -fileset $obj $files
set file "$project_path/hdl/system_top_PM3.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj
set obj [get_filesets sources_1]
set_property "top" "system_top" $obj

