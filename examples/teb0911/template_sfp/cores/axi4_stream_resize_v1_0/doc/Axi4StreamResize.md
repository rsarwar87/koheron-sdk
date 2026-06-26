
# Entity: Axi4StreamResize 
- **File**: Axi4StreamResize.vhd
- **Brief:**  AXI4-Stream Resize
- **Author:**  Domen Cvenkel, Cosylab (domen.cvenkel@cosylab.com)
- **File:**  Axi4StreamResize.vhd

## Diagram
![Diagram](Axi4StreamResize.svg "Diagram")
## Description

Module for resizing AXI4-Stream to different number of parallel data units.
All generalizations are done through constrains applied to unconstrained ports.
The number of data units (bytes or custom) in receiver `RX_TKEEP_WIDTH_C` and transmitter `TX_TKEEP_WIDTH_C` ports
is determined at compile time and the resulting ratio `RATIO_C` is used to define
one of the implementations: passthrough, widen and narrow.

Architecture implements three modes based on width ratio:
- **Passthrough (GEN_EQ)**: Equal widths, direct signal mapping
- **Widen (GEN_WIDEN)**: Narrow RX to wider TX, accumulates multiple RX transfers
- **Narrow (GEN_NARROW)**: Wide RX to narrower TX, splits single RX into multiple TX transfers

### Limitations

1. Only integer ratios are supported.
Non integer ratios can be implemented by first widening and than narrowing the bus.
2. The size of the packet is not limited anyhow by
the number of parallel data units on RX or TX side.
3. The module is designed and tested only for continuous aligned and unaligned streams.
In case a sparse stream is provided at the RX side.
The same sparsity will be present at the TX side.
Also further testing might be needed for proper sparse stream operation.

### Timing diagrams

In case of a width change from narrow (RX) to wider (TX),
there are fewer transactions on the TX side compared to the RX.
With a continuous `VALID` signal at RX side,
this results in an intermittent `VALID` signal at the TX side.

In case of a width change from wide (RX) to narrower (TX),
there are more transactions on the TX side compared to the RX.
With a continuous `READY` signal at the TX side,
this results in an intermittent `READY` backpressure signal at the RX side.

AXI4-Stream width resize implementation with passthrough, widen, and narrow modes

## Generics

| Generic name   | Type      | Value | Description                                          |
| -------------- | --------- | ----- | ---------------------------------------------------- |
| RST_POLARITY_G | std_logic | '1'   | Reset polarity ('1' = active-high, '0' = active-low) |

## Ports

| Port name    | Direction | Type        | Description                                       |
| ------------ | --------- | ----------- | ------------------------------------------------- |
| clk_i        | in        | std_logic   | System clock                                      |
| rst_i        | in        | std_logic   | System reset (polarity defined by RST_POLARITY_G) |
| rx_interface | in        | Virtual bus | RX AXI4-Stream Record Interface                   |
| tx_interface | in        | Virtual bus | TX AXI4-Stream Record Interface                   |

### Virtual Buses

#### rx_interface

| Port name    | Direction | Type                      | Description                                        |
| ------------ | --------- | ------------------------- | -------------------------------------------------- |
| axi4sRxSrc_i | in        | Axi4StreamSourceType      | RX source signals (from upstream)                  |
| axi4sRxDst_o | out       | Axi4StreamDestinationType | RX destination signals (back-pressure to upstream) |
#### tx_interface

| Port name    | Direction | Type                      | Description                                            |
| ------------ | --------- | ------------------------- | ------------------------------------------------------ |
| axi4sTxSrc_o | out       | Axi4StreamSourceType      |                                                        |
| axi4sTxDst_i | in        | Axi4StreamDestinationType | TX destination signals (back-pressure from downstream) |

## Signals

| Name  | Type      | Description                                                   |
| ----- | --------- | ------------------------------------------------------------- |
| cnt   | natural   | Width ratio segment counter (used in widen/narrow modes)      |
| ready | std_logic | Intermediate ready signal for handshaking logic (narrow mode) |

## Constants

| Name             | Type     | Value                     | Description                                     |
| ---------------- | -------- | ------------------------- | ----------------------------------------------- |
| RX_TDATA_WIDTH_C | positive | axi4sRxSrc_i.tdata'length | RX data width in bits                           |
| RX_TUSER_WIDTH_C | positive | axi4sRxSrc_i.tuser'length | RX user data width in bits                      |
| RX_TKEEP_WIDTH_C | positive | axi4sRxSrc_i.tkeep'length | RX data width in bytes (determines width ratio) |
| TX_TDATA_WIDTH_C | positive | axi4sTxSrc_o.tdata'length | TX data width in bits                           |
| TX_TUSER_WIDTH_C | positive | axi4sTxSrc_o.tuser'length | TX user data width in bits                      |
| TX_TKEEP_WIDTH_C | positive | axi4sTxSrc_o.tkeep'length | TX data width in bytes (determines width ratio) |
