# -------------------------------------------------------------------------------------------------
# PMOD
# -------------------------------------------------------------------------------------------------
#bank 33 1.8 v only
set_property IOSTANDARD LVCMOS18 [get_ports PMOD_*]
set_property -dict {PACKAGE_PIN N6} [get_ports {PMOD_C[3]}]
set_property -dict {PACKAGE_PIN N7} [get_ports {PMOD_C[2]}]
set_property -dict {PACKAGE_PIN K7} [get_ports {PMOD_C[1]}]
set_property -dict {PACKAGE_PIN K8} [get_ports {PMOD_C[0]}]

set_property -dict {PACKAGE_PIN J6} [get_ports {PMOD_D[3]}]
set_property -dict {PACKAGE_PIN K6} [get_ports {PMOD_D[2]}]
set_property -dict {PACKAGE_PIN L8} [get_ports {PMOD_D[1]}]
set_property -dict {PACKAGE_PIN M8} [get_ports {PMOD_D[0]}]
