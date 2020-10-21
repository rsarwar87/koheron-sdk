----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.10.2020 12:26:19
-- Design Name: 
-- Module Name: clk_domain_crossover - Behavioral
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

entity unit_top is
	generic (
		C_M00_AXIS_TDATA_WIDTH	: integer	:= 16
	);
  Port ( 
    clk_adc                         : in std_logic;
    clk_adc_rst_n                   : in std_logic;
    clk_ip                          : in std_logic;
    clk_ip_rst_n                    : in std_logic;
    
    adc_ch0                         : in std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
    adc_ch1                         : in std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
    adc_ch2                         : in std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
    adc_ch3                         : in std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
    adc_freq                        : out std_logic_vector(31 downto 0);
    up_time                         : out std_logic_vector(31 downto 0);
  
    ext_trigger                     : in std_logic;
    
    unit_status_in                  : out  std_logic_vector(31 downto 0); 
    bus_error_count                 : out std_logic_vector(31 downto 0); 
    bus_error_integrator            : out std_logic_vector(31 downto 0); 
    tick_counter                    : out std_logic_vector(31 downto 0);
    datac_processed                 : out std_logic_vector(31 downto 0);
    unit_control                    : in  std_logic_vector(31 downto 0);
    datac_delay                     : in  std_logic_vector(31 downto 0);
    datac_window                    : in  std_logic_vector(31 downto 0);
    
    m00_axis_tvalid	                : out std_logic;
    m00_axis_tkeep	                : out std_logic_vector(1 downto 0);
	  m00_axis_tdata	                : out std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
    m00_axis_tready	                : in std_logic
    
    
  );
end unit_top;

architecture Behavioral of unit_top is

component trigger_module is
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
           bus_active    : out std_logic;
           
           state_out     : out std_logic_vector(3 downto 0);
           is_active     : out std_logic;
           in_simulation : out std_logic;
           error         : out std_logic;
           in_delay      : out std_logic;
           iprst         : in std_logic;
           is_triggered     : out std_logic;
           
           tick_counter  : out std_logic_vector(31 downto 0);
           n_seq_error   : out std_logic_vector(31 downto 0);
           n_seq_lost    : out std_logic_vector(31 downto 0);
           tick_target    : out std_logic_vector(31 downto 0);
           
           
           m_axis_tready : in STD_LOGIC;
           m_axis_tvalid : out STD_LOGIC;
           m_axis_tdata  : out STD_LOGIC_VECTOR (C_M00_AXIS_TDATA_WIDTH - 1 downto 0)
           );
end component;
           

           
component clk_domain_crossover is
  Port ( 
    clk_adc                         : in std_logic;
    clk_adc_rst_n                   : in std_logic;
    clk_ip                          : in std_logic;
    clk_ip_rst_n                    : in std_logic;
    
    unit_status_in_synced           : out std_logic_vector(31 downto 0); 
    bus_error_count_synced          : out std_logic_vector(31 downto 0); 
    bus_error_integrator_synced     : out std_logic_vector(31 downto 0); 
    unit_control_synced             : out std_logic_vector(31 downto 0);
    datac_delay_synced              : out std_logic_vector(31 downto 0);
    detac_window_synced             : out std_logic_vector(31 downto 0);
    detac_processed_synced          : out std_logic_vector(31 downto 0);
    tick_counter_synced             : out std_logic_vector(31 downto 0);
    ext_clkfreq_synced              : out std_logic_vector(31 downto 0);
    ext_clkfreq_synced2              : out std_logic_vector(31 downto 0);
    freq_synced              : out std_logic_vector(0 downto 0);
    
    
    unit_status_in                  : in  std_logic_vector(31 downto 0); 
    bus_error_count                 : in  std_logic_vector(31 downto 0); 
    bus_error_integrator            : in  std_logic_vector(31 downto 0); 
    unit_control                    : in  std_logic_vector(31 downto 0);
    datac_delay                     : in  std_logic_vector(31 downto 0);
    detac_window                    : in  std_logic_vector(31 downto 0);
    detac_processed                 : in  std_logic_vector(31 downto 0);
    tick_counter                    : in  std_logic_vector(31 downto 0);
    ext_clkfreq                     : in std_logic_vector(31 downto 0);
    ext_clkfreq2                     : in std_logic_vector(31 downto 0);
    freq                            : in std_logic_vector(0 downto 0)
    
  );
end component;


