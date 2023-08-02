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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_domain_crossover is
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
    freq_synced                     : out std_logic_vector(0 downto 0);
    
    
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
end clk_domain_crossover;

architecture Behavioral of clk_domain_crossover is
    subtype T_MISC_SYNC_DEPTH    is integer range 2 to 16;
    component sync_Vector is
	generic (
		MASTER_BITS   : positive            := 8;                       -- number of bit to be synchronized
		SLAVE_BITS    : natural             := 0;
		INIT          : std_logic_vector    := x"00000000";             --
		SYNC_DEPTH    : T_MISC_SYNC_DEPTH   := 2    -- generate SYNC_DEPTH many stages, at least 2
	);
	port (
		Clock1        : in  std_logic;                                                  -- <Clock>  input clock
		Clock2        : in  std_logic;                                                  -- <Clock>  output clock
		Input         : in  std_logic_vector((MASTER_BITS + SLAVE_BITS) - 1 downto 0);  -- @Clock1:  input vector
		Output        : out std_logic_vector((MASTER_BITS + SLAVE_BITS) - 1 downto 0);  -- @Clock2:  output vector
		Busy          : out  std_logic;                                                 -- @Clock1:  busy bit
		Changed       : out  std_logic                                                  -- @Clock2:  changed bit
	);
    end component;
begin
    SyncBusToClock_freqs : sync_Vector 
      generic map (
        MASTER_BITS => 1, SYNC_DEPTH => 3
      )
      port map(
        Clock1        => clk_ip ,                                                  -- <Clock>  input clock
		Clock2        => clk_adc,                                                 -- <Clock>  output clock
		Input         => freq,   -- @Clock1:  input vector
		Output        => freq_synced ,  -- @Clock2:  output vector
		Busy          => open,                                                -- @Clock1:  busy bit
		Changed       => open                                                -- @Clock2:  changed bit
      );

        
