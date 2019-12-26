# -------------------------------------------------------------------------------------------------
# FMC 
# -------------------------------------------------------------------------------------------------
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN G7} [get_ports FMC_CLK0_M2C_P]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN F7} [get_ports FMC_CLK0_M2C_N]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN M6} [get_ports FMC_CLK1_M2C_P]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN M5} [get_ports VCO_PWR_EN]

set_property -dict {PACKAGE_PIN C8} [get_ports adc_clk_p[0]]
set_property -dict {PACKAGE_PIN C7} [get_ports adc_clk_n[0]]
set_property -dict {PACKAGE_PIN D6} [get_ports adc_clk_p[1]]
set_property -dict {PACKAGE_PIN C6} [get_ports adc_clk_n[1]]

set_property -dict {PACKAGE_PIN J4} [get_ports adc_clk_p[2]]
set_property -dict {PACKAGE_PIN J3} [get_ports adc_clk_n[2]]
set_property -dict {PACKAGE_PIN L3} [get_ports adc_clk_p[3]]
set_property -dict {PACKAGE_PIN K3} [get_ports adc_clk_n[3]]


set_property PACKAGE_PIN A2 [get_ports cha_n[2]]
set_property PACKAGE_PIN B2 [get_ports cha_p[2]]
set_property PACKAGE_PIN A5 [get_ports cha_n[1]]
set_property PACKAGE_PIN B6 [get_ports cha_p[1]]
set_property PACKAGE_PIN B4 [get_ports cha_n[0]]
set_property PACKAGE_PIN B5 [get_ports cha_p[0]]
set_property PACKAGE_PIN A3 [get_ports cha_n[4]]
set_property PACKAGE_PIN A4 [get_ports cha_p[4]]
set_property PACKAGE_PIN B1 [get_ports cha_n[3]]
set_property PACKAGE_PIN C2 [get_ports cha_p[3]]
set_property PACKAGE_PIN C3 [get_ports cha_n[5]]
set_property PACKAGE_PIN C4 [get_ports cha_p[5]]
set_property PACKAGE_PIN B9 [get_ports cha_n[6]]
set_property PACKAGE_PIN C9 [get_ports cha_p[6]]


set_property PACKAGE_PIN A7 [get_ports chc_n[3]]
set_property PACKAGE_PIN B7 [get_ports chc_p[3]]
set_property PACKAGE_PIN A8 [get_ports chc_n[2]]
set_property PACKAGE_PIN A9 [get_ports chc_p[2]]
set_property PACKAGE_PIN A10 [get_ports chc_n[0]]
set_property PACKAGE_PIN B10 [get_ports chc_p[0]]
set_property PACKAGE_PIN D8 [get_ports chc_n[1]]
set_property PACKAGE_PIN D9 [get_ports chc_p[1]]
set_property PACKAGE_PIN D5 [get_ports chc_n[4]]
set_property PACKAGE_PIN E6 [get_ports chc_p[4]]
set_property PACKAGE_PIN E5 [get_ports chc_n[6]]
set_property PACKAGE_PIN F5 [get_ports chc_p[6]]
set_property PACKAGE_PIN E8 [get_ports chc_n[5]]
set_property PACKAGE_PIN F9 [get_ports chc_p[5]]


set_property PACKAGE_PIN E7 [get_ports che_n[3]]
set_property PACKAGE_PIN F8 [get_ports che_p[3]]
set_property PACKAGE_PIN D3 [get_ports che_n[1]]
set_property PACKAGE_PIN D4 [get_ports che_p[1]]
set_property PACKAGE_PIN C1 [get_ports che_n[2]]
set_property PACKAGE_PIN D1 [get_ports che_p[2]]
set_property PACKAGE_PIN F2 [get_ports che_n[6]]
set_property PACKAGE_PIN G2 [get_ports che_p[6]]
set_property PACKAGE_PIN E1 [get_ports che_n[4]]
set_property PACKAGE_PIN E2 [get_ports che_p[4]]
set_property PACKAGE_PIN E3 [get_ports che_n[0]]
set_property PACKAGE_PIN F3 [get_ports che_p[0]]
set_property PACKAGE_PIN G1 [get_ports che_n[5]]
set_property PACKAGE_PIN H2 [get_ports che_p[5]]


