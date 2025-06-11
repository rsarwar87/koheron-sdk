
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

Library UNISIM;
use UNISIM.vcomponents.all;


entity multi_tile_sync is
    Port ( 
           pl_clk_p, pl_clk_n : in STD_LOGIC;
           pl_sysref_p, pl_sysref_n : in std_logic;
           
           adc_axis_clk, dac_axis_clk : in std_logic;

           user_sysref_adc : out std_logic;
           user_sysref_dac : out STD_LOGIC
         );
end multi_tile_sync;


architecture Behavioral of multi_tile_sync is

  signal pl_clk, pl_sysref, pl_sysref_r  : std_logic;
  attribute X_INTERFACE_INFO : string;
attribute X_INTERFACE_PARAMETER : string;

-- Assign the interface to both signals
attribute X_INTERFACE_INFO of pl_clk_p : signal is "xilinx.com:interface:diff_clock_rtl:1.0 clk_p";
attribute X_INTERFACE_INFO of pl_clk_n : signal is "xilinx.com:interface:diff_clock_rtl:1.0 clk_n";
attribute X_INTERFACE_INFO of pl_sysref_p : signal is "xilinx.com:interface:diff_clock_rtl:1.0 clk_p";
attribute X_INTERFACE_INFO of pl_sysref_n : signal is "xilinx.com:interface:diff_clock_rtl:1.0 clk_n";

begin


   IBUFDS_inst : IBUFDS
   port map (
      O => pl_clk,   -- 1-bit output: Buffer output
      I => pl_clk_p,   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
      IB => pl_clk_n  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
   );
   IBUFDS_sysref : IBUFDS
   port map (
      O => pl_sysref,   -- 1-bit output: Buffer output
      I => pl_sysref_p,   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
      IB => pl_sysref_n  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
   );

   process(pl_clk) begin
      if rising_edge(pl_clk) then
        pl_sysref_r <= pl_sysref;
      end if;
   end process;
   process(dac_axis_clk) begin
      if rising_edge(adc_axis_clk) then
        user_sysref_dac <= pl_sysref_r;
      end if;
   end process;
   process(adc_axis_clk) begin
      if rising_edge(adc_axis_clk) then
        user_sysref_adc <= pl_sysref_r;
      end if;
   end process;
end Behavioral;

