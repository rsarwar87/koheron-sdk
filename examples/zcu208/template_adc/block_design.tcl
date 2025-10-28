# Add PS and AXI Interconnect
set obj [current_project]
set_property -name "board_part" -value "xilinx.com:zcu208:part0:2.0" -objects $obj
set board_preset $board_path/config/board_preset.tcl

set_property "ip_repo_paths" "[concat [get_property ip_repo_paths [current_project]] [file normalize $project_path/ip_repo]]" "[current_project]"
update_ip_catalog -rebuild 

source $sdk_path/fpga/lib/starting_point_zynqmp.tcl
source $board_path/board_only_connections_rf.tcl
#source $board_path/board_only_connections_ram_c0.tcl
#source $board_path/board_only_connections_ram_c1.tcl

create_bd_port -dir O -from 7 -to 0 led
# Add config and status registers
source $sdk_path/fpga/lib/ctl_sts.tcl
add_ctl_sts

# Connect 42 to status register
connect_port_pin led [get_slice_pin [ctl_pin led] 7 0]
connect_pins [get_constant_pin 42 32] [sts_pin forty_two]

cell xilinx.com:ip:dds_compiler:6.0 dds_compiler_0 {
  DDS_Clock_Rate {250} \
  Frequency_Resolution {0.4} \
  DATA_Has_TLAST {Not_Required} \
  DSP48_Use {Maximal} \
  Latency {2} \
  M_DATA_Has_TUSER {Not_Required} \
  Noise_Shaping {None} \
  Output_Frequency1 {0} \
  Output_Width {3} \
  PINC1 {0} \
  Parameter_Entry {Hardware_Parameters} \
  PartsPresent {Phase_Generator_only} \
  Phase_Width {16} \
  Phase_offset {None} \
  S_PHASE_Has_TUSER {Not_Required} \
} {
  aclk  clk_wiz_dac0/clk_out1
}
cell xilinx.com:ip:fir_compiler:7.2 fir_compiler_0 {
  Clock_Frequency {300.0} \
  Coefficient_Structure {Inferred} \
  Coefficient_Width {16} \
  ColumnConfig {2} \
  Decimation_Rate {1} \
  Filter_Architecture {Systolic_Multiply_Accumulate} \
  Filter_Type {Interpolation} \
  Interpolation_Rate {16} \
  Number_Channels {1} \
  Output_Rounding_Mode {Truncate_LSBs} \
  Output_Width {16} \
  RateSpecification {Frequency_Specification} \
  Sample_Frequency {300} \
  Zero_Pack_Factor {1} \
} {
  aclk  clk_wiz_dac0/clk_out1
  S_AXIS_DATA dds_compiler_0/M_AXIS_PHASE
  M_AXIS_DATA rfip/s00_axis
}

cell xilinx.com:ip:dds_compiler:6.0 dds_compiler_1 {
  DDS_Clock_Rate {250} \
  Frequency_Resolution {0.4} \
  DATA_Has_TLAST {Not_Required} \
  DSP48_Use {Maximal} \
  Latency {2} \
  M_DATA_Has_TUSER {Not_Required} \
  Noise_Shaping {None} \
  Output_Frequency1 {0} \
  Output_Width {3} \
  PINC1 {0} \
  Parameter_Entry {Hardware_Parameters} \
  PartsPresent {Phase_Generator_only} \
  Phase_Width {16} \
  Phase_offset {None} \
  S_PHASE_Has_TUSER {Not_Required} \
} {
  aclk  clk_wiz_dac0/clk_out1
}
cell xilinx.com:ip:fir_compiler:7.2 fir_compiler_1 {
  Clock_Frequency {300.0} \
  Coefficient_Structure {Inferred} \
  Coefficient_Width {16} \
  ColumnConfig {2} \
  Decimation_Rate {1} \
  Filter_Architecture {Systolic_Multiply_Accumulate} \
  Filter_Type {Interpolation} \
  Interpolation_Rate {16} \
  Number_Channels {1} \
  Output_Rounding_Mode {Truncate_LSBs} \
  Output_Width {16} \
  RateSpecification {Frequency_Specification} \
  Sample_Frequency {300} \
  Zero_Pack_Factor {1} \
} {
  aclk  clk_wiz_dac0/clk_out1
  S_AXIS_DATA dds_compiler_1/M_AXIS_PHASE
  M_AXIS_DATA rfip/s02_axis
}

