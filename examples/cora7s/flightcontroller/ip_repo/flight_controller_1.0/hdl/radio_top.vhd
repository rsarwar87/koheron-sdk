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

entity radio_top is
  Port ( 
    clk_100, rstn_100 : in std_logic;
    enable            : in std_logic_vector(3 downto 0);
    
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
    
    radio_pwm_in   : in std_logic_vector(15 downto 0);
    radio_cppm_in   : in std_logic;
    radio_sbus_in   : in std_logic;
    radio_ibus_in   : in std_logic
  );
end radio_top;

architecture Behavioral of radio_top is
   

    type channel_array is array (0 to 15) of std_logic_vector(15 downto 0) ;
    signal channels : channel_array := (others => (others => '0'));
    signal channels_cppm : channel_array := (others => (others => '0'));
    signal channels_pwm  : channel_array := (others => (others => '0'));
    signal channels_sbus : channel_array := (others => (others => '0'));
    signal channels_ibus : channel_array := (others => (others => '0'));
    component radio_ibus is
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
        
        synce_locked  : out std_logic;
        radio_ibus_in   : in std_logic
    );
    end component;
    component radio_sbus is
      Port (
        clk_100, rstn_100 : in std_logic;
        enable, is_inverted : in std_logic;
        
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
        
        synce_locked  : out std_logic;
        radio_sbus_in   : in std_logic
    );
    end component;
    component radio_cppm is
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
    end component;
    component radio_pwm is
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
        
        radio_pwm_in   : in std_logic_vector(15 downto 0)
    );
    end component;
