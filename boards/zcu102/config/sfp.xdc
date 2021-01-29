set_property PACKAGE_PIN B9       [get_ports SFP_SI5328_OUT_C_N] ;# Bank 230 - MGTREFCLK1N_230
set_property PACKAGE_PIN B10      [get_ports SFP_SI5328_OUT_C_P] ;# Bank 230 - MGTREFCLK1P_230
set_property PACKAGE_PIN H10      [get_ports SFP_SI5328_INT_ALM] ;# Bank  50 VCCO - VCC3V3   - IO_L2P_AD14P_50
set_property IOSTANDARD  LVCMOS33 [get_ports SFP_SI5328_INT_ALM] ;# Bank  50 VCCO - VCC3V3   - IO_L2P_AD14P_50


set_property PACKAGE_PIN R9       [get_ports SFP_REC_CLOCK_C_N] ;# Bank  67 VCCO - VADJ_FMC - IO_L11N_T1U_N9_GC_67
set_property IOSTANDARD  LVDS     [get_ports SFP_REC_CLOCK_C_N] ;# Bank  67 VCCO - VADJ_FMC - IO_L11N_T1U_N9_GC_67
set_property PACKAGE_PIN R10      [get_ports SFP_REC_CLOCK_C_P] ;# Bank  67 VCCO - VADJ_FMC - IO_L11P_T1U_N8_GC_67
set_property IOSTANDARD  LVDS     [get_ports SFP_REC_CLOCK_C_P] ;# Bank  67 VCCO - VADJ_FMC - IO_L11P_T1U_N8_GC_67
set_property PACKAGE_PIN A12      [get_ports SFP_TX_DISABLE[0]] ;# Bank  49 VCCO - VCC3V3   - IO_L9N_AD11N_49
set_property IOSTANDARD  LVCMOS33 [get_ports SFP_TX_DISABLE[0]] ;# Bank  49 VCCO - VCC3V3   - IO_L9N_AD11N_49
set_property PACKAGE_PIN A13      [get_ports SFP_TX_DISABLE[1]] ;# Bank  49 VCCO - VCC3V3   - IO_L9P_AD11P_49
set_property IOSTANDARD  LVCMOS33 [get_ports SFP_TX_DISABLE[1]] ;# Bank  49 VCCO - VCC3V3   - IO_L9P_AD11P_49
set_property PACKAGE_PIN B13      [get_ports SFP_TX_DISABLE[2]] ;# Bank  49 VCCO - VCC3V3   - IO_L8N_HDGC_49
set_property IOSTANDARD  LVCMOS33 [get_ports SFP_TX_DISABLE[2]] ;# Bank  49 VCCO - VCC3V3   - IO_L8N_HDGC_49
set_property PACKAGE_PIN C13      [get_ports SFP_TX_DISABLE[3]] ;# Bank  49 VCCO - VCC3V3   - IO_L8P_HDGC_49
set_property IOSTANDARD  LVCMOS33 [get_ports SFP_TX_DISABLE[3]] ;# Bank  49 VCCO - VCC3V3   - IO_L8P_HDGC_49
set_property PACKAGE_PIN D1       [get_ports SFP_RX_N[0]] ;# Bank 230 - MGTHRXN0_230
set_property PACKAGE_PIN C3       [get_ports SFP_RX_N[1]] ;# Bank 230 - MGTHRXN1_230
set_property PACKAGE_PIN B1       [get_ports SFP_RX_N[2]] ;# Bank 230 - MGTHRXN2_230
set_property PACKAGE_PIN A3       [get_ports SFP_RX_N[3]] ;# Bank 230 - MGTHRXN3_230
set_property PACKAGE_PIN D2       [get_ports SFP_RX_P[0]] ;# Bank 230 - MGTHRXP0_230
set_property PACKAGE_PIN C4       [get_ports SFP_RX_P[1]] ;# Bank 230 - MGTHRXP1_230
set_property PACKAGE_PIN B2       [get_ports SFP_RX_P[2]] ;# Bank 230 - MGTHRXP2_230
set_property PACKAGE_PIN A4       [get_ports SFP_RX_P[3]] ;# Bank 230 - MGTHRXP3_230
set_property PACKAGE_PIN E3       [get_ports SFP_TX_N[0]] ;# Bank 230 - MGTHTXN0_230
set_property PACKAGE_PIN D5       [get_ports SFP_TX_N[1]] ;# Bank 230 - MGTHTXN1_230
set_property PACKAGE_PIN B5       [get_ports SFP_TX_N[2]] ;# Bank 230 - MGTHTXN2_230
set_property PACKAGE_PIN A7       [get_ports SFP_TX_N[3]] ;# Bank 230 - MGTHTXN3_230
set_property PACKAGE_PIN E4       [get_ports SFP_TX_P[0]] ;# Bank 230 - MGTHTXP0_230
set_property PACKAGE_PIN D6       [get_ports SFP_TX_P[1]] ;# Bank 230 - MGTHTXP1_230
set_property PACKAGE_PIN B6       [get_ports SFP_TX_P[2]] ;# Bank 230 - MGTHTXP2_230
set_property PACKAGE_PIN A8       [get_ports SFP_TX_P[3]] ;# Bank 230 - MGTHTXP3_230


set_property -dict {PACKAGE_PIN C7} [get_ports {gt_ref_clk_0_clk_n}]
set_property -dict {PACKAGE_PIN C8} [get_ports {gt_ref_clk_0_clk_p}]


