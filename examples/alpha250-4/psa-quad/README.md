# rp-adc-dac-dma

based on the alpha250 example of the same name and with the same objective.

By default the freq of the AXI bus is set at 250 Mhz through the FCLK0. This leads to a setup error between intra-clock paths between PS (system_i/ps_0/inst/PS7_i/SAXIGP0ACLK) and the the DMA (axi_dma_0/U0/GEN_SG_ENGINE.I_SG_ENGINE/I_SG_AXI_DATAMOVER/GEN_S2MM_BASIC.I_S2MM_BASIC_WRAPPER/I_WR_DATA_CNTL/sig_data2wsc_calc_err_reg/R).

Reducing the clock speed to 100 MHz will mitigate this.

However, even with the setup error the DMA functions correctly.

each 32-bit data corresponds to ADC0 and ADC1 for the range 29 downto 16 and 13 downto 0