begin

    channel_out00 <= channels_pwm(0)  when enable = x"1" else channels_cppm(0)  when enable = x"2" 
                else channels_sbus(0)  when enable = x"4" else channels_ibus(0)  when enable = x"8" else (others => '0');
    channel_out01 <= channels_pwm(1)  when enable = x"1" else channels_cppm(1)  when enable = x"2" 
                else channels_sbus(1)  when enable = x"4" else channels_ibus(1)  when enable = x"8" else (others => '0');
    channel_out02 <= channels_pwm(2)  when enable = x"1" else channels_cppm(2)  when enable = x"2" 
                else channels_sbus(2)  when enable = x"4" else channels_ibus(2)  when enable = x"8" else (others => '0');
    channel_out03 <= channels_pwm(3)  when enable = x"1" else channels_cppm(3)  when enable = x"2" 
                else channels_sbus(3)  when enable = x"4" else channels_ibus(3)  when enable = x"8" else (others => '0');
    channel_out04 <= channels_pwm(4)  when enable = x"1" else channels_cppm(4)  when enable = x"2" 
                else channels_sbus(4)  when enable = x"4" else channels_ibus(4)  when enable = x"8" else (others => '0');
    channel_out05 <= channels_pwm(5)  when enable = x"1" else channels_cppm(5)  when enable = x"2" 
                else channels_sbus(5)  when enable = x"4" else channels_ibus(5)  when enable = x"8" else (others => '0');
    channel_out06 <= channels_pwm(6)  when enable = x"1" else channels_cppm(6)  when enable = x"2" 
                else channels_sbus(6)  when enable = x"4" else channels_ibus(6)  when enable = x"8" else (others => '0');
    channel_out07 <= channels_pwm(7)  when enable = x"1" else channels_cppm(7)  when enable = x"2" 
                else channels_sbus(7)  when enable = x"4" else channels_ibus(7)  when enable = x"8" else (others => '0');
    channel_out08 <= channels_pwm(8)  when enable = x"1" else channels_cppm(8)  when enable = x"2" 
                else channels_sbus(8)  when enable = x"4" else channels_ibus(8)  when enable = x"8" else (others => '0');
    channel_out09 <= channels_pwm(9)  when enable = x"1" else channels_cppm(9)  when enable = x"2" 
                else channels_sbus(9)  when enable = x"4" else channels_ibus(9)  when enable = x"8" else (others => '0');
    channel_out10 <= channels_pwm(10) when enable = x"1" else channels_cppm(10) when enable = x"2" 
                else channels_sbus(10) when enable = x"4" else channels_ibus(10) when enable = x"8" else (others => '0');
    channel_out11 <= channels_pwm(11) when enable = x"1" else channels_cppm(11) when enable = x"2" 
                else channels_sbus(11) when enable = x"4" else channels_ibus(11) when enable = x"8" else (others => '0');
    channel_out12 <= channels_pwm(12) when enable = x"1" else channels_cppm(12) when enable = x"2" 
                else channels_sbus(12) when enable = x"4" else channels_ibus(12) when enable = x"8" else (others => '0');
    channel_out13 <= channels_pwm(13) when enable = x"1" else channels_cppm(13) when enable = x"2" 
                else channels_sbus(13) when enable = x"4" else channels_ibus(13) when enable = x"8" else (others => '0');
    channel_out14 <= channels_pwm(14) when enable = x"1" else channels_cppm(14) when enable = x"2" 
                else channels_sbus(14) when enable = x"4" else channels_ibus(14) when enable = x"8" else (others => '0');
    channel_out15 <= channels_pwm (15) when enable = x"1" 
                else channels_cppm(15) when enable = x"2" 
                else channels_sbus(15) when enable = x"4" 
                else channels_ibus(15) when enable = x"8" 
                else (others => '0');

    U_PWM : radio_pwm
    port map (
        clk_100         => clk_100,
        rstn_100        => rstn_100,
        enable          => enable(0),
        
        channel_out00   => channels_pwm(0),
        channel_out01   => channels_pwm(1),
        channel_out02   => channels_pwm(2),
        channel_out03   => channels_pwm(3),
        channel_out04   => channels_pwm(4),
        channel_out05   => channels_pwm(5),
        channel_out06   => channels_pwm(6),
        channel_out07   => channels_pwm(7),
        channel_out08   => channels_pwm(8),
        channel_out09   => channels_pwm(9),
        channel_out10   => channels_pwm(10),
        channel_out11   => channels_pwm(11),
        channel_out12   => channels_pwm(12),
        channel_out13   => channels_pwm(13),
        channel_out14   => channels_pwm(14),
        channel_out15   => channels_pwm(15),
        
        radio_pwm_in    => radio_pwm_in
    );
    U_CPPM : radio_cppm
    port map (
        clk_100         => clk_100,
        rstn_100        => rstn_100,
        enable          => enable(1),
        
        channel_out00   => channels_cppm(0),
        channel_out01   => channels_cppm(1),
        channel_out02   => channels_cppm(2),
        channel_out03   => channels_cppm(3),
        channel_out04   => channels_cppm(4),
        channel_out05   => channels_cppm(5),
        channel_out06   => channels_cppm(6),
        channel_out07   => channels_cppm(7),
        channel_out08   => channels_cppm(8),
        channel_out09   => channels_cppm(9),
        channel_out10   => channels_cppm(10),
        channel_out11   => channels_cppm(11),
        channel_out12   => channels_cppm(12),
        channel_out13   => channels_cppm(13),
        channel_out14   => channels_cppm(14),
        channel_out15   => channels_cppm(15),
        
        radio_cppm_in    => radio_cppm_in
    );
    U_SBUS : radio_sbus
    port map (
        clk_100         => clk_100,
        rstn_100        => rstn_100,
        enable          => enable(2),
        is_inverted => '1',
        
        channel_out00   => channels_sbus(0),
        channel_out01   => channels_sbus(1),
        channel_out02   => channels_sbus(2),
        channel_out03   => channels_sbus(3),
        channel_out04   => channels_sbus(4),
        channel_out05   => channels_sbus(5),
        channel_out06   => channels_sbus(6),
        channel_out07   => channels_sbus(7),
        channel_out08   => channels_sbus(8),
        channel_out09   => channels_sbus(9),
        channel_out10   => channels_sbus(10),
        channel_out11   => channels_sbus(11),
        channel_out12   => channels_sbus(12),
        channel_out13   => channels_sbus(13),
        channel_out14   => channels_sbus(14),
        channel_out15   => channels_sbus(15),
        
        radio_sbus_in    => radio_sbus_in
    );
    U_IBUS : radio_ibus
    port map (
        clk_100         => clk_100,
        rstn_100        => rstn_100,
        enable          => enable(3),
        
        channel_out00   => channels_ibus(0),
        channel_out01   => channels_ibus(1),
        channel_out02   => channels_ibus(2),
        channel_out03   => channels_ibus(3),
        channel_out04   => channels_ibus(4),
        channel_out05   => channels_ibus(5),
        channel_out06   => channels_ibus(6),
        channel_out07   => channels_ibus(7),
        channel_out08   => channels_ibus(8),
        channel_out09   => channels_ibus(9),
        channel_out10   => channels_ibus(10),
        channel_out11   => channels_ibus(11),
        channel_out12   => channels_ibus(12),
        channel_out13   => channels_ibus(13),
        channel_out14   => channels_ibus(14),
        channel_out15   => channels_ibus(15),
        
        radio_ibus_in    => radio_ibus_in
    );
end Behavioral;
