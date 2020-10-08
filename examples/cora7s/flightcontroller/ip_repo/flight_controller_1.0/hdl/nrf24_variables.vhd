----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/30/2020 10:39:26 PM
-- Design Name: 
-- Module Name: nrf24_variables - Behavioral
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

package NRF24_PACK is
type t_addr is record
   NRF_CONFIG  : std_logic_vector(7 downto 0) ;
   EN_AA       : std_logic_vector(7 downto 0) ;
   EN_RXADDR   : std_logic_vector(7 downto 0) ;
   SETUP_AW    : std_logic_vector(7 downto 0) ;
   SETUP_RETR  : std_logic_vector(7 downto 0) ;
   RF_CH       : std_logic_vector(7 downto 0) ;
   RF_SETUP    : std_logic_vector(7 downto 0) ;
   NRF_STATUS  : std_logic_vector(7 downto 0) ;
   OBSERVE_TX  : std_logic_vector(7 downto 0) ;
   CD          : std_logic_vector(7 downto 0) ;
   RX_ADDR_P0  : std_logic_vector(7 downto 0) ;
   RX_ADDR_P1  : std_logic_vector(7 downto 0) ;
   RX_ADDR_P2  : std_logic_vector(7 downto 0) ;
   RX_ADDR_P3  : std_logic_vector(7 downto 0) ;
   RX_ADDR_P4  : std_logic_vector(7 downto 0) ;
   RX_ADDR_P5  : std_logic_vector(7 downto 0) ;
   TX_ADDR     : std_logic_vector(7 downto 0) ;
   RX_PW_P0    : std_logic_vector(7 downto 0) ;
   RX_PW_P1    : std_logic_vector(7 downto 0) ;
   RX_PW_P2    : std_logic_vector(7 downto 0) ;
   RX_PW_P3    : std_logic_vector(7 downto 0) ;
   RX_PW_P4    : std_logic_vector(7 downto 0) ;
   RX_PW_P5    : std_logic_vector(7 downto 0) ;
   FIFO_STATUS : std_logic_vector(7 downto 0) ;
   DYNPD       : std_logic_vector(7 downto 0) ;
   FEATURE     : std_logic_vector(7 downto 0) ;
  end record t_addr;
  
  
constant NRF24_ADDRESS : t_addr := (
   NRF_CONFIG  => x"00",
   EN_AA       => x"01",
   EN_RXADDR   => x"02",
   SETUP_AW    => x"03",
   SETUP_RETR  => x"04",
   RF_CH       => x"05",
   RF_SETUP    => x"06",
   NRF_STATUS  => x"07",
   OBSERVE_TX  => x"08",
   CD          => x"09",
   RX_ADDR_P0  => x"0A",
   RX_ADDR_P1  => x"0B",
   RX_ADDR_P2  => x"0C",
   RX_ADDR_P3  => x"0D",
   RX_ADDR_P4  => x"0E",
   RX_ADDR_P5  => x"0F",
   TX_ADDR     => x"10",
   RX_PW_P0    => x"11",
   RX_PW_P1    => x"12",
   RX_PW_P2    => x"13",
   RX_PW_P3    => x"14",
   RX_PW_P4    => x"15",
   RX_PW_P5    => x"16",
   FIFO_STATUS => x"17",
   DYNPD       => x"1C",
   FEATURE     => x"1D"
  );
  
  type t_cmd is record
     R_REGISTER    : std_logic_vector(7 downto 0) ; --/* Read register */
     W_REGISTER    : std_logic_vector(7 downto 0) ; --/* Write register */
     REGISTER_MASK : std_logic_vector(7 downto 0) ; --
                   
     R_RX_PAYLOAD  : std_logic_vector(7 downto 0) ; --/* Dequeues and reads RX payload */
     W_TX_PAYLOAD  : std_logic_vector(7 downto 0) ; --/* Enqueues TX payload */
                   
     ACTIVATE      : std_logic_vector(7 downto 0) ; --/* Activates 3 commands below */
     ACTIVATE_2    : std_logic_vector(7 downto 0) ; --/* Always sent after ACTIVATE command */
     R_RX_PL_WID   : std_logic_vector(7 downto 0) ; --/* Read RX-payload width for top R_RX_PAYLOAD */
     W_ACK_PAYLOAD : std_logic_vector(7 downto 0) ; --/* Write payload with ACK packet i.e. piggyback */
     W_TX_PAYLOAD_NOACK : std_logic_vector(7 downto 0) ; --/* Disables Auto-ACK on this packet */
                        
     FLUSH_TX      : std_logic_vector(7 downto 0) ; --/* Flush TX FIFO */
     FLUSH_RX      : std_logic_vector(7 downto 0) ; --/* Flush RX FIFO */
     REUSE_TX_PL   : std_logic_vector(7 downto 0) ; --/* Reuse last TX payload */
     NOP           : std_logic_vector(7 downto 0) ; --/* No opera
     
     
  end record t_cmd;
  
  
  constant NRF24_CMD : t_cmd := (
     R_REGISTER    => x"00", --/* Read register */
     W_REGISTER    => x"20", --/* Write register */
     REGISTER_MASK => x"1F", --
                        
     R_RX_PAYLOAD  => x"61", --/* Dequeues and reads RX payload */
     W_TX_PAYLOAD  => x"A0", --/* Enqueues TX payload */
                        
     ACTIVATE      => x"50", --/* Activates 3 commands below */
     ACTIVATE_2    => x"73", --/* Always sent after ACTIVATE command */
     R_RX_PL_WID   => x"60", --/* Read RX-payload width for top R_RX_PAYLOAD */
     W_ACK_PAYLOAD => x"A8", --/* Write payload with ACK packet i.e. piggyback */
     W_TX_PAYLOAD_NOACK => x"B0", --/* Disables Auto-ACK on this packet */
                        
     FLUSH_TX      => x"E1", --/* Flush TX FIFO */
     FLUSH_RX      => x"E2", --/* Flush RX FIFO */
     REUSE_TX_PL   => x"E3", --/* Reuse last TX payload */
     NOP           => x"FF" --/* No opera
     );
     
     type t_others is record
       POWER_UP_DELAY : integer ; --/* Tpd2stby - delay before CE can be set high */
      POWER_DOWN_DELAY :integer ;
      WRITE_DELAY       : integer; --/* Thce - Minimum delay for 1 packet to be sent */ 
      TRANSITION_DELAY  : integer;
      
      
      MAX_CHANNEL : integer ;
      MAX_PAYLOAD_LEN :integer ;
      MIN_ADDR_WIDTH : integer ;
      MAX_ADDR_WIDTH : integer ;
      MIN_PIPE_NUM : integer ;
      MAX_PIPE_NUM : integer ;
      PIPE0_SET : integer;
      PIPE0_AUTO_ACKED : integer ;
     
  end record t_others;
  
  
  constant NRF24_OTHERS : t_others := (
      POWER_UP_DELAY => 150, -- /* Tpd2stby - delay before CE can be set high */
      POWER_DOWN_DELAY => 150,
      WRITE_DELAY => 10, --/* Thce - Minimum delay for 1 packet to be sent */ 
      TRANSITION_DELAY => 130, 
     
      MAX_CHANNEL => 127,
      MAX_PAYLOAD_LEN => 32,
      MIN_ADDR_WIDTH => 3,
      MAX_ADDR_WIDTH => 5,
      MIN_PIPE_NUM => 0,
      MAX_PIPE_NUM => 5,
      PIPE0_SET => 1,
      PIPE0_AUTO_ACKED => 2
     );
end NRF24_PACK;