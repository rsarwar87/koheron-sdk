create_bd_port -dir O -from 2 -to 0 led

set IIC_FPGA [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_FPGA ]
set DP_AUX_OUT [ create_bd_port -dir O DP_AUX_OUT ]
set DP_AUX_OE [ create_bd_port -dir O DP_AUX_OE ]
set DP_AUX_IN [ create_bd_port -dir I DP_AUX_IN ]
set DP_HPD [ create_bd_port -dir I DP_HPD ]

connect_bd_net -net DP_AUX_IN_1 [get_bd_ports DP_AUX_IN] [get_bd_pins zynq_ultra_ps_e/dp_aux_data_in]
connect_bd_net -net DP_HPD_1 [get_bd_ports DP_HPD] [get_bd_pins zynq_ultra_ps_e/dp_hot_plug_detect]
connect_bd_net -net zynq_ultra_ps_e_dp_aux_data_oe_n [get_bd_pins zynq_ultra_ps_e/dp_aux_data_oe_n] [get_bd_ports DP_AUX_OE]
connect_bd_net -net zynq_ultra_ps_e_dp_aux_data_out [get_bd_pins zynq_ultra_ps_e/dp_aux_data_out] [get_bd_ports DP_AUX_OUT]




