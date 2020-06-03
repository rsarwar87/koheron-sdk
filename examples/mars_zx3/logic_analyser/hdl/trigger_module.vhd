----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.06.2020 18:04:21
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
use IEEE.std_logic_misc.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity trigger_module is
    Port ( clk : in STD_LOGIC;
           rstn : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (15 downto 0);
           trigger_in : in STD_LOGIC_VECTOR (31 downto 0);
           m_axis_tvalid : out STD_LOGIC;
           m_axis_tdata : out STD_LOGIC_VECTOR (15 downto 0);
           m_axis_tready : in STD_LOGIC);
end trigger_module;

architecture Behavioral of trigger_module is
    signal count : std_logic_vector(31 downto 0) := (others => '0');
    signal triggered, or_result : std_logic := '0'; 
    signal trigger_mask : std_logic_vector(15 downto 0) := (others => '0'); 
begin
    trigger_mask <= data_in AND trigger_in(15 downto 0);
    or_result <= '0' when trigger_mask=X"0000" else '1';
    process (clk, rstn)
    
    begin
        if (rstn = '0') then
            count <= (others => '0');
            m_axis_tvalid <= '0';
            m_axis_tdata <= (others => '0');
            triggered <= '0';
        elsif (rising_edge(clk)) then
            count <= count;
            m_axis_tdata <= data_in;
            if (m_axis_tready = '1') then
                if (trigger_in = x"00000000") then
                    m_axis_tvalid <= '0';
                elsif (trigger_in = x"FFFFFFFF") then
                    m_axis_tvalid <= '1';
                elsif(triggered = '1') then
                    m_axis_tvalid <= '1';
                elsif (or_result = '1') then
                    triggered <= '1';
                end if;
            else
                m_axis_tvalid <= '0';
            end if;
            if (trigger_in = x"00000000") then
                
            else
                triggered <= triggered;
            end if;
        end if;
    
    end process;


end Behavioral;
