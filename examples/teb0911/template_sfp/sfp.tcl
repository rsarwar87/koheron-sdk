create_bd_port -dir I -from 3 -to 3 fmcb_rx_p
create_bd_port -dir I -from 3 -to 3 fmcb_rx_n
create_bd_port -dir O -from 3 -to 3 fmcb_tx_p
create_bd_port -dir O -from 3 -to 3 fmcb_tx_n

create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 fmcb_mgt_refclk0
set_property CONFIG.FREQ_HZ 156250000 [get_bd_intf_ports /fmcb_mgt_refclk0]

create_bd_port -dir O fmcb_sfp_tx_disable_n
create_bd_port -dir O -from 2 -to 0 fmcb_sfp_rate_sel
create_bd_port -dir I fmcb_sfp_tx_fault

create_bd_port -dir I -from 3 -to 0 fmcb_sfp_mod_def0
create_bd_port -dir I -from 3 -to 0 fmcb_sfp_los

set_cell_props ps_0 {
  PSU__CRL_APB__PL3_REF_CTRL__FREQMHZ {50} 
  PSU__FPGA_PL3_ENABLE {1}
}

set hier_obj [create_bd_cell -type hier ethernet_subsystem]
current_bd_instance $hier_obj

cell xilinx.com:ip:proc_sys_reset:5.0 rst_phy_0  {
} {
  slowest_sync_clk /ps_0/pl_clk0
  ext_reset_in /ps_0/pl_resetn0 
}
set MARK_DEBUG_ETH  False
cell CCFE:user:ethernet_mac:1.0 ethernet_mac_0 {
    DEBUG_G        {$MARK_DEBUG_ETH}
    RST_POLARITY_G {1}
    IS_10G         [get_parameter IS_10G]
    MEMORY_TYPE_G  {ultra}
} {
    ctrl_axi /axi_mem_intercon_0/M[add_master_interface]_AXI
    core_rst /proc_sys_reset_0/peripheral_reset
    core_clk  /ps_0/pl_clk0
    sfp_tx_disable_n fmcb_sfp_tx_disable_n
    sfp_rate_sel fmcb_sfp_rate_sel
    sfp_tx_fault fmcb_sfp_tx_fault
    sfp_mod_present fmcb_sfp_mod_def0
    sfp_los fmcb_sfp_los
    phy_rst_aux_out rst_phy_0/aux_reset_in
}
if {[get_parameter IS_10G]} {
    set_cell_props /ps_0 {
      PSU__CRL_APB__PL3_REF_CTRL__FREQMHZ {125.0} 
    }
    cell xilinx.com:ip:xxv_ethernet:4.1 ten_gig_eth_0 {
        CORE                 {Ethernet PCS/PMA 64-bit}
        BASE_R_KR            {BASE-R}
        GT_DRP_CLK           {125.00}
        GT_GROUP_SELECT      {Quad_X0Y3}
        INCLUDE_SHARED_LOGIC {1}
        LANE1_GT_LOC         {X0Y15}
    } {
        gt_ref_clk                           /fmcb_mgt_refclk0
        dclk                                 /ps_0/pl_clk3

        gt_rxp_in_0                          /fmcb_rx_p
        gt_rxn_in_0                          /fmcb_rx_n
        gt_txp_out_0                         /fmcb_tx_p
        gt_txn_out_0                         /fmcb_tx_n

        tx_mii_d_0                           ethernet_mac_0/xgmiiTxd
        tx_mii_c_0                           ethernet_mac_0/xgmiiTxc
        rx_mii_d_0                           ethernet_mac_0/xgmiiRxd
        rx_mii_c_0                           ethernet_mac_0/xgmiiRxc

        rx_core_clk_0                        ethernet_mac_0/eth_clk
        tx_mii_clk_0                         ethernet_mac_0/eth_clk
        user_tx_reset_0                      ethernet_mac_0/gth_reset_tx_user
        user_rx_reset_0                      ethernet_mac_0/gth_reset_rx_user

        tx_reset_0                           rst_phy_0/peripheral_reset
        rx_reset_0                           rst_phy_0/peripheral_reset
        sys_reset                            rst_phy_0/peripheral_reset
        qpllreset_in_0                       rst_phy_0/peripheral_reset
        gtwiz_reset_tx_datapath_0            rst_phy_0/peripheral_reset
        gtwiz_reset_rx_datapath_0            rst_phy_0/peripheral_reset

        txoutclksel_in_0                     [get_constant_pin 0b101 3]
        rxoutclksel_in_0                     [get_constant_pin 0b101 3]
        gt_loopback_in_0                     [get_constant_pin 0 3]

        gtpowergood_out_0                    ethernet_mac_0/gtpowergood
        stat_tx_local_fault_0                ethernet_mac_0/stat_tx_local_fault
        stat_rx_bad_code_0                   ethernet_mac_0/stat_rx_bad_code
        stat_rx_bad_code_valid_0             ethernet_mac_0/stat_rx_bad_code_valid
        stat_rx_block_lock_0                 ethernet_mac_0/stat_rx_block_lock
        stat_rx_error_valid_0                ethernet_mac_0/stat_rx_error_valid
        stat_rx_fifo_error_0                 ethernet_mac_0/stat_rx_fifo_error
        stat_rx_framing_err_0                ethernet_mac_0/stat_rx_framing_err
        stat_rx_framing_err_valid_0          ethernet_mac_0/stat_rx_framing_err_valid

        stat_rx_local_fault_0                ethernet_mac_0/stat_rx_local_fault
        stat_rx_valid_ctrl_code_0            ethernet_mac_0/stat_rx_valid_ctrl_code
        stat_rx_status_0                     ethernet_mac_0/stat_rx_status
        stat_rx_error_0                      ethernet_mac_0/stat_rx_error
    }

    cell xilinx.com:ip:proc_sys_reset:5.0 eth_sys_reset {
    } {
      slowest_sync_clk ten_gig_eth_0/rx_core_clk_0
      ext_reset_in /ps_0/pl_resetn0 
      peripheral_reset ethernet_mac_0/eth_rst
    }

    cell trenz.biz:user:labtools_fmeter:1.0 labtools_fmeter_1 {
      C_CHANNELS {6} 
      C_REFCLK_HZ {[get_parameter fclk0]}
    } {
      refclk /ps_0/pl_clk0
      fin [get_concat_pin [list ten_gig_eth_0/rx_core_clk_0 \
        ten_gig_eth_0/rx_core_clk_0 \
        ten_gig_eth_0/rx_core_clk_0 \
        ten_gig_eth_0/rx_core_clk_0 \
        ten_gig_eth_0/rx_core_clk_0 \
        ten_gig_eth_0/rx_core_clk_0 \
        ]]
       
      F0  [sts_pin clock_0]
      F1  [sts_pin clock_1]
      F2  [sts_pin clock_2]
      F3  [sts_pin clock_3]
      F4  [sts_pin clock_4]
      F5  [sts_pin clock_5]
    
    }
    cell xilinx.com:ip:vio:3.0 vio_0  {
       C_EN_PROBE_IN_ACTIVITY {0} 
       C_NUM_PROBE_IN {21} 
       C_PROBE_IN0_WIDTH {32} 
       C_PROBE_IN1_WIDTH {32} 
       C_PROBE_IN2_WIDTH {32} 
       C_PROBE_IN3_WIDTH {32} 
       C_PROBE_IN4_WIDTH {32} 
       C_PROBE_IN5_WIDTH {32} 
       C_PROBE_IN6_WIDTH {16} 
       C_NUM_PROBE_OUT     {11}
       C_PROBE_OUT0_WIDTH  {1}
       C_PROBE_OUT1_WIDTH  {1}
       C_PROBE_OUT2_WIDTH  {1}
       C_PROBE_OUT3_WIDTH  {1}
       C_PROBE_OUT4_WIDTH  {1}
       C_PROBE_OUT5_WIDTH  {1}
       C_PROBE_OUT6_WIDTH  {1}
       C_PROBE_OUT7_WIDTH  {1}
       C_PROBE_OUT8_WIDTH  {58}
       C_PROBE_OUT9_WIDTH  {58}
       C_PROBE_OUT10_WIDTH {1}
    } {
      clk  /ps_0/pl_clk0
      probe_in0 labtools_fmeter_1/F0
      probe_in1 labtools_fmeter_1/F1
      probe_in2 labtools_fmeter_1/F2
      probe_in3 labtools_fmeter_1/F3
      probe_in4 labtools_fmeter_1/F4
      probe_in5 labtools_fmeter_1/F5
      probe_in6 ten_gig_eth_0/gtpowergood_out_0
      probe_in7 ten_gig_eth_0/stat_tx_local_fault_0
      probe_in8 ten_gig_eth_0/stat_rx_bad_code_0
      probe_in9 ten_gig_eth_0/stat_rx_bad_code_valid_0
      probe_in10 ten_gig_eth_0/stat_rx_block_lock_0
      probe_in11 ten_gig_eth_0/stat_rx_error_valid_0
      probe_in12 ten_gig_eth_0/stat_rx_fifo_error_0
      probe_in13 ten_gig_eth_0/stat_rx_framing_err_0
      probe_in14 ten_gig_eth_0/stat_rx_framing_err_valid_0    
      probe_in15 ten_gig_eth_0/stat_rx_local_fault_0    
      probe_in16 ten_gig_eth_0/stat_rx_valid_ctrl_code_0
      probe_in17 ten_gig_eth_0/stat_rx_status_0         
      probe_in18 ten_gig_eth_0/stat_rx_error_0          
      probe_in19 ten_gig_eth_0/user_tx_reset_0          
      probe_in20 ten_gig_eth_0/user_rx_reset_0          

      probe_out0   ten_gig_eth_0/ctl_rx_test_pattern_0               
      probe_out1  ten_gig_eth_0/ctl_rx_data_pattern_select_0         
      probe_out2  ten_gig_eth_0/ctl_rx_test_pattern_enable_0         
      probe_out3  ten_gig_eth_0/ctl_rx_prbs31_test_pattern_enable_0  
      probe_out4  ten_gig_eth_0/ctl_tx_test_pattern_0                
      probe_out5  ten_gig_eth_0/ctl_tx_test_pattern_enable_0         
      probe_out6  ten_gig_eth_0/ctl_tx_test_pattern_select_0         
      probe_out7  ten_gig_eth_0/ctl_tx_data_pattern_select_0         
      probe_out8  ten_gig_eth_0/ctl_tx_test_pattern_seed_a_0         
      probe_out9  ten_gig_eth_0/ctl_tx_test_pattern_seed_b_0         
      probe_out10 ten_gig_eth_0/ctl_tx_prbs31_test_pattern_enable_0  

    }
    
} else {
    set_cell_props /ps_0 {
      PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {50} 
    }
    cell xilinx.com:ip:gig_ethernet_pcs_pma:16.2 gig_ethernet_pcs_pma_0 {
        Auto_Negotiation {true} \
        EMAC_IF_TEMAC {TEMAC} \
        Standard {BOTH} \
        RefClkRate           {156.25}
        GT_Location          {X1Y15}
        SGMII_PHY_Mode {true} \
        SupportLevel {Include_Shared_Logic_in_Core} \
        Management_Interface {false} \
    } {
        gtrefclk_in             /sfp_refclk
        independent_clock_bufg  /ps_0/pl_clk3
        signal_detect           [get_constant_pin 1 1]
        reset                   rst_phy_0/peripheral_reset
        gmii_pcs_pma            ethernet_mac_0/gmii
        an_adv_config_vector    ethernet_mac_0/an_adv_config_vector
        an_restart_config       ethernet_mac_0/an_restart_config
        userclk2_out            ethernet_mac_0/eth_clk
        status_vector           ethernet_mac_0/gth_status_vector
        resetdone               ethernet_mac_0/gth_resetdone
        an_interrupt            ethernet_mac_0/an_interrupt
        configuration_vector    ethernet_mac_0/an_configuration_vector
        basex_or_sgmii          ethernet_mac_0/phy_base_sgmii 
        speed_is_10_100         [get_constant_pin 0 1]
        speed_is_100            [get_constant_pin 0 1]
        rxp                     /sfp_0_rxp
        rxn                     /sfp_0_rxn
        txp                     /sfp_0_txp
        txn                     /sfp_0_txn
    }
    cell xilinx.com:ip:proc_sys_reset:5.0 eth_sys_reset {
    } {
      slowest_sync_clk gig_ethernet_pcs_pma_0/userclk2_out
      ext_reset_in /ps_0/pl_resetn0 
      dcm_locked gig_ethernet_pcs_pma_0/mmcm_locked_out 
      peripheral_reset ethernet_mac_0/eth_rst
    }

    cell trenz.biz:user:labtools_fmeter:1.0 labtools_fmeter_1 {
      C_CHANNELS {6} 
      C_REFCLK_HZ {[get_parameter fclk0]}
    } {
      refclk /ps_0/pl_clk0
      fin [get_concat_pin [list gig_ethernet_pcs_pma_0/rxuserclk2_out \
        gig_ethernet_pcs_pma_0/userclk2_out \
        gig_ethernet_pcs_pma_0/userclk_out \
        gig_ethernet_pcs_pma_0/rxuserclk2_out \
        gig_ethernet_pcs_pma_0/rxuserclk2_out \
        gig_ethernet_pcs_pma_0/rxuserclk2_out \
        ]]
       
      F0  [sts_pin clock_0]
      F1  [sts_pin clock_1]
      F2  [sts_pin clock_2]
      F3  [sts_pin clock_3]
      F4  [sts_pin clock_4]
      F5  [sts_pin clock_5]
    
    }
    cell xilinx.com:ip:vio:3.0 vio_0  {
       C_EN_PROBE_IN_ACTIVITY {0} 
       C_NUM_PROBE_IN {13} 
       C_NUM_PROBE_OUT {0} 
       C_PROBE_IN0_WIDTH {32} 
       C_PROBE_IN1_WIDTH {32} 
       C_PROBE_IN2_WIDTH {32} 
       C_PROBE_IN3_WIDTH {32} 
       C_PROBE_IN4_WIDTH {32} 
       C_PROBE_IN5_WIDTH {32} 
       C_PROBE_IN6_WIDTH {16} 
    } {
      clk  /ps_0/pl_clk0
      probe_in0 labtools_fmeter_1/F0
      probe_in1 labtools_fmeter_1/F1
      probe_in2 labtools_fmeter_1/F2
      probe_in3 labtools_fmeter_1/F3
      probe_in4 labtools_fmeter_1/F4
      probe_in5 labtools_fmeter_1/F5
      probe_in6 gig_ethernet_pcs_pma_0/status_vector
      probe_in7 gig_ethernet_pcs_pma_0/gmii_isolate
      probe_in8 gig_ethernet_pcs_pma_0/reset
      probe_in9 gig_ethernet_pcs_pma_0/mmcm_locked_out
      probe_in10 gig_ethernet_pcs_pma_0/resetdone
      probe_in11 gig_ethernet_pcs_pma_0/gtpowergood
      probe_in12 ethernet_mac_0/eth_rst
    }
    
    create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
    set_property -dict [list CONFIG.IN0_WIDTH.VALUE_SRC USER] [get_bd_cells xlconcat_0]
    set_property -dict [list CONFIG.NUM_PORTS {10} CONFIG.IN0_WIDTH {16}] [get_bd_cells xlconcat_0]
    connect_bd_net [get_bd_pins xlconcat_0/In0] [get_bd_pins gig_ethernet_pcs_pma_0/status_vector]
    connect_bd_net [get_bd_pins xlconcat_0/In3] [get_bd_pins gig_ethernet_pcs_pma_0/gmii_isolate]
    connect_bd_net [get_bd_pins xlconcat_0/In4] [get_bd_pins gig_ethernet_pcs_pma_0/mmcm_locked_out]
    connect_bd_net [get_bd_pins xlconcat_0/In5] [get_bd_pins gig_ethernet_pcs_pma_0/pma_reset_out]
    connect_bd_net [get_bd_pins xlconcat_0/In6] [get_bd_pins gig_ethernet_pcs_pma_0/resetdone]
    connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins sts/gig_eth_status]
}



