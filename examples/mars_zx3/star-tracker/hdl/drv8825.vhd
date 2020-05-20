----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/12/2020 05:22:56 PM
-- Design Name: 
-- Module Name: drv8825 - Behavioral
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
Library UNISIM;
use UNISIM.vcomponents.all;

Library UNIMACRO;
use UNIMACRO.vcomponents.all;

entity drv8825 is
    Port ( clk_50 : in STD_LOGIC;
           rstn_50 : in STD_LOGIC;
           drv8825_mode : out STD_LOGIC_VECTOR (2 downto 0);
           drv8825_enable_n : out STD_LOGIC;
           drv8825_sleep_n : out STD_LOGIC;
           drv8825_rst_n : out STD_LOGIC;
           drv8825_step : out STD_LOGIC;
           drv8825_direction : out STD_LOGIC;
           drv8825_fault_n : in STD_LOGIC;
           ctrl_step_count : out STD_LOGIC_VECTOR (31 downto 0);
           ctrl_status : out STD_LOGIC_VECTOR (31 downto 0);
           ctrl_cmdcontrol : in STD_LOGIC_VECTOR (31 downto 0); -- steps, go, stop, direction
           ctrl_cmdtick : in STD_LOGIC_VECTOR (31 downto 0);    -- speed of command
           ctrl_cmdduration : in STD_LOGIC_VECTOR (31 downto 0);    -- speed of command
           ctrl_backlash_tick : in STD_LOGIC_VECTOR (31 downto 0);  -- speed of backlash
           ctrl_backlash_duration : in STD_LOGIC_VECTOR (31 downto 0); -- duration of backlash
           ctrl_trackctrl : in STD_LOGIC_VECTOR (31 downto 0)    -- speed, start, direction
          );
end drv8825;

architecture Behavioral of drv8825 is
    ATTRIBUTE MARK_DEBUG : string;
    
    
    signal current_direction_buf : std_logic_vector(3 downto 0) := "0000";
    type speed_buffer is array (0 to 3) of integer range 0 to 2**31-1;
    signal current_speed_buf : speed_buffer := (others => 0);
    signal current_mode_buf : std_logic_vector(2 downto 0) := "000";
    signal current_mode_out : std_logic_vector(2 downto 0) := "000";
    signal current_mode_back : std_logic_vector(2 downto 0) := "000";
    
    signal ctr_tracktick_buf : integer range 0 to 2**31-1 := 1;
    signal ctr_track_direction : std_logic := '0';
    signal ctr_track_enabled : std_logic := '0';
    
    signal ctr_cmd_buf, ctr_park_buf : std_logic := '0';
    signal ctr_cmdtick_buf : integer range 0 to 2**31-1 := 1;
    signal ctr_backlash_tick_buf : integer range 0 to 2**31-1 := 1;
    signal ctr_backlash_duration_buf : integer range 0 to 2**31-1 := 1;
    TYPE state_machine_backlash IS (seek, processing, done, disabled);  -- Define the states
    signal state_backlash : state_machine_backlash := seek;
    
    signal stepping_clk, cnt_enable : std_logic := '0';
    signal current_stepper_counter : std_logic_vector(30 downto 0) := (others => '0');
    
    TYPE state_machine_motor IS (idle, tracking, command, park);  -- Define the states
    signal state_motor : state_machine_motor := idle;
    TYPE state_change_trigger_machine IS (normal, direction, direction_speed, speed);  -- Define the states
    signal state_change_trigger : state_change_trigger_machine := normal;
    
    ATTRIBUTE MARK_DEBUG of current_mode_out, current_speed_buf: SIGNAL IS "TRUE";
    ATTRIBUTE MARK_DEBUG of stepping_clk, state_change_trigger, state_motor, current_stepper_counter, cnt_enable: SIGNAL IS "TRUE";
    ATTRIBUTE MARK_DEBUG of state_backlash, ctr_backlash_tick_buf, ctr_backlash_duration_buf, ctr_track_enabled, ctr_track_direction, ctr_tracktick_buf: SIGNAL IS "TRUE";
    
    
