create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin0
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin1
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin2 
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin3
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin4
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin5
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin6
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin7
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout0 
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout1 
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout2 
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout3 
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout4 
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout5 
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout6 
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout7 

create_bd_intf_port -mode Slave -vlnv xilinx.com:display_usp_rf_data_converter:diff_pins_rtl:1.0 sysref_in 
set adc2_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 adc2_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {245760000} \
   ] $adc2_clk
set dac0_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 dac0_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {245760000} \
   ] $dac0_clk

create_bd_port -dir I pl_clk_dac 
create_bd_port -dir I pl_clk_adc 

create_bd_port -dir I dac0_hw_trigger 
create_bd_port -dir I dac0_hw_trigger_en 
create_bd_port -dir I dac1_hw_trigger 
create_bd_port -dir I dac1_hw_trigger_en 
create_bd_port -dir I dac2_hw_trigger 
create_bd_port -dir I dac2_hw_trigger_en 
create_bd_port -dir I dac3_hw_trigger 
create_bd_port -dir I dac3_hw_trigger_en 
create_bd_port -dir I user_sysref_dac_0 
create_bd_port -dir I user_sysref_adc_0 

cell  xilinx.com:ip:usp_rf_data_converter:2.6 rfip {
    ADC0_Band {0} \
    ADC0_Clock_Dist {0} \
    ADC0_Clock_Source {2} \
    ADC0_Link_Coupling {0} \
    ADC0_Multi_Tile_Sync {true} \
    ADC0_Outclk_Freq {276.480} \
    ADC0_PLL_Enable {true} \
    ADC0_Refclk_Div {1} \
    ADC0_Refclk_Freq {245.760} \
    ADC0_Sampling_Rate {4.42368} \
    ADC1_Band {0} \
    ADC1_Clock_Dist {0} \
    ADC1_Clock_Source {2} \
    ADC1_Link_Coupling {0} \
    ADC1_Multi_Tile_Sync {true} \
    ADC1_Outclk_Freq {276.480} \
    ADC1_PLL_Enable {true} \
    ADC1_Refclk_Div {1} \
    ADC1_Refclk_Freq {245.760} \
    ADC1_Sampling_Rate {4.42368} \
    ADC224_En {false} \
    ADC225_En {false} \
    ADC226_En {false} \
    ADC227_En {false} \
    ADC2_Band {0} \
    ADC2_Clock_Dist {1} \
    ADC2_Clock_Source {2} \
    ADC2_Link_Coupling {0} \
    ADC2_Multi_Tile_Sync {true} \
    ADC2_Outclk_Freq {276.480} \
    ADC2_PLL_Enable {true} \
    ADC2_Refclk_Div {1} \
    ADC2_Refclk_Freq {245.760} \
    ADC2_Sampling_Rate {4.42368} \
    ADC3_Band {0} \
    ADC3_Clock_Dist {0} \
    ADC3_Clock_Source {2} \
    ADC3_Link_Coupling {0} \
    ADC3_Multi_Tile_Sync {true} \
    ADC3_Outclk_Freq {276.480} \
    ADC3_PLL_Enable {true} \
    ADC3_Refclk_Div {1} \
    ADC3_Refclk_Freq {245.760} \
    ADC3_Sampling_Rate {4.42368} \
    ADC_CalOpt_Mode00 {2} \
    ADC_CalOpt_Mode02 {2} \
    ADC_CalOpt_Mode10 {2} \
    ADC_CalOpt_Mode12 {2} \
    ADC_CalOpt_Mode20 {2} \
    ADC_CalOpt_Mode22 {2} \
    ADC_CalOpt_Mode30 {2} \
    ADC_CalOpt_Mode32 {2} \
    ADC_DSA_RTS {false} \
    ADC_Data_Type00 {0} \
    ADC_Data_Type02 {0} \
    ADC_Data_Type10 {0} \
    ADC_Data_Type12 {0} \
    ADC_Data_Type20 {0} \
    ADC_Data_Type22 {0} \
    ADC_Data_Type30 {0} \
    ADC_Data_Type32 {0} \
    ADC_Data_Width00 {12} \
    ADC_Data_Width02 {12} \
    ADC_Data_Width10 {12} \
    ADC_Data_Width12 {12} \
    ADC_Data_Width20 {12} \
    ADC_Data_Width22 {12} \
    ADC_Data_Width30 {12} \
    ADC_Data_Width32 {12} \
    ADC_Debug {false} \
    ADC_Decimation_Mode00 {1} \
    ADC_Decimation_Mode02 {1} \
    ADC_Decimation_Mode10 {1} \
    ADC_Decimation_Mode12 {1} \
    ADC_Decimation_Mode20 {1} \
    ADC_Decimation_Mode22 {1} \
    ADC_Decimation_Mode30 {1} \
    ADC_Decimation_Mode32 {1} \
    ADC_Dither00 {true} \
    ADC_Dither02 {true} \
    ADC_Dither10 {true} \
    ADC_Dither12 {true} \
    ADC_Dither20 {true} \
    ADC_Dither22 {true} \
    ADC_Dither30 {true} \
    ADC_Dither32 {true} \
    ADC_NCO_Freq00 {0} \
    ADC_NCO_Freq02 {0} \
    ADC_NCO_Freq10 {0} \
    ADC_NCO_Freq12 {0} \
    ADC_NCO_Freq20 {0} \
    ADC_NCO_Freq22 {0} \
    ADC_NCO_Freq30 {0} \
    ADC_NCO_Freq32 {0} \
    ADC_NCO_Phase00 {0} \
    ADC_NCO_Phase02 {0} \
    ADC_NCO_Phase10 {0} \
    ADC_NCO_Phase12 {0} \
    ADC_NCO_Phase20 {0} \
    ADC_NCO_Phase22 {0} \
    ADC_NCO_Phase30 {0} \
    ADC_NCO_Phase32 {0} \
    ADC_NCO_RTS {false} \
    ADC_Neg_Quadrature00 {false} \
    ADC_Neg_Quadrature02 {false} \
    ADC_Neg_Quadrature10 {false} \
    ADC_Neg_Quadrature12 {false} \
    ADC_Neg_Quadrature20 {false} \
    ADC_Neg_Quadrature22 {false} \
    ADC_Neg_Quadrature30 {false} \
    ADC_Neg_Quadrature32 {false} \
    ADC_Nyquist00 {0} \
    ADC_Nyquist02 {0} \
    ADC_Nyquist10 {0} \
    ADC_Nyquist12 {0} \
    ADC_Nyquist20 {0} \
    ADC_Nyquist22 {0} \
    ADC_Nyquist30 {0} \
    ADC_Nyquist32 {0} \
    ADC_OBS00 {false} \
    ADC_OBS02 {false} \
    ADC_OBS10 {false} \
    ADC_OBS12 {false} \
    ADC_OBS20 {false} \
    ADC_OBS22 {false} \
    ADC_OBS30 {false} \
    ADC_OBS32 {false} \
    ADC_RTS {false} \
    ADC_Slice00_Enable {true} \
    ADC_Slice02_Enable {true} \
    ADC_Slice10_Enable {true} \
    ADC_Slice12_Enable {true} \
    ADC_Slice20_Enable {true} \
    ADC_Slice22_Enable {true} \
    ADC_Slice30_Enable {true} \
    ADC_Slice32_Enable {true} \
    ADC_TDD_RTS00 {0} \
    ADC_TDD_RTS02 {0} \
    ADC_TDD_RTS10 {0} \
    ADC_TDD_RTS12 {0} \
    ADC_TDD_RTS20 {0} \
    ADC_TDD_RTS22 {0} \
    ADC_TDD_RTS30 {0} \
    ADC_TDD_RTS32 {0} \
    AMS_Factory_Var {0} \
    Analog_Detection {1} \
    Auto_Calibration_Freeze {false} \
    Axiclk_Freq {57.5} \
    Calibration_Freeze {true} \
    Calibration_Time {10} \
    Clock_Forwarding {false} \
    Converter_Setup {1} \
    DAC0_Band {0} \
    DAC0_Clock_Dist {1} \
    DAC0_Clock_Source {4} \
    DAC0_Link_Coupling {0} \
    DAC0_Multi_Tile_Sync {true} \
    DAC0_Outclk_Freq {491.520} \
    DAC0_PLL_Enable {true} \
    DAC0_Refclk_Div {1} \
    DAC0_Refclk_Freq {245.760} \
    DAC0_Sampling_Rate {7.86432} \
    DAC0_VOP {32.0} \
    DAC1_Band {0} \
    DAC1_Clock_Source {4} \
    DAC1_Link_Coupling {0} \
    DAC1_Multi_Tile_Sync {true} \
    DAC1_Outclk_Freq {491.520} \
    DAC1_PLL_Enable {true} \
    DAC1_Refclk_Div {1} \
    DAC1_Refclk_Freq {245.760} \
    DAC1_Sampling_Rate {7.86432} \
    DAC1_VOP {32.0} \
    DAC228_En {false} \
    DAC229_En {false} \
    DAC230_En {false} \
    DAC231_En {false} \
    DAC2_Band {0} \
    DAC2_Clock_Dist {0} \
    DAC2_Clock_Source {4} \
    DAC2_Link_Coupling {0} \
    DAC2_Multi_Tile_Sync {true} \
    DAC2_Outclk_Freq {491.520} \
    DAC2_PLL_Enable {true} \
    DAC2_Refclk_Div {1} \
    DAC2_Refclk_Freq {245.760} \
    DAC2_Sampling_Rate {7.86432} \
    DAC2_VOP {32.0} \
    DAC3_Band {0} \
    DAC3_Clock_Source {4} \
    DAC3_Link_Coupling {0} \
    DAC3_Multi_Tile_Sync {true} \
    DAC3_Outclk_Freq {491.520} \
    DAC3_PLL_Enable {true} \
    DAC3_Refclk_Div {1} \
    DAC3_Refclk_Freq {245.760} \
    DAC3_Sampling_Rate {7.86432} \
    DAC3_VOP {32.0} \
    DAC_Data_Type00 {0} \
    DAC_Data_Type02 {0} \
    DAC_Data_Type10 {0} \
    DAC_Data_Type12 {0} \
    DAC_Data_Type20 {0} \
    DAC_Data_Type22 {0} \
    DAC_Data_Type30 {0} \
    DAC_Data_Type32 {0} \
    DAC_Data_Width00 {16} \
    DAC_Data_Width01 {16} \
    DAC_Data_Width02 {16} \
    DAC_Data_Width03 {16} \
    DAC_Data_Width10 {16} \
    DAC_Data_Width11 {16} \
    DAC_Data_Width12 {16} \
    DAC_Data_Width13 {16} \
    DAC_Data_Width20 {16} \
    DAC_Data_Width21 {16} \
    DAC_Data_Width22 {16} \
    DAC_Data_Width23 {16} \
    DAC_Data_Width30 {16} \
    DAC_Data_Width31 {16} \
    DAC_Data_Width32 {16} \
    DAC_Data_Width33 {16} \
    DAC_Debug {false} \
    DAC_Decoder_Mode00 {0} \
    DAC_Decoder_Mode02 {0} \
    DAC_Decoder_Mode10 {0} \
    DAC_Decoder_Mode12 {0} \
    DAC_Decoder_Mode20 {0} \
    DAC_Decoder_Mode22 {0} \
    DAC_Decoder_Mode30 {0} \
    DAC_Decoder_Mode32 {0} \
    DAC_Interpolation_Mode00 {2} \
    DAC_Interpolation_Mode01 {2} \
    DAC_Interpolation_Mode02 {2} \
    DAC_Interpolation_Mode03 {2} \
    DAC_Interpolation_Mode10 {2} \
    DAC_Interpolation_Mode11 {2} \
    DAC_Interpolation_Mode12 {2} \
    DAC_Interpolation_Mode13 {2} \
    DAC_Interpolation_Mode20 {2} \
    DAC_Interpolation_Mode21 {2} \
    DAC_Interpolation_Mode22 {2} \
    DAC_Interpolation_Mode23 {2} \
    DAC_Interpolation_Mode30 {2} \
    DAC_Interpolation_Mode31 {2} \
    DAC_Interpolation_Mode32 {2} \
    DAC_Interpolation_Mode33 {2} \
    DAC_Invsinc_Ctrl00 {false} \
    DAC_Invsinc_Ctrl02 {false} \
    DAC_Invsinc_Ctrl10 {false} \
    DAC_Invsinc_Ctrl12 {false} \
    DAC_Invsinc_Ctrl20 {false} \
    DAC_Invsinc_Ctrl22 {false} \
    DAC_Invsinc_Ctrl30 {false} \
    DAC_Invsinc_Ctrl32 {false} \
    DAC_Mixer_Mode00 {0} \
    DAC_Mixer_Mode01 {0} \
    DAC_Mixer_Mode02 {0} \
    DAC_Mixer_Mode03 {0} \
    DAC_Mixer_Mode10 {0} \
    DAC_Mixer_Mode11 {0} \
    DAC_Mixer_Mode12 {0} \
    DAC_Mixer_Mode13 {0} \
    DAC_Mixer_Mode20 {0} \
    DAC_Mixer_Mode21 {0} \
    DAC_Mixer_Mode22 {0} \
    DAC_Mixer_Mode23 {0} \
    DAC_Mixer_Mode30 {0} \
    DAC_Mixer_Mode31 {0} \
    DAC_Mixer_Mode32 {0} \
    DAC_Mixer_Mode33 {0} \
    DAC_Mixer_Type00 {2} \
    DAC_Mixer_Type01 {2} \
    DAC_Mixer_Type02 {2} \
    DAC_Mixer_Type03 {2} \
    DAC_Mixer_Type10 {2} \
    DAC_Mixer_Type11 {2} \
    DAC_Mixer_Type12 {2} \
    DAC_Mixer_Type13 {2} \
    DAC_Mixer_Type20 {2} \
    DAC_Mixer_Type21 {2} \
    DAC_Mixer_Type22 {2} \
    DAC_Mixer_Type23 {2} \
    DAC_Mixer_Type30 {2} \
    DAC_Mixer_Type31 {2} \
    DAC_Mixer_Type32 {2} \
    DAC_Mixer_Type33 {2} \
    DAC_Mode00 {1} \
    DAC_Mode02 {1} \
    DAC_Mode10 {1} \
    DAC_Mode12 {1} \
    DAC_Mode20 {1} \
    DAC_Mode22 {1} \
    DAC_Mode30 {1} \
    DAC_Mode32 {1} \
    DAC_NCO_Freq00 {0.0} \
    DAC_NCO_Freq01 {0.0} \
    DAC_NCO_Freq02 {0.0} \
    DAC_NCO_Freq03 {0.0} \
    DAC_NCO_Freq10 {0.0} \
    DAC_NCO_Freq11 {0.0} \
    DAC_NCO_Freq12 {0.0} \
    DAC_NCO_Freq13 {0.0} \
    DAC_NCO_Freq20 {0.0} \
    DAC_NCO_Freq21 {0.0} \
    DAC_NCO_Freq22 {0.0} \
    DAC_NCO_Freq23 {0.0} \
    DAC_NCO_Freq30 {0.0} \
    DAC_NCO_Freq31 {0.0} \
    DAC_NCO_Freq32 {0.0} \
    DAC_NCO_Freq33 {0.0} \
    DAC_NCO_Phase00 {0} \
    DAC_NCO_Phase01 {0} \
    DAC_NCO_Phase02 {0} \
    DAC_NCO_Phase03 {0} \
    DAC_NCO_Phase10 {0} \
    DAC_NCO_Phase11 {0} \
    DAC_NCO_Phase12 {0} \
    DAC_NCO_Phase13 {0} \
    DAC_NCO_Phase20 {0} \
    DAC_NCO_Phase21 {0} \
    DAC_NCO_Phase22 {0} \
    DAC_NCO_Phase23 {0} \
    DAC_NCO_Phase30 {0} \
    DAC_NCO_Phase31 {0} \
    DAC_NCO_Phase32 {0} \
    DAC_NCO_Phase33 {0} \
    DAC_NCO_RTS {false} \
    DAC_Neg_Quadrature00 {false} \
    DAC_Neg_Quadrature01 {false} \
    DAC_Neg_Quadrature02 {false} \
    DAC_Neg_Quadrature03 {false} \
    DAC_Neg_Quadrature10 {false} \
    DAC_Neg_Quadrature11 {false} \
    DAC_Neg_Quadrature12 {false} \
    DAC_Neg_Quadrature13 {false} \
    DAC_Neg_Quadrature20 {false} \
    DAC_Neg_Quadrature21 {false} \
    DAC_Neg_Quadrature22 {false} \
    DAC_Neg_Quadrature23 {false} \
    DAC_Neg_Quadrature30 {false} \
    DAC_Neg_Quadrature31 {false} \
    DAC_Neg_Quadrature32 {false} \
    DAC_Neg_Quadrature33 {false} \
    DAC_Nyquist00 {0} \
    DAC_Nyquist02 {0} \
    DAC_Nyquist10 {0} \
    DAC_Nyquist12 {0} \
    DAC_Nyquist20 {0} \
    DAC_Nyquist22 {0} \
    DAC_Nyquist30 {0} \
    DAC_Nyquist32 {0} \
    DAC_RTS {false} \
    DAC_Slice00_Enable {true} \
    DAC_Slice02_Enable {true} \
    DAC_Slice10_Enable {true} \
    DAC_Slice12_Enable {true} \
    DAC_Slice20_Enable {true} \
    DAC_Slice22_Enable {true} \
    DAC_Slice30_Enable {true} \
    DAC_Slice32_Enable {true} \
    DAC_TDD_RTS00 {0} \
    DAC_TDD_RTS01 {0} \
    DAC_TDD_RTS02 {0} \
    DAC_TDD_RTS03 {0} \
    DAC_TDD_RTS10 {0} \
    DAC_TDD_RTS11 {0} \
    DAC_TDD_RTS12 {0} \
    DAC_TDD_RTS13 {0} \
    DAC_TDD_RTS20 {0} \
    DAC_TDD_RTS21 {0} \
    DAC_TDD_RTS22 {0} \
    DAC_TDD_RTS23 {0} \
    DAC_TDD_RTS30 {0} \
    DAC_TDD_RTS31 {0} \
    DAC_TDD_RTS32 {0} \
    DAC_TDD_RTS33 {0} \
    PL_Clock_Freq {122.880} \
    PRESET {None} \
    RESERVED_3 {110000} \
    RF_Analyzer {1} \
    VNC_Include_Fs2_Change {true} \
    VNC_Include_OIS_Change {true} \
    VNC_Testing {false} \
    disable_bg_cal_en {1} \
    mADC_Band {0} \
    mDAC_Band {0} \
    mDAC_Slice00_Enable {false} \
    mDAC_Slice02_Enable {false} \
    production_simulation {0} \
    tb_adc_fft {true} \
    tb_dac_fft {true} \
    use_bram {1} \
} {
  
  sysref_in sysref_in
  adc2_clk adc2_clk
  dac0_clk dac0_clk
  user_sysref_adc user_sysref_adc_0
  user_sysref_dac user_sysref_dac_0

  s_axi_aclk ps_0/pl_clk0
  s_axi_aresetn proc_sys_reset_0/peripheral_aresetn
  s_axi axi_mem_intercon_0/M[add_master_interface]_AXI

  vin0_01 vin0
  vin0_23 vin1
  vin1_01 vin2
  vin1_23 vin3
  vin2_01 vin4
  vin2_23 vin5
  vin3_01 vin6
  vin3_23 vin7

  vout00 vout0
  vout02 vout1
  vout10 vout2
  vout12 vout3
  vout20 vout4
  vout22 vout5
  vout30 vout6
  vout32 vout7
}
cell xilinx.com:ip:proc_sys_reset:5.0 rst_dac1  {
  C_EXT_RST_WIDTH {1}
} {
  slowest_sync_clk rfip/clk_dac0
  ext_reset_in ps_0/pl_resetn0
}
cell xilinx.com:ip:proc_sys_reset:5.0 rst_dac2  {
  C_EXT_RST_WIDTH {1}
} {
  slowest_sync_clk rfip/clk_dac0
  ext_reset_in ps_0/pl_resetn0
}
cell xilinx.com:ip:proc_sys_reset:5.0 rst_dac3  {
  C_EXT_RST_WIDTH {1}
} {
  slowest_sync_clk rfip/clk_dac0
  ext_reset_in ps_0/pl_resetn0
}
cell xilinx.com:ip:proc_sys_reset:5.0 rst_dac0  {
  C_EXT_RST_WIDTH {1}
} {
  slowest_sync_clk rfip/clk_dac0
  ext_reset_in ps_0/pl_resetn0
}
cell xilinx.com:ip:proc_sys_reset:5.0 rst_adc1  {
  C_EXT_RST_WIDTH {1}
} {
  slowest_sync_clk rfip/clk_adc0
  ext_reset_in ps_0/pl_resetn0
}
cell xilinx.com:ip:proc_sys_reset:5.0 rst_adc2  {
  C_EXT_RST_WIDTH {1}
} {
  slowest_sync_clk rfip/clk_adc0
  ext_reset_in ps_0/pl_resetn0
}
cell xilinx.com:ip:proc_sys_reset:5.0 rst_adc3  {
  C_EXT_RST_WIDTH {1}
} {
  slowest_sync_clk rfip/clk_adc0
  ext_reset_in ps_0/pl_resetn0
}
cell xilinx.com:ip:proc_sys_reset:5.0 rst_adc0  {
  C_EXT_RST_WIDTH {1}
} {
  slowest_sync_clk rfip/clk_adc0
  ext_reset_in ps_0/pl_resetn0
}

