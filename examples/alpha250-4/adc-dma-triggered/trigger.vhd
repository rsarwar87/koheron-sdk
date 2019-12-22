----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2019 13:47:45
-- Design Name: 
-- Module Name: trigger - Behavioral
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

entity trigger is
    Port ( CLK : in STD_LOGIC;
           THRESHOLD : in STD_LOGIC_VECTOR (15 downto 0);
           NEGATIVE : in STD_LOGIC;
           S_TREADY : in STD_LOGIC;
           ADC_INPUT : in STD_LOGIC_VECTOR (31 downto 0);
           S_TDATA : out STD_LOGIC_VECTOR (31 downto 0);
           S_TVALID : out STD_LOGIC);
end trigger;

architecture Behavioral of trigger is
TYPE State_type IS (SEEK, ISSUE);  -- Define the states
SIGNAL State : State_Type := SEEK;    -- Create a signal that uses 
SIGNAL triggered : std_logic := '0';
SIGNAL cnt : integer range 0 to 255 := 0;
signal thresh, adc_cur1, adc_prev1 : integer range 0 to 65535 := 0;
signal adc_cur0, adc_prev0 : integer range 0 to 65535 := 0;
signal diff0, diff1 : integer := 0;
signal adc0, adc1, adc2, adc3, adc4, adc5, adc6, adc7, adc8, adc9, adc10, adc11, adc12, adc13 , adc14, adc15, adc16, adc17, adc18, adc19, adc20, adc21, adc22 : STD_LOGIC_VECTOR (31 downto 0);
begin
    process (CLK)
    begin
        if (rising_edge(CLK)) then
            triggered <= '0';
            S_TVALID <= S_TREADY and triggered;
            S_TDATA <= (others => '0');
            State <= State;
            
            adc_cur1 <= to_integer(unsigned(ADC_INPUT(29 downto 16)));
            adc_prev1 <= adc_cur1;
            adc_cur0 <= to_integer(unsigned(ADC_INPUT(13 downto 0)));
            adc_prev0 <= adc_cur0;
            
            diff0 <= adc_prev0 - adc_cur0;
            diff1 <= adc_prev1 - adc_cur1;
            
            adc0 <= ADC_INPUT;
            adc1 <= adc0;
            adc2 <= adc1;
            adc3 <= adc2;
            adc4 <= adc3;
            adc5 <= adc4;
            adc6 <= adc5;
            adc7 <= adc6;
            adc8 <= adc7;
            adc9 <= adc8;
            
            adc10 <= adc9;
            adc11 <= adc10;
            adc12 <= adc11;
            adc13 <= adc12;
            adc14 <= adc13;
            adc15 <= adc14;
            adc16 <= adc15;
            adc17 <= adc16;
            adc18 <= adc17;
            adc19 <= adc18;
            adc20 <= adc19;
            adc21 <= adc20;
            adc22 <= adc21;
            thresh <= to_integer(unsigned(THRESHOLD));
            
            case State is
                when SEEK =>
                    cnt <= 0;
--                    if NEGATIVE = '0' then
--                        if (diff0 < -thresh) then
--                           State <= ISSUE;
--                        elsif (diff1 < -thresh) then
--                            State <= ISSUE;
--                        end if;
--                    else
                        if (diff0 > thresh) then
                           State <= ISSUE;
--                        elsif (diff1 > thresh) then
--                            State <= ISSUE;
                        end if;
--                    end if;
                when ISSUE =>
                    cnt <= cnt + 1;
                    triggered <= '1';
                    S_TDATA <= adc22;
                    if (cnt = 192) then
                        State <= SEEK;
                    end if;
            end case;
        end if;
    end process;

end Behavioral;