signal unit_status_in_buffer           : std_logic_vector(31 downto 0) := (others => '0'); 
signal bus_error_count_buffer          : std_logic_vector(31 downto 0) := (others => '0'); 
signal bus_error_integrator_buffer     : std_logic_vector(31 downto 0) := (others => '0'); 
signal tick_counter_buffer                 : std_logic_vector(31 downto 0) := (others => '0'); 
signal unit_control_buffer             : std_logic_vector(31 downto 0) := (others => '0');
signal datac_delay_buffer              : std_logic_vector(31 downto 0) := (others => '0');
signal datac_window_buffer             : std_logic_vector(31 downto 0) := (others => '0');
signal ext_clkfreq_buffer, ext_clkfreq_b             : std_logic_vector(31 downto 0) := (others => '0');
signal datac_processed_buffer          : std_logic_vector(31 downto 0) := (others => '0');
signal data_in       :  STD_LOGIC_VECTOR (C_M00_AXIS_TDATA_WIDTH - 1 downto 0) := (others => '0');
signal ext_clkfreq, ext_clkfreq_buffer_adc  : std_logic_vector(31 downto 0);

signal channel_select : std_logic_vector (1 downto 0) := (others => '0');
signal trigger_buf : std_logic := '0';
signal is_simulation :  std_logic := '0';
signal do_prepare    :  std_logic := '0';
signal do_arm        :  std_logic := '0';
signal toggle, toggle_synced : std_logic_vector (0 downto 0) := "0";
 
signal state_out     :  std_logic_vector(3 downto 0)  := "0000";
signal is_active, bus_active, in_delay     :  std_logic := '0';
signal in_simulation, trigger_sim_buf :  std_logic := '0';
signal error, clk_err, iprst, is_triggered          :  std_logic := '0';

begin

