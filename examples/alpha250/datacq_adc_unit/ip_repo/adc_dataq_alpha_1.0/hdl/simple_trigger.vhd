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

library UNISIM;
use UNISIM.VComponents.all;
Library UNIMACRO;
use UNIMACRO.vcomponents.all;

entity trigger_module is
        generic (
            C_M00_AXIS_TDATA_WIDTH	: integer	:= 16
        );
    Port ( clk           : in STD_LOGIC;
           nrst           : in STD_LOGIC;
           data_in       : in STD_LOGIC_VECTOR (C_M00_AXIS_TDATA_WIDTH - 1 downto 0);
           sim_trigger_in    : in STD_LOGIC;
           ext_trigger_in    : in STD_LOGIC;
           
           delay_window  : in std_logic_vector(31 downto 0);
           acq_window    : in std_logic_vector(31 downto 0);
           
           is_simulation : in std_logic;
           do_prepare    : in std_logic;
           do_arm        : in std_logic;
           clk_err       : in std_logic;
           iprst         : in std_logic;
           
           state_out     : out std_logic_vector(3 downto 0);
           is_triggered     : out std_logic;
           is_active     : out std_logic;
           in_simulation : out std_logic;
           in_delay      : out std_logic;
           bus_active    : out std_logic;
           error         : out std_logic;
           
           tick_counter  : out std_logic_vector(31 downto 0);
           n_seq_error   : out std_logic_vector(31 downto 0);
           n_seq_lost    : out std_logic_vector(31 downto 0);
           tick_target    : out std_logic_vector(31 downto 0);
           
           
           
           m_axis_tready : in STD_LOGIC;
           m_axis_tvalid : out STD_LOGIC;
           m_axis_tdata  : out STD_LOGIC_VECTOR (C_M00_AXIS_TDATA_WIDTH - 1 downto 0)
           );
end trigger_module;

architecture Behavioral of trigger_module is

