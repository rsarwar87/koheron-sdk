## FMC A (FMC HPC) pinout for TEB0911 carrier board.
set_property PACKAGE_PIN T33 [get_ports {fmca_rx_p[0]}]
set_property PACKAGE_PIN T34 [get_ports {fmca_rx_n[0]}]
set_property PACKAGE_PIN T29 [get_ports {fmca_tx_p[0]}]
set_property PACKAGE_PIN T30 [get_ports {fmca_tx_n[0]}]

set_property PACKAGE_PIN P33 [get_ports {fmca_rx_p[1]}]
set_property PACKAGE_PIN P34 [get_ports {fmca_rx_n[1]}]
set_property PACKAGE_PIN R31 [get_ports {fmca_tx_p[1]}]
set_property PACKAGE_PIN R32 [get_ports {fmca_tx_n[1]}]

set_property PACKAGE_PIN N31 [get_ports {fmca_rx_p[2]}]
set_property PACKAGE_PIN N32 [get_ports {fmca_rx_n[2]}]
set_property PACKAGE_PIN P29 [get_ports {fmca_tx_p[2]}]
set_property PACKAGE_PIN P30 [get_ports {fmca_tx_n[2]}]

set_property PACKAGE_PIN M33 [get_ports {fmca_rx_p[3]}]
set_property PACKAGE_PIN M34 [get_ports {fmca_rx_n[3]}]
set_property PACKAGE_PIN M29 [get_ports {fmca_tx_p[3]}]
set_property PACKAGE_PIN M30 [get_ports {fmca_tx_n[3]}]

set_property PACKAGE_PIN R28 [get_ports {fmc_mgt_refclk0_clk_n[0]}]
set_property PACKAGE_PIN R27 [get_ports {fmc_mgt_refclk0_clk_p[0]}]
create_clock -period 6.400 -name fmca_mgt_clk_p -waveform {0.000 3.200} [get_ports fmc_mgt_refclk0_clk_p[0]]

# -------------------------
# FMCB
# -------------------------
# I2C / MOD_DEF shared + mux control
set_property PACKAGE_PIN E22 [get_ports {fmcb_sfp_mod_def1[0]}]     ; # B_LA00_P (SCL In, shared path)
set_property PACKAGE_PIN D22 [get_ports {fmcb_sfp_mod_def2_in[0]}]  ; # B_LA00_N (SDA In, shared path)
set_property PACKAGE_PIN E20 [get_ports {fmcb_sfp_mod_def2_out[0]}] ; # B_LA01_P (SDA Out, shared path)
set_property PACKAGE_PIN D20 [get_ports {fmcb_sfp_i2c_mux_sel[0]}]  ; # B_LA01_N
set_property PACKAGE_PIN C21 [get_ports {fmcb_sfp_i2c_mux_sel[1]}]  ; # B_LA02_P
set_property PACKAGE_PIN B21 [get_ports {fmcb_sfp_i2c_mux_sel[2]}]  ; # B_LA02_N

# Shared control/status lines
set_property PACKAGE_PIN K20 [get_ports {fmcb_sfp_rate_sel[0]}]     ; # B_LA03_N (RS0, shared)
set_property PACKAGE_PIN J19 [get_ports {fmcb_sfp_rate_sel[1]}]     ; # B_LA04_P (RS1, shared)
set_property PACKAGE_PIN L20 [get_ports {fmcb_sfp_tx_disable}]      ; # B_LA03_P (shared)
set_property PACKAGE_PIN J20 [get_ports {fmcb_sfp_tx_fault}]        ; # B_LA04_N (A+B+C+D combined)


# Per-SFP lines: A-D -> [0-3]
set_property PACKAGE_PIN G21 [get_ports {fmcb_sfp_mod_def0[0]}]     ; # B_LA05_P
set_property PACKAGE_PIN J21 [get_ports {fmcb_sfp_mod_def0[1]}]     ; # B_LA06_P
set_property PACKAGE_PIN D21 [get_ports {fmcb_sfp_mod_def0[2]}]     ; # B_LA07_P
set_property PACKAGE_PIN G20 [get_ports {fmcb_sfp_mod_def0[3]}]     ; # B_LA08_P
set_property PACKAGE_PIN F21 [get_ports {fmcb_sfp_los[0]}]          ; # B_LA05_N
set_property PACKAGE_PIN H21 [get_ports {fmcb_sfp_los[1]}]          ; # B_LA06_N
set_property PACKAGE_PIN C22 [get_ports {fmcb_sfp_los[2]}]          ; # B_LA07_N
set_property PACKAGE_PIN F20 [get_ports {fmcb_sfp_los[3]}]          ; # B_LA08_N
set_property IOSTANDARD LVCMOS18 [get_ports {fmcb_sfp*}]