begin
    
    ctrl_status(3) <= drv8825_fault_n;
    ctrl_status(31 downto 4) <= (others => '0');
    ctrl_step_count(31) <= '0';
    ctrl_step_count(30 downto 0) <= current_stepper_counter;
    trigger_changes : process (clk_50, rstn_50)
    begin
        if (rstn_50 = '0') then
            state_change_trigger <= normal;
        elsif(rising_edge(clk_50)) then
            state_change_trigger <= normal;
            if (current_direction_buf(1) /= current_direction_buf(0) and current_speed_buf(1) /= current_speed_buf(0)) then
                state_change_trigger <= direction_speed;
            elsif (current_direction_buf(1) /= current_direction_buf(0)) then
                state_change_trigger <= direction;
            elsif (current_speed_buf(1) /= current_speed_buf(0)) then
                state_change_trigger <= speed ;
            end if;
        end if;
    end process; 
        
    registered_output : process(clk_50, rstn_50) begin
        if (rstn_50 = '0') then
            drv8825_enable_n<='0';
            drv8825_sleep_n<= '0';
            drv8825_rst_n  <= '0';
            drv8825_direction <= '0';
            drv8825_mode <= (others => '0');
            drv8825_step <= '0';
            ctrl_status(2 downto 0) <= (others => '0');
        elsif (rising_edge(clk_50)) then
            drv8825_enable_n<='0';
            drv8825_sleep_n<= '1';
            drv8825_rst_n  <= '1';
            drv8825_mode <= (others => '0');
            ctrl_status(2 downto 0) <= "000";
            case state_motor is
                when idle  =>
                    drv8825_direction <= '0';
                    drv8825_step <= '0';
                    drv8825_mode <= current_mode_out;
                    ctrl_status(0) <= '0';
                    ctrl_status(1) <= '0';
                    ctrl_status(2) <= '0';
                    drv8825_mode <= (others => '0');
                when tracking =>
                    drv8825_direction <= current_direction_buf(0);
                    drv8825_step <= stepping_clk;
                    drv8825_mode <= current_mode_out;
                    ctrl_status(1) <= '0';
                    ctrl_status(0) <= '1';
                    ctrl_status(2) <= '0';
                when command => 
                    drv8825_direction <= current_direction_buf(0);
                    drv8825_step <= stepping_clk;
                    drv8825_mode <= current_mode_out;
                    ctrl_status(2) <= '0';
                    ctrl_status(1) <= '1';
                    ctrl_status(0) <= '0';
                when park =>
                    drv8825_direction <= current_direction_buf(0);
                    drv8825_step <= stepping_clk;
                    drv8825_mode <= current_mode_out;
                    ctrl_status(2) <= '1';
                    ctrl_status(1) <= '1';
                    ctrl_status(0) <= '0';
                when others => 
                    drv8825_direction <= current_direction_buf(1);
                    drv8825_step <= stepping_clk;
                    drv8825_mode <= current_mode_out;
                    ctrl_status(0) <= '0';
                    ctrl_status(2) <= '0';
                    ctrl_status(1) <= '0';
            end case;
        end if;
    end process; 
--------------------------------------------------------------------------------------------
-- clock divider
--------------------------------------------------------------------------------------------
clock_block: block
    signal ctr_backlash_ptr : integer range 0 to 2**30 := 1;
    signal ctr_backlash_cnt : integer range 0 to 2**30 := 1;
    
     signal counter_buf :integer range 0 to 2**31-1 := 1;
     signal count :integer range 0 to 2**31-1 := 1;
     
     ATTRIBUTE MARK_DEBUG of counter_buf, count, ctr_backlash_cnt: SIGNAL IS "TRUE";
