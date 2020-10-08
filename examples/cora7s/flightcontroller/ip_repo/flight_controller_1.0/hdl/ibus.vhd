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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity radio_ibus is
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
    
    synce_locked  : out std_logic;
    radio_ibus_in   : in std_logic
  );
end radio_ibus;

architecture Behavioral of radio_ibus is

component uart IS
	GENERIC(
		clk_freq		:	INTEGER		:= 100_000_000;	--frequency of system clock in Hertz
		baud_rate	:	INTEGER		:= 100_000;		--data link baud rate in bits/second
		os_rate		:	INTEGER		:= 16;			--oversampling rate to find center of receive bits (in samples per baud period)
		d_width		:	INTEGER		:= 8; 			--data bus width
		parity		:	INTEGER		:= 1;				--0 for no parity, 1 for parity
		parity_eo	:	STD_LOGIC	:= '0');			--'0' for even, '1' for odd parity
	PORT(
		clk		:	IN		STD_LOGIC;										--system clock
		reset_n	:	IN		STD_LOGIC;										--ascynchronous reset
		tx_ena	:	IN		STD_LOGIC;										--initiate transmission
		tx_data	:	IN		STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data to transmit
		rx			:	IN		STD_LOGIC;										--receive pin
		rx_busy	:	OUT	STD_LOGIC;										--data reception in progress
		rx_error	:	OUT	STD_LOGIC;										--start, parity, or stop bit error detected
		rx_data	:	OUT	STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);	--data received
		tx_busy	:	OUT	STD_LOGIC;  									--transmission in progress
		rx_valid	:	OUT	STD_LOGIC;  									--transmission in progress
		tx			:	OUT	STD_LOGIC);										--transmit pin
END component;
ATTRIBUTE MARK_DEBUG : string;
signal rx_busy	:		STD_LOGIC;										--data reception in progress
signal rx_error	:		STD_LOGIC;										--start, parity, or stop bit error detected
signal rx_data	:		STD_LOGIC_VECTOR(7 DOWNTO 0);	--data received
signal tx_busy	:		STD_LOGIC;  									--transmission in progress
signal rx_valid_delayed, rx_valid, rx_valid_buf	:		STD_LOGIC;
signal synced : std_logic;

signal odd_even : std_logic := '0';

type channel_array is array (0 to 15) of std_logic_vector(15 downto 0) ;
signal channels : channel_array := (others => (others => '0'));
signal channels_buffer : channel_array := (others => (others => '0'));
signal rx_count, rx_expected, in_sync_counter : integer := 0;

signal data_rx, checksum, data_rx_buf :std_logic_vector(15 downto 0) ;
signal error_check :std_logic_vector(1 downto 0) ;
constant ccr_high :std_logic_vector(15 downto 0) := x"FFFF";

signal in_sync_pin : std_logic;
signal in_synced : std_logic;

ATTRIBUTE MARK_DEBUG of rx_busy, rx_error, rx_data, synced, channels, rx_count, in_sync_counter, in_sync_pin, in_synced: SIGNAL IS "TRUE";
ATTRIBUTE MARK_DEBUG of odd_even, rx_expected, data_rx, rx_valid, checksum, error_check, radio_ibus_in: SIGNAL IS "TRUE";


