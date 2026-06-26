
# Entity: adc_emulator 
- **File**: adc_emulator.vhd
- **Brief:**  Aurora testing logic (counts up on TX AXIS and checks RX AXIS loopback data)
- **Author:**  Martin Krzisnik, Cosylab (martin.krzisnik@cosylab.com)
- **File:**  adc_emulator.vhd

## Diagram
![Diagram](adc_emulator.svg "Diagram")
## Description

This unit emulates the ADC by emiting 16-bit sequential counter value quadrupled across
the whole word width on m_axis* interface and checks the incoming data on s_axis*
interface for validity.
Control and status are managed through AXI4-Lite memory-mapped registers.


## Generics

| Generic name   | Type      | Value   | Description                                          |
| -------------- | --------- | ------- | ---------------------------------------------------- |
| RST_POLARITY_G | std_logic | '1'     | Reset polarity ('1' = active-high, '0' = active-low) |
| MARK_DEBUG_G   | string    | "false" | Enable ILA debug probes ("true"/"false")             |

## Ports

| Port name           | Direction | Type        | Description                                            |
| ------------------- | --------- | ----------- | ------------------------------------------------------ |
| axi_clk             | in        | std_logic   | System AXI clock                                       |
| axi_rst             | in        | std_logic   | System reset (polarity defined by RST_POLARITY_G)      |
| axil_control_status | in        | Virtual bus | AXI4-Lite Control/Status Interface (axi_clk domain)    |
| aurora_tx_axis      | in        | Virtual bus | Aurora TX AXI-Stream Master Interface (axi_clk domain) |
| aurora_rx_axis      | in        | Virtual bus | Aurora RX AXI-Stream Slave Interface (axi_clk domain)  |

### Virtual Buses

#### axil_control_status

| Port name                  | Direction | Type                          | Description           |
| -------------------------- | --------- | ----------------------------- | --------------------- |
| s00_axil_conf_stat_awaddr  | in        | std_logic_vector(5 downto 0)  | Write address         |
| s00_axil_conf_stat_awprot  | in        | std_logic_vector(2 downto 0)  | Write protection type |
| s00_axil_conf_stat_awvalid | in        | std_logic                     | Write address valid   |
| s00_axil_conf_stat_awready | out       | std_logic                     | Write address ready   |
| s00_axil_conf_stat_wdata   | in        | std_logic_vector(31 downto 0) | Write data            |
| s00_axil_conf_stat_wstrb   | in        | std_logic_vector(3 downto 0)  | Write strobes         |
| s00_axil_conf_stat_wvalid  | in        | std_logic                     | Write valid           |
| s00_axil_conf_stat_wready  | out       | std_logic                     | Write ready           |
| s00_axil_conf_stat_bresp   | out       | std_logic_vector(1 downto 0)  | Write response        |
| s00_axil_conf_stat_bvalid  | out       | std_logic                     | Write response valid  |
| s00_axil_conf_stat_bready  | in        | std_logic                     | Write response ready  |
| s00_axil_conf_stat_araddr  | in        | std_logic_vector(5 downto 0)  | Read address          |
| s00_axil_conf_stat_arprot  | in        | std_logic_vector(2 downto 0)  | Read protection type  |
| s00_axil_conf_stat_arvalid | in        | std_logic                     | Read address valid    |
| s00_axil_conf_stat_arready | out       | std_logic                     | Read address ready    |
| s00_axil_conf_stat_rdata   | out       | std_logic_vector(31 downto 0) | Read data             |
| s00_axil_conf_stat_rresp   | out       | std_logic_vector(1 downto 0)  | Read response         |
| s00_axil_conf_stat_rvalid  | out       | std_logic                     | Read valid            |
| s00_axil_conf_stat_rready  | in        | std_logic                     | Read ready            |
#### aurora_tx_axis

| Port name     | Direction | Type                          | Description                              |
| ------------- | --------- | ----------------------------- | ---------------------------------------- |
| m_axis_tvalid | out       | std_logic                     |                                          |
| m_axis_tdata  | out       | std_logic_vector(63 downto 0) | TX data (quadruplicated 16-bit count)    |
| m_axis_tkeep  | out       | std_logic_vector(7 downto 0)  | TX byte enable                           |
| m_axis_tlast  | out       | std_logic                     | TX last transfer in packet               |
| m_axis_tready | in        | std_logic                     | TX ready (back-pressure from downstream) |
| m_axis_tuser  | out       | std_logic_vector(1 downto 0)  | TX user signals (SOF/EOF indicators)     |
#### aurora_rx_axis

| Port name     | Direction | Type                          | Description                                            |
| ------------- | --------- | ----------------------------- | ------------------------------------------------------ |
| s_axis_tvalid | in        | std_logic                     |                                                        |
| s_axis_tdata  | in        | std_logic_vector(63 downto 0) | RX data (checked for quadrupling and sequential order) |
| s_axis_tkeep  | in        | std_logic_vector(7 downto 0)  | RX byte enable                                         |
| s_axis_tlast  | in        | std_logic                     | RX last transfer in packet                             |
| s_axis_tready | out       | std_logic                     | RX ready (back-pressure to upstream)                   |

