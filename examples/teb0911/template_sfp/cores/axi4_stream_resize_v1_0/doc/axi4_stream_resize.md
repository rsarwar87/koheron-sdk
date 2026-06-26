
# Entity: axi4_stream_resize 
- **File**: axi4_stream_resize.vhd
- **Brief:**  Koheron and Vivado block design ready wrapper for Axi4StreamResize component.
- **Author:**  Domen Cvenkel, Cosylab (domen.cvenkel@cosylab.com)
- **File:**  axi4_stream_resize.vhd

## Diagram
![Diagram](axi4_stream_resize.svg "Diagram")
## Description

The unit is a simple wrapper to allow core interface detection by xilinx IP
packager.

Wrapper entity for Axi4StreamResize with Vivado block design compatible AXI4-Stream ports

## Generics

| Generic name        | Type      | Value | Description                                          |
| ------------------- | --------- | ----- | ---------------------------------------------------- |
| RST_POLARITY_G      | std_logic | '1'   | Reset polarity ('1' = active-high, '0' = active-low) |
| S_TDATA_WIDTH_BYTES | positive  | 8     | Slave AXI-Stream data width in bytes                 |
| M_TDATA_WIDTH_BYTES | positive  | 16    | Master AXI-Stream data width in bytes                |

## Ports

| Port name        | Direction | Type        | Description                                    |
| ---------------- | --------- | ----------- | ---------------------------------------------- |
| axi_clk          | in        | std_logic   | AXI clock                                      |
| axi_rst          | in        | std_logic   | AXI reset (polarity defined by RST_POLARITY_G) |
| slave_interface  | in        | Virtual bus | Slave AXI-Stream Interface                     |
| master_interface | in        | Virtual bus | Master AXI-Stream Interface                    |

### Virtual Buses

#### slave_interface

| Port name     | Direction | Type                                                 | Description                                     |
| ------------- | --------- | ---------------------------------------------------- | ----------------------------------------------- |
| s_axis_tvalid | in        | std_logic                                            | Slave channel valid signal                      |
| s_axis_tdata  | in        | std_logic_vector(S_TDATA_WIDTH_BYTES*8 - 1 downto 0) | Slave channel data                              |
| s_axis_tkeep  | in        | std_logic_vector(S_TDATA_WIDTH_BYTES - 1 downto 0)   | Slave channel byte enable                       |
| s_axis_tlast  | in        | std_logic                                            | Slave channel last transfer in packet           |
| s_axis_tready | out       | std_logic                                            | Slave channel ready (back-pressure to upstream) |
| s_axis_tuser  | in        | std_logic_vector(1 downto 0)                         | Slave channel user-defined data                 |
#### master_interface

| Port name     | Direction | Type                                                 | Description                                          |
| ------------- | --------- | ---------------------------------------------------- | ---------------------------------------------------- |
| m_axis_tvalid | out       | std_logic                                            |                                                      |
| m_axis_tdata  | out       | std_logic_vector(M_TDATA_WIDTH_BYTES*8 - 1 downto 0) | Master channel data                                  |
| m_axis_tkeep  | out       | std_logic_vector(M_TDATA_WIDTH_BYTES - 1 downto 0)   | Master channel byte enable                           |
| m_axis_tlast  | out       | std_logic                                            | Master channel last transfer in packet               |
| m_axis_tuser  | out       | std_logic_vector(1 downto 0)                         | Master channel user-defined data                     |
| m_axis_tready | in        | std_logic                                            | Master channel ready (back-pressure from downstream) |

## Signals

| Name       | Type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | Description                                                               |
| ---------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| axi4sRxSrc | Axi4StreamSourceType (       tData (S_TDATA_WIDTH_BYTES*8 - 1 downto 0),<br><span style="padding-left:20px">       tKeep (S_TDATA_WIDTH_BYTES - 1 downto 0),<br><span style="padding-left:20px">       tUser (1 downto 0),<br><span style="padding-left:20px">       tStrb (S_TDATA_WIDTH_BYTES - 1 downto 0),<br><span style="padding-left:20px">  -- unused but has to be the same length as tKeep       tDest (0 downto 0),<br><span style="padding-left:20px">                        -- unused       tId (0 downto 0)                           -- unused       ) | Slave (RX) AXI-Stream source record                                       |
| axi4sRxDst | Axi4StreamDestinationType                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | Slave (RX) AXI-Stream destination record (back-pressure)                  |
| axi4sTxSrc | Axi4StreamSourceType (       tData (M_TDATA_WIDTH_BYTES*8 - 1 downto 0),<br><span style="padding-left:20px">       tKeep (M_TDATA_WIDTH_BYTES - 1 downto 0),<br><span style="padding-left:20px">       tUser (1 downto 0),<br><span style="padding-left:20px">       tStrb (M_TDATA_WIDTH_BYTES - 1 downto 0),<br><span style="padding-left:20px">  -- unused but has to be the same length as tKeep       tDest (0 downto 0),<br><span style="padding-left:20px">                        -- unused       tId (0 downto 0)                           -- unused       ) | Master (TX) AXI-Stream source record                                      |
| axi4sTxDst | Axi4StreamDestinationType                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | Master (TX) AXI-Stream destination record (back-pressure from downstream) |

## Instantiations

- u_Axi4StreamResize: work.Axi4StreamResize
  -  AXI4-Stream resize component instantiation:<br>   Performs width conversion between slave and master AXI-Stream interfaces.   Supports widening (narrow to wide), narrowing (wide to narrow), or passthrough (equal widths).