component sr_fifo is
        generic (
            C_M00_AXIS_TDATA_WIDTH	: integer	:= 16
        );
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC := '0';
           RE_INIT : in STD_LOGIC := '0';
           TREADY  : IN STD_LOGIC := '0';
           TVALID_IN   : IN STD_LOGIC := '0';
           TVALID_OUT  : OUT STD_LOGIC := '0';
           FULL_FIFO  : OUT std_LOGIC;
           DATA_IN : in STD_LOGIC_VECTOR (C_M00_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
           DATA_OUT : out STD_LOGIC_VECTOR (C_M00_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0')
           );
end component;
signal tdata_buf  :  STD_LOGIC_VECTOR (C_M00_AXIS_TDATA_WIDTH - 1 downto 0) := (others => '0');
signal ext_en_cntr, ext_trigger_buffer, ext_trigger_buffer_delay, do_prepare_delay, do_arm_delay, m_axis_tready_delayed : std_logic := '0';
signal tvalid, fifo_full, rst_cnter, simulation: std_logic := '1';
signal tdata  : STD_LOGIC_VECTOR (C_M00_AXIS_TDATA_WIDTH - 1 downto 0) := (others => '0');
signal count, trigger_duration, trigger_delay  : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal trigger_duration_latched, trigger_delay_latched  : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal lost_count, lost_duration: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

TYPE state_machine IS (s_idle, s_prepare, s_arm, s_seeking, s_delay, s_triggered, s_finished); -- the 4 different states
SIGNAL state : state_machine := s_idle;   -- Create a signal that uses 
	
begin
--    m_axis_tvalid <= tvalid;
--    m_axis_tdata <= tdata_buf;
    tick_target <= trigger_duration_latched;
    state_control : process (clk, nrst)
    begin
       if nrst = '0' then
           state  <= s_idle;
           rst_cnter <= '1';
           ext_en_cntr<= '0';
           is_active <= '0';
           tvalid <= '0';
           tdata_buf <= (others => '0');
           tdata <= (others => '0');
           ext_trigger_buffer <= '0';
           ext_trigger_buffer_delay <= '0';
           in_simulation <= '0';
           trigger_duration <= (others => '0');
           trigger_delay <= (others => '0');
           trigger_delay_latched <= (others => '0');
           trigger_duration_latched <= (others => '0');
           do_prepare_delay <= '0';
           is_triggered <= '0';
           in_delay     <= '0';
           state_out <= "0000";
           simulation <= '0';
           count <= (others => '0');
           tick_counter <= (others => '0');
       elsif rising_edge(clk) then
            tvalid <= '0';
            tdata_buf <= (others => '0');
            
            ext_trigger_buffer_delay <= ext_trigger_buffer;
       
            if (simulation = '0') then
                ext_trigger_buffer <= ext_trigger_in;
                --tdata <= data_in;
                in_simulation <= '0';
                tdata(15 downto 14) <= "00";
                tdata(13) <= data_in(15);
                tdata(12 downto 0) <= not data_in(14 downto 2);
            else
                ext_trigger_buffer <= sim_trigger_in;
                tdata <= count(15 downto 0);
                in_simulation <= '1';
            end if;
            
            simulation <= simulation;
            tick_counter <= count;
           rst_cnter <= rst_cnter;
           ext_en_cntr <= ext_en_cntr;
           is_active <= '0';
           is_triggered <= '0';
           in_delay     <= '0';
           
           trigger_duration <= std_logic_vector(unsigned(acq_window) + unsigned(delay_window));
           trigger_delay <= delay_window;
           trigger_duration_latched <= trigger_duration_latched;
           trigger_delay_latched <= trigger_delay_latched;
           tdata_buf <= x"F000";
           
           do_prepare_delay <= do_prepare;
           do_arm_delay     <= do_arm;
           case state is
              when s_idle =>
                  ext_en_cntr<= '0';
                  simulation <= '0';
                  if (do_prepare_delay = '0' and do_prepare = '1') then
                     state  <= s_prepare;
                  end if;
                  state_out <= "0001";
              when s_prepare => 
                  rst_cnter <= '1';
                  ext_en_cntr<= '0';
                  count <= (others => '0');
                  trigger_duration_latched <= (others => '0');
                  if (do_arm_delay = '0' and do_arm = '1') then
                     state  <= s_arm;
                  end if;
                  state_out <= "0010";
              when s_arm =>
                  rst_cnter <= '1';
                  trigger_duration_latched <=  trigger_duration;
                  trigger_delay_latched <=  trigger_delay;
                  simulation <= is_simulation;
                  state <= s_seeking;
                  state_out <= "0011";
              when s_seeking => 
                  tdata_buf <= x"FF00";
                  rst_cnter <= '0';
                  is_active <= '1';
                  if ext_trigger_buffer = '0' and ext_trigger_buffer_delay = '1' then
                     state  <= s_delay;
                     ext_en_cntr <= '1';
                     if count = trigger_delay_latched then
                        state <= s_triggered;
                     end if;
                  end if;
                  state_out <= "0100";
              when s_delay =>
                  is_active <= '1';
                  is_triggered <= '1';
                  in_delay     <= '1';
                  tdata_buf <= x"FFF0";
                  count <= std_logic_vector(unsigned(count)  + 1);
                  if count = trigger_delay_latched then
                     state <= s_triggered;
                     tvalid <= '1';
                  end if;
                  state_out <= "0101";
              when s_triggered =>
                  is_active <= '1';
                  is_triggered <= '1';
                  tdata_buf <= tdata;
                  tvalid <= '1';
                  count <= std_logic_vector(unsigned(count)  + 1); 
                  if count = trigger_duration_latched then
                     state <= s_finished;
                  end if;
                  state_out <= "0110";
              when others =>
                  is_active <= '0';
                  is_triggered <= '1';
                  ext_en_cntr <= '0';
                  tdata_buf <= x"FFFF";
                  tvalid <= m_axis_tready;
                  if iprst = '1' then
                     state <= s_idle;
                  end if;
                  state_out <= "0111";
           end case;
           if iprst = '1' then
              state <= s_idle;
           elsif (clk_err = '1') then
              state <= s_idle;
              state_out <= "1111";
           end if;
       end if;
    end process;
    
    check_bus_activity : process(clk, nrst)
    
    begin
        if (nrst = '0') then
            bus_active <= '0';
            error <= '0';
            n_seq_error <= (others => '0');
            n_seq_lost <= (others => '0');
            lost_count <= (others => '0');
            lost_duration <= (others => '0');
            m_axis_tready_delayed <= '0';
        elsif (rising_edge(clk)) then
            bus_active <= m_axis_tready;
            m_axis_tready_delayed <= m_axis_tready;
            n_seq_error <= lost_count;
            n_seq_lost <= lost_duration;
            --error <= error;
            case state is
                when s_triggered =>
                    if (m_axis_tready = '0') then
                        lost_duration <= std_logic_vector(unsigned(lost_duration) + 1);
                        --error <= '1';
                    end if;
                    if (m_axis_tready = '0' and m_axis_tready_delayed = '1') then
                        lost_count <= std_logic_vector(unsigned(lost_count) + 1);
                    end if;
                    if fifo_full = '1' then
                        error <= '1';
                    end if;
                when s_prepare =>
                    lost_count <= (others => '0');
                    lost_duration <= (others => '0');
                    error <= '0';
                when others =>
                    lost_duration <= lost_duration;
                    lost_count <= lost_count;
                             
            
            end case;
        end if;
    end process;
    
    U_FIFO : sr_fifo 
        generic map (
            C_M00_AXIS_TDATA_WIDTH	=> C_M00_AXIS_TDATA_WIDTH
        )
    Port map ( 
           CLK  => clk,
           RST => nrst,
           RE_INIT => rst_cnter,
           TREADY  => m_axis_tready,
           TVALID_IN  => tvalid,
           FULL_FIFO => fifo_full,
           TVALID_OUT  => m_axis_tvalid,
           DATA_IN => tdata_buf,
           DATA_OUT => m_axis_tdata
           );
--   COUNTER_TC_MACRO_inst : COUNTER_TC_MACRO
--   generic map (
--      COUNT_BY => X"000000000001",   -- Count by value
--      DEVICE => "7SERIES",           -- Target Device: "VIRTEX5", "7SERIES" 
--      DIRECTION => "UP",             -- Counter direction "UP" or "DOWN" 
--      RESET_UPON_TC => "FALSE",      -- Reset counter upon terminal count, TRUE or FALSE
--      TC_VALUE => X"000000000000",   -- Terminal count value
--      WIDTH_DATA => 32)              -- Counter output bus width, 1-48
--   port map (
--      Q   => count,          -- Counter ouput, width determined by WIDTH_DATA generic 
--      TC  => open,           -- 1-bit terminal count output, high = terminal count is reached
--      CLK => clk,         -- 1-bit clock input
--      CE  => ext_en_cntr,      -- 1-bit clock enable input
--      RST => rst_cnter       -- 1-bit active high synchronous reset
--   );

end Behavioral;
