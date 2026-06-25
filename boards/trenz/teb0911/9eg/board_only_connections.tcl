# TEB0911 board-specific connections.
# Keep this file intentionally minimal; board IO is constrained in config/ports.xdc.
# Add optional peripheral wiring here for specific designs.

# Expose all FMC PL ports at the top level so board FMC constraints can apply.
# source $board_path/fmc_ports.tcl
# add_teb0911_fmc_ports
#
#
#
create_bd_port -dir O -from 1 -to 0 led 
create_bd_port -dir I dp_aux_data_in 
create_bd_port -dir O dp_aux_data_oe_n 
create_bd_port -dir O dp_aux_data_out 
create_bd_port -dir I dp_hot_plug_detect

connect_cell ps_0 {
  dp_aux_data_in dp_aux_data_in
  dp_hot_plug_detect dp_hot_plug_detect
  dp_aux_data_out dp_aux_data_out
  dp_aux_data_oe_n dp_aux_data_oe_n 
}