begin
    process (clk_100, rstn_100)
    begin
        if (rstn_100 = '0') then
            channels <= (others => (others => '0'));
            channels_buffer <= (others => (others => '0'));
            rx_valid_buf <= '0';
            synced <= '0';
            rx_count <= 0;
            data_rx <= (others => '0');
            checksum <= (others => '1');
            odd_even <= '0';
            error_check <= "00";
            rx_valid_delayed <= rx_valid_delayed;
            data_rx_buf <= (others => '0');
        elsif (rising_edge(clk_100)) then
            rx_valid_buf <= '0';
            rx_valid_delayed <= rx_valid;
            if rx_valid = '1' and rx_valid_delayed = '0' then
                data_rx(15 downto 8) <= rx_data; 
                data_rx(7 downto 0) <= data_rx(15 downto 8);
                error_check(1) <= rx_error;
                error_check(0) <= error_check(1);
                --checksum <= std_logic_vector(unsigned(checksum) - unsigned(rx_data));
                odd_even <= not odd_even;
                rx_valid_buf <= odd_even;
            end if;
            
            
            if rx_valid_buf = '1' then
                if (synced = '0') then -- find sync
                    rx_count <= -1;
                    if data_rx(7 downto 0) = x"20" then
                        synced <= '1';
                        rx_count <= 0;
                        rx_expected <= to_integer(unsigned(rx_data(7 downto 2)))-2;
                        checksum <= std_logic_vector(unsigned(ccr_high) - unsigned(data_rx(15 downto 8)) - unsigned(data_rx(7 downto 0))); --- unsigned(rx_data));
                    end if;
                else    -- check for sync // start and end byte
                    rx_count <= rx_count + 1;
                    data_rx_buf <= data_rx;
                    if (data_rx(15 downto 0) = x"4020") then
                        
                        rx_count <= 0;
                        rx_expected <= to_integer(unsigned(rx_data(7 downto 2)))-2;
                        checksum <= std_logic_vector(unsigned(ccr_high) - unsigned(data_rx(15 downto 8)) - unsigned(data_rx(7 downto 0))); -- - unsigned(rx_data));
                        if checksum = data_rx_buf then
                            channels <= channels_buffer;
                            channels(15) <= (others => '1');
                        end if;
                    elsif (rx_count < rx_expected) then
                        channels_buffer(rx_count) <= data_rx;
                        checksum <= std_logic_vector(unsigned(checksum) - unsigned(data_rx(15 downto 8)) - unsigned(data_rx(7 downto 0)));
                        --if error_check /= "00" then
                        --    channels_buffer(rx_count - 1)(15) <= '1';
                        --end if;
                    elsif(rx_count = rx_expected) then -- check sum
                        channels <= channels_buffer;
                        --rx_count <= 0;
                        if checksum = data_rx then
                            channels(15) <= (others => '1');
                        end if;
                    else
                        synced <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;


    process (clk_100, rstn_100)
    begin
        if rstn_100 = '0'  then
            channel_out00 <= ((others => '0'));
            channel_out01 <= ((others => '0'));
            channel_out02 <= ((others => '0'));
            channel_out03 <= ((others => '0'));
            channel_out04 <= ((others => '0'));
            channel_out05 <= ((others => '0'));
            channel_out06 <= ((others => '0'));
            channel_out07 <= ((others => '0'));
            channel_out08 <= ((others => '0'));
            channel_out09 <= ((others => '0'));
            channel_out10 <= ((others => '0'));
            channel_out11 <= ((others => '0'));
            channel_out12 <= ((others => '0'));
            channel_out13 <= ((others => '0'));
            channel_out14 <= ((others => '0'));
            channel_out15 <= ((others => '0'));
            synce_locked <= '0';
        elsif (rising_edge(clk_100)) then
            synce_locked <= synced;
            if (enable = '0' or synced = '0') then
                
                channel_out00 <= ((others => '0'));
                channel_out01 <= ((others => '0'));
                channel_out02 <= ((others => '0'));
                channel_out03 <= ((others => '0'));
                channel_out04 <= ((others => '0'));
                channel_out05 <= ((others => '0'));
                channel_out06 <= ((others => '0'));
                channel_out07 <= ((others => '0'));
                channel_out08 <= ((others => '0'));
                channel_out09 <= ((others => '0'));
                channel_out10 <= ((others => '0'));
                channel_out11 <= ((others => '0'));
                channel_out12 <= ((others => '0'));
                channel_out13 <= ((others => '0'));
                channel_out14 <= ((others => '0'));
                channel_out15 <= ((others => '0'));
            else
                
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
            end if;
        end if;
    end process;

    U_UART_IBUS: uart
    generic map (
        clk_freq    => 100_000_000,
        baud_rate   => 115_200,
        os_rate     => 16,
        d_width     => 8,
        parity      => 0,
        parity_eo   => '0'
    )
    PORT map (
        clk         => clk_100,
        reset_n     => rstn_100,
        tx_ena      => '0',
        tx_data     => (others => '0'),
        tx          => open,
        tx_busy     => open,
        rx_busy     => rx_busy,
        rx_error    => rx_error,
        rx_data     => rx_data,
        rx_valid    => rx_valid,
        rx          => in_sync_pin
    );
    in_sync_pin <= radio_ibus_in when in_synced = '1' else '1';
    
    process (clk_100, rstn_100)
    begin
        if rstn_100 = '0' then
            in_synced <= '0';
            in_sync_counter <= 0;
        elsif (rising_edge(clk_100)) then
            if (in_synced = '0') then
                if radio_ibus_in = '1' then
                    in_sync_counter <= in_sync_counter + 1;
                else 
                    in_sync_counter <= 0;
                end if;
                if (in_sync_counter = 200) then
                    in_synced <= '1';
                end if;
            end if;
        end if;
    end process;
end Behavioral;
