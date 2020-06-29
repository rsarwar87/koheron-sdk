
# -------------------------------------------------------------------------------------------------
# Anios
# -------------------------------------------------------------------------------------------------
### bank 13 -- ANIOS A == VCC_IO_B13
set_property IOSTANDARD LVCMOS33 [get_ports ANIOS_A*]
set_property -dict {PACKAGE_PIN AF19} [get_ports {ANIOS_A[0]}]
set_property -dict {PACKAGE_PIN AF20} [get_ports {ANIOS_A[1]}]
set_property -dict {PACKAGE_PIN AE18} [get_ports {ANIOS_A[2]}]
set_property -dict {PACKAGE_PIN AF18} [get_ports {ANIOS_A[3]}]
set_property -dict {PACKAGE_PIN AE20} [get_ports {ANIOS_A[4]}]
set_property -dict {PACKAGE_PIN AE21} [get_ports {ANIOS_A[5]}]
set_property -dict {PACKAGE_PIN AD18} [get_ports {ANIOS_A[6]}]
set_property -dict {PACKAGE_PIN AD19} [get_ports {ANIOS_A[7]}]
set_property -dict {PACKAGE_PIN Y18} [get_ports {ANIOS_A[8]}]
set_property -dict {PACKAGE_PIN AA18} [get_ports {ANIOS_A[9]}]
set_property -dict {PACKAGE_PIN AE25} [get_ports {ANIOS_A[10]}]
set_property -dict {PACKAGE_PIN AE26} [get_ports {ANIOS_A[11]}]
set_property -dict {PACKAGE_PIN AF24} [get_ports {ANIOS_A[12]}]
set_property -dict {PACKAGE_PIN AF25} [get_ports {ANIOS_A[13]}]
set_property -dict {PACKAGE_PIN AD25} [get_ports {ANIOS_A[14]}]
set_property -dict {PACKAGE_PIN AD26} [get_ports {ANIOS_A[15]}]
set_property -dict {PACKAGE_PIN AA24} [get_ports {ANIOS_A[16]}]
set_property -dict {PACKAGE_PIN AB24} [get_ports {ANIOS_A[17]}]
set_property -dict {PACKAGE_PIN AB26} [get_ports {ANIOS_A[18]}]
set_property -dict {PACKAGE_PIN AC26} [get_ports {ANIOS_A[19]}]
set_property -dict {PACKAGE_PIN AA25} [get_ports {ANIOS_A[20]}]
set_property -dict {PACKAGE_PIN AB25} [get_ports {ANIOS_A[21]}]
set_property -dict {PACKAGE_PIN AD23} [get_ports {ANIOS_A[22]}]
set_property -dict {PACKAGE_PIN AD24} [get_ports {ANIOS_A[23]}]

set_property IOSTANDARD LVCMOS33 [get_ports ANIOS_B*]
set_property -dict {PACKAGE_PIN AA19} [get_ports {ANIOS_B[0]}]
set_property -dict {PACKAGE_PIN AB19} [get_ports {ANIOS_B[1]}]
set_property -dict {PACKAGE_PIN AC18} [get_ports {ANIOS_B[2]}]
set_property -dict {PACKAGE_PIN AC19} [get_ports {ANIOS_B[3]}]
set_property -dict {PACKAGE_PIN AA20} [get_ports {ANIOS_B[4]}]
set_property -dict {PACKAGE_PIN AB20} [get_ports {ANIOS_B[5]}]
set_property -dict {PACKAGE_PIN W20} [get_ports {ANIOS_B[6]}]
set_property -dict {PACKAGE_PIN Y20} [get_ports {ANIOS_B[7]}]
set_property -dict {PACKAGE_PIN AB21} [get_ports {ANIOS_B[8]}]
set_property -dict {PACKAGE_PIN AB22} [get_ports {ANIOS_B[9]}]
set_property -dict {PACKAGE_PIN AE22} [get_ports {ANIOS_B[10]}]
set_property -dict {PACKAGE_PIN AF22} [get_ports {ANIOS_B[11]}]
set_property -dict {PACKAGE_PIN AE23} [get_ports {ANIOS_B[12]}]
set_property -dict {PACKAGE_PIN AF23} [get_ports {ANIOS_B[13]}]
set_property -dict {PACKAGE_PIN AA22} [get_ports {ANIOS_B[14]}]
set_property -dict {PACKAGE_PIN AA23} [get_ports {ANIOS_B[15]}]
set_property -dict {PACKAGE_PIN V19} [get_ports {ANIOS_B[16]}]
# shared with Dip 0
set_property -dict {PACKAGE_PIN V18} [get_ports {ANIOS_B[17]}]
# shared with Dip 1
set_property -dict {PACKAGE_PIN W18} [get_ports {ANIOS_B[18]}]
# shared with DIP 2
set_property -dict {PACKAGE_PIN W19} [get_ports {ANIOS_B[19]}]
# shared with Dip 3
#bank 12 == VCC_CFG_MIO_B12 1.8-3.3
#NAND flash is disabled when VCC_CFG_MIO_B12 is 1.8 V;
#The RGMII Ethernet interface is specified only up to 2.5 V on the MIO pins by Xilinx
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN  Y10} [get_ports ANIOS_B[20]] # shared with Pb 0
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AA10} [get_ports ANIOS_B[21]] # shared with Pb  1
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN  Y12} [get_ports ANIOS_B[22]] # shared with Pb 2
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN  Y11} [get_ports ANIOS_B[23]] # shared with Pb 3
