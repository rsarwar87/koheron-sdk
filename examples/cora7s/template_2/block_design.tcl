# Add PS and AXI Interconnect
set board_preset $board_path/config/board_preset.tcl
source $sdk_path/fpga/lib/starting_point.tcl

# Add config and status registers
source $sdk_path/fpga/lib/ctl_sts.tcl
add_ctl_sts
source $board_path/board_connections.tcl
source $board_path/analogue.tcl
#source $board_path/pmods.tcl

# Connect 42 to status register
connect_pins [get_constant_pin 42 32] [sts_pin forty_two]
create_bd_port -dir O -from 13 -to 0 ck_inner_io
create_bd_port -dir I -from 15 -to 0 ck_outer_io
create_bd_port -dir O -from  6 -to 0 user_dio
create_bd_port -dir O user_spi_mosi 
create_bd_port -dir O -from  1 -to 0 user_spi_ss
create_bd_port -dir O user_spi_sck 
create_bd_port -dir I user_spi_miso 

# Connect LEDs to config register
connect_port_pin ck_inner_io [get_slice_pin [ctl_pin ck_inner] 13 0]
connect_port_pin user_dio [get_slice_pin [ctl_pin user_io] 6 0]

connect_port_pin ck_outer_io [sts_pin ck_outer ]
connect_port_pin btns [sts_pin buttons]


  # Create instance: axi_spi, and set properties
  cell xilinx.com:ip:axi_quad_spi:3.2 axi_spi0 {
   C_USE_STARTUP {0} 
   C_USE_STARTUP_INT {0} 
  } {
    AXI_LITE axi_mem_intercon_0/M[add_master_interface]_AXI
    ext_spi_clk $ps_name/FCLK_CLK0
    s_axi_aclk $ps_name/FCLK_CLK0
    s_axi_aresetn proc_sys_reset_0/peripheral_aresetn
  }
  create_bd_addr_seg -range [get_memory_range axi_spi] -offset [get_memory_offset axi_spi] [get_bd_addr_spaces ps_0/Data] [get_bd_addr_segs axi_spi0/AXI_LITE/Reg] SEG_axi_spi0_Reg
  connect_bd_net [get_bd_ports user_spi_sck] [get_bd_pins axi_spi0/sck_o]
  connect_bd_net [get_bd_pins axi_spi0/sck_i] [get_bd_pins axi_spi0/sck_o]
  connect_bd_net [get_bd_ports user_spi_ss] [get_bd_pins axi_spi0/ss_o]
  connect_bd_net [get_bd_pins axi_spi0/ss_i] [get_bd_pins axi_spi0/ss_o]
  connect_bd_net [get_bd_pins axi_spi0/io1_i] [get_bd_ports user_spi_miso] 
  connect_bd_net [get_bd_pins axi_spi0/io0_i] [get_bd_pins axi_spi0/io0_o]
  connect_bd_net [get_bd_ports user_spi_mosi] [get_bd_pins axi_spi0/io0_o]

  connect_pin ps_0/IRQ_F2P [get_concat_pin [list xadc_wiz_0/ip2intc_irpt axi_iic/iic2intc_irpt axi_spi0/ip2intc_irpt] ] 

