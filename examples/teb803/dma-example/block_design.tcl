# Add PS and AXI Interconnect
set board_preset $board_path/config/board_preset.tcl

source $sdk_path/fpga/lib/starting_point_zynqmp.tcl

# Add config and status registers
source $sdk_path/fpga/lib/ctl_sts.tcl
add_ctl_sts
source $board_path/board_only_connections.tcl

# Connect 42 to status register
connect_pins [get_constant_pin 42 32] [sts_pin forty_two]

set_cell_props ps_0 {
  PSU__USE__S_AXI_GP2 {1} 
  CONFIG.PSU__USE__IRQ0 {1}
  PSU__USE__S_AXI_GP2 {1} 
  PSU__USE__S_AXI_GP3 {1} 
  PSU__USE__S_AXI_GP6 {1} 
  PSU__USE__IRQ0 {1}
  PSU__SAXIGP6__DATA_WIDTH {32}
  PSU__MAXIGP0__DATA_WIDTH {32}
}

connect_pins ps_0/saxihp0_fpd_aclk ps_0/pl_clk0
connect_pins ps_0/saxihp1_fpd_aclk ps_0/pl_clk0
connect_pins ps_0/saxi_lpd_aclk ps_0/pl_clk0

cell xilinx.com:ip:smartconnect:1.0 dma_interconnect_omc {
  NUM_SI 1
  NUM_MI 1
} {
  aclk ${ps_name}/pl_clk0
  aresetn proc_sys_reset_0/peripheral_aresetn
  M00_AXI ${ps_name}/S_AXI_LPD
}

cell xilinx.com:ip:smartconnect:1.0 dma_interconnect_mm2s {
  NUM_SI 1
  NUM_MI 1
  S00_AXIHAS_REGSLICE 1
} {
  aclk ${ps_name}/pl_clk0
  aresetn proc_sys_reset_0/peripheral_aresetn
  M00_AXI ${ps_name}/S_AXI_HP0_FPD
}

cell xilinx.com:ip:smartconnect:1.0 dma_interconnect_s2mm {
  NUM_SI 1
  NUM_MI 1
  S00_AXIHAS_REGSLICE 1
} {
  aclk ${ps_name}/pl_clk0
  aresetn proc_sys_reset_0/peripheral_aresetn
  M00_AXI ${ps_name}/S_AXI_HP1_FPD
}

cell xilinx.com:ip:axi_dma:7.1 axi_dma_0 {
  c_include_sg 1
  c_sg_include_stscntrl_strm 0
  c_sg_length_width 20
  c_s2mm_burst_size 16
  c_m_axi_s2mm_data_width 128
  c_m_axi_mm2s_data_width 128
  c_m_axis_mm2s_tdata_width 128
  c_mm2s_burst_size 16
  c_sg_include_stscntrl_strm {0} 
} {
  S_AXI_LITE axi_mem_intercon_0/M[add_master_interface]_AXI
  s_axi_lite_aclk ps_0/pl_clk0
  M_AXI_SG dma_interconnect_omc/S00_AXI
  m_axi_sg_aclk ps_0/pl_clk0
  M_AXI_MM2S dma_interconnect_mm2s/S00_AXI
  m_axi_mm2s_aclk ps_0/pl_clk0
  M_AXI_S2MM dma_interconnect_s2mm/S00_AXI
  m_axi_s2mm_aclk ps_0/pl_clk0
  axi_resetn proc_sys_reset_0/peripheral_aresetn
  M_AXIS_MM2S axi_dma_0/S_AXIS_S2MM
}

connect_cell ps_0 {
  pl_ps_irq0 [get_concat_pin [ list axi_dma_0/mm2s_introut axi_dma_0/s2mm_introut ]]
}

# DMA AXI Lite
assign_bd_address [get_bd_addr_segs {axi_dma_0/S_AXI_LITE/Reg }]
set_property offset [get_memory_offset dma] [get_bd_addr_segs {ps_0/Data/SEG_axi_dma_0_Reg}]
set_property range [get_memory_range dma] [get_bd_addr_segs {ps_0/Data/SEG_axi_dma_0_Reg}]

# Scatter Gather interface in On Chip Memory
assign_bd_address [get_bd_addr_segs {ps_0/SAXIGP6/LPD_LPS_OCM}]
include_bd_addr_seg [get_bd_addr_segs -excluded axi_dma_0/Data_SG/SEG_ps_0_LPD_LPS_OCM]
set_property range 64K [get_bd_addr_segs {axi_dma_0/Data_SG/SEG_ps_0_LPD_LPS_OCM}]
set_property offset [get_memory_offset ocm_mm2s] [get_bd_addr_segs {axi_dma_0/Data_SG/SEG_ps_0_LPD_LPS_OCM}]

# MM2S on HP2
assign_bd_address [get_bd_addr_segs {ps_0/S_AXI_HP0/HP0_DDR_LOW}]
set_property range [get_memory_range ram_mm2s] [get_bd_addr_segs {axi_dma_0/Data_MM2S/SEG_ps_0_HP0_DDR_LOW}]
set_property offset [get_memory_offset ram_mm2s] [get_bd_addr_segs {axi_dma_0/Data_MM2S/SEG_ps_0_HP0_DDR_LOW}]

# S2MM on HP0
assign_bd_address [get_bd_addr_segs {ps_0/S_AXI_HP1/HP1_DDR_LOW}]
set_property range [get_memory_range ram_s2mm] [get_bd_addr_segs {axi_dma_0/Data_S2MM/SEG_ps_0_HP1_DDR_LOW}]
set_property offset [get_memory_offset ram_s2mm] [get_bd_addr_segs {axi_dma_0/Data_S2MM/SEG_ps_0_HP1_DDR_LOW}]


delete_bd_objs [get_bd_addr_segs axi_dma_0/Data_SG/SEG_ps_0_LPD_DDR_LOW] \
        [get_bd_addr_segs axi_dma_0/Data_SG/SEG_ps_0_LPD_PCIE_LOW] \
        [get_bd_addr_segs axi_dma_0/Data_SG/SEG_ps_0_LPD_QSPI] \
        [get_bd_addr_segs axi_dma_0/Data_MM2S/SEG_ps_0_HP0_PCIE_LOW] \
        [get_bd_addr_segs axi_dma_0/Data_MM2S/SEG_ps_0_HP0_QSPI] \
        [get_bd_addr_segs axi_dma_0/Data_S2MM/SEG_ps_0_HP1_PCIE_LOW] \
        [get_bd_addr_segs axi_dma_0/Data_S2MM/SEG_ps_0_HP1_QSPI]


# connect_pins xdma_0/M_AXIS_H2C_0 xdma_0/S_AXIS_C2H_0 
# connect_pins xdma_0/M_AXIS_H2C_1 xdma_0/S_AXIS_C2H_1 