m00_axis_tkeep <= "11";
U_CLK_DOMAINS : clk_domain_crossover 
  Port map ( 
    clk_adc                         => clk_adc        ,
    clk_adc_rst_n                   => clk_adc_rst_n  ,
    clk_ip                          => clk_ip         ,
    clk_ip_rst_n                    => clk_ip_rst_n   ,
    
    unit_status_in_synced           => unit_status_in ,
    bus_error_count_synced          => bus_error_count, 
    bus_error_integrator_synced     => bus_error_integrator, 
    unit_control_synced             => unit_control_buffer,
    datac_delay_synced              => datac_delay_buffer,
    detac_window_synced             => datac_window_buffer,
    detac_processed_synced          => datac_processed,
    tick_counter_synced             => tick_counter,
    ext_clkfreq_synced              => ext_clkfreq_buffer,
    ext_clkfreq_synced2              => ext_clkfreq_buffer_adc,
    freq_synced                     => toggle_synced,
    
    
    unit_status_in                  =>  unit_status_in_buffer,
    bus_error_count                 => bus_error_count_buffer,
    bus_error_integrator            => bus_error_integrator_buffer,
    unit_control                    => unit_control,
    datac_delay                     => datac_delay,
    detac_window                    => datac_window,
    detac_processed                 => datac_processed_buffer,
    tick_counter                    => tick_counter_buffer,
    ext_clkfreq                     => ext_clkfreq_b,
    ext_clkfreq2                    => ext_clkfreq,
    freq                            => toggle
    
    
    
  );
  
      process (clk_adc, clk_adc_rst_n)
      
      begin
        if (clk_adc_rst_n = '0') then
            data_in <= (others => '0');
            channel_select <= "00";
            trigger_buf <= '0';
            clk_err <= '0';
            unit_status_in_buffer <= (others => '0');
        elsif (rising_edge(clk_adc)) then
        
            -- channel select
            channel_select <= unit_control_buffer(1 downto 0);
            trigger_buf <= ext_trigger;
            case channel_select is
                when "00" =>
                    data_in <= adc_ch0;
                when "01" =>
                    data_in <= adc_ch1;
                when "10" =>
                    data_in <= adc_ch2;
                when others =>
                    data_in <= adc_ch3;
            end case;
            
            -- status
            unit_status_in_buffer(3 downto 0) <= state_out;
            unit_status_in_buffer(4) <= is_active; 
            unit_status_in_buffer(5) <= in_simulation; 
            unit_status_in_buffer(6) <= error;
            unit_status_in_buffer(9) <= bus_active;
            unit_status_in_buffer(10) <= is_triggered;
            unit_status_in_buffer(11) <= in_delay;
            unit_status_in_buffer(12) <= m00_axis_tready;
            if (ext_clkfreq_buffer_adc < x"0003C090" or ext_clkfreq_buffer_adc > x"0003E090") then
                unit_status_in_buffer(7) <= '1';
                unit_status_in_buffer(8) <= '0' and unit_control_buffer(5); -- and (not is_simulation);  
                clk_err <= '1';
            else
                unit_status_in_buffer(7) <= '0';
                unit_status_in_buffer(8) <= '1' and unit_control_buffer(5); -- and (not is_simulation);
                clk_err <= '0';
            end if;  
            
            -- control
            trigger_sim_buf <= unit_control_buffer(6);
            is_simulation <= unit_control_buffer(2);
            do_prepare <= unit_control_buffer(3);
            do_arm <= unit_control_buffer(4);
            iprst <= unit_control_buffer(7);
            
        end if;
      end process;
  
 U_SIMPLE_TRIGGER: component trigger_module 
        generic map (
            C_M00_AXIS_TDATA_WIDTH	=> C_M00_AXIS_TDATA_WIDTH
        )
    Port map ( 
           clk           => clk_adc,
           nrst          => clk_adc_rst_n,
           data_in       => data_in,
           ext_trigger_in    => trigger_buf,
           sim_trigger_in    => trigger_sim_buf,
           
           delay_window  => datac_delay_buffer,
           acq_window    => datac_window_buffer,
           
           is_simulation => is_simulation ,
           do_prepare    => do_prepare    ,
           do_arm        => do_arm        ,
           clk_err       => clk_err       ,
           iprst         => iprst,
           is_triggered  => is_triggered,
           
           state_out     => state_out,
           is_active     => is_active    ,
           in_simulation => in_simulation,
           error         => error        ,
           bus_active    => bus_active,
           in_delay => in_delay,
           
           tick_counter  => tick_counter_buffer,
           n_seq_error   => bus_error_count_buffer,
           n_seq_lost    => bus_error_integrator_buffer,
           tick_target   => datac_processed_buffer,
           
           
           m_axis_tready => m00_axis_tready,
           m_axis_tvalid => m00_axis_tvalid,
           m_axis_tdata  => m00_axis_tdata
           );
           
   FREQ_COUNTER: block
    signal runtime, refcnt, count : std_logic_vector (31 downto 0) := (others => '0');
    signal toggle_delay, tc, enable_freqc, enable_freqc_synced, ext_en_cntr, rst_cnter : std_logic_vector(0 downto 0) := "0";
   begin        
   adc_freq <= ext_clkfreq_buffer_adc ; --;
   enable_freqc <= not toggle;
   up_time <= runtime;
   process(clk_adc, clk_adc_rst_n)
   begin
       if (clk_adc_rst_n = '0') then
            runtime <= (others => '0');
            toggle_delay <= "0";
       elsif (rising_edge(clk_adc)) then
            toggle_delay <= toggle_synced;
            if (iprst = '1') then
                runtime <= (others => '0');
            elsif (toggle_synced(0) = '1' and toggle_delay(0) = '0') then
                runtime   <= std_logic_vector( unsigned(runtime) + 1 );
            end if;
       end if;
   end process;
   
   process(clk_ip, clk_ip_rst_n)
   begin
       if (clk_ip_rst_n = '0') then
            ext_clkfreq <= (others => '0');
            toggle <= "0";
       elsif (rising_edge(clk_ip)) then
        if (tc(0) = '1') then
                toggle <= not toggle;
                if (enable_freqc(0)='1') then
                    ext_clkfreq <= ext_clkfreq_buffer;
                end if;
           end if;
       end if;
   end process;
   
   enable_freqc_synced <= not toggle_synced;
   
   COUNTER_EXT_inst: COUNTER_TC_MACRO
   generic map (
      COUNT_BY => X"000000000001", -- Count by value
      DEVICE => "7SERIES",         -- Target Device: "VIRTEX5", "7SERIES" 
      DIRECTION => "UP",           -- Counter direction "UP" or "DOWN" 
      RESET_UPON_TC => "FALSE",    -- Reset counter upon terminal count, TRUE or FALSE
      TC_VALUE => X"000000000000", -- Terminal count value
      WIDTH_DATA => 32)            -- Counter output bus width, 1-48
   port map (
      Q     => ext_clkfreq_b,              -- Counter ouput, width determined by WIDTH_DATA generic 
      TC    => open,            --TC,      -- 1-bit terminal count output, high = terminal count is reached
      CLK   => clk_adc,          --CLK,    -- 1-bit clock input
      CE    => enable_freqc_synced(0),    --CE,      -- 1-bit clock enable input
      RST   => toggle_synced(0)      --RST        -- 1-bit active high synchronous reset
   );
   
   COUNTER_REFCLK_inst: COUNTER_TC_MACRO
   generic map (
      COUNT_BY => X"000000000001",  -- Count by value
      DEVICE => "7SERIES",          -- Target Device: "VIRTEX5", "7SERIES" 
      DIRECTION => "UP",            -- Counter direction "UP" or "DOWN" 
      RESET_UPON_TC => "TRUE",      -- Reset counter upon terminal count, TRUE or FALSE
      TC_VALUE   => X"00000001E847",-- Terminal count value 125MHz
      WIDTH_DATA => 32)             -- Counter output bus width, 1-48
   port map (
      Q     => refcnt,          -- Counter ouput, width determined by WIDTH_DATA generic 
      TC    => tc(0),              --TC,      -- 1-bit terminal count output, high = terminal count is reached
      CLK   => clk_ip,          --CLK,    -- 1-bit clock input
      CE    => '1',             --CE,      -- 1-bit clock enable input
      RST   => '0' --RST        -- 1-bit active high synchronous reset
   );
   end block ;
end Behavioral;
