----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/30/2020 09:00:25 PM
-- Design Name: 
-- Module Name: tb_spimaster - Behavioral
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

entity tb_spimaster is
--  Port ( );
end tb_spimaster;

architecture Behavioral of tb_spimaster is

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

constant CLK_PERIOD : time := 10 ns;
constant MAX_DATA_SIZE_BYTES : natural := 33;

signal nbytes_i   :   integer range 1 to MAX_DATA_SIZE_BYTES + 1;
signal data_in    :   std_logic_vector((8*MAX_DATA_SIZE_BYTES - 1) downto 0);
signal data_out   :   std_logic_vector((8*MAX_DATA_SIZE_BYTES - 1) downto 0);
signal x_valid    :   std_logic;
signal bus_ready  :   std_logic;
signal x_done     :   std_logic;

signal spi_mosi  :  std_logic;
signal spi_miso  :  std_logic;
signal spi_nsel  :  std_logic_vector(((1) - 1) downto 0);
signal spi_sclk  :  std_logic;

signal clk100                   : STD_LOGIC;
signal rstn_50                  : STD_LOGIC;
begin
      -- Clock process definitions( clock with 50% duty cycle is generated here.
       Clk_process :process
       begin
            rstn_50 <= '1';
            clk100  <= '0';
            --adcin <= std_logic_vector(unsigned(adcin) + 1);
            wait for CLK_PERIOD/2;  --for half of clock period clk stays at '0'.
            clk100  <= '1';
            wait for CLK_PERIOD/2;  --for next half of clock period clk stays at '1'.
       end process;
       
       
spi_t : spi_top 
generic map (
    MAX_DATA_SIZE_BYTES  => MAX_DATA_SIZE_BYTES,
    slv_bits => 1
)
port map (
    clk100  => clk100,
    rstn    => rstn_50,
    --
    -- Whishbone Interface
    --
    nbytes_i   => nbytes_i,
    data_in    => data_in,
    data_out   => data_out,
    x_valid    => x_valid,
    bus_ready  => bus_ready,
    x_done     => x_done,
    --
    -- SPI Master Signals
    --
    spi_mosi  => spi_mosi,
    spi_miso  => spi_mosi,
    spi_nsel  => spi_nsel,
    spi_sclk  => spi_sclk
);

stim_proc: process
     begin        
          data_in(31 downto 0) <= x"F012CD34"; 
          nbytes_i <= 4;
          x_valid <= '0';
          wait for 100 ns;
          x_valid <= '1';
          wait;
          
    end process;


end Behavioral;
