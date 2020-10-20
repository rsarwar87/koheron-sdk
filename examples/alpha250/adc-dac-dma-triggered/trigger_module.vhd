----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2020 11:31:24 AM
-- Design Name: 
-- Module Name: trigger_module - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity trigger_module is
    Port ( clk           : in STD_LOGIC;
           nrst           : in STD_LOGIC;
           data_in       : in STD_LOGIC_VECTOR (15 downto 0);
           trigger_in    : in STD_LOGIC;
           led_out       : out STD_LOGIC;
           config_in       : in STD_LOGIC_VECTOR (31 downto 0);
           s_axis_tready : in STD_LOGIC;
           s_axis_tvalid : out STD_LOGIC;
           s_axis_tdata  : out STD_LOGIC_VECTOR (15 downto 0)
           );
end trigger_module;

architecture Behavioral of trigger_module is
signal tvalid : std_logic := '0';
signal tcounter : integer range 0 to 250000001:= 0;
signal tdata  : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');

TYPE state_type IS (prereset, seeking, active); -- the 4 different states
SIGNAL state : state_type := prereset;   -- Create a signal that uses 
	
begin

    led_out <= tvalid;
    s_axis_tvalid <= tvalid;
    s_axis_tdata <= tdata;
    
    process (clk, nrst)
    begin
        if (nrst = '0' or config_in(31) = '1') then
            tdata <= (others => '0');
            tcounter     <= 0;
            tvalid       <= '0';
            state        <= prereset;
        elsif (rising_edge(clk)) then
            state <= state;
            tdata <= tdata;
            tcounter <= tcounter;
            tvalid <= tvalid;
            case (state) is
                when prereset =>
                    state <= seeking;
                    tdata <= (others => '0');
                    tcounter     <= 0;
                    tvalid       <= '0';
                when seeking =>
                    if (trigger_in = '1' and s_axis_tready = '1') then
                        state <= active;
                    end if; 
                when others => 
                    tdata <= data_in;
                    tvalid <= '1';
                    if (tcounter =  to_integer(unsigned(config_in(31 downto 0)))) then
                        state        <= prereset;
                    elsif (s_axis_tready = '1') then
                        tcounter <= tcounter + 1;
                    end if;
            end case;
            
            
        end if;
    end process;



end Behavioral;
