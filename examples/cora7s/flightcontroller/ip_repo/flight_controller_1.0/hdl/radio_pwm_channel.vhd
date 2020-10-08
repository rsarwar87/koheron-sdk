----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/04/2020 08:01:33 PM
-- Design Name: 
-- Module Name: radio_pwm_channel - Behavioral
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

entity radio_pwm_channel is
   GENERIC(
   		component_period		: INTEGER := 10;    --Hz
    	sampling_period		: INTEGER := 50;		   --Hz
    	max_pulse_duration		: INTEGER := 20000;		   --Hz
    	max_active_pulse		: INTEGER := 2000;		   --Hz
    	output_width		: INTEGER := 13;   			   --Bits
    	signal_active_high  : boolean := true     
    );
  Port (
    clk_100, rstn_100 : in std_logic;
    enable            : in std_logic;
    channel_out : out std_logic_vector(15 downto 0);
    
    radio_pwm_in   : in std_logic
);
end radio_pwm_channel;

architecture Behavioral of radio_pwm_channel is
    CONSTANT clock_div : INTEGER := sampling_period / component_period;
    CONSTANT half_samples_to_count : INTEGER := (clock_div / 2) + 1;
    SIGNAL s_sample_clock_tick_counter : INTEGER range 0 to clock_div + 1 := 0;
    SIGNAL s_sample_clock : STD_LOGIC := '0';
    SIGNAL s_pwm_count : STD_LOGIC_VECTOR(output_width - 1 downto 0) := (others => '0');
    SIGNAL s_previous_pwm_in : STD_LOGIC := '0';
    SIGNAL tick_counter : INTEGER := 0;
    SIGNAL tick_cal1, tick_cal2 : INTEGER := 0;
    SIGNAL bool_cal1, bool_cal2 : boolean := false;
begin
    sample_clocking : process(clk_100)
		BEGIN
			if(rising_edge(clk_100)) THEN
				s_sample_clock_tick_counter <= s_sample_clock_tick_counter + 1;
				IF(s_sample_clock_tick_counter < half_samples_to_count) THEN
					s_sample_clock <= '1';
				ELSE
					s_sample_clock <= '0';
				END IF;
			END IF;
		END PROCESS;

        sampling : process(s_sample_clock, rstn_100)
		BEGIN
		
			IF(rstn_100 = '0' or enable = '1') THEN
				s_pwm_count <= (others => '0');
				s_previous_pwm_in <= '0';
				tick_counter <= 0;
				tick_cal1 <= 0;
				bool_cal1 <= false;
				tick_cal2 <= 0;
				bool_cal2 <= false;
			ELSIF(rising_edge(s_sample_clock)) THEN
			    
				IF(radio_pwm_in = '1' and s_previous_pwm_in ='0') THEN
					--rising edge on pwm
					tick_counter <= 1;
				ELSIF(radio_pwm_in = '1' and s_previous_pwm_in ='1') THEN
					--pwm is high
					tick_counter <= tick_counter + 1;
				ELSIF(radio_pwm_in = '0' and s_previous_pwm_in = '1') THEN
					--pwm goto low
--					if (tick_counter - tick_cal1 + tick_cal2 > 2**output_width-1) then
--					   tick_cal1 <= tick_counter + tick_cal2 - 2**output_width-1;
--					   s_pwm_count <= (others => '1');
--					   bool_cal1 <= true;
--					   channel_out(15) <= '1';
--					elsif (tick_counter - tick_cal1 + tick_cal2 < ((2**output_width)/2)-1) then
--					   tick_cal2 <= ((2**output_width)/2)-1 - tick_counter - tick_cal1;
--					   s_pwm_count <= (others => '0');
--					   bool_cal2 <= true;
--					else
					   s_pwm_count <= STD_LOGIC_VECTOR(to_unsigned(tick_counter - tick_cal1 + tick_cal2, output_width));
					--end if;
				ELSE
					s_pwm_count <= s_pwm_count;
				END IF;
				
			    s_previous_pwm_in <= radio_pwm_in;
			    channel_out(output_width - 1 downto 0) <= s_pwm_count;
			END IF;
		END PROCESS;


end Behavioral;
