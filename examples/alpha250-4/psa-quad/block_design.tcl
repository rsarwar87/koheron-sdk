set board_preset $board_path/config/board_preset.tcl
source $sdk_path/fpga/lib/starting_point.tcl
source $board_path/adc.tcl

# Add config and status registers
source $sdk_path/fpga/lib/ctl_sts.tcl
add_ctl_sts adc/adc_clk rst_adc_clk/peripheral_aresetn

connect_cell adc {
    adc00 [sts_pin adc00]
    adc01 [sts_pin adc01]
    adc10 [sts_pin adc10]
    adc11 [sts_pin adc11]
    ctl [ctl_pin mmcm]
    cfg_data [ctl_pin spi_cfg_data]
    cfg_cmd [ctl_pin spi_cfg_cmd]
    cfg_sts [sts_pin spi_cfg_sts]
}

# Add XADC for monitoring of Zynq temperature
set files [glob -nocomplain $project_path/hdl/*.vhd]
if {[llength $files] > 0} {
  add_files -norecurse $files
}
update_compile_order -fileset sources_1
create_bd_cell -type module -reference trigger trigger_0

create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vp_Vn

cell xilinx.com:ip:xadc_wiz:3.3 xadc_wiz_0 {
} {
  Vp_Vn Vp_Vn
  s_axi_lite axi_mem_intercon_0/M[add_master_interface 0]_AXI
  s_axi_aclk ps_0/FCLK_CLK0
  s_axi_aresetn proc_sys_reset_0/peripheral_aresetn
}
assign_bd_address [get_bd_addr_segs xadc_wiz_0/s_axi_lite/Reg]

# Expansion connector IOs

for {set i 0} {$i < 8} {incr i} {
  create_bd_port -dir I exp_io_${i}_p
  create_bd_port -dir O exp_io_${i}_n
}

# SPI
source $board_path/spi.tcl

connect_pins ps_0/SDIO0_CDN [get_constant_pin 0 1]
connect_pins ps_0/SDIO0_WP [get_constant_pin 0 1]

connect_pins [sts_pin digital_inputs] [get_concat_pin [list exp_io_0_p exp_io_1_p exp_io_2_p exp_io_3_p exp_io_4_p exp_io_5_p exp_io_6_p exp_io_7_p]]

for {set i 0} {$i < 8} {incr i} {
    connect_pins  [get_slice_pin [ctl_pin digital_outputs] $i $i] exp_io_${i}_n
}



##################################################
# DMA
##################################################


# Configure Zynq Processing System
set_cell_props ps_0 {
  PCW_USE_S_AXI_HP0 1
  PCW_S_AXI_HP0_DATA_WIDTH 64
  PCW_USE_S_AXI_HP2 1
  PCW_S_AXI_HP2_DATA_WIDTH 64
  PCW_USE_HIGH_OCM 1
  PCW_USE_S_AXI_GP0 1
}

connect_pins ps_0/S_AXI_GP0_ACLK ps_0/FCLK_CLK0
connect_pins ps_0/S_AXI_HP0_ACLK ps_0/FCLK_CLK0
connect_pins ps_0/S_AXI_HP2_ACLK ps_0/FCLK_CLK0

cell xilinx.com:ip:smartconnect:1.0 dma_interconnect_omc {
  NUM_SI 2
  NUM_MI 1
} {
  aclk ${ps_name}/FCLK_CLK0
  aresetn proc_sys_reset_0/peripheral_aresetn
  M00_AXI ${ps_name}/S_AXI_GP0
}

cell xilinx.com:ip:smartconnect:1.0 dma_interconnect_s2mm_psa {
  NUM_SI 1
  NUM_MI 1
  S00_AXIHAS_REGSLICE 1
} {
  aclk ${ps_name}/FCLK_CLK0
  aresetn proc_sys_reset_0/peripheral_aresetn
  M00_AXI ${ps_name}/S_AXI_HP0
}

cell xilinx.com:ip:smartconnect:1.0 dma_interconnect_s2mm_wave {
  NUM_SI 2
  NUM_MI 1
  S00_AXIHAS_REGSLICE 1
} {
  aclk ${ps_name}/FCLK_CLK0
  aresetn proc_sys_reset_0/peripheral_aresetn
  M00_AXI ${ps_name}/S_AXI_HP2
}

cell xilinx.com:ip:axi_dma:7.1 axi_dma_psa {
  c_include_sg 1
  c_sg_include_stscntrl_strm 0
  c_sg_length_width 20
  c_s2mm_burst_size 16
  c_include_mm2s {0}
  c_include_s2mm {1}
  c_m_axi_s2mm_data_width 64
  c_mm2s_burst_size 16
} {
  S_AXI_LITE axi_mem_intercon_0/M[add_master_interface]_AXI
  s_axi_lite_aclk ps_0/FCLK_CLK0
  M_AXI_SG dma_interconnect_omc/S01_AXI
  m_axi_sg_aclk ps_0/FCLK_CLK0
  M_AXI_S2MM dma_interconnect_s2mm_psa/S00_AXI
  m_axi_s2mm_aclk ps_0/FCLK_CLK0
  axi_resetn proc_sys_reset_0/peripheral_aresetn
}

# Add BRAM Controller
set idx [add_master_interface 0]
cell xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_psa0 {
  SINGLE_PORT_BRAM 1
  READ_LATENCY 3
  PROTOCOL AXI4LITE
} {
  s_axi_aclk ps_0/FCLK_CLK0
  s_axi_aresetn proc_sys_reset_0/peripheral_aresetn
  S_AXI axi_mem_intercon_0/M${idx}_AXI
}
assign_bd_address   [get_bd_addr_segs axi_bram_ctrl_psa0/S_AXI/Mem0]
set memory_segment  [get_bd_addr_segs /ps_0/Data/SEG_axi_bram_ctrl_psa0_Mem0]
set_property offset [get_memory_offset psa0_limits] $memory_segment
set_property range  [get_memory_range psa0_limits]  $memory_segment

set idx [add_master_interface 0]
cell xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_psa1 {
  SINGLE_PORT_BRAM 1
  READ_LATENCY 3
  PROTOCOL AXI4LITE
} {
  s_axi_aclk ps_0/FCLK_CLK0
  s_axi_aresetn proc_sys_reset_0/peripheral_aresetn
  S_AXI axi_mem_intercon_0/M${idx}_AXI
}
assign_bd_address   [get_bd_addr_segs axi_bram_ctrl_psa1/S_AXI/Mem0]
set memory_segment  [get_bd_addr_segs /ps_0/Data/SEG_axi_bram_ctrl_psa1_Mem0]
set_property offset [get_memory_offset psa1_limits] $memory_segment
set_property range  [get_memory_range psa1_limits]  $memory_segment
# Add BRAM Controller
set idx [add_master_interface 0]
cell xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_psa2 {
  SINGLE_PORT_BRAM 1
  READ_LATENCY 3
  PROTOCOL AXI4LITE
} {
  s_axi_aclk ps_0/FCLK_CLK0
  s_axi_aresetn proc_sys_reset_0/peripheral_aresetn
  S_AXI axi_mem_intercon_0/M${idx}_AXI
}
assign_bd_address   [get_bd_addr_segs axi_bram_ctrl_psa2/S_AXI/Mem0]
set memory_segment  [get_bd_addr_segs /ps_0/Data/SEG_axi_bram_ctrl_psa2_Mem0]
set_property offset [get_memory_offset psa2_limits] $memory_segment
set_property range  [get_memory_range psa2_limits]  $memory_segment

set idx [add_master_interface 0]
cell xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_psa3 {
  SINGLE_PORT_BRAM 1
  READ_LATENCY 3
  PROTOCOL AXI4LITE
} {
  s_axi_aclk ps_0/FCLK_CLK0
  s_axi_aresetn proc_sys_reset_0/peripheral_aresetn
  S_AXI axi_mem_intercon_0/M${idx}_AXI
}
assign_bd_address   [get_bd_addr_segs axi_bram_ctrl_psa3/S_AXI/Mem0]
set memory_segment  [get_bd_addr_segs /ps_0/Data/SEG_axi_bram_ctrl_psa3_Mem0]
set_property offset [get_memory_offset psa3_limits] $memory_segment
set_property range  [get_memory_range psa3_limits]  $memory_segment

set idx [add_master_interface 0]
cell xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_psa4 {
  SINGLE_PORT_BRAM 1
  READ_LATENCY 3
  PROTOCOL AXI4LITE
} {
  s_axi_aclk ps_0/FCLK_CLK0
  s_axi_aresetn proc_sys_reset_0/peripheral_aresetn
  S_AXI axi_mem_intercon_0/M${idx}_AXI
}
assign_bd_address   [get_bd_addr_segs axi_bram_ctrl_psa4/S_AXI/Mem0]
set memory_segment  [get_bd_addr_segs /ps_0/Data/SEG_axi_bram_ctrl_psa4_Mem0]
set_property offset [get_memory_offset psa4_limits] $memory_segment
set_property range  [get_memory_range psa4_limits]  $memory_segment

set idx [add_master_interface 0]
# Add AXI stream FIFO
cell xilinx.com:ip:axi_clock_converter:2.1 axi_clock_converter {
} {
  m_axi_aclk adc/adc_clk
  m_axi_aresetn rst_adc_clk/peripheral_aresetn
  S_AXI axi_mem_intercon_0/M${idx}_AXI
  s_axi_aclk ps_0/FCLK_CLK0
  s_axi_aresetn proc_sys_reset_0/peripheral_aresetn
}

connect_pins trigger_0/THRESHOLD [ctl_pin trigger_threshold]
connect_pins trigger_0/clll adc/adc_clk
connect_pins trigger_0/ADC_INPUT [get_concat_pin [list adc/adc00 adc/adc01 adc/adc10 adc/adc11 ]]
cell xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 {
  TDATA_NUM_BYTES 8
} {
  s_axis_aclk adc/adc_clk
  s_axis_aresetn rst_adc_clk/peripheral_aresetn
  m_axis_aclk ps_0/FCLK_CLK0
  m_axis_aresetn proc_sys_reset_0/peripheral_aresetn
  s_axis_tdata trigger_0/TA 
  s_axis_tready trigger_0/TR
  s_axis_tvalid trigger_0/TV
}
cell koheron:user:tlast_gen:1.0 dma_tlast_gen_wave {
  TDATA_WIDTH 64
  PKT_LENGTH [expr 1024 * 1024]
} {
  aclk ps_0/FCLK_CLK0
  resetn proc_sys_reset_0/peripheral_aresetn
  s_axis axis_clock_converter_0/M_AXIS
}

cell xilinx.com:ip:axi_dma:7.1 axi_dma_wave {
  c_include_sg 1
  c_sg_include_stscntrl_strm 0
  c_sg_length_width 20
  c_s2mm_burst_size 16
  c_include_mm2s {1}
  c_include_s2mm {1}
  c_m_axi_s2mm_data_width 64
  c_m_axi_mm2s_data_width 64
  c_m_axis_mm2s_tdata_width 64
  c_mm2s_burst_size 16
} {
  S_AXI_LITE axi_mem_intercon_0/M[add_master_interface]_AXI
  s_axi_lite_aclk ps_0/FCLK_CLK0
  M_AXI_SG dma_interconnect_omc/S00_AXI
  m_axi_sg_aclk ps_0/FCLK_CLK0
  m_axi_mm2s_aclk ps_0/FCLK_CLK0
  M_AXI_S2MM dma_interconnect_s2mm_wave/S00_AXI
  M_AXI_MM2S dma_interconnect_s2mm_wave/S01_AXI
  m_axi_s2mm_aclk ps_0/FCLK_CLK0
  S_AXIS_S2MM dma_tlast_gen_wave/m_axis
  axi_resetn proc_sys_reset_0/peripheral_aresetn
}
cell xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_out {
  TDATA_NUM_BYTES 8
} {
  S_AXIS axi_dma_wave/M_AXIS_MM2S
  s_axis_aclk ps_0/FCLK_CLK0
  s_axis_aresetn proc_sys_reset_0/peripheral_aresetn
  m_axis_aclk adc/adc_clk
  m_axis_aresetn rst_adc_clk/peripheral_aresetn
}

cell xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_out {
  S_TDATA_NUM_BYTES 8
  M_TDATA_NUM_BYTES 2
} {
  aclk adc/adc_clk
  aresetn rst_adc_clk/peripheral_aresetn
  S_AXIS axis_clock_converter_out/M_AXIS
  m_axis_tvalid axis_dwidth_converter_out/m_axis_tready
}
set idx [add_master_interface 0]
# Add AXI stream FIFO
cell xilinx.com:ip:axi_clock_converter:2.1 psa_axis_clock_converter {
} {
  m_axi_aclk adc/adc_clk
  m_axi_aresetn rst_adc_clk/peripheral_aresetn
  S_AXI axi_mem_intercon_0/M${idx}_AXI
  s_axi_aclk ps_0/FCLK_CLK0
  s_axi_aresetn proc_sys_reset_0/peripheral_aresetn
}
cell xilinx.com:ip:axis_dwidth_converter:1.1 psa_axis_dwidth_converter {
  S_TDATA_NUM_BYTES 16 
  M_TDATA_NUM_BYTES 4
} {
  aclk adc/adc_clk
  aresetn rst_adc_clk/peripheral_aresetn
}
cell xilinx.com:ip:axi_fifo_mm_s:4.1 psa_axis_fifo {
  C_USE_TX_DATA 0
  C_USE_TX_CTRL 0
  C_USE_RX_CUT_THROUGH true
  C_RX_FIFO_DEPTH 4096
  C_RX_FIFO_PF_THRESHOLD 4000
} {
  s_axi_aclk adc/adc_clk
  s_axi_aresetn rst_adc_clk/peripheral_aresetn
  S_AXI psa_axis_clock_converter/M_AXI
  AXI_STR_RXD psa_axis_dwidth_converter/M_AXIS
}
assign_bd_address [get_bd_addr_segs psa_axis_fifo/S_AXI/Mem0]
set memory_segment  [get_bd_addr_segs /ps_0/Data/SEG_psa_axis_fifo_Mem0]
set_property offset [get_memory_offset psa_fifo] $memory_segment
set_property range [get_memory_range psa_fifo] $memory_segment


set_property "ip_repo_paths" "[concat [get_property ip_repo_paths [current_project]] [file normalize $project_path/ip_dir]]" "[current_project]"
update_ip_catalog -rebuild 

set idx [add_master_interface 0]
cell rsarwar.org:rsarwar:psa_core:2.0 psa_core_0  {
   C_NO_CHANN {5}
   C_ADC_MODE {TWOS_COMPLIMENT}
} {
  s_ctrl_axi axi_clock_converter/M_AXI
  stream_aclk ps_0/FCLK_CLK0
  stream_aresetn proc_sys_reset_0/peripheral_aresetn
  s_ctrl_axi_aclk adc/adc_clk
  s_ctrl_axi_aresetn rst_adc_clk/peripheral_aresetn
  TIMEOUT [sts_pin psa_runtime]
  m_adc_dma axi_dma_psa/S_AXIS_S2MM 
  adc_aclk adc/adc_clk
  adc_aresetn rst_adc_clk/peripheral_aresetn
    ADC0_IN adc/adc00 
    ADC1_IN adc/adc01
    ADC2_IN adc/adc10 
    ADC3_IN adc/adc11
    ADC4_IN axis_dwidth_converter_out/m_axis_tdata
    psa_bram_ch2 axi_bram_ctrl_psa2/BRAM_PORTA
    psa_bram_ch4 axi_bram_ctrl_psa4/BRAM_PORTA
    psa_bram_ch3 axi_bram_ctrl_psa3/BRAM_PORTA
    psa_bram_ch1 axi_bram_ctrl_psa1/BRAM_PORTA
    psa_bram_ch0 axi_bram_ctrl_psa0/BRAM_PORTA
    m_psa250 psa_axis_dwidth_converter/S_AXIS 
}

cell trenz.biz:user:labtools_fmeter:1.0 labtools_fmeter_0 {
  C_CHANNELS {1}
} {
  refclk ps_0/FCLK_CLK1
  fin adc/adc_clk
  F0 [sts_pin adc_freq0]
}


# DMA AXI Lite
assign_bd_address [get_bd_addr_segs {axi_dma_wave/S_AXI_LITE/Reg }]
set_property range [get_memory_range dma_wave] [get_bd_addr_segs {ps_0/Data/SEG_axi_dma_wave_Reg}]
set_property offset [get_memory_offset dma_wave] [get_bd_addr_segs {ps_0/Data/SEG_axi_dma_wave_Reg}]
assign_bd_address [get_bd_addr_segs {axi_dma_psa/S_AXI_LITE/Reg }]
set_property range [get_memory_range dma_psa] [get_bd_addr_segs {ps_0/Data/SEG_axi_dma_psa_Reg}]
set_property offset [get_memory_offset dma_psa] [get_bd_addr_segs {ps_0/Data/SEG_axi_dma_psa_Reg}]

# Scatter Gather interface in On Chip Memory
assign_bd_address [get_bd_addr_segs {ps_0/S_AXI_GP0/GP0_HIGH_OCM }]
set_property range 32K [get_bd_addr_segs {axi_dma_psa/Data_SG/SEG_ps_0_GP0_HIGH_OCM}]
set_property offset [get_memory_offset ocm_s2mm_psa] [get_bd_addr_segs {axi_dma_psa/Data_SG/SEG_ps_0_GP0_HIGH_OCM}]
set_property range 32K [get_bd_addr_segs {axi_dma_wave/Data_SG/SEG_ps_0_GP0_HIGH_OCM}]
set_property offset [get_memory_offset ocm_s2mm_wave] [get_bd_addr_seg {axi_dma_wave/Data_SG/SEG_ps_0_GP0_HIGH_OCM}]

# MM2S on HP2
assign_bd_address [get_bd_addr_segs {ps_0/S_AXI_HP2/HP0_DDR_LOWOCM }]
set_property range [get_memory_range ram_s2mm_wave] [get_bd_addr_segs {axi_dma_wave/Data_S2MM/SEG_ps_0_HP2_DDR_LOWOCM}]
set_property offset [get_memory_offset ram_s2mm_wave] [get_bd_addr_segs {axi_dma_wave/Data_S2MM/SEG_ps_0_HP2_DDR_LOWOCM}]
set_property range [get_memory_range ram_s2mm_wave] [get_bd_addr_segs {axi_dma_wave/Data_MM2S/SEG_ps_0_HP2_DDR_LOWOCM}]
set_property offset [get_memory_offset ram_s2mm_wave] [get_bd_addr_segs {axi_dma_wave/Data_MM2S/SEG_ps_0_HP2_DDR_LOWOCM}]


# S2MM on HP0
assign_bd_address [get_bd_addr_segs {ps_0/S_AXI_HP0/HP2_DDR_LOWOCM }]
set_property range [get_memory_range ram_s2mm_psa] [get_bd_addr_segs {axi_dma_psa/Data_S2MM/SEG_ps_0_HP0_DDR_LOWOCM}]
set_property offset [get_memory_offset ram_s2mm_psa] [get_bd_addr_segs {axi_dma_psa/Data_S2MM/SEG_ps_0_HP0_DDR_LOWOCM}]

exclude_bd_addr_seg [get_bd_addr_segs axi_dma_psa/Data_S2MM/SEG_ps_0_HP0_HIGH_OCM]
exclude_bd_addr_seg [get_bd_addr_segs axi_dma_wave/Data_S2MM/SEG_ps_0_HP2_HIGH_OCM]
exclude_bd_addr_seg [get_bd_addr_segs axi_dma_psa/Data_SG/SEG_ps_0_GP0_QSPI_LINEAR]
exclude_bd_addr_seg [get_bd_addr_segs axi_dma_psa/Data_SG/SEG_ps_0_GP0_DDR_LOWOCM]
exclude_bd_addr_seg [get_bd_addr_segs axi_dma_wave/Data_SG/SEG_ps_0_GP0_QSPI_LINEAR]
exclude_bd_addr_seg [get_bd_addr_segs axi_dma_wave/Data_SG/SEG_ps_0_GP0_DDR_LOWOCM]

# create blocks
move_bd_cells [get_bd_cells ctl] [get_bd_cells slice_5_5_ctl_digital_outputs] [get_bd_cells slice_3_3_ctl_digital_outputs] [get_bd_cells slice_0_0_ctl_digital_outputs] [get_bd_cells slice_2_2_ctl_digital_outputs] [get_bd_cells slice_1_1_ctl_digital_outputs] [get_bd_cells slice_7_7_ctl_digital_outputs] [get_bd_cells slice_4_4_ctl_digital_outputs] [get_bd_cells slice_6_6_ctl_digital_outputs] [get_bd_cells concat_precision_dac_data]
group_bd_cells psa [get_bd_cells axi_bram_ctrl_psa0] [get_bd_cells axi_bram_ctrl_psa4] [get_bd_cells axi_bram_ctrl_psa1] [get_bd_cells axi_bram_ctrl_psa2] [get_bd_cells axi_bram_ctrl_psa3] [get_bd_cells psa_core_0] 
move_bd_cells [get_bd_cells psa] [get_bd_cells psa_axis_dwidth_converter] [get_bd_cells psa_axis_clock_converter] [get_bd_cells psa_axis_fifo]
move_bd_cells [get_bd_cells psa] [get_bd_cells axi_clock_converter]
# Hack to change the 32 bit auto width in AXI_DMA S_AXI_S2MM
validate_bd_design

    set obj [get_filesets sim_1]
    add_files -fileset sim_1 -norecurse $project_path/tb_fulltest_behav.wcfg
    add_files -fileset sim_1 -norecurse $project_path/tb_full_synt.vhd
    set file "$project_path/tb_full_synt.vhd"
    set file [file normalize $file]
    set file_obj [get_files -of_objects [get_filesets sim_1] [list "*$file"]]
    set_property -name "file_type" -value "VHDL" -objects $file_obj
    set_property -name "sim_mode" -value "post-implementation" -objects $obj
    set_property -name "top" -value "tb_full_synt" -objects $obj
    set_property -name "top_auto_set" -value "0" -objects $obj
    set_property -name "top_lib" -value "xil_defaultlib" -objects $obj

