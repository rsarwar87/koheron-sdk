create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin0_01
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin1_01
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin2_01
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin3_01
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin4_01
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin5_01
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin6_01
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin7_01
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout00 
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout10 
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout20
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout30 
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout40 
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout50 
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout60 
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout70 

create_bd_intf_port -mode Slave -vlnv xilinx.com:display_usp_rf_data_converter:diff_pins_rtl:1.0 sysref_in 
set adc2_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 adc1_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {409600000} \
   ] $adc2_clk
set dac0_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 dac2_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {409600000} \
   ] $dac0_clk
#create_bd_intf_port -mode Slave -vlnv xilinx.com:display_usp_rf_data_converter:diff_pins_rtl:1.0 pl_clk 
#create_bd_intf_port -mode Slave -vlnv xilinx.com:display_usp_rf_data_converter:diff_pins_rtl:1.0 pl_sysref 

create_bd_port -dir I pl_sysref_n 
create_bd_port -dir I pl_sysref_p 
create_bd_port -dir I pl_clk_n 
create_bd_port -dir I pl_clk_p 

create_bd_port -dir I dac0_hw_trigger 
create_bd_port -dir I dac0_hw_trigger_en 
create_bd_port -dir I dac1_hw_trigger 
create_bd_port -dir I dac1_hw_trigger_en 
create_bd_port -dir I dac2_hw_trigger 
create_bd_port -dir I dac2_hw_trigger_en 
create_bd_port -dir I dac3_hw_trigger 
create_bd_port -dir I dac3_hw_trigger_en 



cell  xilinx.com:ip:usp_rf_data_converter:2.6 rfip {
    ADC0_Clock_Dist {0} \
    ADC0_Clock_Source {1} \
    ADC0_Multi_Tile_Sync {true} \
    ADC0_Outclk_Freq {307.200} \
    ADC0_PLL_Enable {true} \
    ADC0_Refclk_Freq {491.520} \
    ADC0_Sampling_Rate {4.9152} \
    ADC1_Clock_Dist {1} \
    ADC1_Clock_Source {1} \
    ADC1_Multi_Tile_Sync {true} \
    ADC1_Outclk_Freq {307.200} \
    ADC1_PLL_Enable {true} \
    ADC1_Refclk_Freq {491.520} \
    ADC1_Sampling_Rate {4.9152} \
    ADC2_Clock_Dist {0} \
    ADC2_Clock_Source {1} \
    ADC2_Multi_Tile_Sync {true} \
    ADC2_Outclk_Freq {307.200} \
    ADC2_PLL_Enable {true} \
    ADC2_Refclk_Div {1} \
    ADC2_Refclk_Freq {491.520} \
    ADC2_Sampling_Rate {4.9152} \
    ADC3_Clock_Dist {0} \
    ADC3_Clock_Source {1} \
    ADC3_Multi_Tile_Sync {true} \
    ADC3_Outclk_Freq {307.200} \
    ADC3_PLL_Enable {true} \
    ADC3_Refclk_Freq {491.520} \
    ADC3_Sampling_Rate {4.9152} \
    ADC_Data_Type00 {1} \
    ADC_Data_Type10 {1} \
    ADC_Data_Type20 {1} \
    ADC_Data_Type30 {1} \
    ADC_Data_Width00 {8} \
    ADC_Data_Width10 {8} \
    ADC_Data_Width20 {8} \
    ADC_Data_Width30 {8} \
    ADC_Decimation_Mode00 {2} \
    ADC_Decimation_Mode10 {2} \
    ADC_Decimation_Mode20 {2} \
    ADC_Decimation_Mode30 {2} \
    ADC_Mixer_Mode00 {0} \
    ADC_Mixer_Mode10 {0} \
    ADC_Mixer_Mode20 {0} \
    ADC_Mixer_Mode30 {0} \
    ADC_Mixer_Type00 {2} \
    ADC_Mixer_Type10 {2} \
    ADC_Mixer_Type20 {2} \
    ADC_Mixer_Type30 {2} \
    ADC_Slice02_Enable {false} \
    ADC_Slice10_Enable {true} \
    ADC_Slice12_Enable {false} \
    ADC_Slice20_Enable {true} \
    ADC_Slice22_Enable {false} \
    ADC_Slice30_Enable {true} \
    ADC_Slice32_Enable {false} \
    DAC0_Clock_Dist {0} \
    DAC0_Clock_Source {6} \
    DAC0_Multi_Tile_Sync {true} \
    DAC0_Outclk_Freq {307.200} \
    DAC0_PLL_Enable {true} \
    DAC0_Refclk_Freq {491.520} \
    DAC0_Sampling_Rate {4.9152} \
    DAC1_Clock_Source {6} \
    DAC1_Multi_Tile_Sync {true} \
    DAC1_Outclk_Freq {307.200} \
    DAC1_PLL_Enable {true} \
    DAC1_Refclk_Freq {491.520} \
    DAC1_Sampling_Rate {4.9152} \
    DAC2_Clock_Dist {1} \
    DAC2_Clock_Source {6} \
    DAC2_Multi_Tile_Sync {true} \
    DAC2_Outclk_Freq {307.200} \
    DAC2_PLL_Enable {true} \
    DAC2_Refclk_Freq {491.520} \
    DAC2_Sampling_Rate {4.9152} \
    DAC3_Clock_Source {6} \
    DAC3_Multi_Tile_Sync {true} \
    DAC3_Outclk_Freq {307.200} \
    DAC3_PLL_Enable {true} \
    DAC3_Refclk_Freq {491.520} \
    DAC3_Sampling_Rate {4.9152} \
    DAC_Data_Type20 {0} \
    DAC_Interpolation_Mode00 {2} \
    DAC_Interpolation_Mode10 {2} \
    DAC_Interpolation_Mode20 {2} \
    DAC_Interpolation_Mode30 {2} \
    DAC_Mixer_Mode00 {0} \
    DAC_Mixer_Mode10 {0} \
    DAC_Mixer_Mode20 {0} \
    DAC_Mixer_Mode30 {0} \
    DAC_Mixer_Type00 {2} \
    DAC_Mixer_Type10 {2} \
    DAC_Mixer_Type20 {2} \
    DAC_Mixer_Type30 {2} \
    DAC_Slice00_Enable {true} \
    DAC_Slice02_Enable {false} \
    DAC_Slice10_Enable {true} \
    DAC_Slice12_Enable {false} \
    DAC_Slice20_Enable {true} \
    DAC_Slice22_Enable {false} \
    DAC_Slice30_Enable {true} \
} {
  
  sysref_in sysref_in
  adc1_clk adc1_clk
  dac2_clk dac2_clk

  s_axi_aclk ps_0/pl_clk0
  s_axi_aresetn proc_sys_reset_0/peripheral_aresetn
  s_axi axi_mem_intercon_0/M[add_master_interface]_AXI

  vin0_01 vin0_01
  vin1_01 vin1_01
  vin2_01 vin2_01
  vin3_01 vin3_01

  vout00 vout00
  vout10 vout10
  vout20 vout20
  vout30 vout30
}


