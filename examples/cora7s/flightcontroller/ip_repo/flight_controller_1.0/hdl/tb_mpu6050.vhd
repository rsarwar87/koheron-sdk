----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.10.2020 21:08:42
-- Design Name: 
-- Module Name: tb_mpu6050 - Behavioral
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

entity tb_mpu6050 is
--  Port ( );
end tb_mpu6050;

architecture Behavioral of tb_mpu6050 is

			
signal clk_100  :  std_logic;
signal rstn_100 :  std_logic;
signal restart  :  std_logic;
 
signal mpu6050_interrupt :  std_logic;
 
signal scl :  std_logic;
signal sda :  std_logic;
 
signal gyro_x_out :  std_logic_vector(15 downto 0);
signal gyro_y_out :  std_logic_vector(15 downto 0);
signal gyro_z_out :  std_logic_vector(15 downto 0);
signal acel_x_out :  std_logic_vector(15 downto 0);
signal acel_y_out :  std_logic_vector(15 downto 0);
signal acel_z_out :  std_logic_vector(15 downto 0);
 
signal gyro_vaid : std_logic;
signal acel_valid : std_logic;

constant CLK_PERIOD : time := 10 ns;
constant MAX_DATA_SIZE_BYTES : natural := 33;


component mpu6050_wrapper is
generic (
     boot_delay : integer := 100_000_000 ;
     mpu_address : std_logic_vector (6 downto 0) := "1101000"
);
port (
   clk_100 : in std_logic;
   rstn_100 : in std_logic;
   restart  : in std_logic;
   
   mpu6050_interrupt : in std_logic;
   
   scl : inout std_logic;
   sda : inout std_logic;
   
   gyro_x_out : out std_logic_vector(15 downto 0);
   gyro_y_out : out std_logic_vector(15 downto 0);
   gyro_z_out : out std_logic_vector(15 downto 0);
   acel_x_out : out std_logic_vector(15 downto 0);
   acel_y_out : out std_logic_vector(15 downto 0);
   acel_z_out : out std_logic_vector(15 downto 0);
   
   gyro_vaid : out std_logic;
   acel_valid : out std_logic
   
);
end component;

			
begin
	Clk_process :process
       begin
            rstn_100 <= '1';
            clk_100  <= '0';
            --adcin <= std_logic_vector(unsigned(adcin) + 1);
            wait for CLK_PERIOD/2;  --for half of clock period clk stays at '0'.
            clk_100  <= '1';
            wait for CLK_PERIOD/2;  --for next half of clock period clk stays at '1'.
       end process;	
DUT : mpu6050_wrapper 
generic map (
     boot_delay => 100,
     mpu_address => "1101000"
)
port map(
   clk_100  => clk_100,
   rstn_100 => rstn_100,
   restart  => restart,
   
   mpu6050_interrupt => mpu6050_interrupt,
   
   scl => scl,
   sda => sda,
   
   gyro_x_out => gyro_x_out ,
   gyro_y_out => gyro_y_out ,
   gyro_z_out => gyro_z_out ,
   acel_x_out => acel_x_out ,
   acel_y_out => acel_y_out ,
   acel_z_out => acel_z_out ,
              
   gyro_vaid  => gyro_vaid  ,
   acel_valid => acel_valid 
   
);

end Behavioral;
