
library IEEE;               
use IEEE.STD_LOGIC_1164.ALL;
library ieee_proposed;
USE ieee.numeric_std.ALL;

entity esp_mshot is
--generic (

--);
port (
       clk_100, clk_200 : in  std_logic;
       rstn_100         : in  std_logic;
       grade            : in  std_logic_vector(7 downto 0);
       enabled          : in  std_logic;
       update           : in  std_logic;
       is_multi         : in  std_logic;
       speed            : in  std_logic_vector(11 downto 0);
       ack              : out  std_logic;
       pin_out          : out std_logic
);
end esp_mshot;
			
architecture rtl of esp_mshot is
    type array_int is array (0 to 3) of integer ;
   -- grade 0 => 1000us (1000us-2500us), 125 us (125 us-300us), 42 us (42 us - 100us), 5us (20 us - 40us)
   constant PRE_SIG : array_int  := (4096, 4096,  4096,  1024);
   constant POST_SIG : array_int := (6144, 6144,  6144, 5120);
   --constant HIGH_SIG : array_int := (2048, 2048,  2048, 2048);  -- 2000 baseline
   constant HIGH_TIC : array_int := (    50,     6,     2,    1);  -- actual

   --constant HIGH_SIG : array_int := (102400, 12288,  4096, 2048);  -- actual

   signal grade_int : integer range 0 to 3 := 0;
   signal analog_int, analog_count : integer range 0 to 4095 := 0;
   signal pre_int : integer range 0 to 100000*2 := PRE_SIG(0) - 1;
   signal post_int : integer range 0 to 250000*2 := POST_SIG(0)  - 1;
   signal count_int : integer := 0;
   signal count_tick_int : integer := 0;
   signal tick_int : integer range 0 to 50 := HIGH_TIC(0) - 1;
   
   TYPE STATE_TYPE IS (IDLE, UPDATEPARAM, PRE, ACTIVE, POST, ONESHOT);
   SIGNAL state, state_prev  : STATE_TYPE;
   
   signal needs_update, update_delayed, acked : std_logic := '0';
begin
   
    update_param: process(clk_100, rstn_100)
    
    begin
        if (rstn_100 = '0') then
            grade_int <= 0;
            needs_update <= '0';
            update_delayed <= '0';
            analog_int <= 0;
        elsif rising_edge (clk_100) then
            update_delayed <= update;
            ack <= '0';
            if (update_delayed = '0' and update = '1') then
                grade_int <= to_integer(unsigned(grade));
                analog_int <= to_integer(unsigned(speed));
                needs_update <= '1';
            elsif (acked = '1') then
                needs_update <= '0';
                ack <= '1';
            end if;
            
        end if;
    end process;
   
    update_ticks: process(clk_200, rstn_100)
    
    begin
        if (rstn_100 = '0') then
            count_int <= 0;
            count_tick_int <= 0;
        elsif (rising_edge (clk_200) ) then
            if (acked = '1' or state_prev /= state) then
                count_int <= 0;
                count_tick_int <= 0;
            elsif (state = PRE or state = ACTIVE or state = POST ) then
                if (count_tick_int = tick_int) then
                    count_tick_int <= 0;
                    count_int <= count_int + 1;
                else
                    count_tick_int <= count_tick_int + 1;
                end if;
            else
                count_int <= 0;
                count_tick_int <= 0;
            end if;
        end if;
    end process;
   
   update_state : process(clk_200, rstn_100)
    
    begin
        if (rstn_100 = '0') then
            state <= IDLE;
            state_prev <= IDLE;
            pin_out <= '0';
            analog_count <= 0;
            pre_int <= PRE_SIG(0) - 1;
            post_int <= POST_SIG(0) - 1;
            tick_int <= HIGH_TIC(0) - 1;
            acked <= '0';
        elsif (rising_edge (clk_200) ) then
            state_prev <= state;
            case state is 
                when IDLE =>
                    pin_out <= '0';
                    if (enabled = '1') then
                        state <= UPDATEPARAM;
                    end if;
                when UPDATEPARAM => 
                    pin_out <= '0';
                    if (needs_update = '0') then
                        state <= PRE;
                    elsif (needs_update = '1') then
                        acked <= '1';
                        analog_count <= analog_int;
                        pre_int <= PRE_SIG(grade_int) - 1;
                        post_int <= POST_SIG(grade_int) - analog_int;
                        tick_int <= HIGH_TIC(grade_int) - 1;
                    end if;
                when PRE =>
                    pin_out <= '1';
                    acked <= '0';
                    if (count_int = pre_int) then
                        state <= ACTIVE;
                    end if;
                when ACTIVE =>
                    pin_out <= '1';
                    if (count_int = analog_count) then
                        state <= POST;
                    end if;
                
                when POST =>
                    pin_out <= '0';
                    
                    if (count_int = post_int) then
                        
                        if (enabled = '0') then
                            state <= IDLE;
                        elsif (needs_update = '1') then
                            state <= UPDATEPARAM;
                        elsif (is_multi = '1') then
                            state <= PRE;
                        else
                            state <= ONESHOT;
                        end if;
                    end if;
                
                when ONESHOT =>
                    pin_out <= '0';
                    if (needs_update = '1') then
                        state <= UPDATEPARAM;
                    end if;
                    if (enabled = '0') then
                        state <= IDLE;
                    end if;
            end case;
        end if;
    end process;
end rtl;
			
			