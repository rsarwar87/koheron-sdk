# Add PS and AXI Interconnect
set board_preset $board_path/config/board_preset.tcl
set obj [current_project]
set_property -name "board_part" -value "xilinx.com:zcu102:part0:3.3" -objects $obj
source $sdk_path/fpga/lib/starting_point_zynqmp.tcl

# Add config and status registers
source $sdk_path/fpga/lib/ctl_sts.tcl
add_ctl_sts

source $board_path/board_only_connections.tcl
source $board_path/sfp_ethernet.tcl

# Connect LEDs to config register
create_bd_port -dir O -from 7 -to 0 LED
create_bd_port -dir I -from 7 -to 0 DIP_SW
create_bd_port -dir I  SW_E
create_bd_port -dir I  SW_S
create_bd_port -dir I  SW_N
create_bd_port -dir I  SW_W
connect_port_pin LED [get_slice_pin [ctl_pin led] 7 0]

# Connect 42 to status register
connect_pins [get_constant_pin 42 32] [sts_pin forty_two]
connect_pins DIP_SW [sts_pin dip]
connect_pins [get_concat_pin [list SW_E SW_S SW_N SW_W]] [sts_pin sw]

# Connect SPI_0
#create_bd_intf_port -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 SPI_0
#connect_bd_intf_net [get_bd_intf_pins ps_0/SPI_0] [get_bd_intf_ports SPI_0]

# Connect IIC_0
#create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_0
#connect_bd_intf_net [get_bd_intf_pins ps_0/IIC_0] [get_bd_intf_ports IIC_0]
