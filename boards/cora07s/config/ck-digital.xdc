# ChipKit Outer Analog Header - as Digital I/O
# NOTE: The following constraints should be used when using these ports as digital I/O.
set_property -dict { PACKAGE_PIN F17   IOSTANDARD LVCMOS33 } [get_ports { ck_a[0] }]; #IO_L6N_T0_VREF_35 Sch=ck_a[0]
set_property -dict { PACKAGE_PIN J19   IOSTANDARD LVCMOS33 } [get_ports { ck_a[1] }]; #IO_L10N_T1_AD11N_35 Sch=ck_a[1]
set_property -dict { PACKAGE_PIN K17   IOSTANDARD LVCMOS33 } [get_ports { ck_a[2] }]; #IO_L12P_T1_MRCC_35 Sch=ck_a[2]
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { ck_a[3] }]; #IO_L11P_T1_SRCC_35 Sch=ck_a[3]
set_property -dict { PACKAGE_PIN N16   IOSTANDARD LVCMOS33 } [get_ports { ck_a[4] }]; #IO_L21N_T3_DQS_AD14N_35 Sch=ck_a[4]
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { ck_a[5] }]; #IO_L6P_T0_34 Sch=ck_a[5]

# ChipKit Inner Analog Header - as Digital I/O
# NOTE: The following constraints should be used when using the inner analog header ports as digital I/O.
set_property -dict { PACKAGE_PIN C20   IOSTANDARD LVCMOS33 } [get_ports { ck_a[6] }]; #IO_L1P_T0_AD0P_35 Sch=ad_p[0]
set_property -dict { PACKAGE_PIN B20   IOSTANDARD LVCMOS33 } [get_ports { ck_a[7] }]; #IO_L1N_T0_AD0N_35 Sch=ad_n[0]
set_property -dict { PACKAGE_PIN F19   IOSTANDARD LVCMOS33 } [get_ports { ck_a[8] }]; #IO_L15P_T2_DQS_AD12P_35 Sch=ad_p[12]
set_property -dict { PACKAGE_PIN F20   IOSTANDARD LVCMOS33 } [get_ports { ck_a[9] }]; #IO_L15N_T2_DQS_AD12N_35 Sch=ad_n[12]
set_property -dict { PACKAGE_PIN B19   IOSTANDARD LVCMOS33 } [get_ports { ck_a[10] }]; #IO_L2P_T0_AD8P_35 Sch=ad_p[8]
set_property -dict { PACKAGE_PIN A20   IOSTANDARD LVCMOS33 } [get_ports { ck_a[11] }]; #IO_L2N_T0_AD8N_35 Sch=ad_n[8]

