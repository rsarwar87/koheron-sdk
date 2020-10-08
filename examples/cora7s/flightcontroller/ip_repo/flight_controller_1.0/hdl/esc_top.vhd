
library IEEE;               
use IEEE.STD_LOGIC_1164.ALL;


entity esp_top is
--generic (

--);
port (
   clk_100          : in  std_logic;
   clk_200          : in  std_logic;
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
end esp_top;
			
		
			

architecture rtl of esp_top is
   -- declarative_items (signal declarations, component declarations, etc.)
    component esp_dshot
    port (
       clk_100          : in  std_logic;
       rstn_100         : in  std_logic;
       grade            : in  std_logic_vector(7 downto 0);
       enabled          : in  std_logic;
       update           : in  std_logic;
       request_tele     : in  std_logic;
       speed            : in  std_logic_vector(11 downto 0);
       ack              : out  std_logic;
       pin_out          : out std_logic
    );
    end component;

    
    component esp_mshot
    port (
       clk_100, clk_200 : in  std_logic;
       rstn_100         : in  std_logic;
       grade            : in  std_logic_vector(7 downto 0);
       enabled          : in  std_logic;
       is_multi         : in  std_logic;
       update           : in  std_logic;
       speed            : in  std_logic_vector(11 downto 0);
       ack              : out std_logic;
       pin_out          : out std_logic
    );
    end component;
			
	signal ack_out, pin_out, enabled, is_multi    :  std_logic_vector(1 downto 0) := "00";
begin
   -- architecture body
p_type: process (clk_100) 
begin
    if rising_edge(clk_100) then
        err <= '1';
        ack <= '0';
        signal_out <= '0';
        enabled <= "00";
        is_multi <= "00";
        if (protocal_type = "001") then
            enabled(0) <= '1';
            ack <= ack_out(0);
            is_multi <= "11";
            signal_out <= pin_out(0);
            err <= '0';
        elsif (protocal_type = "010") then
            err <= '0';
            
            ack <= ack_out(0);
            enabled(0) <= '1';
            signal_out <= pin_out(0);
        elsif (protocal_type = "100") then
            err <= '0';
            ack <= ack_out(1);
            enabled(1) <= '1';
            signal_out <= pin_out(1);
            
        end if;
    end if;
end process p_type;



U_DSHOT : esp_dshot
port map (
   clk_100     => clk_100,
   rstn_100    => rstn_100,
   grade       => protocal_grade,
   enabled     => enabled(1),
   request_tele=> request_tele,
   update      => update,
   speed       => speed(11 downto 0),
   ack         => ack_out(1),
   pin_out     => pin_out(1)
);

U_MSHOT : esp_mshot
port map (
   clk_100     => clk_100,
   clk_200     => clk_200,
   rstn_100    => rstn_100,
   grade       => protocal_grade,
   enabled     => enabled(0),
   update      => update,
   is_multi    => is_multi(0),
   speed       => speed(11 downto 0),
   ack         => ack_out(0),
   pin_out     => pin_out(0)
);
						
end rtl;
			
			