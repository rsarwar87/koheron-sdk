set_property PACKAGE_PIN AR19     [get_ports led[0]] ;# Bank  66 VCCO - VCC1V2   - IO_L9P_T1L_N4_AD12P_66
set_property PACKAGE_PIN AT17     [get_ports led[1]] ;# Bank  66 VCCO - VCC1V2   - IO_L7N_T1L_N1_QBC_AD13N_66
set_property PACKAGE_PIN AR17     [get_ports led[2]] ;# Bank  66 VCCO - VCC1V2   - IO_L7P_T1L_N0_QBC_AD13P_66
set_property PACKAGE_PIN AU19     [get_ports led[3]] ;# Bank  66 VCCO - VCC1V2   - IO_L6N_T0U_N11_AD6N_66
set_property PACKAGE_PIN AU20     [get_ports led[4]] ;# Bank  66 VCCO - VCC1V2   - IO_L6P_T0U_N10_AD6P_66
set_property PACKAGE_PIN AW21     [get_ports led[5]] ;# Bank  66 VCCO - VCC1V2   - IO_L4N_T0U_N7_DBC_AD7N_66
set_property PACKAGE_PIN AV21     [get_ports led[6]] ;# Bank  66 VCCO - VCC1V2   - IO_L4P_T0U_N6_DBC_AD7P_66
set_property PACKAGE_PIN AV17     [get_ports led[7]] ;# Bank  66 VCCO - VCC1V2   - IO_L3N_T0L_N5_AD15N_66
set_property IOSTANDARD  LVCMOS12 [get_ports led* ]   ;# Bank  66 VCCO - VCC1V2   - IO_L9P_T1L_N4_AD12P_66


#create_pblock adc_bufgmux
#add_cells_to_pblock [get_pblocks adc_bufgmux] [get_cells -quiet [list rfip_ex_i/clocking_block/bufgmux_adc0/inst/BUFGMUX_inst rfip_ex_i/clocking_block/bufgmux_adc1/inst/BUFGMUX_inst rfip_ex_i/clocking_block/bufgmux_adc2/inst/BUFGMUX_inst rfip_ex_i/clocking_block/bufgmux_adc3/inst/BUFGMUX_inst]]
#resize_pblock [get_pblocks adc_bufgmux] -add {CLOCKREGION_X4Y0:CLOCKREGION_X4Y1}
create_pblock pblock_dac_source_i
resize_pblock pblock_dac_source_i -add CLOCKREGION_X4Y4:CLOCKREGION_X5Y7


create_clock -period 8.138 -name pl_clk [get_ports pl_clk_p]

#set_property IOSTANDARD LVDCI_18 [get_ports pl_clk_p]
set_property IOSTANDARD LVDS_25 [get_ports pl_clk_p]
set_property IOSTANDARD LVDS_25 [get_ports pl_clk_n]
#set_property IOSTANDARD LVDCI_18 [get_ports pl_sysref_p]
set_property IOSTANDARD LVDS_25 [get_ports pl_sysref_p]
set_property IOSTANDARD LVDS_25 [get_ports pl_sysref_n]
set_property PACKAGE_PIN B8 [get_ports pl_clk_p]
set_property PACKAGE_PIN B10 [get_ports pl_sysref_p]



set_input_delay -clock [get_clocks pl_clk] -min -add_delay 8.068 [get_ports pl_sysref_p]
set_input_delay -clock [get_clocks pl_clk] -max -add_delay 8.123 [get_ports pl_sysref_p]