begin
    
    clock_generatory : process (clk_50, rstn_50)
    begin
        if (rstn_50 = '0') then
            stepping_clk <= '0';
        elsif (rising_edge (clk_50) ) then
            stepping_clk <= stepping_clk;
            count <= count + 1;
            if (state_change_trigger = speed or state_change_trigger = speed OR state_change_trigger = direction_speed) then
                count <= 0;
                stepping_clk <= '0';
            elsif (count = counter_buf/2) then
                stepping_clk <= not stepping_clk;
                count <= count + 1;
            elsif (count > counter_buf - 1) then
                count <= 0;
                stepping_clk <= not stepping_clk;
            end if;
        end if;
    end process;
    
    backslash: process (clk_50, rstn_50)
    begin
        if (rstn_50 = '0') then
            ctr_backlash_cnt <= 0;
            state_backlash   <= seek;
            counter_buf <= 1;
        elsif (rising_edge(clk_50)) then
            counter_buf <= current_speed_buf(1);
            current_mode_out <= current_mode_buf;
            case (state_backlash) is
                when seek =>
                    ctr_backlash_cnt <= 0;
                    if (state_change_trigger = direction OR state_change_trigger = direction_speed) then
                        state_backlash <= processing;
                        counter_buf <= ctr_backlash_tick_buf;
                        current_mode_out <= current_mode_back;
                    end if; 
                    if (ctr_backlash_duration_buf = 0) then
                        state_backlash <= disabled;
                    end if;
                when processing =>
                    ctr_backlash_cnt <= ctr_backlash_cnt + 1; 
                    counter_buf <= ctr_backlash_tick_buf;
                    current_mode_out <= current_mode_back;
                    if (ctr_backlash_cnt = ctr_backlash_duration_buf) then
                        state_backlash <= done;
                    end if;
                when done =>
                    state_backlash <= seek;
                    ctr_backlash_cnt <= 0;
                when disabled => 
                    if (ctr_backlash_duration_buf /= 0) then
                        state_backlash <= seek;
                    end if;
                when others =>
                    state_backlash <= seek;
             end case;
        end if;
    end process;
    
    
 end block clock_block;

command_block: block
    signal ctr_cmdtick_in : integer range 0 to 2**31-1 := 1;
    signal ctr_cmdduration_in : std_logic_vector(30 downto 0) := (others => '0');
    signal ctr_cmd_direction_in  : std_logic := '0';
    signal ctr_cmd_in : std_logic := '0';
    signal ctr_cmdcancel_in : std_logic := '0';
    signal ctr_goto_in : std_logic := '0';
    signal ctr_park_in : std_logic := '0';
    signal ctr_cmdmode_in : std_logic_vector(2 downto 0) := "000";
    
    signal ctr_backlash_tick_in  : integer range 0 to 2**31-1 := 1;
    signal ctr_backlash_duration_in  : integer range 0 to 2**31-1 := 1;
    
    signal ctr_track_enabled_in : std_logic := '0';
    signal ctr_track_direction_in : std_logic := '0';
    signal ctr_tracktick_in : integer range 0 to 2**31-1 := 1;
    signal ctr_trackmode_in : std_logic_vector(2 downto 0) := "000";
    
    --signal stepper_counter_int : integer range 0 to 2**31-1 := 1;
    signal target_counter_int : std_logic_vector(30 downto 0) := (others => '0');
    
    ATTRIBUTE MARK_DEBUG of ctr_cmd_in, ctr_cmdcancel_in, ctr_goto_in, ctr_park_in, ctr_cmdmode_in, ctr_cmdtick_in, ctr_cmdduration_in: SIGNAL IS "TRUE";
    ATTRIBUTE MARK_DEBUG of ctr_track_enabled_in, ctr_track_direction_in, ctr_tracktick_in, ctr_trackmode_in: SIGNAL IS "TRUE";
