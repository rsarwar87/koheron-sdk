---------------------------------------------------------------------------------------------------
--! @brief Counter used for testing (counts up when not in reset and is enabled)
--!
--! @author Martin Krzisnik, Cosylab (martin.krzisnik@cosylab.com)
--! @file TestCounter.vhd
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

---------------------------------------------------------------------------------------------------
--! Configurable test counter with saturation, wait cycles, and external load
entity TestCounter is
   generic (
      RST_POLARITY_G : std_logic := '1';                                                --! Reset polarity ('1' = active-high, '0' = active-low)
      WIDTH_G        : positive  := 32;                                                 --! Counter width in bits
      WAIT_WIDTH_G   : positive  := 32;                                                 --! Wait counter width in bits
      REVERSE_G      : boolean   := false;                                              --! Count direction (false = up, true = down) - NOT IMPLEMENTED
      SATURATE_G     : boolean   := false;                                              --! Enable saturation at max value (true = saturate, false = wrap)
      TPD_G          : time      := 1 ns                                                --! Simulation propagation delay
      );
   port (
      --! Clock and Reset
      clk_i        : in  std_logic;                                                     --! Input clock
      rst_i        : in  std_logic;                                                     --! System reset (polarity defined by RST_POLARITY_G)
      ext_rst_i    : in  std_logic;                                                     --! External reset (always active-high)
      --
      --! Counter Control
      en_i         : in  std_logic;                                                     --! Counter enable
      --
      --! Counter Outputs
      count_o      : out std_logic_vector(WIDTH_G-1 downto 0);                          --! Counter value output
      endReached_o : out std_logic;                                                     --! Max value reached flag
      countUpd_o   : out std_logic;                                                     --! Counter updated strobe (single-cycle pulse)
      --
      --! Optional Wait Configuration
      incWait_i    : in  std_logic_vector(WAIT_WIDTH_G-1 downto 0) := (others => '0');  --! Wait cycles between increments (0 = no wait)
      --
      --! Optional External Load Interface
      load_i       : in  std_logic                                 := '0';              --! Load trigger (active-high)
      ldCount_i    : in  std_logic_vector(WIDTH_G-1 downto 0)      := (others => '0')   --! Load value
      );
end TestCounter;
---------------------------------------------------------------------------------------------------
architecture rtl of TestCounter is
   --! Register type for Two-Process design pattern
   type RegType is record
      count    : unsigned(WIDTH_G-1 downto 0);       --! Main counter value
      secCount : unsigned(WAIT_WIDTH_G-1 downto 0);  --! Wait cycle counter
      maxFlag  : std_logic;                          --! Maximum value reached flag
      upd      : std_logic;                          --! Counter updated flag (strobed)
   end record RegType;

   --! Initial and reset values for all register elements
   constant REG_INIT_C : RegType := (
      count    => (others => '0'),
      secCount => (others => '0'),
      maxFlag  => '0',
      upd      => '0'
      );

   --! Output of registers
   signal r : RegType;

   --! Combinatorial next-state value for registers
   signal rin : RegType;

   --! Maximum counter value for WIDTH_G bits (all ones)
   constant MAX_VAL_C : unsigned(WIDTH_G-1 downto 0) := (others => '1');

---------------------------------------------------------------------------------------------------
begin

   --! Combinatorial process for next-state logic:<br>
   --!   Implements counter increment with wait cycles, saturation/wrap logic, and external load.<br>
   --!   Priority: load > enable. Handles both internal and external resets.
   p_Comb : process(all)
      variable v : RegType;
   begin

      v := r;                           --! default assignment

      -- Set default value for upd signal
      v.upd := '0';

      if (load_i = '1') then
         -- Load external count
         v.count    := unsigned(ldCount_i);
         v.upd      := '1';
         -- Reset the wait counter and the max reached flag
         v.secCount := (others => '0');
         v.maxFlag  := '0';
      elsif (en_i = '1') then
         -- Only change count value if the counter is enabled
         if (r.count = MAX_VAL_C) then
            -- Overflow the counter if saturation is not enabled
            if (SATURATE_G = false) then
               v.count := REG_INIT_C.count;
               v.upd   := '1';
            end if;
         else
            -- Increment the counter if max value is not reached yet
            if (r.secCount >= unsigned(incWait_i)) then
               -- only increment counter when wait elapses
               v.count    := r.count + 1;
               v.upd      := '1';
               v.secCount := (others => '0');
            else
               v.secCount := r.secCount + 1;
            end if;
         end if;
      end if;

      -- Set max value reached flag when counter reaches the max value
      if (v.count = MAX_VAL_C) then
         v.maxFlag := '1';
      end if;

      if ext_rst_i = '1' then           --! External reset
         v := REG_INIT_C;
      end if;

      if rst_i = RST_POLARITY_G then    --! reset condition
         v := REG_INIT_C;
      end if;

      rin <= v;                         --! drive register inputs

      --! drive outputs
      count_o      <= std_logic_vector(r.count);
      endReached_o <= r.maxFlag;
      countUpd_o   <= r.upd;

   end process p_Comb;

   --! Sequential process for register updates:<br>
   --!   Transfers combinatorial next-state (rin) to registered state (r) on clock edge.<br>
   --!   Includes TPD_G simulation delay for timing verification.
   p_Seq : process(clk_i)
   begin
      if rising_edge(clk_i) then
         r <= rin after TPD_G;
      end if;
   end process p_Seq;

end rtl;
---------------------------------------------------------------------------------------------------
