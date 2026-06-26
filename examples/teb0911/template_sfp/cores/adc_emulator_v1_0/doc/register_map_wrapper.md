
# Entity: register_map_wrapper 
- **File**: register_map_wrapper.vhd
- **Brief:**  Wrapper for AXI4-Lite register map with application-specific signal names
- **Author:**  Martin Krzisnik, Cosylab (martin.krzisnik@cosylab.com)
- **File:**  register_map_wrapper.vhd

## Diagram
![Diagram](register_map_wrapper.svg "Diagram")
## Description

Maps generic register interface to ADC emulator-specific control and status signals.
Register mapping:
- reg0: emulator_control (R/W)
- reg1: dbg_control (R/W)
- reg8: emulator_status (R-only)
- reg9: tlast_count (R-only)
- reg10: dbg_status (R-only)

Application-specific wrapper for register_map entity

## Ports

| Port name        | Direction | Type                          | Description                      |
| ---------------- | --------- | ----------------------------- | -------------------------------- |
| emulator_control | out       | std_logic_vector(31 downto 0) | Emulator control register output |
| emulator_status  | in        | std_logic_vector(31 downto 0) | Emulator status register input   |
| tlast_count      | in        | std_logic_vector(31 downto 0) | tlast event counter input        |
| dbg_control      | out       | std_logic_vector(31 downto 0) | Debug control register output    |
| dbg_status       | in        | std_logic_vector(31 downto 0) | Debug status register input      |
| axi_lite_slave   | in        | Virtual bus                   | AXI4-Lite Slave Interface        |

### Virtual Buses

#### axi_lite_slave

| Port name          | Direction | Type                          | Description           |
| ------------------ | --------- | ----------------------------- | --------------------- |
| s_axi_lite_aclk    | in        | std_logic                     | AXI clock             |
| s_axi_lite_aresetn | in        | std_logic                     | AXI active-low reset  |
| s_axi_lite_awaddr  | in        | std_logic_vector(5 downto 0)  | Write address         |
| s_axi_lite_awprot  | in        | std_logic_vector(2 downto 0)  | Write protection type |
| s_axi_lite_awvalid | in        | std_logic                     | Write address valid   |
| s_axi_lite_awready | out       | std_logic                     | Write address ready   |
| s_axi_lite_wdata   | in        | std_logic_vector(31 downto 0) | Write data            |
| s_axi_lite_wstrb   | in        | std_logic_vector(3 downto 0)  | Write strobes         |
| s_axi_lite_wvalid  | in        | std_logic                     | Write valid           |
| s_axi_lite_wready  | out       | std_logic                     | Write ready           |
| s_axi_lite_bresp   | out       | std_logic_vector(1 downto 0)  | Write response        |
| s_axi_lite_bvalid  | out       | std_logic                     | Write response valid  |
| s_axi_lite_bready  | in        | std_logic                     | Write response ready  |
| s_axi_lite_araddr  | in        | std_logic_vector(5 downto 0)  | Read address          |
| s_axi_lite_arprot  | in        | std_logic_vector(2 downto 0)  | Read protection type  |
| s_axi_lite_arvalid | in        | std_logic                     | Read address valid    |
| s_axi_lite_arready | out       | std_logic                     | Read address ready    |
| s_axi_lite_rdata   | out       | std_logic_vector(31 downto 0) | Read data             |
| s_axi_lite_rresp   | out       | std_logic_vector(1 downto 0)  | Read response         |
| s_axi_lite_rvalid  | out       | std_logic                     | Read valid            |
| s_axi_lite_rready  | in        | std_logic                     | Read ready            |

## Instantiations

- u_register_map: work.register_map
  -  AXI4-Lite register map instantiation:<br>   Maps registers to application-specific signals:<br>   - Registers 0-1: Control outputs (emulator_control, dbg_control)<br>   - Registers 2-7: Unused (tied to open)<br>   - Registers 8-10: Status inputs (emulator_status, tlast_count, dbg_status)<br>   - Registers 11-15: Unused (tied to '0')