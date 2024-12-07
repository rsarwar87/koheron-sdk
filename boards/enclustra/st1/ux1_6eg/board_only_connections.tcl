create_bd_port -dir O -from 2 -to 0 led

set IIC_FPGA [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_FPGA ]
set DP_AUX_OUT [ create_bd_port -dir O DP_AUX_OUT ]
set DP_AUX_OE [ create_bd_port -dir O DP_AUX_OE ]
set DP_AUX_IN [ create_bd_port -dir I DP_AUX_IN ]
set DP_HPD [ create_bd_port -dir I DP_HPD ]


connect_cell ps_0 {
    dp_aux_data_in DP_AUX_IN
    dp_hot_plug_detect DP_HPD
    dp_aux_data_oe_n DP_AUX_OE
    dp_aux_data_out DP_AUX_OUT
    IIC_1 IIC_FPGA
}