## FMC B (FMC HPC) pinout for TEB0911 carrier board.
set_property PACKAGE_PIN B33 [get_ports {fmcb_rx_p[3]}]
set_property PACKAGE_PIN B34 [get_ports {fmcb_rx_n[3]}]
set_property PACKAGE_PIN A31 [get_ports {fmcb_tx_p[3]}]
set_property PACKAGE_PIN A32 [get_ports {fmcb_tx_n[3]}]

set_property PACKAGE_PIN C31 [get_ports {fmcb_rx_p[2]}]
set_property PACKAGE_PIN C32 [get_ports {fmcb_rx_n[2]}]
set_property PACKAGE_PIN B29 [get_ports {fmcb_tx_p[2]}]
set_property PACKAGE_PIN B30 [get_ports {fmcb_tx_n[2]}]

set_property PACKAGE_PIN D33 [get_ports {fmcb_rx_p[1]}]
set_property PACKAGE_PIN D34 [get_ports {fmcb_rx_n[1]}]
set_property PACKAGE_PIN D29 [get_ports {fmcb_tx_p[1]}]
set_property PACKAGE_PIN D30 [get_ports {fmcb_tx_n[1]}]

set_property PACKAGE_PIN E31 [get_ports {fmcb_rx_p[0]}]
set_property PACKAGE_PIN E32 [get_ports {fmcb_rx_n[0]}]
set_property PACKAGE_PIN F29 [get_ports {fmcb_tx_p[0]}]
set_property PACKAGE_PIN F30 [get_ports {fmcb_tx_n[0]}]

set_property PACKAGE_PIN G28 [get_ports {fmcb_mgt_refclk0_clk_n}]
set_property PACKAGE_PIN G27 [get_ports {fmcb_mgt_refclk0_clk_p}]
create_clock -period 6.400 -name fmcb_mgt_clk_p -waveform {0.000 3.200} [get_ports fmcb_mgt_refclk0_clk_p]


## FMC C (FMC HPC) pinout for TEB0911 carrier board.
set_property PACKAGE_PIN A4 [get_ports {fmcc_rx_p[3]}]
set_property PACKAGE_PIN A3 [get_ports {fmcc_rx_n[3]}]
set_property PACKAGE_PIN A8 [get_ports {fmcc_tx_p[3]}]
set_property PACKAGE_PIN A7 [get_ports {fmcc_tx_n[3]}]

set_property PACKAGE_PIN B2 [get_ports {fmcc_rx_p[2]}]
set_property PACKAGE_PIN B1 [get_ports {fmcc_rx_n[2]}]
set_property PACKAGE_PIN B6 [get_ports {fmcc_tx_p[2]}]
set_property PACKAGE_PIN B5 [get_ports {fmcc_tx_n[2]}]

set_property PACKAGE_PIN C4 [get_ports {fmcc_rx_p[1]}]
set_property PACKAGE_PIN C3 [get_ports {fmcc_rx_n[1]}]
set_property PACKAGE_PIN D6 [get_ports {fmcc_tx_p[1]}]
set_property PACKAGE_PIN D5 [get_ports {fmcc_tx_n[1]}]

set_property PACKAGE_PIN D2 [get_ports {fmcc_rx_p[0]}]
set_property PACKAGE_PIN D1 [get_ports {fmcc_rx_n[0]}]
set_property PACKAGE_PIN E4 [get_ports {fmcc_tx_p[0]}]
set_property PACKAGE_PIN E3 [get_ports {fmcc_tx_n[0]}]

set_property PACKAGE_PIN C7  [get_ports {fmc_mgt_refclk0_clk_n[2]}]
set_property PACKAGE_PIN C8  [get_ports {fmc_mgt_refclk0_clk_p[2]}]
create_clock -period 6.400 -name fmcc_mgt_clk_p -waveform {0.000 3.200} [get_ports fmc_mgt_refclk0_clk_p[2]]

## FMC D (FMC HPC) pinout for TEB0911 carrier board.
set_property PACKAGE_PIN F2 [get_ports {fmcd_rx_p[3]}]
set_property PACKAGE_PIN F1 [get_ports {fmcd_rx_n[3]}]
set_property PACKAGE_PIN F6 [get_ports {fmcd_tx_p[3]}]
set_property PACKAGE_PIN F5 [get_ports {fmcd_tx_n[3]}]

