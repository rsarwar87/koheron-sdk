  set pmod_ja [ create_bd_intf_port -mode Master -vlnv digilentinc.com:interface:pmod_rtl:1.0 pmod_ja ]
  set pmod_jb [ create_bd_intf_port -mode Master -vlnv digilentinc.com:interface:pmod_rtl:1.0 pmod_jb ]
  
  # Create instance: PmodGPIO_0, and set properties
  cell digilentinc.com:IP:PmodGPIO:1.0  PmodGPIO_0 {
  } {
    AXI_LITE_GPIO axi_mem_intercon_0/M[add_master_interface]_AXI
    s_axi_aclk $ps_name/FCLK_CLK0
    s_axi_aresetn proc_sys_reset_0/peripheral_aresetn
    Pmod_out pmod_ja
  }

  # Create instance: PmodGPIO_1, and set properties
  cell digilentinc.com:IP:PmodGPIO:1.0 PmodGPIO_1 {
  } {
    AXI_LITE_GPIO axi_mem_intercon_0/M[add_master_interface]_AXI
    s_axi_aclk $ps_name/FCLK_CLK0
    s_axi_aresetn proc_sys_reset_0/peripheral_aresetn
    Pmod_out pmod_jb
  }
  
  
  create_bd_addr_seg -range [get_memory_range pmod0] -offset [get_memory_offset pmod0] [get_bd_addr_spaces_0/Data] [get_bd_addr_segs PmodGPIO_0/AXI_LITE_GPIO/Reg0] SEG_PmodGPIO_0_Reg0
  create_bd_addr_seg -range [get_memory_range pmod1] -offset [get_memory_offset pmod1] [get_bd_addr_spaces ps_0/Data] [get_bd_addr_segs PmodGPIO_1/AXI_LITE_GPIO/Reg0] SEG_PmodGPIO_1_Reg0

