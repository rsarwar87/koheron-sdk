
library IEEE;               
use IEEE.STD_LOGIC_1164.ALL;


entity esp_oshot is
--generic (

--);
port (
       clk_100          : in  std_logic;
       rstn_100         : in  std_logic;
       grade            : in  std_logic_vector(7 downto 0);
       enabled          : in  std_logic;
       update           : in  std_logic;
       speed            : in  std_logic_vector(20 downto 0);
       ack              : in  std_logic;
       pin_out          : out std_logic
);
end esp_oshot;
			
		
			

architecture rtl of esp_oshot is
   
			
begin
   -- architecture body
end rtl;
			
			