--        unit_status_in_synced          <=  unit_status_in                 ;
--        bus_error_count_synced         <=  bus_error_count                ;
--        bus_error_integrator_synced    <=  bus_error_integrator           ;
--        unit_control_synced            <=  unit_control                   ;
--        datac_delay_synced             <=  datac_delay                    ;
--        detac_window_synced            <=  detac_window                   ;
--        detac_processed_synced         <=  detac_processed                ;
--        tick_counter_synced            <=  tick_counter                   ;
--        ext_clkfreq_synced             <=  ext_clkfreq                    ;
        
        
        
    SyncBusToClock_freq2 : sync_Vector 
      generic map (
        MASTER_BITS => 32, SYNC_DEPTH => 3
      )
      port map(
        Clock1        => clk_ip,                                                  -- <Clock>  input clock
		Clock2        => clk_adc,                                                 -- <Clock>  output clock
		Input         => ext_clkfreq2,   -- @Clock1:  input vector
		Output        => ext_clkfreq_synced2 ,  -- @Clock2:  output vector
		Busy          => open,                                                -- @Clock1:  busy bit
		Changed       => open                                                -- @Clock2:  changed bit
      );
    SyncBusToClock_ticks : sync_Vector 
      generic map (
        MASTER_BITS => 32, SYNC_DEPTH => 3
      )
      port map(
        Clock1        => clk_adc,                                                  -- <Clock>  input clock
		Clock2        => clk_ip,                                                 -- <Clock>  output clock
		Input         => tick_counter,   -- @Clock1:  input vector
		Output        => tick_counter_synced ,  -- @Clock2:  output vector
		Busy          => open,                                                -- @Clock1:  busy bit
		Changed       => open                                                -- @Clock2:  changed bit
      );

    SyncBusToClock_freq : sync_Vector 
      generic map (
        MASTER_BITS => 32, SYNC_DEPTH => 3
      )
      port map(
        Clock1        => clk_adc ,                                                  -- <Clock>  input clock
		Clock2        => clk_ip,                                                 -- <Clock>  output clock
		Input         => ext_clkfreq,   -- @Clock1:  input vector
		Output        => ext_clkfreq_synced ,  -- @Clock2:  output vector
		Busy          => open,                                                -- @Clock1:  busy bit
		Changed       => open                                                -- @Clock2:  changed bit
      );
    SyncBusToClock_window : sync_Vector 
      generic map (
        MASTER_BITS => 32, SYNC_DEPTH => 3
      )
      port map(
        Clock1        => clk_ip,                                                  -- <Clock>  input clock
		Clock2        => clk_adc,                                                 -- <Clock>  output clock
		Input         => detac_window,   -- @Clock1:  input vector
		Output        => detac_window_synced ,  -- @Clock2:  output vector
		Busy          => open,                                                -- @Clock1:  busy bit
		Changed       => open                                                -- @Clock2:  changed bit
      );
    SyncBusToClock_delay : sync_Vector 
      generic map (
        MASTER_BITS => 32, SYNC_DEPTH => 3
      )
      port map(
        Clock1        => clk_ip,                                                  -- <Clock>  input clock
		Clock2        => clk_adc,                                                 -- <Clock>  output clock
		Input         => datac_delay,   -- @Clock1:  input vector
		Output        => datac_delay_synced ,  -- @Clock2:  output vector
		Busy          => open,                                                -- @Clock1:  busy bit
		Changed       => open                                                -- @Clock2:  changed bit
      );
    SyncBusToClock_ctrl : sync_Vector 
      generic map (
        MASTER_BITS => 32, SYNC_DEPTH => 3
      )
      port map(
        Clock1        => clk_ip,                                                  -- <Clock>  input clock
		Clock2        => clk_adc,                                                 -- <Clock>  output clock
		Input         => unit_control,   -- @Clock1:  input vector
		Output        => unit_control_synced ,  -- @Clock2:  output vector
		Busy          => open,                                                -- @Clock1:  busy bit
		Changed       => open                                                -- @Clock2:  changed bit
      );

    SyncBusToClock_data_p : sync_Vector 
      generic map (
        MASTER_BITS => 32, SYNC_DEPTH => 3
      )
      port map(
        Clock1        => clk_adc,                                                  -- <Clock>  input clock
		Clock2        => clk_ip,                                                 -- <Clock>  output clock
		Input         => detac_processed,   -- @Clock1:  input vector
		Output        => detac_processed_synced ,  -- @Clock2:  output vector
		Busy          => open,                                                -- @Clock1:  busy bit
		Changed       => open                                                -- @Clock2:  changed bit
      );
    SyncBusToClock_error_ic : sync_Vector 
      generic map (
        MASTER_BITS => 32, SYNC_DEPTH => 3
      )
      port map(
        Clock1        => clk_adc,                                                  -- <Clock>  input clock
		Clock2        => clk_ip,                                                 -- <Clock>  output clock
		Input         => bus_error_integrator,   -- @Clock1:  input vector
		Output        => bus_error_integrator_synced ,  -- @Clock2:  output vector
		Busy          => open,                                                -- @Clock1:  busy bit
		Changed       => open                                                -- @Clock2:  changed bit
      );
    SyncBusToClock_error_c : sync_Vector 
      generic map (
        MASTER_BITS => 32, SYNC_DEPTH => 3
      )
      port map(
        Clock1        => clk_adc,                                                  -- <Clock>  input clock
		Clock2        => clk_ip,                                                 -- <Clock>  output clock
		Input         => bus_error_count,   -- @Clock1:  input vector
		Output        => bus_error_count_synced ,  -- @Clock2:  output vector
		Busy          => open,                                                -- @Clock1:  busy bit
		Changed       => open                                                -- @Clock2:  changed bit
      );
    SyncBusToClock_status : sync_Vector 
      generic map (
        MASTER_BITS => 32, SYNC_DEPTH => 3
      )
      port map(
        Clock1        => clk_adc,                                                  -- <Clock>  input clock
		Clock2        => clk_ip,                                                 -- <Clock>  output clock
		Input         => unit_status_in,   -- @Clock1:  input vector
		Output        => unit_status_in_synced ,  -- @Clock2:  output vector
		Busy          => open,                                                -- @Clock1:  busy bit
		Changed       => open                                                -- @Clock2:  changed bit
      );
end Behavioral;
