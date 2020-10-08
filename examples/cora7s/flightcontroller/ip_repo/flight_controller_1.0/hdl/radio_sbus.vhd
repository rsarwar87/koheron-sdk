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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity radio_sbus is
  generic (is_inverted : std_logic := '1');
  Port ( 
    clk_100, rstn_100 : in std_logic;
    enable : in std_logic;
    
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
    
    synce_locked : out std_logic;
    radio_sbus_in   : in std_logic
  );
end radio_sbus;

architecture Behavioral of radio_sbus is

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
signal rx_busy, radio_sbus_in_buf	:		STD_LOGIC;										--data reception in progress
signal rx_error	:		STD_LOGIC;										--start, parity, or stop bit error detected
signal rx_data, rx_data_rev	:		STD_LOGIC_VECTOR(7 DOWNTO 0);	--data received
signal tx_busy	:		STD_LOGIC;  									--transmission in progress
signal rx_valid	:		STD_LOGIC;
signal synced, rx_valid_delayed : std_logic;
type channel_array is array (0 to 15) of std_logic_vector(15 downto 0) ;
signal channels : channel_array := (others => (others => '0'));
signal channels_buffer : channel_array := (others => (others => '0'));
signal rx_count, in_sync_counter, activity_counter : integer := 0;

signal in_sync_pin : std_logic;
signal in_synced : std_logic;

