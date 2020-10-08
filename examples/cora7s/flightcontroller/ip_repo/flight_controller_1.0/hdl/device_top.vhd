----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/03/2020 09:55:09 PM
-- Design Name: 
-- Module Name: device_top - Behavioral
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

entity device_top is
generic (
    MAX_DATA_SIZE_BYTES  : natural := 33;
    slv_bits: natural := 3
);
 Port ( 
    clk100  : in  std_logic;
    clk_200          : in  std_logic;
    rstn  : in  std_logic;
    
    esp_status : out std_logic_vector(31 downto 0);
    esp_control : in std_logic_vector(127 downto 0);
    i2c_control : in std_logic_vector(31 downto 0);
    i2c_status : out std_logic_vector(31 downto 0);
    i2c_data_in : in std_logic_vector(8*MAX_DATA_SIZE_BYTES-1 downto 0);
    i2c_data_out : out std_logic_vector(8*MAX_DATA_SIZE_BYTES-1 downto 0);
    
    radio_pwm   : in std_logic_vector(15 downto 0);
    radio_cppm   : in std_logic;
    radio_sbus   : in std_logic;
    radio_ibus   : in std_logic;
    radio_select : in std_logic_vector(3 downto 0);
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
    
    spi_control : in std_logic_vector(31 downto 0);
    spi_status : out std_logic_vector(31 downto 0);
    spi_data_in : in std_logic_vector(8*MAX_DATA_SIZE_BYTES-1 downto 0);
    spi_data_out : out std_logic_vector(8*MAX_DATA_SIZE_BYTES-1 downto 0);
    
    spi_mosi  : out std_logic;
    spi_miso  : in  std_logic;
    spi_nsel  : out std_logic_vector(0 downto 0);
    spi_sclk  : out std_logic;
    
    esp_out   : out std_logic_vector(3 downto 0);
    
    sda       : INOUT  STD_LOGIC;                    --serial data output of i2c bus
    scl       : INOUT  STD_LOGIC
 );
end device_top;

architecture Behavioral of device_top is
component esp_top is
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
end component;
component ic_interface_top is
generic (
    MAX_DATA_SIZE_BYTES  : natural := 33;
    slv_bits: natural := 3
);
 Port ( 
    clk100  : in  std_logic;
    rstn  : in  std_logic;
    
    i2c_control : std_logic_vector(31 downto 0);
    i2c_status : out std_logic_vector(31 downto 0);
    i2c_data_in : in std_logic_vector(8*MAX_DATA_SIZE_BYTES-1 downto 0);
    i2c_data_out : out std_logic_vector(8*MAX_DATA_SIZE_BYTES-1 downto 0);
    
    spi_control : in std_logic_vector(31 downto 0);
    spi_status : out std_logic_vector(31 downto 0);
    spi_data_in : in std_logic_vector(8*MAX_DATA_SIZE_BYTES-1 downto 0);
    spi_data_out : out std_logic_vector(8*MAX_DATA_SIZE_BYTES-1 downto 0);
    
    spi_mosi  : out std_logic;
    spi_miso  : in  std_logic;
    spi_nsel  : out std_logic_vector(0 downto 0);
    spi_sclk  : out std_logic;
    
    sda       : INOUT  STD_LOGIC;                    --serial data output of i2c bus
    scl       : INOUT  STD_LOGIC
 );
end component;

component radio_top is
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
end component;

begin

G_ESC: for I in 0 to 3 generate
    U_ESC: esp_top 
    port map(
       clk_100  => clk100,
       clk_200  => clk_200,
       rstn_100  => rstn,
       
       protocal_grade   => esp_control((I*32) + 7 downto 32*I),
       protocal_type    => esp_control((I*32)+10 downto (I*32)+8),
       request_tele     => esp_control((I*32)+12),
       
       speed            => esp_control(((I+1)*32)-1 downto (I*32)+16),
       update           => esp_control((I*32)+11),
       ack              => esp_status(I*2 + 0),
       err              => esp_status(I*2 + 1),
       signal_out       => esp_out(I)
    );
end generate G_ESC;

ic_t : ic_interface_top 
generic map (
    MAX_DATA_SIZE_BYTES  => MAX_DATA_SIZE_BYTES,
    slv_bits => slv_bits
)
port map (
    clk100  => clk100,
    rstn    => rstn,
    
	i2c_control => i2c_control,             
	i2c_status  => i2c_status,
	i2c_data_in => i2c_data_in,
	i2c_data_out => i2c_data_out,
	spi_control => spi_control,             
	spi_status  => spi_status,
	spi_data_in => spi_data_in,
	spi_data_out =>spi_data_out,
    
    spi_mosi  => spi_mosi,
    spi_miso  => spi_miso,
    spi_nsel  => spi_nsel,
    spi_sclk  => spi_sclk,
    sda       => sda,                    --serial data output of i2c bus
    scl       => scl
);

U_RADIO: radio_top 
  Port map ( 
    clk_100         => clk100,
    rstn_100        => rstn,
    enable          => radio_select,
    
    channel_out00   => channel_out00 ,
    channel_out01   => channel_out01 ,
    channel_out02   => channel_out02 ,
    channel_out03   => channel_out03 ,
    channel_out04   => channel_out04 ,
    channel_out05   => channel_out05 ,
    channel_out06   => channel_out06 ,
    channel_out07   => channel_out07 ,
    channel_out08   => channel_out08 ,
    channel_out09   => channel_out09 ,
    channel_out10   => channel_out10 ,
    channel_out11   => channel_out11 ,
    channel_out12   => channel_out12 ,
    channel_out13   => channel_out13 ,
    channel_out14   => channel_out14 ,
    channel_out15   => channel_out15 ,
    
    radio_pwm_in    => radio_pwm  ,
    radio_cppm_in   => radio_cppm,
    radio_sbus_in   => radio_sbus,
    radio_ibus_in   => radio_ibus
  );
end Behavioral;