cell xilinx.com:ip:proc_sys_reset:5.0 rst_dac1  {
  C_EXT_RST_WIDTH {1}
} {
  ext_reset_in ps_0/pl_resetn0
  slowest_sync_clk rfip/clk_dac1
}
cell xilinx.com:ip:proc_sys_reset:5.0 rst_dac2  {
  C_EXT_RST_WIDTH {1}
} {
  ext_reset_in ps_0/pl_resetn0
  slowest_sync_clk rfip/clk_dac2
}
cell xilinx.com:ip:proc_sys_reset:5.0 rst_dac3  {
  C_EXT_RST_WIDTH {1}
} {
  ext_reset_in ps_0/pl_resetn0
  slowest_sync_clk rfip/clk_dac3
}
cell xilinx.com:ip:proc_sys_reset:5.0 rst_dac0  {
  C_EXT_RST_WIDTH {1}
} {
  ext_reset_in ps_0/pl_resetn0
  slowest_sync_clk rfip/clk_dac0 
}
cell xilinx.com:ip:proc_sys_reset:5.0 rst_adc1  {
  C_EXT_RST_WIDTH {1}
} {
  ext_reset_in ps_0/pl_resetn0
  slowest_sync_clk rfip/clk_adc1 
}
cell xilinx.com:ip:proc_sys_reset:5.0 rst_adc2  {
  C_EXT_RST_WIDTH {1}
} {
  ext_reset_in ps_0/pl_resetn0
  slowest_sync_clk rfip/clk_adc2 
}
cell xilinx.com:ip:proc_sys_reset:5.0 rst_adc3  {
  C_EXT_RST_WIDTH {1}
} {
  ext_reset_in ps_0/pl_resetn0
  slowest_sync_clk rfip/clk_adc3 
}
cell xilinx.com:ip:proc_sys_reset:5.0 rst_adc0  {
  C_EXT_RST_WIDTH {1}
} {
  slowest_sync_clk rfip/clk_adc0 
  ext_reset_in ps_0/pl_resetn0
}

connect_cell rfip {
  s0_axis_aclk rfip/clk_dac0
  s1_axis_aclk rfip/clk_dac1
  s2_axis_aclk rfip/clk_dac2  
  s3_axis_aclk rfip/clk_dac3
  m0_axis_aclk rfip/clk_adc0
  m1_axis_aclk rfip/clk_adc1
  m2_axis_aclk rfip/clk_adc2
  m3_axis_aclk rfip/clk_adc3

  m0_axis_aresetn rst_adc0/peripheral_aresetn
  m1_axis_aresetn rst_adc1/peripheral_aresetn
  m2_axis_aresetn rst_adc2/peripheral_aresetn
  m3_axis_aresetn rst_adc3/peripheral_aresetn
  s0_axis_aresetn rst_dac0/peripheral_aresetn
  s1_axis_aresetn rst_dac1/peripheral_aresetn
  s2_axis_aresetn rst_dac2/peripheral_aresetn
  s3_axis_aresetn rst_dac3/peripheral_aresetn

}

assign_bd_address -offset [get_memory_offset rfip] -range [get_memory_range rfip] \
            -target_address_space [get_bd_addr_spaces ps_0/data] \
            [get_bd_addr_segs rfip/s_axi/reg] 

