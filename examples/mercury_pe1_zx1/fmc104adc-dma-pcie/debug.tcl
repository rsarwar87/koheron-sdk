set_property HDL_ATTRIBUTE.DEBUG true [get_bd_nets {adc_spi_sck_o spi_sck_i_1 adc_spi_ss_o spi_ss_i_1 adc_spi_io0_o spi_sdi_i_1 spi_sdo_i_1 }]
apply_bd_automation -rule xilinx.com:bd_rule:debug -dict [list \
                                                          [get_bd_nets adc_spi_io0_o] {PROBE_TYPE "Data" CLK_SRC "/ps_0/FCLK_CLK1" SYSTEM_ILA "Auto" } \
                                                          [get_bd_nets adc_spi_sck_o] {PROBE_TYPE "Data" CLK_SRC "/ps_0/FCLK_CLK1" SYSTEM_ILA "Auto" } \
                                                          [get_bd_nets adc_spi_ss_o] {PROBE_TYPE "Data and Trigger" CLK_SRC "/ps_0/FCLK_CLK1" SYSTEM_ILA "Auto" } \
                                                          [get_bd_nets spi_sck_i_1] {PROBE_TYPE "Data" CLK_SRC "/ps_0/FCLK_CLK1" SYSTEM_ILA "Auto" } \
                                                          [get_bd_nets spi_sdi_i_1] {PROBE_TYPE "Data" CLK_SRC "/ps_0/FCLK_CLK1" SYSTEM_ILA "Auto" } \
                                                          [get_bd_nets spi_sdo_i_1] {PROBE_TYPE "Data" CLK_SRC "/ps_0/FCLK_CLK1" SYSTEM_ILA "Auto" } \
                                                          [get_bd_nets spi_ss_i_1] {PROBE_TYPE "Data and Trigger" CLK_SRC "/ps_0/FCLK_CLK1" SYSTEM_ILA "Auto" } \
                                                         ]
                                                         
set_property HDL_ATTRIBUTE.DEBUG true [get_bd_intf_nets {adc_dma/tlast_gen_0_m_axis adc_dma/tlast_gen_1_m_axis}]
apply_bd_automation -rule xilinx.com:bd_rule:debug -dict [list \
                                                          [get_bd_intf_nets adc_dma/tlast_gen_0_m_axis] {AXIS_SIGNALS "Data and Trigger" CLK_SRC "/ps_0/FCLK_CLK0" SYSTEM_ILA "Auto" APC_EN "0" } \
                                                          [get_bd_intf_nets adc_dma/tlast_gen_1_m_axis] {AXIS_SIGNALS "Data and Trigger" CLK_SRC "/ps_0/FCLK_CLK0" SYSTEM_ILA "Auto" APC_EN "0" } \
                                                         ]
move_bd_cells [get_bd_cells adc_dma] [get_bd_cells system_ila_1]

set_property HDL_ATTRIBUTE.DEBUG true [get_bd_nets {adc_data_in_d_1 adc_data_in_b_1 adc_error_1 adc_data_in_c_1 adc_data_in_a_1 adc_valid_1 }]
create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_0
set_property -dict [list CONFIG.C_NUM_OF_PROBES {9} CONFIG.C_ENABLE_ILA_AXI_MON {false} CONFIG.C_MONITOR_TYPE {Native}] [get_bd_cells ila_0]
connect_bd_net [get_bd_ports adc_data_in_b] [get_bd_pins ila_0/probe1]
connect_bd_net [get_bd_ports adc_valid] [get_bd_pins ila_0/probe4]
connect_bd_net [get_bd_ports adc_error] [get_bd_pins ila_0/probe5]
connect_bd_net [get_bd_ports adc_data_in_c] [get_bd_pins ila_0/probe2]
connect_bd_net [get_bd_ports adc_data_in_d] [get_bd_pins ila_0/probe3]
connect_bd_net [get_bd_pins ila_0/probe6] [get_bd_pins ctl/adc_delay_inc]
connect_bd_net [get_bd_pins ila_0/probe7] [get_bd_pins ctl/adc_delay_dec]
connect_bd_net [get_bd_pins ila_0/probe8] [get_bd_pins ctl/adc_clear_error]
connect_bd_net [get_bd_ports adc_data_in_a] [get_bd_pins ila_0/probe0]
connect_bd_net [get_bd_ports ClkAdc] [get_bd_pins ila_0/clk]

    create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 vio_0
    set_property -dict [list CONFIG.C_PROBE_IN4_WIDTH {32} CONFIG.C_PROBE_IN3_WIDTH {14} CONFIG.C_PROBE_IN2_WIDTH {14} CONFIG.C_PROBE_IN1_WIDTH {14} CONFIG.C_PROBE_IN0_WIDTH {14} CONFIG.C_NUM_PROBE_OUT {0} CONFIG.C_NUM_PROBE_IN {8}] [get_bd_cells vio_0]
    connect_bd_net [get_bd_pins vio_0/clk] [get_bd_pins ps_0/FCLK_CLK0]
    connect_bd_net [get_bd_ports adc_data_in_a] [get_bd_pins vio_0/probe_in0]
    connect_bd_net [get_bd_ports adc_data_in_b] [get_bd_pins vio_0/probe_in1]
    connect_bd_net [get_bd_ports adc_data_in_c] [get_bd_pins vio_0/probe_in2]
    connect_bd_net [get_bd_ports adc_data_in_d] [get_bd_pins vio_0/probe_in3]
    connect_bd_net [get_bd_pins vio_0/probe_in4] [get_bd_pins xdma/gpio2_io_o]
    connect_bd_net [get_bd_pins vio_0/probe_in5] [get_bd_pins xdma/xdma_0/user_lnk_up]
    connect_bd_net [get_bd_pins delay_refclk_200/locked] [get_bd_pins vio_0/probe_in6]
    connect_bd_net [get_bd_pins vio_0/probe_in7] [get_bd_pins SDRAM/mmcm_locked]
    set_property -dict [list CONFIG.C_PROBE_IN9_WIDTH {4} CONFIG.C_PROBE_IN8_WIDTH {4} CONFIG.C_NUM_PROBE_IN {10}] [get_bd_cells vio_0]
    connect_bd_net [get_bd_ports adc_error] [get_bd_pins vio_0/probe_in8]
    connect_bd_net [get_bd_ports adc_valid] [get_bd_pins vio_0/probe_in9]

    group_bd_cells adc_debug [get_bd_cells vio_0] [get_bd_cells ila_0]



