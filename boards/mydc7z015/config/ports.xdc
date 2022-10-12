set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

set_property PACKAGE_PIN U19 [get_ports {pmod1[0]}]
set_property PACKAGE_PIN AA14 [get_ports {pmod1[1]}]
set_property PACKAGE_PIN V19 [get_ports {pmod1[2]}]
set_property PACKAGE_PIN AA15 [get_ports {pmod1[3]}]
set_property PACKAGE_PIN AB16 [get_ports {pmod1[4]}]
set_property PACKAGE_PIN U17 [get_ports {pmod1[5]}]
set_property PACKAGE_PIN AB17 [get_ports {pmod1[6]}]
set_property PACKAGE_PIN U18 [get_ports {pmod1[7]}]

set_property PACKAGE_PIN AB13 [get_ports {pmod2[0]}]
set_property PACKAGE_PIN AA11 [get_ports {pmod2[1]}]
set_property PACKAGE_PIN AB14 [get_ports {pmod2[2]}]
set_property PACKAGE_PIN AB11 [get_ports {pmod2[3]}]
set_property PACKAGE_PIN Y14 [get_ports {pmod2[4]}]
set_property PACKAGE_PIN R17 [get_ports {pmod2[5]}]
set_property PACKAGE_PIN Y15 [get_ports {pmod2[6]}]
set_property PACKAGE_PIN T17 [get_ports {pmod2[7]}]


