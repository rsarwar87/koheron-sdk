
# Entity: TestCounter 
- **File**: TestCounter.vhd
- **Brief:**  Counter used for testing (counts up when not in reset and is enabled)
- **Author:**  Martin Krzisnik, Cosylab (martin.krzisnik@cosylab.com)
- **File:**  TestCounter.vhd

## Diagram
![Diagram](TestCounter.svg "Diagram")
## Description


Configurable test counter with saturation, wait cycles, and external load

## Generics

| Generic name   | Type      | Value | Description                                                    |
| -------------- | --------- | ----- | -------------------------------------------------------------- |
| RST_POLARITY_G | std_logic | '1'   | Reset polarity ('1' = active-high, '0' = active-low)           |
| WIDTH_G        | positive  | 32    | Counter width in bits                                          |
| WAIT_WIDTH_G   | positive  | 32    | Wait counter width in bits                                     |
| REVERSE_G      | boolean   | false | Count direction (false = up, true = down) - NOT IMPLEMENTED    |
| SATURATE_G     | boolean   | false | Enable saturation at max value (true = saturate, false = wrap) |
| TPD_G          | time      | 1 ns  | Simulation propagation delay                                   |

## Ports

| Port name    | Direction | Type                                      | Description                                       |
| ------------ | --------- | ----------------------------------------- | ------------------------------------------------- |
| clk_i        | in        | std_logic                                 | Input clock                                       |
| rst_i        | in        | std_logic                                 | System reset (polarity defined by RST_POLARITY_G) |
| ext_rst_i    | in        | std_logic                                 | External reset (always active-high)               |
| en_i         | in        | std_logic                                 | Counter enable                                    |
| count_o      | out       | std_logic_vector(WIDTH_G-1 downto 0)      | Counter value output                              |
| endReached_o | out       | std_logic                                 | Max value reached flag                            |
| countUpd_o   | out       | std_logic                                 | Counter updated strobe (single-cycle pulse)       |
| incWait_i    | in        | std_logic_vector(WAIT_WIDTH_G-1 downto 0) | Wait cycles between increments (0 = no wait)      |
| load_i       | in        | std_logic                                 | Load trigger (active-high)                        |
| ldCount_i    | in        | std_logic_vector(WIDTH_G-1 downto 0)      | Load value                                        |

## Signals

| Name | Type    | Description                                  |
| ---- | ------- | -------------------------------------------- |
| r    | RegType | Output of registers                          |
| rin  | RegType | Combinatorial next-state value for registers |

## Constants

| Name       | Type                         | Value                                                                                                                                                                                                                                    | Description                                        |
| ---------- | ---------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------- |
| REG_INIT_C | RegType                      | (       count    => (others => '0'),<br><span style="padding-left:20px">       secCount => (others => '0'),<br><span style="padding-left:20px">       maxFlag  => '0',<br><span style="padding-left:20px">       upd      => '0'       ) | Initial and reset values for all register elements |
| MAX_VAL_C  | unsigned(WIDTH_G-1 downto 0) | (others => '1')                                                                                                                                                                                                                          | Maximum counter value for WIDTH_G bits (all ones)  |

## Records


### *RegType*
 Register type for Two-Process design pattern
| Name     | Type                              | Description                    |
| -------- | --------------------------------- | ------------------------------ |
| count    | unsigned(WIDTH_G-1 downto 0)      | Main counter value             |
| secCount | unsigned(WAIT_WIDTH_G-1 downto 0) | Wait cycle counter             |
| maxFlag  | std_logic                         | Maximum value reached flag     |
| upd      | std_logic                         | Counter updated flag (strobed) |


## Processes
- p_Comb: ( all )
  - **Description**
  Combinatorial process for next-state logic:<br>   Implements counter increment with wait cycles, saturation/wrap logic, and external load.<br>   Priority: load > enable. Handles both internal and external resets.
- p_Seq: ( clk_i )
  - **Description**
  Sequential process for register updates:<br>   Transfers combinatorial next-state (rin) to registered state (r) on clock edge.<br>   Includes TPD_G simulation delay for timing verification.
