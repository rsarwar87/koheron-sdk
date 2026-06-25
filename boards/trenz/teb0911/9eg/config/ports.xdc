
# DisplayPort AUX + HPD
set_property PACKAGE_PIN AB1 [get_ports dp_aux_data_in] 
set_property PACKAGE_PIN V9  [get_ports dp_hot_plug_detect] 
set_property PACKAGE_PIN AA8 [get_ports dp_aux_data_out] 
set_property PACKAGE_PIN AA3 [get_ports dp_aux_data_oe_n] 

  set_property IOSTANDARD LVCMOS18 [get_ports dp_*]

# LEDs
set_property PACKAGE_PIN K14 [get_ports {led[0]}] 
set_property PACKAGE_PIN K10 [get_ports {led[1]}] 
  set_property IOSTANDARD LVCMOS18 [get_ports led[*]]


# GT Clocks
#B128-1
set_property PACKAGE_PIN N27 [get_ports {PL_MGT_CLK_clk_p[0]}]
#B129-1
set_property PACKAGE_PIN J27 [get_ports {PL_MGT_CLK_clk_p[1]}]
#B228-1
set_property PACKAGE_PIN J8  [get_ports {PL_MGT_CLK_clk_p[2]}]
#B130-1
set_property PACKAGE_PIN E27 [get_ports {PL_MGT_CLK_clk_p[3]}]
#B229-1
set_property PACKAGE_PIN E8  [get_ports {PL_MGT_CLK_clk_p[4]}]
#B230-1
set_property PACKAGE_PIN B10 [get_ports {PL_MGT_CLK_clk_p[5]}]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN PULLNONE [current_design]