cell xilinx.com:ip:dds_compiler:6.0 dds_compiler_2 {
  DDS_Clock_Rate {250} \
  Frequency_Resolution {0.4} \
  DATA_Has_TLAST {Not_Required} \
  DSP48_Use {Maximal} \
  Latency {2} \
  M_DATA_Has_TUSER {Not_Required} \
  Noise_Shaping {None} \
  Output_Frequency1 {0} \
  Output_Width {3} \
  PINC1 {0} \
  Parameter_Entry {Hardware_Parameters} \
  PartsPresent {Phase_Generator_only} \
  Phase_Width {16} \
  Phase_offset {None} \
  S_PHASE_Has_TUSER {Not_Required} \
} {
  aclk  clk_wiz_dac1/clk_out1
}
cell xilinx.com:ip:fir_compiler:7.2 fir_compiler_2 {
  Clock_Frequency {300.0} \
  Coefficient_Structure {Inferred} \
  Coefficient_Width {16} \
  ColumnConfig {2} \
  Decimation_Rate {1} \
  Filter_Architecture {Systolic_Multiply_Accumulate} \
  Filter_Type {Interpolation} \
  Interpolation_Rate {16} \
  Number_Channels {1} \
  Output_Rounding_Mode {Truncate_LSBs} \
  Output_Width {16} \
  RateSpecification {Frequency_Specification} \
  Sample_Frequency {300} \
  Zero_Pack_Factor {1} \
} {
  aclk  clk_wiz_dac1/clk_out1
  S_AXIS_DATA dds_compiler_2/M_AXIS_PHASE
  M_AXIS_DATA rfip/s10_axis
}

cell xilinx.com:ip:dds_compiler:6.0 dds_compiler_3 {
  DDS_Clock_Rate {250} \
  Frequency_Resolution {0.4} \
  DATA_Has_TLAST {Not_Required} \
  DSP48_Use {Maximal} \
  Latency {2} \
  M_DATA_Has_TUSER {Not_Required} \
  Noise_Shaping {None} \
  Output_Frequency1 {0} \
  Output_Width {3} \
  PINC1 {0} \
  Parameter_Entry {Hardware_Parameters} \
  PartsPresent {Phase_Generator_only} \
  Phase_Width {16} \
  Phase_offset {None} \
  S_PHASE_Has_TUSER {Not_Required} \
} {
  aclk  clk_wiz_dac1/clk_out1
}
cell xilinx.com:ip:fir_compiler:7.2 fir_compiler_3 {
  Clock_Frequency {300.0} \
  Coefficient_Structure {Inferred} \
  Coefficient_Width {16} \
  ColumnConfig {2} \
  Decimation_Rate {1} \
  Filter_Architecture {Systolic_Multiply_Accumulate} \
  Filter_Type {Interpolation} \
  Interpolation_Rate {16} \
  Number_Channels {1} \
  Output_Rounding_Mode {Truncate_LSBs} \
  Output_Width {16} \
  RateSpecification {Frequency_Specification} \
  Sample_Frequency {300} \
  Zero_Pack_Factor {1} \
} {
  aclk clk_wiz_dac1/clk_out1
  S_AXIS_DATA dds_compiler_3/M_AXIS_PHASE
  M_AXIS_DATA rfip/s12_axis
}

cell xilinx.com:ip:dds_compiler:6.0 dds_compiler_4 {
  DDS_Clock_Rate {250} \
  Frequency_Resolution {0.4} \
  DATA_Has_TLAST {Not_Required} \
  DSP48_Use {Maximal} \
  Latency {2} \
  M_DATA_Has_TUSER {Not_Required} \
  Noise_Shaping {None} \
  Output_Frequency1 {0} \
  Output_Width {3} \
  PINC1 {0} \
  Parameter_Entry {Hardware_Parameters} \
  PartsPresent {Phase_Generator_only} \
  Phase_Width {16} \
  Phase_offset {None} \
  S_PHASE_Has_TUSER {Not_Required} \
} {
  aclk  clk_wiz_dac2/clk_out1
}
cell xilinx.com:ip:fir_compiler:7.2 fir_compiler_4 {
  Clock_Frequency {300.0} \
  Coefficient_Structure {Inferred} \
  Coefficient_Width {16} \
  ColumnConfig {2} \
  Decimation_Rate {1} \
  Filter_Architecture {Systolic_Multiply_Accumulate} \
  Filter_Type {Interpolation} \
  Interpolation_Rate {16} \
  Number_Channels {1} \
  Output_Rounding_Mode {Truncate_LSBs} \
  Output_Width {16} \
  RateSpecification {Frequency_Specification} \
  Sample_Frequency {300} \
  Zero_Pack_Factor {1} \
} {
  aclk  clk_wiz_dac2/clk_out1
  S_AXIS_DATA dds_compiler_4/M_AXIS_PHASE
  M_AXIS_DATA rfip/s20_axis
}

