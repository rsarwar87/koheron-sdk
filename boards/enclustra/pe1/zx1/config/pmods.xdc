
# -------------------------------------------------------------------------------------------------
# PMOD
# -------------------------------------------------------------------------------------------------

#set_property -dict {PACKAGE_PIN AE5} [get_ports PMOD_A[7]]
#set_property -dict {PACKAGE_PIN AE6} [get_ports PMOD_A[6]]
#set_property -dict {PACKAGE_PIN AF3} [get_ports PMOD_A[5]]
#set_property -dict {PACKAGE_PIN AF4} [get_ports PMOD_A[4]]
#set_property -dict {PACKAGE_PIN AD7} [get_ports PMOD_A[3]]
#set_property -dict {PACKAGE_PIN AD8} [get_ports PMOD_A[2]]
#set_property -dict {PACKAGE_PIN AF7} [get_ports PMOD_A[1]]
#set_property -dict {PACKAGE_PIN AF8} [get_ports PMOD_A[0]]

#set_property -dict {PACKAGE_PIN AD3} [get_ports PMOD_B[7]]
#set_property -dict {PACKAGE_PIN AD4} [get_ports PMOD_B[6]]
#set_property -dict {PACKAGE_PIN AC1} [get_ports PMOD_B[5]]
#set_property -dict {PACKAGE_PIN AC2} [get_ports PMOD_B[4]]
#set_property -dict {PACKAGE_PIN AC5} [get_ports PMOD_B[3]]
#set_property -dict {PACKAGE_PIN AC6} [get_ports PMOD_B[2]]
#set_property -dict {PACKAGE_PIN AE1} [get_ports PMOD_B[1]]
#set_property -dict {PACKAGE_PIN AE2} [get_ports PMOD_B[0]]

#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN G1} [get_ports PMOD_A[7]] -- No Connect
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN H1} [get_ports PMOD_A[6]] -- No Connect
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN N6} [get_ports PMOD_A[5]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN N7} [get_ports PMOD_A[4]]
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN G2} [get_ports PMOD_A[3]] -- No Connect
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN G3} [get_ports PMOD_A[2]] -- No Connect
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN K7} [get_ports PMOD_A[1]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN K8} [get_ports PMOD_A[0]]

#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN F4} [get_ports PMOD_B[7]] -- No Connect
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN G4} [get_ports PMOD_B[6]] -- No Connect
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN J6} [get_ports PMOD_B[5]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN K6} [get_ports PMOD_B[4]]
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN E3} [get_ports PMOD_B[3]] -- No Connect
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN E4} [get_ports PMOD_B[2]] -- No Connect
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN L8} [get_ports PMOD_B[1]]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN M8} [get_ports PMOD_B[0]]

