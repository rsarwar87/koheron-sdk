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
    Port ( clll : in STD_LOGIC;
           THRESHOLD : in STD_LOGIC_VECTOR (15 downto 0);
           TR : in STD_LOGIC;
           ADC_INPUT : in STD_LOGIC_VECTOR (63 downto 0);
           TA : out STD_LOGIC_VECTOR (63 downto 0);
           TV : out STD_LOGIC);
end trigger;

architecture Behavioral of trigger is
TYPE State_type IS (SEEK, ISSUE);  -- Define the states
SIGNAL State : State_Type := SEEK;    -- Create a signal that uses 
SIGNAL triggered, isAlwaysOn  : std_logic := '0';
SIGNAL cnt : integer range 0 to 255 := 0;
signal thresh, adc_cur1, adc_prev1 : integer range -65535 to 65535 := 0;
signal adc_cur0, adc_prev0, adc_cur2, adc_prev2,  adc_cur3, adc_prev3 : integer range -65535 to 65535 := 0;
signal diff0, diff1, diff2, diff3 : integer := 0;
type NIBBLE is array (0 to 32) of STD_LOGIC_VECTOR (63 downto 0);
signal adc0 : NIBBLE;
begin
    process (clll)
    begin
        if (rising_edge(clll)) then
            triggered <= '0';
            if thresh = 0 then
                isAlwaysOn <= '1';
            else
                isAlwaysOn <= '0';
            end if;
            TV <= TR and (triggered or isAlwaysOn);
            TA <= (others => '0');
            State <= State;
            
            adc_cur1 <= to_integer(signed(ADC_INPUT(31 downto 16)));
            adc_prev1 <= adc_cur1;
            adc_cur0 <= to_integer(signed(ADC_INPUT(15 downto 0)));
            adc_prev0 <= adc_cur0;
            adc_cur2 <= to_integer(signed(ADC_INPUT(47 downto 32)));
            adc_prev2 <= adc_cur2;
            adc_cur3 <= to_integer(signed(ADC_INPUT(63 downto 48)));
            adc_prev3 <= adc_cur3;
            
            diff0 <= abs(adc_prev0 - adc_cur0);
            diff1 <= abs(adc_prev1 - adc_cur1);
            diff2 <= abs(adc_prev2 - adc_cur2);
            diff3 <= abs(adc_prev3 - adc_cur3);
            
            adc0(0) <= ADC_INPUT;
            adc0(1 to 32) <=adc0(0 to 31)  ;
            
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
                        if (diff0 > thresh or diff1 > thresh or diff3 > thresh or diff2 > thresh) then
                           State <= ISSUE;
--                        elsif (diff1 > thresh) then
--                            State <= ISSUE;
                        end if;
--                    end if;
                when ISSUE =>
                    cnt <= cnt + 1;
                    triggered <= '1';
                    TA <= adc0(21);
                    if (cnt = 192) then
                        State <= SEEK;
                    end if;
            end case;
        end if;
    end process;

end Behavioral;
