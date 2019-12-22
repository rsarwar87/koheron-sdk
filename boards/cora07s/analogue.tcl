  set Vaux0_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux0_0 ]
  set Vaux12_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux12_0 ]
  set Vaux13_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux13_0 ]
  set Vaux15_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux15_0 ]
  set Vaux1_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux1_0 ]
  set Vaux5_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux5_0 ]
  set Vaux6_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux6_0 ]
  set Vaux8_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux8_0 ]
  set Vaux9_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux9_0 ]

connect_cell xadc_wiz_0 {
    Vaux0 Vaux0_0
    Vaux1 Vaux1_0
    Vaux5 Vaux5_0
    Vaux6 Vaux6_0
    Vaux8 Vaux8_0
    Vaux9 Vaux9_0
    Vaux12 Vaux12_0
    Vaux13 Vaux13_0
    Vaux15 Vaux15_0
}

