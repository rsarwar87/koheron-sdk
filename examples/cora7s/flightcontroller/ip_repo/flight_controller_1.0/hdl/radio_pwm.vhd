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

entity radio_pwm is
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
end radio_pwm;

architecture Behavioral of radio_pwm is
    component radio_pwm_channel is
      Port (
        clk_100, rstn_100 : in std_logic;
        enable            : in std_logic;
        
        channel_out : out std_logic_vector(15 downto 0);
        
        radio_pwm_in   : in std_logic
    );
    end component;
    type channel_array is array (0 to 15) of std_logic_vector(15 downto 0) ;
    signal channels : channel_array := (others => (others => '0'));
    
begin
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

    pwm_channel : for I in 0 to 15 generate
        U_CHANNEL : radio_pwm_channel
        port map (
            clk_100   => clk_100,
            rstn_100  => rstn_100,
            enable    => enable,
            radio_pwm_in => radio_pwm_in(I),
            channel_out => channels(I)
        );
    
    end generate pwm_channel;
    
    
end Behavioral;
