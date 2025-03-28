# Add PS and AXI Interconnect
set board_preset $board_path/config/board_preset.tcl

source $sdk_path/fpga/lib/starting_point.tcl

# Add config and status registers
source $sdk_path/fpga/lib/ctl_sts.tcl
add_ctl_sts
source $board_path/board_only_connections.tcl

# Connect LEDs to config register
connect_port_pin gpio [get_slice_pin [ctl_pin led] 7 0]

# Connect 42 to status register
connect_pins [get_constant_pin 42 32] [sts_pin forty_two]

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
  NUM_SI 1
  NUM_MI 1
} {
  aclk ${ps_name}/FCLK_CLK0
  aresetn proc_sys_reset_0/peripheral_aresetn
  M00_AXI ${ps_name}/S_AXI_GP0
}

cell xilinx.com:ip:smartconnect:1.0 dma_interconnect_mm2s {
  NUM_SI 1
  NUM_MI 1
  S00_AXIHAS_REGSLICE 1
} {
  aclk ${ps_name}/FCLK_CLK0
  aresetn proc_sys_reset_0/peripheral_aresetn
  M00_AXI ${ps_name}/S_AXI_HP0
}

cell xilinx.com:ip:smartconnect:1.0 dma_interconnect_s2mm {
  NUM_SI 1
  NUM_MI 1
  S00_AXIHAS_REGSLICE 1
} {
  aclk ${ps_name}/FCLK_CLK0
  aresetn proc_sys_reset_0/peripheral_aresetn
  M00_AXI ${ps_name}/S_AXI_HP2
}

cell xilinx.com:ip:axi_dma:7.1 axi_dma_0 {
  c_include_sg 1
  c_sg_include_stscntrl_strm 0
  c_sg_length_width 20
  c_s2mm_burst_size 16
  c_m_axi_s2mm_data_width 64
  c_m_axi_mm2s_data_width 64
  c_m_axis_mm2s_tdata_width 64
  c_mm2s_burst_size 16
} {
  S_AXI_LITE axi_mem_intercon_1/M[add_master_interface 1]_AXI
  s_axi_lite_aclk ps_0/FCLK_CLK1
  M_AXI_SG dma_interconnect_omc/S00_AXI
  m_axi_sg_aclk ps_0/FCLK_CLK0
  M_AXI_MM2S dma_interconnect_mm2s/S00_AXI
  m_axi_mm2s_aclk ps_0/FCLK_CLK0
  M_AXI_S2MM dma_interconnect_s2mm/S00_AXI
  m_axi_s2mm_aclk ps_0/FCLK_CLK0
  axi_resetn proc_sys_reset_0/peripheral_aresetn
}
connect_cell axi_dma_0 {
    S_AXIS_S2MM axi_dma_0/M_AXIS_MM2S
}

# DMA AXI Lite
assign_bd_address [get_bd_addr_segs {axi_dma_0/S_AXI_LITE/Reg }]
set_property range [get_memory_range dma] [get_bd_addr_segs {ps_0/Data/SEG_axi_dma_0_Reg}]
set_property offset [get_memory_offset dma] [get_bd_addr_segs {ps_0/Data/SEG_axi_dma_0_Reg}]

# Scatter Gather interface in On Chip Memory
assign_bd_address [get_bd_addr_segs {ps_0/S_AXI_GP0/GP0_HIGH_OCM }]
set_property range 64K [get_bd_addr_segs {axi_dma_0/Data_SG/SEG_ps_0_GP0_HIGH_OCM}]
set_property offset [get_memory_offset ocm_mm2s] [get_bd_addr_segs {axi_dma_0/Data_SG/SEG_ps_0_GP0_HIGH_OCM}]

# MM2S on HP2
assign_bd_address [get_bd_addr_segs {ps_0/S_AXI_HP0/HP0_DDR_LOWOCM }]
set_property range [get_memory_range ram_mm2s] [get_bd_addr_segs {axi_dma_0/Data_MM2S/SEG_ps_0_HP0_DDR_LOWOCM}]
set_property offset [get_memory_offset ram_mm2s] [get_bd_addr_segs {axi_dma_0/Data_MM2S/SEG_ps_0_HP0_DDR_LOWOCM}]

# S2MM on HP0
assign_bd_address [get_bd_addr_segs {ps_0/S_AXI_HP2/HP2_DDR_LOWOCM }]
set_property range [get_memory_range ram_s2mm] [get_bd_addr_segs {axi_dma_0/Data_S2MM/SEG_ps_0_HP2_DDR_LOWOCM}]
set_property offset [get_memory_offset ram_s2mm] [get_bd_addr_segs {axi_dma_0/Data_S2MM/SEG_ps_0_HP2_DDR_LOWOCM}]


set run_autowrapper 0
set extension pcie_
set obj [get_filesets sources_1]
set files [list \
"[file normalize "$board_path/config/system_top_${extension}PE1.vhd"]"\
]
add_files -norecurse -fileset $obj $files
set file "$board_path/config/system_top_${extension}PE1.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj
set obj [get_filesets sources_1]
set_property "top" "system_top" $obj

# add pcie at after adding all interfaces to the ps_0 interconnect.
set int_bus 0   
# source $board_path/pcie_mm_connections.tcl
source $board_path/pcie_streaming_connections.tcl
connect_cell xdma_0 {
    M_AXIS_H2C_0 xdma_0/S_AXIS_C2H_0
    M_AXIS_H2C_1 xdma_0/S_AXIS_C2H_1
}
# connect_pins xdma_0/M_AXIS_H2C_0 xdma_0/S_AXIS_C2H_0 
# connect_pins xdma_0/M_AXIS_H2C_1 xdma_0/S_AXIS_C2H_1 
# Unmap unused segments
exclude_bd_addr_seg [get_bd_addr_segs axi_dma_0/Data_SG/SEG_ps_0_GP0_M_AXI_GP0]
exclude_bd_addr_seg [get_bd_addr_segs axi_dma_0/Data_SG/SEG_ps_0_GP0_IOP]
exclude_bd_addr_seg [get_bd_addr_segs axi_dma_0/Data_SG/SEG_ps_0_GP0_DDR_LOWOCM]
exclude_bd_addr_seg [get_bd_addr_segs axi_dma_0/Data_SG/SEG_ps_0_GP0_QSPI_LINEAR]
exclude_bd_addr_seg [get_bd_addr_segs axi_dma_0/Data_MM2S/SEG_ps_0_GP0_HIGH_OCM]
exclude_bd_addr_seg [get_bd_addr_segs axi_dma_0/Data_MM2S/SEG_ps_0_HP2_DDR_LOWOCM]
exclude_bd_addr_seg [get_bd_addr_segs axi_dma_0/Data_S2MM/SEG_ps_0_GP0_HIGH_OCM]
exclude_bd_addr_seg [get_bd_addr_segs axi_dma_0/Data_S2MM/SEG_ps_0_HP0_DDR_LOWOCM]

#
# Hack to change the 32 bit auto width in AXI_DMA S_AXI_S2MM
validate_bd_design
#
