
# Entity: register_map 
- **File**: register_map.vhd
- **Brief:**  AXI4-Lite register map with 16 32-bit registers
- **Author:**  Martin Krzisnik, Cosylab (martin.krzisnik@cosylab.com)
- **File:**  register_map.vhd

## Diagram
![Diagram](register_map.svg "Diagram")
## Description

Auto-generated AXI4-Lite slave providing 16 registers:
- Registers 0-7: R/W configuration registers
- Registers 8-15: R-only status registers

AXI4-Lite register map with 16 registers (8 R/W, 8 R-only)

## Generics

| Generic name       | Type    | Value | Description                                         |
| ------------------ | ------- | ----- | --------------------------------------------------- |
| C_S_AXI_DATA_WIDTH | integer | 32    | AXI data bus width (bits)                           |
| C_S_AXI_ADDR_WIDTH | integer | 6     | AXI address bus width (bits, supports 16 registers) |

### Virtual Buses

#### user_registers

| Port name | Direction | Type                                              | Description                               |
| --------- | --------- | ------------------------------------------------- | ----------------------------------------- |
| reg0_o    | out       | std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0) | Configuration register 0 (R/W)            |
| reg1_o    | out       | std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0) | Configuration register 1 (R/W)            |
| reg2_o    | out       | std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0) | Configuration register 2 (R/W)            |
| reg3_o    | out       | std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0) | Configuration register 3 (R/W)            |
| reg4_o    | out       | std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0) | Configuration register 4 (R/W)            |
| reg5_o    | out       | std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0) | Configuration register 5 (R/W)            |
| reg6_o    | out       | std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0) | Configuration register 6 (R/W)            |
| reg7_o    | out       | std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0) | Configuration register 7 (R/W)            |
| reg8_i    | in        | std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0) | Status register 8 (R-only)                |
| reg9_i    | in        | std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0) | Status register 9 (R-only)                |
| reg10_i   | in        | std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0) | Status register 10 (R-only)               |
| reg11_i   | in        | std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0) | Status register 11 (R-only)               |
| reg12_i   | in        | std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0) | Status register 12 (R-only)               |
| reg13_i   | in        | std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0) | Status register 13 (R-only)               |
| reg14_i   | in        | std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0) | Status register 14 (R-only)               |
| reg15_i   | in        | std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0) | Status register 15 (R-only)               |
| wrReq_o   | out       | std_logic                                         | Write request strobe (single-cycle pulse) |
| rdReq_o   | out       | std_logic                                         | Read request strobe (single-cycle pulse)  |
#### axi_lite_slave

| Port name     | Direction | Type                                                | Description           |
| ------------- | --------- | --------------------------------------------------- | --------------------- |
| S_AXI_ACLK    | in        | std_logic                                           |                       |
| S_AXI_ARESETN | in        | std_logic                                           | AXI active-low reset  |
| S_AXI_AWADDR  | in        | std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0)     | Write address         |
| S_AXI_AWPROT  | in        | std_logic_vector(2 downto 0)                        | Write protection type |
| S_AXI_AWVALID | in        | std_logic                                           | Write address valid   |
| S_AXI_AWREADY | out       | std_logic                                           | Write address ready   |
| S_AXI_WDATA   | in        | std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0)     | Write data            |
| S_AXI_WSTRB   | in        | std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0) | Write strobes         |
| S_AXI_WVALID  | in        | std_logic                                           | Write valid           |
| S_AXI_WREADY  | out       | std_logic                                           | Write ready           |
| S_AXI_BRESP   | out       | std_logic_vector(1 downto 0)                        | Write response        |
| S_AXI_BVALID  | out       | std_logic                                           | Write response valid  |
| S_AXI_BREADY  | in        | std_logic                                           | Write response ready  |
| S_AXI_ARADDR  | in        | std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0)     | Read address          |
| S_AXI_ARPROT  | in        | std_logic_vector(2 downto 0)                        | Read protection type  |
| S_AXI_ARVALID | in        | std_logic                                           | Read address valid    |
| S_AXI_ARREADY | out       | std_logic                                           | Read address ready    |
| S_AXI_RDATA   | out       | std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0)     | Read data             |
| S_AXI_RRESP   | out       | std_logic_vector(1 downto 0)                        | Read response         |
| S_AXI_RVALID  | out       | std_logic                                           | Read valid            |
| S_AXI_RREADY  | in        | std_logic                                           | Read ready            |