## Signals

| Name             | Type                          | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| ---------------- | ----------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| sAxiAresetn      | std_logic                     | AXI active-low reset (converted from axi_rst based on RST_POLARITY_G)                                                                                                                                                                                                                                                                                                                                                                                                                              |
| count            | std_logic_vector(15 downto 0) | 16-bit counter value from TestCounter (quadruplicated for TX data)                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| emulator_control | std_logic_vector(31 downto 0) | Control register from AXI-Lite (R/W)<br>    - [15:0]  Packet size (number of transfers before tlast)<br>    - [27:16] Pause length (pause duration in clock cycles between packets)<br>    - [28]    Pause enable (1=enable inter-packet pause, 0=continuous)<br>    - [29]    Reset tlast counter (write 1 to clear tlast_count register)<br>    - [30]    Reset errors (write 1 to clear all latched error flags)<br>    - [31]    Loopback enable (1=pass RX directly to TX, 0=TX test pattern) |
| emulator_status  | std_logic_vector(31 downto 0) | Status register to AXI-Lite (R-only)<br>  Bit assignments (latched error flags):<br>    - [0]     TX handshake error (m_axis_tready was deasserted during valid)<br>    - [1]     RX not quadrupled error (received data quadrants don't match)<br>    - [2]     RX not sequential error (received data not incrementing by 1)<br>    - [31:3]  Unused (reserved, read as 0)                                                                                                                       |
| tlast_count      | std_logic_vector(31 downto 0) | tlast counter register to AXI-Lite (R-only, counts number of RX tlast events)                                                                                                                                                                                                                                                                                                                                                                                                                      |
| dbg_control      | std_logic_vector(31 downto 0) | Debug control register from AXI-Lite (R/W, looped back to dbg_status for verification)                                                                                                                                                                                                                                                                                                                                                                                                             |
| dbg_status       | std_logic_vector(31 downto 0) | Debug status register to AXI-Lite (R-only, mirrors dbg_control)                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| r                | RegType                       | Output of registers                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| rin              | RegType                       | p_Combinatorial input to registers                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |

## Constants

| Name                    | Type     | Value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | Description                                        |
| ----------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------- |
| REG_INIT_C              | RegType  | (       resetCounter    => '0',<br><span style="padding-left:20px">       rxData          => (others => '0'),<br><span style="padding-left:20px">       firstPacketFlag => '1',<br><span style="padding-left:20px">       tlastCounter    => (others => '0'),<br><span style="padding-left:20px">       pauseCounter    => (others => '0'),<br><span style="padding-left:20px">       pause           => '0',<br><span style="padding-left:20px">       sof             => '0',<br><span style="padding-left:20px">       emulatorStatus  => (others => '0')       ) | Initial and reset values for all register elements |
| PAUSE_EN_C              | positive | 28                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |                                                    |
| RESET_TLAST_COUNT_C     | positive | 29                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |                                                    |
| RESET_ERRORS_C          | positive | 30                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |                                                    |
| LOOPBACK_EN_C           | positive | 31                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |                                                    |
| ERR_TX_HANDSHAKE_C      | natural  | 0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | Bits in emulator_status                            |
| ERR_RX_NOT_QUADRUPLED_C | positive | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |                                                    |
| ERR_RX_NOT_SEQUENTIAL_C | positive | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |                                                    |

## Records


### *RegType*
 Register type for Two-Process design pattern
| Name            | Type                          | Description                                |
| --------------- | ----------------------------- | ------------------------------------------ |
| resetCounter    | std_logic                     | Counter reset signal (triggers tlast)      |
| rxData          | unsigned(15 downto 0)         | Last received RX data value                |
| firstPacketFlag | std_logic                     | Flag indicating first transfer after tlast |
| tlastCounter    | unsigned(31 downto 0)         | Count of tlast events received             |
| pauseCounter    | unsigned(11 downto 0)         | Inter-packet pause counter                 |
| pause           | std_logic                     | Pause TX transmission flag                 |
| sof             | std_logic                     | Start-of-frame indicator                   |
| emulatorStatus  | std_logic_vector(31 downto 0) | Latched error status register              |


## Processes
- p_Comb: ( all )
  - **Description**
  Combinatorial process for next-state logic:   Implements TX packet generation with configurable pause, RX loopback verification,   and error detection logic. Updates all register next values based on current state.
- p_Seq: ( axi_clk )
  - **Description**
  Sequential process for register updates:   Transfers combinatorial next-state (rin) to registered state (r) on clock edge.

## Instantiations

- u_register_map_wrapper: work.register_map_wrapper
  -  AXI4-Lite register interface wrapper:<br>   Provides memory-mapped access to control and status registers:<br>   - emulator_control: Packet size, pause config, loopback enable, reset commands<br>   - emulator_status: Error flags (TX handshake, RX quadrupling, RX sequence)<br>   - tlast_count: Count of received tlast events<br>   - dbg_control/status: Debug registers- u_TestCounter: work.TestCounter
  -  16-bit test counter for TX data generation:   Generates incrementing 16-bit count value with pause and reset control.   Configured for saturation at maximum value to prevent rollover.