begin
    
    issue_command: process (clk_50, rstn_50)
    begin
        if (rstn_50 = '0') then
            state_motor <= idle;
            current_direction_buf <= (others => '0');
            current_speed_buf <= (others=> 0);
            --stepper_counter_int  <= 0;
            target_counter_int  <= (others=> '0');
            current_mode_buf <= (others=>'0');
            ctr_cmd_buf <= '0';
            ctr_park_buf <= '0';
        elsif (rising_edge(clk_50)) then
            --stepper_counter_int <= to_integer(unsigned(current_stepper_counter));
            target_counter_int <= target_counter_int;
            state_motor <= state_motor;
            current_direction_buf(0) <= current_direction_buf(0);
            current_direction_buf(3 downto 1) <= current_direction_buf(2 downto 0);
            current_speed_buf(1 to 3) <= current_speed_buf(0 to 2);
            current_speed_buf(0) <= current_speed_buf(0);
            current_mode_buf <= current_mode_buf;
            ctr_cmd_buf <= ctr_cmd_in;
            ctr_park_buf <= ctr_park_in;
            case (state_motor) is
                when command => 
                    if (ctr_cmdcancel_in = '1' or target_counter_int = current_stepper_counter) then
                        state_motor <= idle;
                    end if;
                when park =>
                    if (ctr_cmdcancel_in = '1' or target_counter_int = current_stepper_counter) then
                        state_motor <= idle;
                    end if;
                when others =>
                    if (ctr_cmd_buf = '0' and ctr_cmd_in = '1') then
                        state_motor <= command;
                        current_direction_buf(0) <= ctr_cmd_direction_in;
                        current_mode_buf <= ctr_cmdmode_in;
                        if (ctr_goto_in = '1') then
                           target_counter_int <= ctr_cmdduration_in;
                        else
                            if (ctr_cmd_direction_in = '1') then
                                target_counter_int <= std_logic_vector( unsigned(current_stepper_counter) + unsigned(ctr_cmdduration_in) );
                            else
                                target_counter_int <= std_logic_vector( unsigned(current_stepper_counter) - unsigned(ctr_cmdduration_in) );
                            end if;
                        end if;
                        current_speed_buf(0) <= ctr_cmdtick_in;
                    elsif (ctr_park_buf = '0' and ctr_park_in = '1') then
                        state_motor <= park;
                        current_direction_buf(0) <= ctr_cmd_direction_in;
                        current_speed_buf(0) <= ctr_cmdtick_in;
                        current_mode_buf <= ctr_cmdmode_in;
                        target_counter_int <= (others => '0');
                    elsif (ctr_track_enabled_in = '1') then
                        state_motor <= tracking;
                        current_direction_buf(0) <= ctr_track_direction_in;
                        current_speed_buf(0) <= ctr_tracktick_in;
                        current_mode_buf <= ctr_trackmode_in;
                    else 
                        state_motor <= idle;
                    end if; 
            end case;
         
        
        end if;
    end process;
    

    settings: process(clk_50, rstn_50)
    begin
        if (rstn_50 = '0') then
        
            ctr_cmd_direction_in  <= '1';
            ctr_cmd_in <= '0';
            ctr_goto_in  <= '0';
            ctr_cmdtick_in <= 1;
            ctr_cmdtick_buf <= 1;
            ctr_cmdcancel_in <= '0';
            ctr_park_in <= '0';
            
            
            ctr_backlash_duration_buf <= 0;
            ctr_backlash_duration_in <= 0;
            ctr_backlash_tick_in <= 1;
            ctr_backlash_tick_buf <= 1;
            current_mode_back <= (others => '0');
            
            ctr_tracktick_buf <= 1;
            ctr_tracktick_in <= 1;
            ctr_track_direction_in <=  '0';
            ctr_track_direction <= '0';
            ctr_track_enabled_in <= '0';
            ctr_track_enabled <= '0';
            ctr_cmdduration_in <= (others => '0');
        elsif (rising_edge(clk_50)) then
            ctr_cmd_direction_in  <= ctr_cmd_direction_in;
            ctr_cmd_in <=  ctr_cmd_in;
            ctr_goto_in  <=  ctr_goto_in;
            ctr_cmdtick_in  <= ctr_cmdtick_in  ;
            ctr_cmdtick_buf <= ctr_cmdtick_buf ;
            ctr_cmdcancel_in <= '0';
            ctr_park_in <= ctr_park_in;
            
            ctr_tracktick_in <= ctr_tracktick_in ;
            ctr_tracktick_buf<=ctr_tracktick_buf ;
            ctr_track_direction_in <= ctr_track_direction_in;
            ctr_track_enabled_in <= ctr_track_enabled_in;
            ctr_track_enabled <= ctr_track_enabled;
            ctr_track_direction <= ctr_track_direction;
            
            
            ctr_backlash_tick_in<= ctr_backlash_tick_in;
            ctr_backlash_duration_in <= ctr_backlash_duration_in;
            ctr_backlash_duration_buf <= ctr_backlash_duration_buf;
            ctr_backlash_tick_buf <= ctr_backlash_tick_buf;
            ctr_cmdduration_in <= ctr_cmdduration_in;
            current_mode_back <= current_mode_back;
            if (state_motor /= command) then
                ctr_cmdtick_in <= to_integer(unsigned(ctrl_cmdtick(30 downto 0)));
                ctr_cmdtick_buf <= ctr_cmdtick_in;
                ctr_cmd_direction_in  <= ctrl_cmdcontrol(2);
                ctr_cmd_in <= ctrl_cmdcontrol(0);
                ctr_goto_in  <=  ctrl_cmdcontrol(1);
                ctr_park_in <= ctrl_cmdcontrol(3);
                ctr_cmdmode_in <= ctrl_cmdcontrol(6 downto 4);
                ctr_cmdduration_in(30 downto 0) <= ctrl_cmdduration(30 downto 0);
                
                ctr_tracktick_in <= to_integer(unsigned(ctrl_trackctrl(31 downto 5)));
                ctr_tracktick_buf <= ctr_tracktick_in;
                ctr_track_enabled_in <= ctrl_trackctrl(0);
                ctr_track_direction_in <= ctrl_trackctrl(1);
                ctr_trackmode_in <= ctrl_trackctrl(4 downto 2);
                --ctr_track_enabled_buf <= ctr_track_enabled_in;
                --ctr_track_direction_buf <= ctr_track_direction_in;
                ctr_cmdcancel_in <= '0';
            elsif state_motor = command or state_motor = park then
                ctr_cmdcancel_in <= ctrl_cmdcontrol(31);
            end if;
            if (state_backlash /= processing) then
                ctr_backlash_tick_in <= to_integer(unsigned(ctrl_backlash_tick(31 downto 3)));
                ctr_backlash_tick_buf <= ctr_backlash_tick_in;
                ctr_backlash_duration_in <= to_integer(unsigned(ctrl_backlash_duration(30 downto 0)));
                ctr_backlash_duration_buf <= ctr_backlash_duration_in;
                current_mode_back <= ctrl_backlash_tick(2 downto 0);
            end if;
        end if;
    end process;

end block command_block;


--------------------------------------------------------------------------------------------
-- step counter
--------------------------------------------------------------------------------------------
   cnt_enable <= '1' when ((state_motor /= idle) and (state_backlash /= processing)) else '0';
   stepping_counter: COUNTER_LOAD_MACRO
   generic map (
      COUNT_BY => X"000000000001", -- Count by value
      DEVICE => "7SERIES",         -- Target Device: "VIRTEX5", "7SERIES", "SPARTAN6" 
      WIDTH_DATA => 31)            -- Counter output bus width, 1-48
   port map (
      Q => current_stepper_counter,                 -- Counter ouput, width determined by WIDTH_DATA generic 
      CLK => stepping_clk,             -- 1-bit clock input
      CE => cnt_enable,               -- 1-bit clock enable input
      DIRECTION => current_direction_buf(0), -- 1-bit up/down count direction input, high is count up
      LOAD => '0',           -- 1-bit active high load input
      LOAD_DATA => current_stepper_counter, -- Counter load data, width determined by WIDTH_DATA generic 
      RST => '0'              -- 1-bit active high synchronous reset
   );

end Behavioral;