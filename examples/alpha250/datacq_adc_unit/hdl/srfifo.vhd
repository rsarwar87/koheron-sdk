----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.10.2018 08:41:42
-- Design Name: 
-- Module Name: sr_fifo - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library xil_defaultlib;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


Library xpm;
use xpm.vcomponents.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sr_fifo is
        generic (
            C_M00_AXIS_TDATA_WIDTH	: integer	:= 16
        );
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC := '0';
           RE_INIT : in STD_LOGIC := '0';
           TREADY  : IN STD_LOGIC := '0';
           TVALID_IN   : IN STD_LOGIC := '0';
           TVALID_OUT  : OUT STD_LOGIC := '0';
           FULL_FIFO  : OUT std_LOGIC;
           DATA_IN : in STD_LOGIC_VECTOR (C_M00_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
           DATA_OUT : out STD_LOGIC_VECTOR (C_M00_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0')
           );
end sr_fifo;
 
architecture Behavioral of sr_fifo is
component fifo_generator_0 IS
  PORT (
    clk : IN STD_LOGIC;
    srst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC;
    data_count : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
  );
end component;

signal init,wr_en, rd_en, full, empty : std_logic := '0';
signal reset_sig: std_logic := '1';
attribute DONT_TOUCH : string;
--attribute DONT_TOUCH  of addr, wid, reset_sig, wr_en, rd_en, WIDTH, CLK_EN, ACTIVE : signal is "true";
--type NIBBLE is array (511 downto 0) of std_logic_vector(27 downto  0);
--signal array_std : NIBBLE := (others => (others => '0'));
TYPE STATE IS (REST_HOLD, ACTIVE);  -- Define the states
signal state_machine : STATE := REST_HOLD;
signal count : integer := 0;
begin
FULL_FIFO <= full;
shift_effect : process (CLK, RST) begin
    if (RST = '0') then
        wr_en <= '0';
        rd_en <= '0';
        reset_sig <= '1';
        state_machine <= REST_HOLD;
        count <= 0;
        ---DATA_OUT <= (others => '0');
        --array_std <= (others => (others => '0'));
    elsif (rising_edge(CLK)) then
        reset_sig <= '0'; 
        init <= RE_INIT;
        if init = '1' and RE_INIT = '0' then
            state_machine <= REST_HOLD;
            count <= 0;
            wr_en <= '0';
            rd_en <= '0';
            reset_sig <= '1';
        end if;
        if (state_machine = REST_HOLD) then
            count <= count + 1;
            state_machine <= REST_HOLD;
            wr_en <= '0';
            rd_en <= '0';
            reset_sig <= '1';
            if (count  = 6) then
                count <= count + 1;
                state_machine <= ACTIVE;
            end if;
        else
            count <= 0;
            wr_en <= TVALID_IN;
            rd_en <= TREADY;
        end if;
    end if;
end process;

FI: xpm_fifo_sync
   generic map (
      DOUT_RESET_VALUE => "0",    -- String
      ECC_MODE => "no_ecc",       -- String
      FIFO_MEMORY_TYPE => "auto",-- String
      FIFO_READ_LATENCY => 2,     -- DECIMAL
      FIFO_WRITE_DEPTH => 32768,   -- DECIMAL
      FULL_RESET_VALUE => 0,      -- DECIMAL
      PROG_EMPTY_THRESH => 10,    -- DECIMAL
      PROG_FULL_THRESH => 32760,     -- DECIMAL
      RD_DATA_COUNT_WIDTH => 9,   -- DECIMAL ----
      READ_DATA_WIDTH => 16,      -- DECIMAL
      READ_MODE => "std",         -- String
      USE_ADV_FEATURES => "0000", -- String
      WAKEUP_TIME => 0,           -- DECIMAL
      WRITE_DATA_WIDTH => 16,     -- DECIMAL
      WR_DATA_COUNT_WIDTH => 9    -- DECIMAL
   )
   port map (
      almost_empty => open,   -- 1-bit output: Almost Empty : When asserted, this signal indicates that
                                      -- only one more read can be performed before the FIFO goes to empty.
      almost_full => open,     -- 1-bit output: Almost Full: When asserted, this signal indicates that
                                      -- only one more write can be performed before the FIFO is full.
      data_valid => open,       -- 1-bit output: Read Data Valid: When asserted, this signal indicates
                                      -- that valid data is available on the output bus (dout).
      dbiterr => open,             -- 1-bit output: Double Bit Error: Indicates that the ECC decoder
                                      -- detected a double-bit error and data in the FIFO core is corrupted.
      dout => DATA_OUT,                   -- READ_DATA_WIDTH-bit output: Read Data: The output data bus is driven
                                      -- when reading the FIFO.
      empty => empty,                 -- 1-bit output: Empty Flag: When asserted, this signal indicates that
                                      -- the FIFO is empty. Read requests are ignored when the FIFO is empty,
                                      -- initiating a read while empty is not destructive to the FIFO.
      full => full,                   -- 1-bit output: Full Flag: When asserted, this signal indicates that the
                                      -- FIFO is full. Write requests are ignored when the FIFO is full,
                                      -- initiating a write when the FIFO is full is not destructive to the
                                      -- contents of the FIFO.
      overflow => open,               -- 1-bit output: Overflow: This signal indicates that a write request
                                      -- (wren) during the prior clock cycle was rejected, because the FIFO is
                                      -- full. Overflowing the FIFO is not destructive to the contents of the
                                      -- FIFO.
      prog_empty => open,             -- 1-bit output: Programmable Empty: This signal is asserted when the
                                      -- number of words in the FIFO is less than or equal to the programmable
                                      -- empty threshold value. It is de-asserted when the number of words in
                                      -- the FIFO exceeds the programmable empty threshold value.
      prog_full => open,              -- 1-bit output: Programmable Full: This signal is asserted when the
                                      -- number of words in the FIFO is greater than or equal to the
                                      -- programmable full threshold value. It is de-asserted when the number
                                      -- of words in the FIFO is less than the programmable full threshold
                                      -- value.
      rd_data_count => open,          -- RD_DATA_COUNT_WIDTH-bit output: Read Data Count: This bus indicates
                                      -- the number of words read from the FIFO.
      rd_rst_busy => open,            -- 1-bit output: Read Reset Busy: Active-High indicator that the FIFO
                                      -- read domain is currently in a reset state.
      sbiterr => open,                -- 1-bit output: Single Bit Error: Indicates that the ECC decoder
                                      -- detected and fixed a single-bit error.
      underflow => open,              -- 1-bit output: Underflow: Indicates that the read request (rd_en)
                                      -- during the previous clock cycle was rejected because the FIFO is
                                      -- empty. Under flowing the FIFO is not destructive to the FIFO.
      wr_ack => open,                 -- 1-bit output: Write Acknowledge: This signal indicates that a write
                                      -- request (wr_en) during the prior clock cycle is succeeded.
      wr_data_count => open,          -- WR_DATA_COUNT_WIDTH-bit output: Write Data Count: This bus indicates
                                      -- the number of words written into the FIFO.
      wr_rst_busy => open,            -- 1-bit output: Write Reset Busy: Active-High indicator that the FIFO
                                      -- write domain is currently in a reset state.
      din => DATA_IN,                 -- WRITE_DATA_WIDTH-bit input: Write Data: The input data bus used when
                                      -- writing the FIFO.
      injectdbiterr => '0',           -- 1-bit input: Double Bit Error Injection: Injects a double bit error if
                                      -- the ECC feature is used on block RAMs or UltraRAM macros.
      injectsbiterr => '0',           -- 1-bit input: Single Bit Error Injection: Injects a single bit error if
                                      -- the ECC feature is used on block RAMs or UltraRAM macros.
      rd_en => rd_en,                 -- 1-bit input: Read Enable: If the FIFO is not empty, asserting this
                                      -- signal causes data (on dout) to be read from the FIFO. Must be held
                                      -- active-low when rd_rst_busy is active high.
      rst => reset_sig,                     -- 1-bit input: Reset: Must be synchronous to wr_clk. The clock(s) can be
                                      -- unstable at the time of applying reset, but reset must be released
                                      -- only after the clock(s) is/are stable.
      sleep => '0',                   -- 1-bit input: Dynamic power saving- If sleep is High, the memory/fifo
                                      -- block is in power saving mode.
      wr_clk => CLK,                  -- 1-bit input: Write clock: Used for write operation. wr_clk must be a
                                      -- free running clock.
      wr_en => wr_en              -- 1-bit input: Write Enable: If the FIFO is not full, asserting this
                                      -- signal causes data (on din) to be written to the FIFO Must be held
                                      -- active-low when rst or wr_rst_busy or rd_rst_busy is active high
   );

--FI : fifo_generator_0 
--  PORT MAP (
--    clk => CLK,
--    srst => reset_sig,
--    data_count => open,
--    din => DATA_IN,
--    wr_en => wr_en,
--    rd_en => rd_en,
--    dout => DATA_OUT,
--    full => full,
--    empty => empty
--  );

end Behavioral;