assign_bd_address -offset [get_memory_offset mac_eth] -range [get_memory_range mac_eth] \
    -target_address_space [get_bd_addr_spaces ps_0/Data] \
    [get_bd_addr_segs ethernet_mac_0/ctrl_axi/reg0]

cell CCFE:user:udp_client:1.0 udp_client_0 {
    RST_POLARITY_G               {1}
    LOCAL_PORT_G                 {8193}
    USE_CLIENT_ARP_G             {false}
} {
    s_intf_rx     ethernet_mac_0/m_core_rx
    m_intf_tx     ethernet_mac_0/s_core_tx

    s_axi_lite    /axi_mem_intercon_0/M[add_master_interface]_AXI
    axi_clk       /ps_0/pl_clk0
    axi_rst       /proc_sys_reset_0/peripheral_reset
    local_mac_out ethernet_mac_0/local_mac
}

assign_bd_address -offset [get_memory_offset udp_client] -range [get_memory_range udp_client] \
            -target_address_space [get_bd_addr_spaces ps_0/Data] \
            [get_bd_addr_segs udp_client_0/s_axi_lite/reg0]

if {[get_parameter DO_EMULATE]} {
  cell CCFE:user:axi4_stream_resize:1.0 axi4_stream_resize_tx_ch01 {
      RST_POLARITY_G      {0}
      S_TDATA_WIDTH_BYTES {8}
      M_TDATA_WIDTH_BYTES {16}
  } {
      axi_clk /ps_0/pl_clk0
      axi_rst /proc_sys_reset_0/peripheral_aresetn
      m_axis  udp_client_0/s_core_tx
  }
  
  cell CCFE:user:adc_emulator:1.0 adc_emulator_01 {
      RST_POLARITY_G {0}
  } {
      axi_clk            /ps_0/pl_clk0
      axi_rst            /proc_sys_reset_0/peripheral_aresetn
      s00_axil_conf_stat /axi_mem_intercon_0/M[add_master_interface]_AXI
      m_axis             axi4_stream_resize_tx_ch01/s_axis
  }
  assign_bd_address -offset [get_memory_offset adc_emulator_01] -range [get_memory_range adc_emulator_01] \
    -target_address_space [get_bd_addr_spaces pcie_subsystem/xdma_0/M_AXI_LITE] \
    [get_bd_addr_segs adc_emulator_01/s00_axil_conf_stat/reg0]

}