set_property PACKAGE_PIN F4 [get_ports chg_n[2]]
set_property PACKAGE_PIN G4 [get_ports chg_p[2]]
set_property PACKAGE_PIN K1 [get_ports chg_n[3]]
set_property PACKAGE_PIN K2 [get_ports chg_p[3]]
set_property PACKAGE_PIN H1 [get_ports chg_n[1]]
set_property PACKAGE_PIN J1 [get_ports chg_p[1]]
set_property PACKAGE_PIN H3 [get_ports chg_n[4]]
set_property PACKAGE_PIN H4 [get_ports chg_p[4]]
set_property PACKAGE_PIN L2 [get_ports chg_n[0]]
set_property PACKAGE_PIN M2 [get_ports chg_p[0]]
set_property PACKAGE_PIN M1 [get_ports chg_n[5]]
set_property PACKAGE_PIN N1 [get_ports chg_p[5]]
set_property PACKAGE_PIN N2 [get_ports chg_n[6]]
set_property PACKAGE_PIN N3 [get_ports chg_p[6]]

set_property -dict {IOSTANDARD LVCMOS18 SLEW SLOW PACKAGE_PIN N4} [get_ports ad9510_clk]
set_property -dict {IOSTANDARD LVCMOS18 SLEW SLOW PACKAGE_PIN M4} [get_ports ad9510_mosi]
set_property -dict {IOSTANDARD LVCMOS18 SLEW SLOW PACKAGE_PIN K5} [get_ports ad9510_csn]
set_property -dict {IOSTANDARD LVCMOS18 SLEW SLOW PACKAGE_PIN J5} [get_ports FMC_LA_N[33]]


create_clock -name adc_clk_p0 -period 4.00 [get_ports adc_clk_p[0]]
create_clock -name adc_clk_p1 -period 4.00 [get_ports adc_clk_p[1]]
create_clock -name adc_clk_p2 -period 4.00 [get_ports adc_clk_p[2]]
create_clock -name adc_clk_p3 -period 4.00 [get_ports adc_clk_p[3]]
set_clock_groups -name ad_clk_grp -group [get_clocks -include_generated_clocks adc_clk_p0] \
    -group [get_clocks -include_generated_clocks adc_clk_p2] \
    -group [get_clocks -include_generated_clocks adc_clk_p3] \
    -group [get_clocks -include_generated_clocks adc_clk_p1] -asynchronous

set_false_path -from [get_clocks clk_fpga_*] -to [get_clocks adc_clk_p*]
set_false_path -from [get_clocks adc_clk_p*] -to [get_clocks clk_fpga_*]
set_false_path -from [get_clocks clk_out1*] -to [get_clocks adc_clk_p*]
set_false_path -from [get_clocks adc_clk_p*] -to [get_clocks clk_out1*]
set_false_path -from [get_clocks userclk2*] -to [get_clocks clk_out1*]
set_false_path -from [get_clocks userclk2*] -to [get_clocks clk_fpga_*]
set_false_path -from [get_clocks clk_out1*] -to [get_clocks userclk2]
set_false_path -from [get_clocks clk_fpga_*] -to [get_clocks userclk2*]
set_false_path -from [get_clocks clk_fpga_*] -to [get_clocks clk_out1*]
set_false_path -from [get_clocks clk_fpga_0] -to [get_clocks clk_fpga_1]
set_false_path -from [get_clocks clk_fpga_1] -to [get_clocks clk_fpga_0]

set_input_delay -clock [get_clocks adc_clk_p0] -clock_fall -min -add_delay 4.400 [get_ports {cha_n[*]}]
set_input_delay -clock [get_clocks adc_clk_p0] -clock_fall -max -add_delay 1.700 [get_ports {cha_n[*]}]
set_input_delay -clock [get_clocks adc_clk_p0] -min -add_delay 4.400 [get_ports {cha_n[*]}]
set_input_delay -clock [get_clocks adc_clk_p0] -max -add_delay 1.700 [get_ports {cha_n[*]}]