set_property PACKAGE_PIN U11 [get_ports {pmod3[0]}]
set_property PACKAGE_PIN V11 [get_ports {pmod3[1]}]
set_property PACKAGE_PIN U12 [get_ports {pmod3[2]}]
set_property PACKAGE_PIN W11 [get_ports {pmod3[3]}]
set_property PACKAGE_PIN W12 [get_ports {pmod3[4]}]
set_property PACKAGE_PIN AA12 [get_ports {pmod3[5]}]
set_property PACKAGE_PIN W13 [get_ports {pmod3[6]}]
set_property PACKAGE_PIN AB12 [get_ports {pmod3[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports pmod3*]

set_property PACKAGE_PIN Y18 [get_ports {sfp_ctrl_disable}]
set_property PACKAGE_PIN AA20 [get_ports {sfp_ctrl_txfault}]
set_property PACKAGE_PIN Y19 [get_ports {sfp_ctrl_los}]
set_property PACKAGE_PIN V18 [get_ports {sfp_ctrl_rate_sel}]
set_property PACKAGE_PIN AA17 [get_ports {sfp_ctrl_mode_def[0]}]
set_property PACKAGE_PIN AA16 [get_ports {sfp_ctrl_mode_def[1]}]
set_property PACKAGE_PIN W18 [get_ports {sfp_ctrl_mode_def[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports sfp_ctrl*]

set_property PACKAGE_PIN W2 [get_ports {sfp_tx_p}]
set_property PACKAGE_PIN Y2 [get_ports {sfp_tx_n}]
set_property PACKAGE_PIN W6 [get_ports {sfp_rx_p}]
set_property PACKAGE_PIN Y6 [get_ports {sfp_rx_n}]

set_property PACKAGE_PIN AA5 [get_ports {pcie_tx_p[0]}]
set_property PACKAGE_PIN AB5 [get_ports {pcie_tx_n[0]}]
set_property PACKAGE_PIN AA3 [get_ports {pcie_tx_p[1]}]
set_property PACKAGE_PIN AB3 [get_ports {pcie_tx_n[1]}]
set_property PACKAGE_PIN AA9 [get_ports {pcie_rx_p[0]}]
set_property PACKAGE_PIN AB9 [get_ports {pcie_rx_n[0]}]
set_property PACKAGE_PIN AA7 [get_ports {pcie_rx_p[1]}]
set_property PACKAGE_PIN AB7 [get_ports {pcie_rx_n[1]}]

set_property PACKAGE_PIN AB21 [get_ports pcie_ctrl_smbclk]
set_property PACKAGE_PIN AB22 [get_ports pcie_ctrl_smbdat]
set_property PACKAGE_PIN AB18 [get_ports pcie_ctrl_perst_n]
set_property PACKAGE_PIN AB19 [get_ports pcie_ctrl_wake]
set_property PACKAGE_PIN AA19 [get_ports pcie_ctrl_prsnt2]
set_property PULLUP true [get_ports pcie_ctrl_perst_n]
set_property PULLUP true [get_ports pcie_ctrl_prsnt2]
set_property PULLUP true [get_ports pcie_ctrl_wake]
set_property IOSTANDARD LVCMOS33 [get_ports pcie_ctrl*]


set_property PACKAGE_PIN U9 [get_ports {pcie_refclk_p}]  # 100 mhz pcie ?
set_property PACKAGE_PIN V9 [get_ports {pcie_refclk_n}]
set_property PACKAGE_PIN U5 [get_ports {sfp_refclk_p}]  # ?? sfp
set_property PACKAGE_PIN V5 [get_ports {sfp_refclk_n}]
create_clock -name gtrefclk_in_clk_p -period 10 [get_ports MGTREFCLK_p[1]]
create_clock -name gtrefclk_in_clk_p -period 10 [get_ports MGTREFCLK_n[1]]


set_property PACKAGE_PIN B2 [get_ports {fmc_c2m_p}]
set_property PACKAGE_PIN B1 [get_ports {fmc_c2m_n}]
set_property PACKAGE_PIN C6 [get_ports {fmc_m2c_p}]
set_property PACKAGE_PIN C5 [get_ports {fmc_m2c_n}]
set_property PACKAGE_PIN J3 [get_ports {fmc_present}]

set_property PACKAGE_PIN D1 [get_ports {fmc_p[0]}] # cc0
set_property PACKAGE_PIN C1 [get_ports {fmc_n[0]}] # cc0
set_property PACKAGE_PIN D5 [get_ports {fmc_p[1]}] # cc1
set_property PACKAGE_PIN C4 [get_ports {fmc_p[1]}] # cc1
set_property PACKAGE_PIN G4 [get_ports {fmc_p[2]}]
set_property PACKAGE_PIN F4 [get_ports {fmc_n[2]}]
set_property PACKAGE_PIN D7 [get_ports {fmc_p[3]}]
set_property PACKAGE_PIN D6 [get_ports {fmc_n[3]}]
set_property PACKAGE_PIN A2 [get_ports {fmc_p[4]}]
set_property PACKAGE_PIN A1 [get_ports {fmc_n[4]}]
set_property PACKAGE_PIN F5 [get_ports {fmc_p[5]}]
set_property PACKAGE_PIN E5 [get_ports {fmc_n[5]}]
set_property PACKAGE_PIN A7 [get_ports {fmc_p[6]}]
set_property PACKAGE_PIN A6 [get_ports {fmc_n[6]}]
set_property PACKAGE_PIN B4 [get_ports {fmc_p[7]}]
set_property PACKAGE_PIN B3 [get_ports {fmc_n[7]}]
set_property PACKAGE_PIN A5 [get_ports {fmc_p[8]}]
set_property PACKAGE_PIN A4 [get_ports {fmc_n[8]}]
set_property PACKAGE_PIN B7 [get_ports {fmc_p[9]}]
set_property PACKAGE_PIN B6 [get_ports {fmc_n[9]}]
set_property PACKAGE_PIN D3 [get_ports {fmc_p[10]}]
set_property PACKAGE_PIN C3 [get_ports {fmc_n[10]}]
set_property PACKAGE_PIN H1 [get_ports {fmc_p[11]}]
set_property PACKAGE_PIN G1 [get_ports {fmc_n[11]}]
set_property PACKAGE_PIN F2 [get_ports {fmc_p[12]}]
set_property PACKAGE_PIN F1 [get_ports {fmc_n[12]}]
set_property PACKAGE_PIN C8 [get_ports {fmc_p[13]}]
set_property PACKAGE_PIN B8 [get_ports {fmc_n[13]}]
set_property PACKAGE_PIN G6 [get_ports {fmc_p[14]}]
set_property PACKAGE_PIN F6 [get_ports {fmc_n[14]}]
set_property PACKAGE_PIN E4 [get_ports {fmc_p[15]}]
set_property PACKAGE_PIN E3 [get_ports {fmc_n[15]}]
set_property PACKAGE_PIN E2 [get_ports {fmc_p[16]}]
set_property PACKAGE_PIN D2 [get_ports {fmc_n[16]}]
set_property PACKAGE_PIN E8 [get_ports {fmc_p[17]}] # cc2
set_property PACKAGE_PIN D8 [get_ports {fmc_n[17]}] # cc2
set_property PACKAGE_PIN L2 [get_ports {fmc_p[18]}] # cc3
set_property PACKAGE_PIN L1 [get_ports {fmc_n[18]}] # cc3
set_property PACKAGE_PIN H4 [get_ports {fmc_p[19]}]
set_property PACKAGE_PIN H3 [get_ports {fmc_n[19]}]
set_property PACKAGE_PIN G3 [get_ports {fmc_p[20]}]
set_property PACKAGE_PIN G2 [get_ports {fmc_n[20]}]
set_property PACKAGE_PIN N8 [get_ports {fmc_p[21]}]
set_property PACKAGE_PIN P8 [get_ports {fmc_n[21]}]
set_property PACKAGE_PIN F7 [get_ports {fmc_p[22]}]
set_property PACKAGE_PIN E7 [get_ports {fmc_n[22]}]
set_property PACKAGE_PIN G8 [get_ports {fmc_p[23]}]
set_property PACKAGE_PIN G7 [get_ports {fmc_n[23]}]
set_property PACKAGE_PIN P6 [get_ports {fmc_p[24]}]
set_property PACKAGE_PIN G5 [get_ports {fmc_n[24]}]
set_property PACKAGE_PIN P7 [get_ports {fmc_p[25]}]
set_property PACKAGE_PIN R7 [get_ports {fmc_n[25]}]
set_property PACKAGE_PIN R5 [get_ports {fmc_p[26]}]
set_property PACKAGE_PIN R4 [get_ports {fmc_n[26]}]
set_property PACKAGE_PIN N4 [get_ports {fmc_p[27]}]
set_property PACKAGE_PIN N3 [get_ports {fmc_n[27]}]
set_property PACKAGE_PIN U2 [get_ports {fmc_p[28]}]
set_property PACKAGE_PIN U1 [get_ports {fmc_n[28]}]
set_property PACKAGE_PIN R3 [get_ports {fmc_p[29]}]
set_property PACKAGE_PIN R2 [get_ports {fmc_n[29]}]
set_property PACKAGE_PIN M4 [get_ports {fmc_p[30]}]
set_property PACKAGE_PIN M3 [get_ports {fmc_n[30]}]
set_property PACKAGE_PIN L6 [get_ports {fmc_p[31]}]
set_property PACKAGE_PIN M6 [get_ports {fmc_n[31]}]
set_property PACKAGE_PIN M2 [get_ports {fmc_p[32]}]
set_property PACKAGE_PIN M1 [get_ports {fmc_n[32]}]
set_property PACKAGE_PIN J2 [get_ports {fmc_p[33]}]
set_property PACKAGE_PIN J1 [get_ports {fmc_n[33]}]

set_property PACKAGE_PIN H5  [get_ports {fmc_sda}]
set_property PACKAGE_PIN H6  [get_ports {fmc_scl}]
set_property IOSTANDARD LVCMOS33 [get_ports fmc_s*]
set_property IOSTANDARD LVCMOS33 [get_ports fmc_p*]
set_property IOSTANDARD LVCMOS33 [get_ports fmc_n*]


#set_property IOSTANDARD LVCMOS33 [get_ports lcd_bl_en_io]
#set_property IOSTANDARD LVCMOS33 [get_ports lcd_disp_io]
#set_property IOSTANDARD LVCMOS33 [get_ports sys_led_io]
#set_property IOSTANDARD LVCMOS33 [get_ports tp_intn]
#set_property IOSTANDARD LVCMOS33 [get_ports tp_resetn_io]
#set_property PACKAGE_PIN H8 [get_ports lcd_bl_en_io]
#set_property PACKAGE_PIN R8 [get_ports lcd_disp_io]
#set_property PACKAGE_PIN K7 [get_ports sys_led_io]
#set_property PACKAGE_PIN K8 [get_ports tp_intn]
#set_property PACKAGE_PIN J8 [get_ports tp_resetn_io]
#set_property PULLUP true [get_ports lcd_bl_en_io]
#set_property PULLUP true [get_ports lcd_disp_io]
#set_property PULLUP true [get_ports tp_intn]
#set_property PULLUP true [get_ports tp_resetn_io]
#


set_property IOSTANDARD LVCMOS33 [get_ports gpio_0_tri_io]
set_property PACKAGE_PIN K7 [get_ports gpio_0_tri_io]


