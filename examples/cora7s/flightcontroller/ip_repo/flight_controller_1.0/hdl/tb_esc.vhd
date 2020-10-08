----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/05/2020 08:14:55 PM
-- Design Name: 
-- Module Name: tb_esc - Behavioral
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

entity tb_esc is
--  Port ( );
end tb_esc;

architecture Behavioral of tb_esc is
component esp_top is
--generic (

--);
port (
   clk_100          : in  std_logic;
   rstn_100         : in  std_logic;
   
   protocal_grade   : in  std_logic_vector(7 downto 0);
   protocal_type    : in  std_logic_vector(2 downto 0);
   request_tele     : in  std_logic;
   
   speed            : in  std_logic_vector(15 downto 0);
   update           : in  std_logic;
   ack              : out  std_logic;
   err              : out  std_logic;
   signal_out       : out std_logic
);
end component;
constant CLK_PERIOD : time := 5 ns;


signal clk_100          :  std_logic;
signal rstn_100         :  std_logic;

signal protocal_grade   :  std_logic_vector(7 downto 0);
signal protocal_type    :  std_logic_vector(2 downto 0);
signal request_tele     :  std_logic;

signal speed            :  std_logic_vector(15 downto 0);
signal update           :  std_logic;
signal ack              :   std_logic;
signal err              :   std_logic;
signal signal_out       :  std_logic;

 
begin
     -- Clock process definitions( clock with 50% duty cycle is generated here.
       Clk_process :process
       begin
            
            clk_100  <= '0';
            --adcin <= std_logic_vector(unsigned(adcin) + 1);
            wait for CLK_PERIOD/2;  --for half of clock period clk stays at '0'.
            clk_100  <= '1';
            wait for CLK_PERIOD/2;  --for next half of clock period clk stays at '1'.
       end process;
       
       stim :process 
       begin
            rstn_100 <= '1';
            protocal_grade <= x"00";
            protocal_type  <= "001";
            request_tele  <= '0';
            speed <= x"0000";
            update <= '0';
--            wait for 20 ms;
--            protocal_grade <= x"00";
--            protocal_type  <= "001";
--            request_tele  <= '0';
--            speed <= x"00FF";
--            update <= '1';
--            wait for 5 ms;
--            update <= '0';
--            wait for 20 ms;
--            protocal_grade <= x"03";
--            protocal_type  <= "001";
--            request_tele  <= '0';
--            speed <= x"00FF";
--            update <= '1';
--            wait for 5 ms;
--            update <= '0';
            
            
--            wait for 5 ms;
--            protocal_grade <= x"02";
--            protocal_type  <= "001";
--            request_tele  <= '0';
--            speed <= x"00FF";
--            update <= '1';
--            wait for 5 ms;
--            update <= '0';
--            wait for 10 ms;
            
--            protocal_grade <= x"01";
--            protocal_type  <= "001";
--            request_tele  <= '0';
--            speed <= x"00FF";
--            update <= '1';
--            wait for 5 ms;
--            update <= '0';
--            wait for 10 ms;
            
--            protocal_grade <= x"03";
--            protocal_type  <= "001";
--            request_tele  <= '0';
--            speed <= x"00FF";
--            update <= '1';
--            wait for 5 ms;
--            update <= '0';
--            wait for 10 ms;
            
            
--            protocal_type  <= "000";
--            wait for 5 ms;
            
            protocal_grade <= x"03";
            protocal_type  <= "100";
            request_tele  <= '0';
            speed <= x"0A27";
            update <= '0';
            wait for 5 ms;
            update <= '1';
            wait for 1 ms;
            
            wait;
       end process;
       
       
ESP :  esp_top 
port map (
   clk_100        => clk_100        , 
   rstn_100       => rstn_100       , 
             
   protocal_grade => protocal_grade , 
   protocal_type  => protocal_type  , 
   request_tele   => request_tele   , 
               
   speed          => speed          , 
   update         => update         , 
   ack            => ack            , 
   err            => err            , 
   signal_out     => signal_out       
);

end Behavioral;