connect_cell rfip {
  adc0_01_int_cal_freeze [get_not_pin rfip/adc0_01_sig_detect]
  adc1_01_int_cal_freeze [get_not_pin rfip/adc1_01_sig_detect]
  adc2_01_int_cal_freeze [get_not_pin rfip/adc2_01_sig_detect]
  adc3_01_int_cal_freeze [get_not_pin rfip/adc3_01_sig_detect]
  adc0_23_int_cal_freeze [get_not_pin rfip/adc0_23_sig_detect]
  adc1_23_int_cal_freeze [get_not_pin rfip/adc1_23_sig_detect]
  adc2_23_int_cal_freeze [get_not_pin rfip/adc2_23_sig_detect]
  adc3_23_int_cal_freeze [get_not_pin rfip/adc3_23_sig_detect]


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

group_bd_cells adc_calib [get_bd_cells not_rfip_adc1_23_sig_detect] [get_bd_cells not_rfip_adc1_01_sig_detect] [get_bd_cells not_rfip_adc0_01_sig_detect] [get_bd_cells not_rfip_adc3_01_sig_detect] [get_bd_cells not_rfip_adc0_23_sig_detect] [get_bd_cells not_rfip_adc2_23_sig_detect] [get_bd_cells not_rfip_adc2_01_sig_detect] [get_bd_cells not_rfip_adc3_23_sig_detect]

