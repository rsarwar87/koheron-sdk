----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/30/2020 10:25:56 PM
-- Design Name: 
-- Module Name: nrf24 - Behavioral
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
use work.NRF24_PACK.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity nrf24 is
    generic (
        CHANNEL  : std_logic_vector(7 downto 0) := x"05";
        RATE     : std_logic_vector(7 downto 0) := x"05";
        POWER     : std_logic_vector(7 downto 0) := x"05";
        PIPE     : std_logic_vector(39 downto 0) := x"7878787878";
        RETRT_COUNT     : std_logic_vector(7 downto 0) := x"0F";
        RETRT_DELAY     : std_logic_vector(7 downto 0) := x"0F";
        IS_READ     : boolean := true
    );
    Port ( 
        CLK, RSTn   : std_logic;
        
        readout     : std_logic_vector(32*8-1 downto 0);
        writein     : std_logic_vector(32*8-1 downto 0);
        
        init_done   : out std_logic;
        reinit      : in std_logic;
        nrf24_err   : out std_logic_vector(15 downto 0);
        
        nrf24_mosi  : out std_logic;
        nrf24_miso  : in  std_logic;
        nrf24_int_i : in  std_logic;
        nrf24_int_o : out  std_logic;
        nrf24_int_t : out  std_logic;
        nrf24_ce    : out  std_logic;
        nrf24_nsel  : out std_logic_vector(0 downto 0);
        nrf24_sclk  : out std_logic
  
    );
end nrf24;

architecture Behavioral of nrf24 is

begin
-- ---- begin
-- ce = 0
-- delay = 5ms
-- reset config NRF_CONFIG, 0x0C
-- set retries
        -- write_register(SETUP_RETR,(delay&0xf)<<ARD | (count&0xf)<<ARC);
-- read setup read_register(RF_SETUP);
-- setDataRate( RF24_1MBPS ) ; 
    --- set delay between tx (0 -> )
    --- read setup
    --- update
    --- write to RF_SETUP
-- toggle_features();
-- write_register(FEATURE,0 ); 
-- write_register(DYNPD,0); 
-- dynamic_payloads_enabled = false;
-- reset and flush - write_register(NRF_STATUS,_BV(RX_DR) | _BV(TX_DS) | _BV(MAX_RT) );
-- setChannel(76); 
        -----------write_register(RF_CH,rf24_min(channel,max_channel)); 
-- flush tx and tx
-- powerUp();
-- Enable PTX, write_register(NRF_CONFIG, ( read_register(NRF_CONFIG) ) & ~_BV(PRIM_RX) ); 
-- set write_register(NRF_CONFIG, ( read_register(NRF_CONFIG) ) & ~_BV(PRIM_RX) ); 

------- Set power
-- write_register( RF_SETUP, setup |= level ) level = (level << 1) + 1;
 
-- enabledynamic pauload
    ---write_register(FEATURE,read_register(FEATURE) | _BV(EN_ACK_PAY) | _BV(EN_DPL) );
    ---write_register(DYNPD,read_register(DYNPD) | _BV(DPL_P1) | _BV(DPL_P0));

-- setAutoAck
    --write_register(EN_AA, 0x3F); or 0 for disabled
    
-- openreadpipe
    --write_register(EN_RXADDR,read_register(EN_RXADDR) | _BV(pgm_read_byte(&child_pipe_en

end Behavioral;