ATTRIBUTE MARK_DEBUG : string;
ATTRIBUTE MARK_DEBUG of rx_busy, rx_error, rx_data, synced, channels, rx_count, in_sync_pin, in_synced: SIGNAL IS "TRUE";
ATTRIBUTE MARK_DEBUG of rx_valid, radio_sbus_in, activity_counter: SIGNAL IS "TRUE";
begin

    process (clk_100, rstn_100)
    begin
        if (rstn_100 = '0') then
            channels <= (others => (others => '0'));
            channels_buffer <= (others => (others => '0'));
            synced <= '0';
            rx_count <= 0;
            rx_valid_delayed <= '0';
            activity_counter <= 0;
        elsif (rising_edge(clk_100)) then
        
            --if (synced = '1') then
                if activity_counter = 100000000 then
                    synced <= '0'; 
                --elsif rx_busy = '1' then
                --    activity_counter <= 0;
                
                else
                    activity_counter <= activity_counter + 1;
                end if;
                if activity_counter = 481073 then
                    rx_count <= 0;
                end if;
             --end if;
            rx_valid_delayed <= rx_valid;
            if rx_valid = '1' and rx_valid_delayed = '0' then
                activity_counter <= 0;
                if (synced = '0') then -- find sync
                    rx_count <= rx_count + 1;
                    if rx_data = x"0f" then
                        activity_counter <= 0;
                        synced <= '1';
                        rx_count <= 1;
                    end if;
                else    -- check for sync // start and end byte
                    rx_count <= rx_count + 1;
                    
                    case rx_count is
                        when 0 => -- end flag
                            if (rx_data = x"0f") then 
                                --rx_count <= 1;
                                channels <= channels_buffer;
                                CLEAR_VAL : for K in 0 to 15  loop
                                    channels_buffer(K)(0) <= '0';
                                end loop;
                             else 
                                synced <= '0';
                             end if;
                        when 1 =>
                            --if (rx_error /= '1') then
                                channels_buffer(0)(7 downto 0) <= rx_data(7 downto 0);
                            --else
                            if (rx_error = '1') then
                                channels_buffer(0)(15) <= '1';
                            end if;
                        when 2 =>
                            --if (rx_error /= '1') then
                            channels_buffer(0)(10 downto 8) <= rx_data(2 downto 0);
                            channels_buffer(1)(4 downto 0) <= rx_data(7 downto 3);
                            if (rx_error = '1') then
                                channels_buffer(0)(15) <= '1';
                                channels_buffer(1)(15) <= '1';
                            end if;
                        when 3 =>
                            --if (rx_error /= '1') then
                            channels_buffer(1)(10 downto 5) <= rx_data(5 downto 0);
                            channels_buffer(2)(1 downto 0) <= rx_data(7 downto 6);
                            if (rx_error = '1') then
                                channels_buffer(1)(15) <= '1';
                                channels_buffer(2)(15) <= '1';
                            end if;
                        when 4 =>
                            --if (rx_error /= '1') then
                            channels_buffer(2)(9 downto 2) <= rx_data(7 downto 0);
                            --channels_buffer(3)(1 downto 0) <= rx_data(7 downto 6);
                            if (rx_error = '1') then
                                channels_buffer(2)(15) <= '1';
                            end if;
                        when 5 =>
                            --if (rx_error /= '1') then
                            channels_buffer(2)(10) <= rx_data(0);
                            channels_buffer(3)(6 downto 0) <= rx_data(7 downto 1);
                            if (rx_error = '1') then
                                channels_buffer(2)(15) <= '1';
                                channels_buffer(3)(15) <= '1';
                            end if;
                        when 6 =>
                            --if (rx_error /= '1') then
                            channels_buffer(3)(10 downto 7) <= rx_data(3 downto 0);
                            channels_buffer(4)(3 downto 0) <= rx_data(7 downto 4);
                            if (rx_error = '1') then
                              channels_buffer(3)(15) <= '1';
                              channels_buffer(4)(15) <= '1';
                            end if;
                        when 7 =>
                            --if (rx_error /= '1') then
                            channels_buffer(4)(10 downto 4) <= rx_data(6 downto 0);
                            channels_buffer(5)(0) <= rx_data(0);
                            if (rx_error = '1') then
                                channels_buffer(0)(15) <= '1';
                            end if;
                        when 8 =>
                            --if (rx_error /= '1') then
                            channels_buffer(5)(8 downto 1) <= rx_data(7 downto 0);
                            --channels_buffer(7)(3 downto 0) <= rx_data(7 downto 4);
                            if (rx_error = '1') then
                                channels_buffer(0)(15) <= '1';
                            end if;
                        when 9 =>
                            --if (rx_error /= '1') then
                            channels_buffer(5)(10 downto 9) <= rx_data(1 downto 0);
                            channels_buffer(6)(5 downto 0) <= rx_data(7 downto 2);
                            if (rx_error = '1') then
                                channels_buffer(5)(15) <= '1';
                                channels_buffer(6)(15) <= '1';
                            end if;
                        when 10 =>
                            --if (rx_error /= '1') then
                            channels_buffer(6)(10 downto 6) <= rx_data(4 downto 0);
                            channels_buffer(7)(2 downto 0) <= rx_data(7 downto 5);
                            if (rx_error = '1') then
                                channels_buffer(6)(15) <= '1';
                                channels_buffer(7)(15) <= '1';
                            end if;
                        when 11 =>
                            --if (rx_error /= '1') then
                            channels_buffer(7)(10 downto 3) <= rx_data(7 downto 0);
                            --channels_buffer(7)(2 downto 0) <= rx_data(7 downto 5);
                            if (rx_error = '1') then
                                channels_buffer(7)(15) <= '1';
                            end if;
                        when 12 =>
                            --if (rx_error /= '1') then
                            channels_buffer(8)(7 downto 0) <= rx_data(7 downto 0);
                            --channels_buffer(7)(2 downto 0) <= rx_data(7 downto 5);
                            if (rx_error = '1') then
                                channels_buffer(8)(15) <= '1';
                            end if;
                        when 13 =>
                            --if (rx_error /= '1') then
                            channels_buffer(8)(10 downto 8) <= rx_data(2 downto 0);
                            channels_buffer(9)(4 downto 0) <= rx_data(7 downto 3);
                            if (rx_error = '1') then
                                channels_buffer(8)(15) <= '1';
                                channels_buffer(9)(15) <= '1';
                            end if;
                        when 14 =>
                            --if (rx_error /= '1') then
                            channels_buffer(9)(10 downto 5) <= rx_data(5 downto 0);
                            channels_buffer(10)(1 downto 0) <= rx_data(7 downto 6);
                            if (rx_error = '1') then
                                channels_buffer(9)(15) <= '1';
                                channels_buffer(10)(15) <= '1';
                            end if;
                        when 15 =>
                            --if (rx_error /= '1') then
                            channels_buffer(10)(9 downto 2) <= rx_data(7 downto 0);
                            --channels_buffer(10)(1 downto 0) <= rx_data(7 downto 6);
                            if (rx_error = '1') then
                                channels_buffer(10)(15) <= '1';
                            end if;
                        when 16 =>
                            --if (rx_error /= '1') then
                            channels_buffer(10)(10) <= rx_data(0);
                            channels_buffer(11)(6 downto 0) <= rx_data(7 downto 1);
                            if (rx_error = '1') then
                                channels_buffer(10)(15) <= '1';
                                channels_buffer(11)(15) <= '1';
                            end if;
                        when 17 =>
                            --if (rx_error /= '1') then
                            channels_buffer(11)(10 downto 7) <= rx_data(3 downto 0);
                            channels_buffer(12)(3 downto 0) <= rx_data(7 downto 4);
                            if (rx_error = '1') then
                                channels_buffer(11)(15) <= '1';
                                channels_buffer(12)(15) <= '1';
                            end if;
                        when 18 =>
                            --if (rx_error /= '1') then
                            channels_buffer(12)(10 downto 4) <= rx_data(6 downto 0);
                            channels_buffer(13)(0) <= rx_data(7);
                            if (rx_error = '1') then
                                channels_buffer(12)(15) <= '1';
                                channels_buffer(13)(15) <= '1';
                            end if;
                        when 19 =>
                            --if (rx_error /= '1') then
                            channels_buffer(13)(8 downto 1) <= rx_data(7 downto 0);
                            if (rx_error = '1') then
                                channels_buffer(13)(15) <= '1';
                            end if;
                        when 20 =>
                            --if (rx_error /= '1') then
                            channels_buffer(13)(10 downto 9) <= rx_data(1 downto 0);
                            channels_buffer(14)(5 downto 0) <= rx_data(7 downto 2);
                            if (rx_error = '1') then
                                channels_buffer(13)(15) <= '1';
                                channels_buffer(14)(15) <= '1';
                            end if;
                        when 21 =>
                            --if (rx_error /= '1') then
                            channels_buffer(14)(10 downto 6) <= rx_data(4 downto 0);
                            channels_buffer(15)(2 downto 0) <= rx_data(7 downto 5);
                            if (rx_error = '1') then
                                channels_buffer(14)(15) <= '1';
                                channels_buffer(15)(15) <= '1';
                            end if;
                        when 22 =>
                            --if (rx_error /= '1') then
                            channels_buffer(15)(10 downto 3) <= rx_data(7 downto 0);
                            if (rx_error = '1') then
                                channels_buffer(15)(15) <= '1';
                            end if;
                        when 23 => -- control flag
                            
                        when 24 => -- end flag
                            --if (rx_data /= x"00" and rx_error /= '1') then 
                             --   synced <= '0';
                             --end if;
                        
                        when others => -- end flag
                            if (rx_data = x"0f") then 
                                --rx_count <= 1;
                                channels <= channels_buffer;
                                CLEAR_VAL2 : for K in 0 to 15  loop
                                    channels_buffer(K)(0) <= '0';
                                end loop;
                             else 
                                synced <= '0';
                             end if;
                        
                        
                    end case;
                    
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

    U_UART: uart
    generic map (
        clk_freq    => 100_000_000,
        baud_rate   => 100_000,
        os_rate     => 16,
        d_width     => 8,
        parity      => 1,
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
    --rx_data(0 downto 7) <= rx_data_rev(7 downto 0);
    radio_sbus_in_buf <= radio_sbus_in when is_inverted = '0' else not radio_sbus_in;
    in_sync_pin <= radio_sbus_in_buf when in_synced = '1' else '1';
    process (clk_100, rstn_100)
    begin
        if rstn_100 = '0' then
            in_synced <= '0';
            in_sync_counter <= 0;
        elsif (rising_edge(clk_100)) then
            if (in_synced = '0') then
                if radio_sbus_in_buf = '1' then
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
