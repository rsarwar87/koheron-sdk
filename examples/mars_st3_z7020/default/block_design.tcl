# Add PS and AXI Interconnect
set board_preset $board_path/config/board_preset.tcl
source $sdk_path/fpga/lib/starting_point.tcl

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 I2C_USER
create_bd_port -dir O -from 3 -to 0 LED_N
create_bd_port -dir O  DDR3_VSEL 

# Add config and status registers
source $sdk_path/fpga/lib/ctl_sts.tcl
add_ctl_sts

# Connect 42 to status register
connect_pins [get_constant_pin 0 1] DDR3_VSEL
connect_pins [get_constant_pin 42 32] [sts_pin forty_two]

# Add XADC for monitoring of Zynq temperature

create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vp_Vn
connect_pins LED_N [get_slice_pin [ctl_pin led] 3 0]

cell xilinx.com:ip:xadc_wiz:3.3 xadc_wiz_0 {
  CHANNEL_ENABLE_VP_VN {false}
} {
  Vp_Vn Vp_Vn
  s_axi_lite axi_mem_intercon_0/M[add_master_interface 0]_AXI
  s_axi_aclk ps_0/FCLK_CLK0
  s_axi_aresetn proc_sys_reset_0/peripheral_aresetn
}
assign_bd_address [get_bd_addr_segs xadc_wiz_0/s_axi_lite/Reg]


connect_bd_intf_net [get_bd_intf_ports I2C_USER] [get_bd_intf_pins ps_0/IIC_1]

connect_pin ps_0/IRQ_F2P [get_concat_pin xadc_wiz_0/ip2intc_irpt]