#cell CCFE:user:rtdi_packetizer:1.0 rtdi_packetizer_0 {
#    RST_POLARITY_G {1}
#    IDLE_FREQ {1000}
#    SEND_FREQ {50}
#    CLK_FREQUENCY_G {[expr {[get_parameter fclk0] / 1000000}]} 
#    TDATA_BYTES_C 32
#} {
#    s_intf_rx  udp_client_0/m_core_rx
#    m_intf_tx  udp_client_0/s_core_tx
#    core_clk   ps_0/pl_clk0
#    core_rst   proc_sys_reset_0/peripheral_reset
#
#    s_axi_lite axi_mem_intercon_0/M[add_master_interface]_AXI
#    axi_clk    ps_0/pl_clk0
#    axi_rst    proc_sys_reset_0/peripheral_reset
#
#    tx_en    [ctl_pin send_en] 
#    trigger_in  [ctl_pin soft_trig]
#    test_en    [ctl_pin rtdn_test] 
#    dev_type   [ctl_pin dev_type] 
#    diag_id    [ctl_pin diag_id]
#    version    [ctl_pin version]
#    payload_sz [ctl_pin payload_sz]
#    shot_num   [ctl_pin shot_num]
#
#}
#connect_bd_intf_net [get_bd_intf_pins rtdi_packetizer_0/m_core_rx] [get_bd_intf_pins rtdi_packetizer_0/s_core_tx]

# Return to parent hierarchy
current_bd_instance ..