## Signals

| Name         | Type                                            | Description                        |
| ------------ | ----------------------------------------------- | ---------------------------------- |
| axi_awaddr   | std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0) | Latched write address              |
| axi_awready  | std_logic                                       | Write address ready                |
| axi_wready   | std_logic                                       | Write data ready                   |
| axi_bresp    | std_logic_vector(1 downto 0)                    | Write response                     |
| axi_bvalid   | std_logic                                       | Write response valid               |
| axi_araddr   | std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0) | Latched read address               |
| axi_arready  | std_logic                                       | Read address ready                 |
| axi_rdata    | std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) | Read data                          |
| axi_rresp    | std_logic_vector(1 downto 0)                    | Read response                      |
| axi_rvalid   | std_logic                                       | Read valid                         |
| slv_reg0     | std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) | Register 0 (R/W)                   |
| slv_reg1     | std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) | Register 1 (R/W)                   |
| slv_reg2     | std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) | Register 2 (R/W)                   |
| slv_reg3     | std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) | Register 3 (R/W)                   |
| slv_reg4     | std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) | Register 4 (R/W)                   |
| slv_reg5     | std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) | Register 5 (R/W)                   |
| slv_reg6     | std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) | Register 6 (R/W)                   |
| slv_reg7     | std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) | Register 7 (R/W)                   |
| slv_reg8     | std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) | Register 8 (R-only, external)      |
| slv_reg9     | std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) | Register 9 (R-only, external)      |
| slv_reg10    | std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) | Register 10 (R-only, external)     |
| slv_reg11    | std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) | Register 11 (R-only, external)     |
| slv_reg12    | std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) | Register 12 (R-only, external)     |
| slv_reg13    | std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) | Register 13 (R-only, external)     |
| slv_reg14    | std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) | Register 14 (R-only, external)     |
| slv_reg15    | std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) | Register 15 (R-only, external)     |
| slv_reg_rden | std_logic                                       | Register read enable               |
| slv_reg_wren | std_logic                                       | Register write enable              |
| reg_data_out | std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) | Register read data                 |
| byte_index   | integer                                         | Byte lane index for partial writes |
| aw_en        | std_logic                                       |                                    |

## Constants

| Name              | Type    | Value                      | Description                                          |
| ----------------- | ------- | -------------------------- | ---------------------------------------------------- |
| ADDR_LSB          | integer | (C_S_AXI_DATA_WIDTH/32)+ 1 | LSB for word addressing (2 for 32-bit, 3 for 64-bit) |
| OPT_MEM_ADDR_BITS | integer | 3                          | Register address bits (supports 16 registers)        |

## Processes
- p_awready: ( S_AXI_ACLK )
  - **Description**
  Write Address Ready Process: Asserts axi_awready when both AWVALID and WVALID are present.
- p_awaddr: ( S_AXI_ACLK )
  - **Description**
  Write Address Latch Process: Latches write address when AWVALID and WVALID are both asserted.
- p_wready: ( S_AXI_ACLK )
  - **Description**
  Write Data Ready Process: Asserts axi_wready for one cycle when AWVALID and WVALID are both present.
- p_wr_reg: ( S_AXI_ACLK )
  - **Description**
  Register Write Process:   Writes data to registers 0-7 when write enable is asserted.   Supports byte-level write strobes for partial register updates.
- p_write_resp: ( S_AXI_ACLK )
  - **Description**
  Write Response Process: Asserts write response valid when write transaction completes successfully.
- p_arready: ( S_AXI_ACLK )
  - **Description**
  Read Address Process: Asserts axi_arready and latches read address when ARVALID is asserted.
- p_rvalid: ( S_AXI_ACLK )
  - **Description**
  Read Valid Process: Asserts read valid when read transaction is ready with data.
- p_read_mux: ( slv_reg0, slv_reg1, slv_reg2, slv_reg3, slv_reg4, slv_reg5, slv_reg6, slv_reg7, slv_reg8, slv_reg9, slv_reg10, slv_reg11, slv_reg12, slv_reg13, slv_reg14, slv_reg15, axi_araddr, S_AXI_ARESETN, slv_reg_rden )
  - **Description**
  Register Read Mux Process: Address decode for register read operations (combinatorial).
- p_read_out: ( S_AXI_ACLK )
  - **Description**
  Read Output Register Process: Registers read data output when read enable is asserted.
