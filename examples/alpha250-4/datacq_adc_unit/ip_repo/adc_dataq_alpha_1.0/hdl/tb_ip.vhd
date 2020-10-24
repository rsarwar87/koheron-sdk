----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.10.2020 16:45:22
-- Design Name: 
-- Module Name: tb_ip - Behavioral
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

entity tb_ip is
--  Port ( );
end tb_ip;

architecture Behavioral of tb_ip is
    constant C_M00_AXIS_TDATA_WIDTH	: integer	:= 16;
    component unit_top is
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
        up_time                         : out std_logic_vector(31 downto 0);
      
        ext_trigger                     : in std_logic;
        
        unit_status_in                  : out  std_logic_vector(31 downto 0); 
        bus_error_count                 : out std_logic_vector(31 downto 0); 
        bus_error_integrator            : out std_logic_vector(31 downto 0); 
        unit_control                    : in  std_logic_vector(31 downto 0);
        datac_delay                     : in  std_logic_vector(31 downto 0);
        datac_window                    : in  std_logic_vector(31 downto 0);
        datac_processed                 : out std_logic_vector(31 downto 0);
        
        tick_counter                    : out std_logic_vector(31 downto 0);
        adc_freq                        : out std_logic_vector(31 downto 0);
        
        m00_axis_tvalid	                : out std_logic;
        m00_axis_tdata	                : out std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
        m00_axis_tready	                : in std_logic
        
        
      );
    end component;
    
    
    signal  unit_status_in          : std_logic_vector(31 downto 0) := (others => '0');
    signal  bus_error_count         : std_logic_vector(31 downto 0) := (others => '0');
    signal  bus_error_integrator    : std_logic_vector(31 downto 0) := (others => '0');
    signal  unit_control            : std_logic_vector(31 downto 0) := (others => '0');
    signal  datac_delay             : std_logic_vector(31 downto 0) := (others => '0');
    signal  datac_window            : std_logic_vector(31 downto 0) := (others => '0');
    signal  datac_processed         : std_logic_vector(31 downto 0) := (others => '0');
    signal  tick_counter            : std_logic_vector(31 downto 0) := (others => '0');
    signal  adc_freq, up_time       : std_logic_vector(31 downto 0) := (others => '0');
    signal m00_axis_tvalid	                : std_logic := '0';
    signal m00_axis_tdata	                : std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
    signal m00_axis_tready	                :  std_logic := '0';
    
    signal clk_adc                         :  std_logic := '0';
    signal clk_adc_rst_n                   :  std_logic := '0';
    signal clk_ip, ext_trigger                          :  std_logic := '0';
    signal clk_ip_rst_n                    :  std_logic := '0';
       
    signal adc_ch0                         :  std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
    signal adc_ch1                         :  std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
    signal adc_ch2                         :  std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
    signal adc_ch3                         :  std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0) := (others => '0');
    
    signal CLK_PERIOD1 : time := 8 ns;
    signal CLK_PERIOD2 : time := 4 ns;
    
begin

    

DUT : unit_top 
        generic map(
            C_M00_AXIS_TDATA_WIDTH	=> C_M00_AXIS_TDATA_WIDTH 
        )
      Port map ( 
        clk_adc                      => clk_adc                    ,
        clk_adc_rst_n                => clk_adc_rst_n              ,
        clk_ip                       => clk_ip                     ,
        clk_ip_rst_n                 => clk_ip_rst_n               ,
                            
        adc_ch0                      => adc_ch0                    ,
        adc_ch1                      => adc_ch1                    ,
        adc_ch2                      => adc_ch2                    ,
        adc_ch3                      => adc_ch3                    ,
        up_time                      => up_time                    ,
                                     
        ext_trigger                  => ext_trigger                ,
                    
        unit_status_in               => unit_status_in             ,
        bus_error_count              => bus_error_count            ,
        bus_error_integrator         => bus_error_integrator       ,
        unit_control                 => unit_control               ,
        datac_delay                  => datac_delay                ,
        datac_window                 => datac_window               ,
        datac_processed              => datac_processed            ,
                                    
        tick_counter                 => tick_counter               ,
        adc_freq                     => adc_freq                   ,
       
        m00_axis_tvalid	             => m00_axis_tvalid	           ,
        m00_axis_tdata	             => m00_axis_tdata	           , 
        m00_axis_tready	             => m00_axis_tready	           
        
        
      );    

    Clk_soc_process :process
    begin
         clk_ip <= '0';
         --adcin <= std_logic_vector(unsigned(adcin) + 1);
         wait for CLK_PERIOD1/2;  --for half of clock period clk stays at '0'.
         clk_ip <= '1';
         wait for CLK_PERIOD1/2;  --for next half of clock period clk stays at '1'.
    end process;
    Clk_ext_process :process
    begin
         clk_adc <= '1';
         --adcin <= std_logic_vector(unsigned(adcin) + 1);
         wait for CLK_PERIOD2/2;  --for half of clock period clk stays at '0'.
         clk_adc <= '0';
         wait for CLK_PERIOD2/2;  --for next half of clock period clk stays at '1'.
    end process;
    
    S_process :process
    begin
         clk_adc_rst_n <= '1';
         clk_ip_rst_n <= '1';
         
         m00_axis_tready <= '1';
         wait for 1.1 ms;   --for next half of clock period clk stays at '1'.
         
         
         datac_window <= x"0000d090";
         datac_delay <= x"00000090";
         unit_control(7) <= '0'; --ip_rest
         unit_control(6) <= '0'; --trigger_sim_buf
         unit_control(5) <= '0'; --ignore clock error
         unit_control(4) <= '0'; --do_arm
         unit_control(3) <= '0'; --do_prepare
         unit_control(2) <= '0'; --is_simulation
         unit_control(1 downto 0) <= "00"; --channel_select
         
         wait for 10 us;
            unit_control(2) <= '1'; --is_simulation
            
         wait for 10 us;
            unit_control(3) <= '1'; --do_prepare
            
         wait for 10 us;
            unit_control(4) <= '1'; --do_arm
            unit_control(3) <= '0'; --do_prepare
         
         wait for 10 us;
            unit_control(6) <= '1'; --trigger_sim_buf
            unit_control(4) <= '0'; --do_arm
            
            
            
         wait for 10 us;
            unit_control(6) <= '0'; --trigger_sim_buf
            
            
         wait for 10 us;
            m00_axis_tready <= '0'; --trigger_sim_buf
            
            
         wait for 10 us;
            m00_axis_tready <= '1'; --trigger_sim_buf
            
            
         wait for 10 us;
            m00_axis_tready <= '0'; --trigger_sim_buf
            
            
         wait for 10 us;
            m00_axis_tready <= '1'; --trigger_sim_buf
         wait;   --for next half of clock period clk stays at '1'.
    end process;
end Behavioral;
