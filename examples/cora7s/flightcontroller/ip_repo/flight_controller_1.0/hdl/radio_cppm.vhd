----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/04/2020 07:54:01 PM
-- Design Name: 
-- Module Name: radio_sbus - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- http://www.rcfair.com/en/blogs/view_entry/13144/
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

entity radio_cppm is   
    GENERIC(
   		component_period		: INTEGER := 10;    --Hz
    	sampling_period		: INTEGER := 50;		   --Hz
    	max_pulse_duration		: INTEGER := 20000;		   --Hz
    	max_sleep_pulse		: INTEGER := 2000;		   --Hz
    	output_width		: INTEGER := 13;   			   --Bits
    	signal_active_high  : std_logic := '1'
    );
  Port ( 
    clk_100, rstn_100 : in std_logic;
    enable            : in std_logic;
    
    channel_out00 : out std_logic_vector(15 downto 0);
    channel_out01 : out std_logic_vector(15 downto 0);
    channel_out02 : out std_logic_vector(15 downto 0);
    channel_out03 : out std_logic_vector(15 downto 0);
    channel_out04 : out std_logic_vector(15 downto 0);
    channel_out05 : out std_logic_vector(15 downto 0);
    channel_out06 : out std_logic_vector(15 downto 0);
    channel_out07 : out std_logic_vector(15 downto 0);
    channel_out08 : out std_logic_vector(15 downto 0);
    channel_out09 : out std_logic_vector(15 downto 0);
    channel_out10 : out std_logic_vector(15 downto 0);
    channel_out11 : out std_logic_vector(15 downto 0);
    channel_out12 : out std_logic_vector(15 downto 0);
    channel_out13 : out std_logic_vector(15 downto 0);
    channel_out14 : out std_logic_vector(15 downto 0);
    channel_out15 : out std_logic_vector(15 downto 0);
    
    radio_cppm_in   : in std_logic
  );
end radio_cppm;

architecture Behavioral of radio_cppm is
type channel_array is array (0 to 15) of std_logic_vector(15 downto 0) ;
signal channels : channel_array := (others => (others => '0'));
    
    CONSTANT clock_div : INTEGER := sampling_period / component_period;
    CONSTANT half_samples_to_count : INTEGER := (clock_div / 2) + 1;
    SIGNAL s_sample_clock_tick_counter : INTEGER range 0 to clock_div + 1 := 0;
    SIGNAL s_sample_clock : STD_LOGIC := '0';
    
    SIGNAL s_previous_cppm_in : STD_LOGIC := '0';
    
    
    SIGNAL tick_counter_low, tick_counter_high : INTEGER := 0;
    SIGNAL ch_counter : INTEGER range 0 to 15 := 0;
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
				s_previous_cppm_in <= '0';
				tick_counter_high <= 0;
				ch_counter <= 0;
				
				tick_cal1 <= 0;
				bool_cal1 <= false;
				tick_cal2 <= 0;
				bool_cal2 <= false;
			ELSIF(rising_edge(s_sample_clock)) THEN
			    
				IF(radio_cppm_in = signal_active_high and s_previous_cppm_in = not signal_active_high) THEN
					--rising edge on pwm
					tick_counter_high <= 1;
					
				ELSIF(radio_cppm_in = signal_active_high and s_previous_cppm_in = signal_active_high) THEN
					--pwm is high
					tick_counter_high <= tick_counter_high + 1;
				ELSIF(radio_cppm_in = not signal_active_high and s_previous_cppm_in = signal_active_high) THEN
					--pwm goto low
					if (tick_counter_high > max_sleep_pulse) then
					   ch_counter <= 0;
					else 
					   ch_counter <= ch_counter + 1;
					   channels(ch_counter)  <= STD_LOGIC_VECTOR(to_unsigned(tick_counter_high - tick_cal1 + tick_cal2, 15));
					end if;
				END IF;
				
			    s_previous_cppm_in <= radio_cppm_in;
			    
			END IF;
		END PROCESS;


    channel_out00 <= channels(0);
    channel_out01 <= channels(1);
    channel_out02 <= channels(2);
    channel_out03 <= channels(3);
    channel_out04 <= channels(4);
    channel_out05 <= channels(5);
    channel_out06 <= channels(6);
    channel_out07 <= channels(7);
    channel_out08 <= channels(8);
    channel_out09 <= channels(9);
    channel_out10 <= channels(10);
    channel_out11 <= channels(11);
    channel_out12 <= channels(12);
    channel_out13 <= channels(13);
    channel_out14 <= channels(14);
    channel_out15 <= channels(15);
    
    


end Behavioral;
