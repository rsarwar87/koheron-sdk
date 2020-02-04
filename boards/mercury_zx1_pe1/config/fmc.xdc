
set_property -dict {IOSTANDARD LVDS PACKAGE_PIN C8} [get_ports {FMC_LACC_P[0]}]
set_property -dict {IOSTANDARD LVDS PACKAGE_PIN C7} [get_ports {FMC_LACC_N[0]}]
set_property -dict {IOSTANDARD LVDS PACKAGE_PIN D6} [get_ports {FMC_LACC_P[1]}]
set_property -dict {IOSTANDARD LVDS PACKAGE_PIN C6} [get_ports {FMC_LACC_N[1]}]


set_property -dict {IOSTANDARD LVDS PACKAGE_PIN C6} [get_ports {FMC_LACC_N[1]}]

set_property PACKAGE_PIN N4 [get_ports ad9510_sdata]
set_property IOSTANDARD LVCMOS18 [get_ports ad9510_sdata]
set_property PACKAGE_PIN M4 [get_ports ad9510_sclk]
set_property IOSTANDARD LVCMOS18 [get_ports ad9510_sclk]
set_property PACKAGE_PIN K5 [get_ports trigger_to_fpga]
set_property IOSTANDARD LVCMOS18 [get_ports trigger_to_fpga]
set_property PACKAGE_PIN J5 [get_ports ad9510_n_cs]
set_property IOSTANDARD LVCMOS18 [get_ports ad9510_n_cs]
