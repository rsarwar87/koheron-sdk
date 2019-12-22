## ChipKit Outer Analog Header - as Single-Ended Analog Inputs
## NOTE: These ports can be used as single-ended analog inputs with voltages from 0-3.3V (ChipKit analog pins A0-A5) or as digital I/O.
## WARNING: Do not use both sets of constraints at the same time!
set_property -dict { PACKAGE_PIN E17   IOSTANDARD LVCMOS33 } [get_ports { Vaux1_0_v_p  }]; #IO_L3P_T0_DQS_AD1P_35 Sch=ck_an_p[0]
set_property -dict { PACKAGE_PIN D18   IOSTANDARD LVCMOS33 } [get_ports { Vaux1_0_v_n  }]; #IO_L3N_T0_DQS_AD1N_35 Sch=ck_an_n[0]
set_property -dict { PACKAGE_PIN E18   IOSTANDARD LVCMOS33 } [get_ports { Vaux9_0_v_p  }]; #IO_L5P_T0_AD9P_35 Sch=ck_an_p[1]
set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVCMOS33 } [get_ports { Vaux9_0_v_n  }]; #IO_L5N_T0_AD9N_35 Sch=ck_an_n[1]
set_property -dict { PACKAGE_PIN K14   IOSTANDARD LVCMOS33 } [get_ports { Vaux6_0_v_p  }]; #IO_L20P_T3_AD6P_35 Sch=ck_an_p[2]
set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports { Vaux6_0_v_n  }]; #IO_L20N_T3_AD6N_35 Sch=ck_an_n[2]
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { Vaux15_0_v_p }]; #IO_L24P_T3_AD15P_35 Sch=ck_an_p[3]
set_property -dict { PACKAGE_PIN J16   IOSTANDARD LVCMOS33 } [get_ports { Vaux15_0_v_n }]; #IO_L24N_T3_AD15N_35 Sch=ck_an_n[3]
set_property -dict { PACKAGE_PIN J20   IOSTANDARD LVCMOS33 } [get_ports { Vaux5_0_v_p  }]; #IO_L17P_T2_AD5P_35 Sch=ck_an_p[4]
set_property -dict { PACKAGE_PIN H20   IOSTANDARD LVCMOS33 } [get_ports { Vaux5_0_v_n  }]; #IO_L17N_T2_AD5N_35 Sch=ck_an_n[4]
set_property -dict { PACKAGE_PIN G19   IOSTANDARD LVCMOS33 } [get_ports { Vaux13_0_v_p }]; #IO_L18P_T2_AD13P_35 Sch=ck_an_p[5]
set_property -dict { PACKAGE_PIN G20   IOSTANDARD LVCMOS33 } [get_ports { Vaux13_0_v_n }]; #IO_L18N_T2_AD13N_35 Sch=ck_an_n[5]
#

## ChipKit Inner Analog Header - as Differential Analog Inputs
## NOTE: These ports can be used as differential analog inputs with voltages fr 0-1 (ChipKit analog pins A6-A11) or as digital I/O.
set_property -dict { PACKAGE_PIN C20   IOSTANDARD LVCMOS33 } [get_ports { Vaux0_0_v_p  }]; #IO_L1P_T0_AD0P_35 Sch=ad_p[0]
set_property -dict { PACKAGE_PIN B20   IOSTANDARD LVCMOS33 } [get_ports { Vaux0_0_v_n  }]; #IO_L1N_T0_AD0N_35 Sch=ad_n[0]
set_property -dict { PACKAGE_PIN F19   IOSTANDARD LVCMOS33 } [get_ports { Vaux12_0_v_p }]; #IO_L15P_T2_DQS_AD12P_35 Sch=ad_p[12]
set_property -dict { PACKAGE_PIN F20   IOSTANDARD LVCMOS33 } [get_ports { Vaux12_0_v_n }]; #IO_L15N_T2_DQS_AD12N_35 Sch=ad_n[12]
set_property -dict { PACKAGE_PIN B19   IOSTANDARD LVCMOS33 } [get_ports { Vaux8_0_v_p  }]; #IO_L2P_T0_AD8P_35 Sch=ad_p[8]
set_property -dict { PACKAGE_PIN A20   IOSTANDARD LVCMOS33 } [get_ports { Vaux8_0_v_n  }]; #IO_L2N_T0_AD8N_35 Sch=ad_n[8]
## WARNING: Do not use both sets of constraints at the same time!