set_input_delay -clock [get_clocks adc_clk_p0] -clock_fall -min -add_delay 4.400 [get_ports {cha_p[*]}]
set_input_delay -clock [get_clocks adc_clk_p0] -clock_fall -max -add_delay 1.700 [get_ports {cha_p[*]}]
set_input_delay -clock [get_clocks adc_clk_p0] -min -add_delay 4.400 [get_ports {cha_p[*]}]
set_input_delay -clock [get_clocks adc_clk_p0] -max -add_delay 1.700 [get_ports {cha_p[*]}]

set_input_delay -clock [get_clocks adc_clk_p0] -clock_fall -min -add_delay 4.400 [get_ports {chc_n[*]}]
set_input_delay -clock [get_clocks adc_clk_p0] -clock_fall -max -add_delay 1.700 [get_ports {chc_n[*]}]
set_input_delay -clock [get_clocks adc_clk_p0] -min -add_delay 4.400 [get_ports {chc_n[*]}]
set_input_delay -clock [get_clocks adc_clk_p0] -max -add_delay 1.700 [get_ports {chc_n[*]}]

set_input_delay -clock [get_clocks adc_clk_p0] -clock_fall -min -add_delay 4.400 [get_ports {chc_p[*]}]
set_input_delay -clock [get_clocks adc_clk_p0] -clock_fall -max -add_delay 1.700 [get_ports {chc_p[*]}]
set_input_delay -clock [get_clocks adc_clk_p0] -min -add_delay 4.400 [get_ports {chc_p[*]}]
set_input_delay -clock [get_clocks adc_clk_p0] -max -add_delay 1.700 [get_ports {chc_p[*]}]

set_input_delay -clock [get_clocks adc_clk_p0] -clock_fall -min -add_delay 4.400 [get_ports {che_n[*]}]
set_input_delay -clock [get_clocks adc_clk_p0] -clock_fall -max -add_delay 1.700 [get_ports {che_n[*]}]
set_input_delay -clock [get_clocks adc_clk_p0] -min -add_delay 4.400 [get_ports {che_n[*]}]
set_input_delay -clock [get_clocks adc_clk_p0] -max -add_delay 1.700 [get_ports {che_n[*]}]

set_input_delay -clock [get_clocks adc_clk_p0] -clock_fall -min -add_delay 4.400 [get_ports {che_p[*]}]
set_input_delay -clock [get_clocks adc_clk_p0] -clock_fall -max -add_delay 1.700 [get_ports {che_p[*]}]
set_input_delay -clock [get_clocks adc_clk_p0] -min -add_delay 4.400 [get_ports {che_p[*]}]
set_input_delay -clock [get_clocks adc_clk_p0] -max -add_delay 1.700 [get_ports {che_p[*]}]


set_input_delay -clock [get_clocks adc_clk_p0] -clock_fall -min -add_delay 4.400 [get_ports {chg_n[*]}]
set_input_delay -clock [get_clocks adc_clk_p0] -clock_fall -max -add_delay 1.700 [get_ports {chg_n[*]}]
set_input_delay -clock [get_clocks adc_clk_p0] -min -add_delay 4.400 [get_ports {chg_n[*]}]
set_input_delay -clock [get_clocks adc_clk_p0] -max -add_delay 1.700 [get_ports {chg_n[*]}]

set_input_delay -clock [get_clocks adc_clk_p0] -clock_fall -min -add_delay 4.400 [get_ports {chg_p[*]}]
set_input_delay -clock [get_clocks adc_clk_p0] -clock_fall -max -add_delay 1.700 [get_ports {chg_p[*]}]
set_input_delay -clock [get_clocks adc_clk_p0] -min -add_delay 4.400 [get_ports {chg_p[*]}]
set_input_delay -clock [get_clocks adc_clk_p0] -max -add_delay 1.700 [get_ports {chg_p[*]}]

