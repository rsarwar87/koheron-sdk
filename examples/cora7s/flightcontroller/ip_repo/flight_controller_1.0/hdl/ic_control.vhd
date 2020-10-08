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

entity ic_interface_top is
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
end ic_interface_top;

architecture Behavioral of ic_interface_top is
signal i2c_nbytes_i   :   integer range 1 to MAX_DATA_SIZE_BYTES + 1;
signal i2c_valid, i2c_err    :   std_logic;
signal i2c_bus_ready  :   std_logic;
signal i2c_done, i2c_error, i2c_rw     :   std_logic;
signal i2c_addr      :  STD_LOGIC_VECTOR(6 DOWNTO 0);
signal reg_addr   : std_logic_vector(7 downto 0); 


signal nbytes_i   :   integer range 1 to MAX_DATA_SIZE_BYTES + 1;
signal x_valid    :   std_logic;
signal bus_ready  :   std_logic;
signal x_done, has_reg  :   std_logic;

component i2c_top is
 generic (
    MAX_DATA_SIZE_BYTES  : natural := 33
 );
 Port (
    clk100, rstn_100 : std_logic;
    
    
    nbytes_i   : in  integer range 1 to MAX_DATA_SIZE_BYTES + 1;
    addr      : IN     STD_LOGIC_VECTOR(6 DOWNTO 0);
    data_in    : in  std_logic_vector((8*MAX_DATA_SIZE_BYTES - 1) downto 0);
    data_out   : out std_logic_vector((8*MAX_DATA_SIZE_BYTES - 1) downto 0);
    x_valid    : in   std_logic;
    bus_ready  : out  std_logic;
    x_done     : out  std_logic;
    x_err      : out  std_logic;
    read_write : in   std_logic;
    has_reg    : in   std_logic;
    reg_addr   : in   std_logic_vector(7 downto 0);
    
    sda       : INOUT  STD_LOGIC;                    --serial data output of i2c bus
    scl       : INOUT  STD_LOGIC
 );
end component;

component spi_top is
generic (
    MAX_DATA_SIZE_BYTES  : natural := 33;
    slv_bits: natural := 3
);
port (
    clk100  : in  std_logic;
    rstn  : in  std_logic;
    --
    -- Whishbone Interface
    --
    nbytes_i   : in  integer range 1 to MAX_DATA_SIZE_BYTES + 1;
    data_in    : in  std_logic_vector((8*MAX_DATA_SIZE_BYTES - 1) downto 0);
    data_out   : out std_logic_vector((8*MAX_DATA_SIZE_BYTES - 1) downto 0);
    x_valid    : in   std_logic;
    bus_ready  : out  std_logic;
    x_done     : out  std_logic;
    --
    -- SPI Master Signals
    --
    spi_mosi  : out std_logic;
    spi_miso  : in  std_logic;
    spi_nsel  : out std_logic_vector(((slv_bits) - 1) downto 0);
    spi_sclk  : out std_logic
);
end component;
begin

spi_status(0) <= bus_ready;
spi_status(1) <= x_done;
i2c_status(0) <= i2c_bus_ready;
i2c_status(1) <= i2c_done;
i2c_status(2) <= i2c_err;

process (clk100)
begin
    if rising_edge(clk100) then
        if (bus_ready = '1') then
            x_valid <= spi_control(31);
            nbytes_i <= to_integer(unsigned(spi_control(7 downto 0)));
        end if;
        if (i2c_bus_ready = '1') then
            i2c_valid <= i2c_control(31);
            i2c_nbytes_i <= to_integer(unsigned(i2c_control(7 downto 0)));
            i2c_addr <= i2c_control(14 downto 8);
            i2c_rw   <= i2c_control(15);
            has_reg  <= i2c_control(30);
            reg_addr <= i2c_control(23 downto 16);
        end if;
    end if;
end process;

i2c_t : i2c_top 
generic map (
    MAX_DATA_SIZE_BYTES  => MAX_DATA_SIZE_BYTES
)
port map (
    clk100  => clk100,
    rstn_100    => rstn,
    
    nbytes_i   => i2c_nbytes_i,
    addr       => i2c_addr,
    data_in    => i2c_data_in,
    data_out   => i2c_data_out,
    x_valid    => i2c_valid,
    bus_ready  => i2c_bus_ready,
    x_done     => i2c_done,
    x_err      => i2c_err,
    read_write => i2c_rw,
    has_reg    => has_reg,
    reg_addr   => reg_addr,
    
    sda  => sda,
    scl  => scl
);

spi_t : spi_top 
generic map (
    MAX_DATA_SIZE_BYTES  => MAX_DATA_SIZE_BYTES,
    slv_bits => 1
)
port map (
    clk100  => clk100,
    rstn    => rstn,
    --
    -- Whishbone Interface
    --
    nbytes_i   => nbytes_i,
    data_in    => spi_data_in,
    data_out   => spi_data_out,
    x_valid    => x_valid,
    bus_ready  => bus_ready,
    x_done     => x_done,
    --
    -- SPI Master Signals
    --
    spi_mosi  => spi_mosi,
    spi_miso  => spi_miso,
    spi_nsel  => spi_nsel,
    spi_sclk  => spi_sclk
);
end Behavioral;