cell xilinx.com:ip:dds_compiler:6.0 dds_compiler_5 {
  DDS_Clock_Rate {250} \
  Frequency_Resolution {0.4} \
  DATA_Has_TLAST {Not_Required} \
  DSP48_Use {Maximal} \
  Latency {2} \
  M_DATA_Has_TUSER {Not_Required} \
  Noise_Shaping {None} \
  Output_Frequency1 {0} \
  Output_Width {3} \
  PINC1 {0} \
  Parameter_Entry {Hardware_Parameters} \
  PartsPresent {Phase_Generator_only} \
  Phase_Width {16} \
  Phase_offset {None} \
  S_PHASE_Has_TUSER {Not_Required} \
} {
  aclk  clk_wiz_dac2/clk_out1
}
cell xilinx.com:ip:fir_compiler:7.2 fir_compiler_5 {
  Clock_Frequency {300.0} \
  Coefficient_Structure {Inferred} \
  Coefficient_Width {16} \
  ColumnConfig {2} \
  Decimation_Rate {1} \
  Filter_Architecture {Systolic_Multiply_Accumulate} \
  Filter_Type {Interpolation} \
  Interpolation_Rate {16} \
  Number_Channels {1} \
  Output_Rounding_Mode {Truncate_LSBs} \
  Output_Width {16} \
  RateSpecification {Frequency_Specification} \
  Sample_Frequency {300} \
  Zero_Pack_Factor {1} \
} {
  aclk  clk_wiz_dac2/clk_out1
  S_AXIS_DATA dds_compiler_5/M_AXIS_PHASE
  M_AXIS_DATA rfip/s22_axis
}


cell xilinx.com:ip:dds_compiler:6.0 dds_compiler_6 {
  DDS_Clock_Rate {250} \
  Frequency_Resolution {0.4} \
  DATA_Has_TLAST {Not_Required} \
  DSP48_Use {Maximal} \
  Latency {2} \
  M_DATA_Has_TUSER {Not_Required} \
  Noise_Shaping {None} \
  Output_Frequency1 {0} \
  Output_Width {3} \
  PINC1 {0} \
  Parameter_Entry {Hardware_Parameters} \
  PartsPresent {Phase_Generator_only} \
  Phase_Width {16} \
  Phase_offset {None} \
  S_PHASE_Has_TUSER {Not_Required} \
} {
  aclk clk_wiz_dac3/clk_out1
}
cell xilinx.com:ip:fir_compiler:7.2 fir_compiler_6 {
  Clock_Frequency {300.0} \
  Coefficient_Structure {Inferred} \
  Coefficient_Width {16} \
  ColumnConfig {2} \
  Decimation_Rate {1} \
  Filter_Architecture {Systolic_Multiply_Accumulate} \
  Filter_Type {Interpolation} \
  Interpolation_Rate {16} \
  Number_Channels {1} \
  Output_Rounding_Mode {Truncate_LSBs} \
  Output_Width {16} \
  RateSpecification {Frequency_Specification} \
  Sample_Frequency {300} \
  Zero_Pack_Factor {1} \
} {
  aclk  clk_wiz_dac3/clk_out1
  S_AXIS_DATA dds_compiler_6/M_AXIS_PHASE
  M_AXIS_DATA rfip/s30_axis
}

cell xilinx.com:ip:dds_compiler:6.0 dds_compiler_7 {
  DDS_Clock_Rate {250} \
  Frequency_Resolution {0.4} \
  DATA_Has_TLAST {Not_Required} \
  DSP48_Use {Maximal} \
  Latency {2} \
  M_DATA_Has_TUSER {Not_Required} \
  Noise_Shaping {None} \
  Output_Frequency1 {0} \
  Output_Width {3} \
  PINC1 {0} \
  Parameter_Entry {Hardware_Parameters} \
  PartsPresent {Phase_Generator_only} \
  Phase_Width {16} \
  Phase_offset {None} \
  S_PHASE_Has_TUSER {Not_Required} \
} {
  aclk  clk_wiz_dac3/clk_out1
}
cell xilinx.com:ip:fir_compiler:7.2 fir_compiler_7 {
  Clock_Frequency {300.0} \
  Coefficient_Structure {Inferred} \
  Coefficient_Width {16} \
  ColumnConfig {2} \
  Decimation_Rate {1} \
  Filter_Architecture {Systolic_Multiply_Accumulate} \
  Filter_Type {Interpolation} \
  Interpolation_Rate {16} \
  Number_Channels {1} \
  Output_Rounding_Mode {Truncate_LSBs} \
  Output_Width {16} \
  RateSpecification {Frequency_Specification} \
  Sample_Frequency {300} \
  Zero_Pack_Factor {1} \
} {
  aclk  clk_wiz_dac3/clk_out1
  S_AXIS_DATA dds_compiler_7/M_AXIS_PHASE
  M_AXIS_DATA rfip/s32_axis
}