set_property PACKAGE_PIN H2 [get_ports {fmcd_rx_p[2]}]
set_property PACKAGE_PIN H1 [get_ports {fmcd_rx_n[2]}]
set_property PACKAGE_PIN G4 [get_ports {fmcd_tx_p[2]}]
set_property PACKAGE_PIN G3 [get_ports {fmcd_tx_n[2]}]

set_property PACKAGE_PIN J4 [get_ports {fmcd_rx_p[1]}]
set_property PACKAGE_PIN J3 [get_ports {fmcd_rx_n[1]}]
set_property PACKAGE_PIN H6 [get_ports {fmcd_tx_p[1]}]
set_property PACKAGE_PIN H5 [get_ports {fmcd_tx_n[1]}]

set_property PACKAGE_PIN K2 [get_ports {fmcd_rx_p[0]}]
set_property PACKAGE_PIN K1 [get_ports {fmcd_rx_n[0]}]
set_property PACKAGE_PIN K6 [get_ports {fmcd_tx_p[0]}]
set_property PACKAGE_PIN K5 [get_ports {fmcd_tx_n[0]}]

set_property PACKAGE_PIN G7  [get_ports {fmc_mgt_refclk0_clk_n[3]}]
set_property PACKAGE_PIN G8  [get_ports {fmc_mgt_refclk0_clk_p[3]}]
create_clock -period 6.400 -name fmcd_mgt_clk_p -waveform {0.000 3.200} [get_ports fmc_mgt_refclk0_clk_p[3]]

## FMC E (FMC HPC) pinout for TEB0911 carrier board.
set_property PACKAGE_PIN L4 [get_ports {fmce_rx_p[3]}]
set_property PACKAGE_PIN L3 [get_ports {fmce_rx_n[3]}]
set_property PACKAGE_PIN M6 [get_ports {fmce_tx_p[3]}]
set_property PACKAGE_PIN M5 [get_ports {fmce_tx_n[3]}]

set_property PACKAGE_PIN M2 [get_ports {fmce_rx_p[2]}]
set_property PACKAGE_PIN M1 [get_ports {fmce_rx_n[2]}]
set_property PACKAGE_PIN N4 [get_ports {fmce_tx_p[2]}]
set_property PACKAGE_PIN N3 [get_ports {fmce_tx_n[2]}]

set_property PACKAGE_PIN P2 [get_ports {fmce_rx_p[1]}]
set_property PACKAGE_PIN P1 [get_ports {fmce_rx_n[1]}]
set_property PACKAGE_PIN P6 [get_ports {fmce_tx_p[1]}]
set_property PACKAGE_PIN P5 [get_ports {fmce_tx_n[1]}]

set_property PACKAGE_PIN T2 [get_ports {fmce_rx_p[0]}]
set_property PACKAGE_PIN T1 [get_ports {fmce_rx_n[0]}]
set_property PACKAGE_PIN R4 [get_ports {fmce_tx_p[0]}]
set_property PACKAGE_PIN R3 [get_ports {fmce_tx_n[0]}]

set_property PACKAGE_PIN L7  [get_ports {fmc_mgt_refclk0_clk_n[4]}]
set_property PACKAGE_PIN L8  [get_ports {fmc_mgt_refclk0_clk_p[4]}]
create_clock -period 6.400 -name fmce_mgt_clk_p -waveform {0.000 3.200} [get_ports fmc_mgt_refclk0_clk_p[4]]

## FMC F (FMC HPC) pinout for TEB0911 carrier board.
set_property PACKAGE_PIN L31 [get_ports {fmcf_rx_p[0]}]
set_property PACKAGE_PIN L32 [get_ports {fmcf_rx_n[0]}]
set_property PACKAGE_PIN K29 [get_ports {fmcf_tx_p[0]}]
set_property PACKAGE_PIN K30 [get_ports {fmcf_tx_n[0]}]

set_property PACKAGE_PIN K33 [get_ports {fmcf_rx_p[1]}]
set_property PACKAGE_PIN K34 [get_ports {fmcf_rx_n[1]}]
set_property PACKAGE_PIN J31 [get_ports {fmcf_tx_p[1]}]
set_property PACKAGE_PIN J32 [get_ports {fmcf_tx_n[1]}]

set_property PACKAGE_PIN L28 [get_ports {fmc_mgt_refclk0_clk_n[5]}]
set_property PACKAGE_PIN L27 [get_ports {fmc_mgt_refclk0_clk_p[5]}]
create_clock -period 6.400 -name fmcf_mgt_clk_p -waveform {0.000 3.200} [get_ports fmc_mgt_refclk0_clk_p[5]]