set_property HDL_ATTRIBUTE.DEBUG true [get_bd_intf_nets {xdma/pcie_clock_converter_0_M_AXIS}]
set_property HDL_ATTRIBUTE.DEBUG true [get_bd_nets {xdma/bypass_controller_0_dsc_byp_load xdma/bypass_controller_0_dsc_byp_ctl xdma/bypass_controller_0_dsc_byp_dst_addr xdma/bypass_controller_0_dsc_byp_length xdma/xdma_0_c2h_dsc_byp_ready_0 }]
apply_bd_automation -rule xilinx.com:bd_rule:debug -dict [list \
                                                          [get_bd_nets xdma/bypass_controller_0_dsc_byp_ctl] {PROBE_TYPE "Data and Trigger" CLK_SRC "/xdma/xdma_0/axi_aclk" SYSTEM_ILA "Auto" } \
                                                          [get_bd_nets xdma/bypass_controller_0_dsc_byp_dst_addr] {PROBE_TYPE "Data and Trigger" CLK_SRC "/xdma/xdma_0/axi_aclk" SYSTEM_ILA "Auto" } \
                                                          [get_bd_nets xdma/bypass_controller_0_dsc_byp_length] {PROBE_TYPE "Data and Trigger" CLK_SRC "/xdma/xdma_0/axi_aclk" SYSTEM_ILA "Auto" } \
                                                          [get_bd_nets xdma/bypass_controller_0_dsc_byp_load] {PROBE_TYPE "Data and Trigger" CLK_SRC "/xdma/xdma_0/axi_aclk" SYSTEM_ILA "Auto" } \
                                                          [get_bd_intf_nets xdma/pcie_clock_converter_0_M_AXIS] {AXIS_SIGNALS "Data and Trigger" CLK_SRC "/xdma/xdma_0/axi_aclk" SYSTEM_ILA "Auto" APC_EN "0" } \
                                                          [get_bd_nets xdma/xdma_0_c2h_dsc_byp_ready_0] {PROBE_TYPE "Data and Trigger" CLK_SRC "/xdma/xdma_0/axi_aclk" SYSTEM_ILA "Auto" } \
                                                         ]
move_bd_cells [get_bd_cells xdma] [get_bd_cells system_ila_1]

set_property -dict [list CONFIG.C_BRAM_CNT {1} CONFIG.C_DATA_DEPTH {4096}] [get_bd_cells system_ila_0]

#set_property HDL_ATTRIBUTE.DEBUG true [get_bd_nets {xdma/bypass_controller_1_dsc_byp_load xdma/bypass_controller_1_dsc_byp_length xdma/bypass_controller_1_dsc_byp_dst_addr xdma/xdma_0_c2h_dsc_byp_ready_1 xdma/bypass_controller_1_dsc_byp_ctl xdma/bypass_controller_1_dsc_byp_src_addr }]
#set_property HDL_ATTRIBUTE.DEBUG true [get_bd_intf_nets {xdma/pcie_clock_converter_1_M_AXIS}]
#apply_bd_automation -rule xilinx.com:bd_rule:debug -dict [list \
                                                          [get_bd_nets xdma/xdma_0_c2h_dsc_byp_ready_1] {PROBE_TYPE "Data and Trigger" CLK_SRC "/xdma/util_ds_buf/IBUF_OUT" SYSTEM_ILA "Auto" } \
                                                         ]