cell xilinx.com:ip:ila:6.2 ila_0 {
  C_MONITOR_TYPE {Native} \
  C_NUM_OF_PROBES {8} \
  C_PROBE1_WIDTH {192} \
  C_PROBE2_WIDTH {192} \
  C_PROBE3_WIDTH {192} \
  C_PROBE4_WIDTH {192} \
  C_PROBE5_WIDTH {192} \
  C_PROBE6_WIDTH {192} \
  C_PROBE7_WIDTH {192}
} {
  clk  clk_wiz_adc0/clk_out1
  probe0 rfip/m00_axis_tdata
  probe1 rfip/m02_axis_tdata
  probe2 rfip/m10_axis_tdata
  probe3 rfip/m12_axis_tdata
  probe4 rfip/m20_axis_tdata
  probe5 rfip/m22_axis_tdata
  probe6 rfip/m30_axis_tdata
  probe7 rfip/m32_axis_tdata
}
connect_pins [sts_pin adc_sample0] rfip/m00_axis_tdata
connect_pins [sts_pin adc_sample1] rfip/m02_axis_tdata
connect_pins [sts_pin adc_sample2] rfip/m10_axis_tdata
connect_pins [sts_pin adc_sample3] rfip/m12_axis_tdata
connect_pins [sts_pin adc_sample4] rfip/m20_axis_tdata
connect_pins [sts_pin adc_sample5] rfip/m22_axis_tdata
connect_pins [sts_pin adc_sample6] rfip/m30_axis_tdata
connect_pins [sts_pin adc_sample7] rfip/m32_axis_tdata

cell trenz.biz:user:labtools_fmeter:1.0 labtools_fmeter_0 {
      C_REFCLK_HZ {[get_parameter fclk0]}
   C_CHANNELS {8}
} {
  refclk  ps_0/pl_clk0
  fin [get_concat_pin [list rfip/clk_adc0 rfip/clk_adc1 rfip/clk_adc2 rfip/clk_adc3 rfip/clk_dac0 rfip/clk_dac1 rfip/clk_dac2  rfip/clk_dac3]]
  F0 [sts_pin adc_clk0]
  F1 [sts_pin adc_clk1]
  F2 [sts_pin adc_clk2]
  F3 [sts_pin adc_clk3]
  F4 [sts_pin dac_clk0]
  F5 [sts_pin dac_clk1]
  F6 [sts_pin dac_clk2]
  F7 [sts_pin dac_clk3]
}

cell xilinx.com:ip:vio:3.0 vio_0 {
   C_NUM_PROBE_IN {8} 
   C_PROBE_IN7_WIDTH {32} 
   C_PROBE_IN6_WIDTH {32} 
   C_PROBE_IN5_WIDTH {32} 
   C_PROBE_IN4_WIDTH {32} 
   C_PROBE_IN3_WIDTH {32} 
   C_PROBE_IN2_WIDTH {32} 
   C_PROBE_IN1_WIDTH {32} 
   C_PROBE_IN0_WIDTH {32} 
   C_NUM_PROBE_OUT {1} 
} {
  clk  ps_0/pl_clk0
  probe_in0 labtools_fmeter_0/F0
  probe_in1 labtools_fmeter_0/F1
  probe_in2 labtools_fmeter_0/F2
  probe_in3 labtools_fmeter_0/F3
  probe_in4 labtools_fmeter_0/F4
  probe_in5 labtools_fmeter_0/F5
  probe_in6 labtools_fmeter_0/F6
  probe_in7 labtools_fmeter_0/F7
}

# connect_pins xdma_0/M_AXIS_H2C_0 xdma_0/S_AXIS_C2H_0 
# connect_pins xdma_0/M_AXIS_H2C_1 xdma_0/S_AXIS_C2H_1 
#connect_bd_intf_net [get_bd_intf_pins ddr4_dma_1/M_AXIS_MM2S] [get_bd_intf_pins ddr4_dma_0/S_AXIS_S2MM]
#connect_bd_intf_net [get_bd_intf_pins ddr4_dma_1/S_AXIS_S2MM] [get_bd_intf_pins ddr4_dma_0/M_AXIS_MM2S]
