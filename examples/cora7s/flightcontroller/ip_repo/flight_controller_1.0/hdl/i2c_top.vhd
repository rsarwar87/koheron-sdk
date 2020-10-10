----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/03/2020 10:43:17 PM
-- Design Name: 
-- Module Name: i2c_top - Behavioral
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

entity i2c_top is
 generic (
    MAX_DATA_SIZE_BYTES  : natural := 6
 );
 Port (
    clk100, rstn_100 : std_logic;
    
    
    nbytes_i   : in  integer range 1 to MAX_DATA_SIZE_BYTES;
    addr      : IN     STD_LOGIC_VECTOR(6 DOWNTO 0);
    data_in    : in  std_logic_vector((8*MAX_DATA_SIZE_BYTES - 1) downto 0);
    data_out   : out std_logic_vector((8*MAX_DATA_SIZE_BYTES - 1) downto 0);
    read_write : in   std_logic;
    x_valid    : in   std_logic;
    bus_ready  : out  std_logic;
    x_done     : out  std_logic;
    x_err      : out  std_logic;
    has_reg    : in   std_logic;
    reg_addr   : in  std_logic_vector(7 downto 0);
    
    sda       : INOUT  STD_LOGIC;                    --serial data output of i2c bus
    scl       : INOUT  STD_LOGIC
 );
end i2c_top;

architecture Behavioral of i2c_top is
COMPONENT i2c_master IS
  GENERIC(
    input_clk : INTEGER := 100_000_000; --input clock speed from user logic in Hz
    bus_clk   : INTEGER := 400_000);   --speed the i2c bus (scl) will run at in Hz
  PORT(
    clk       : IN     STD_LOGIC;                    --system clock
    reset_n   : IN     STD_LOGIC;                    --active low reset
    ena       : IN     STD_LOGIC;                    --latch in command
    addr      : IN     STD_LOGIC_VECTOR(6 DOWNTO 0); --address of target slave
    rw        : IN     STD_LOGIC;                    --'0' is write, '1' is read
    data_wr   : IN     STD_LOGIC_VECTOR(7 DOWNTO 0); --data to write to slave
    busy      : OUT    STD_LOGIC;                    --indicates transaction in progress
    data_rd   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0); --data read from slave
    ack_error : BUFFER STD_LOGIC;                    --flag if improper acknowledge from slave
    sda       : INOUT  STD_LOGIC;                    --serial data output of i2c bus
    scl       : INOUT  STD_LOGIC
    );                   --serial clock output of i2c bus
END COMPONENT;
signal rw, ack_error, x_valid_buf        :      STD_LOGIC;
signal ena, busy, iic_ready, iic_ready_delayed : std_logic;
signal data_wr, data_rd   :      STD_LOGIC_VECTOR(7 DOWNTO 0);
signal iic_addr : std_logic_vector(6 downto 0);
TYPE STATE_TYPE IS (IDLE, PREPARE, POLL, COMPLETED);
    SIGNAL state   : STATE_TYPE := IDLE;
   
    signal reg_nbyte    : integer range 1 to MAX_DATA_SIZE_BYTES + 1 := 1;
    signal cnt_nbyte    : integer range 0 to MAX_DATA_SIZE_BYTES + 1 := 0;
    signal data_in_buf  : std_logic_vector((8*MAX_DATA_SIZE_BYTES - 1) downto 0) := (others => '0');
    signal data_out_buf : std_logic_vector((8*MAX_DATA_SIZE_BYTES - 1) downto 0) := (others => '0');
    
                                                                                                                                                 
ATTRIBUTE MARK_DEBUG : string;                                                                                                               
ATTRIBUTE MARK_DEBUG of x_err, x_done, x_valid, data_out, ack_error, reg_nbyte, cnt_nbyte, data_in_buf, data_out_buf, x_valid_buf, iic_addr, state: SIGNAL IS "TRUE";
begin
    iic_ready <= not busy;
    x_err <= ack_error;
    process (clk100, rstn_100)
    begin
        if (rstn_100 = '0') then
            state       <= IDLE;
            reg_nbyte   <= 1;
            data_wr         <= (others => '0');
            data_out_buf<= (others => '0');
            data_in_buf <= (others => '0');
            ena     <= '0';
            x_valid_buf <= '0';
            cnt_nbyte   <= 0;
            iic_ready_delayed <= '0';
            iic_addr <= (others => '0');
        elsif rising_edge(clk100) then
            data_out_buf <= data_out_buf;
            data_in_buf  <= data_in_buf;
            x_valid_buf <= x_valid;
            x_done      <= '0';
            iic_ready_delayed <= iic_ready;
            case state is
                when IDLE => 
                    ena     <= '0';
                    bus_ready   <= '1';
                    reg_nbyte   <= 1;
                    cnt_nbyte   <= 0;
                    rw <= '0';
                    iic_addr <= (others => '0');
                    if (x_valid_buf = '0' and x_valid = '1' and iic_ready = '1') then
                        data_in_buf <= data_in;
                        data_out_buf<= (others => '0');
                        
                        bus_ready   <= '0';
                        data_out    <= (others => '0');
                        reg_nbyte   <= nbytes_i;
                        state       <= PREPARE;
                    end if;    
                when PREPARE => 
                    
                    iic_addr <= addr;
                    ena <= '1';
                    
                    ena <= '1';
                    if (reg_nbyte = 1 or has_reg = '0') then          -- if transaction size is 1 or has not register map, just follow command
                        rw <= read_write;
                        data_wr <= data_in_buf(7 downto 0);
                        cnt_nbyte <= 1;
                    else                                               ---- if it has register
                        data_wr <= reg_addr;
                    end if;
                    state <= POLL;
                when POLL =>
                
                    if (iic_ready = '0' and iic_ready_delayed = '1') then
                        rw <= read_write;
                        cnt_nbyte <= cnt_nbyte + 1;
                        data_wr <= data_in_buf((cnt_nbyte+1)*8 - 1 downto ((cnt_nbyte)*8));
                    end if;
                    
                    if (reg_nbyte = cnt_nbyte and iic_ready = '0') then 
                        state <= COMPLETED;
                    end if;
                    
                    if (iic_ready = '1' and rw = '1' and iic_ready_delayed = '0') then
                        data_out_buf(cnt_nbyte*8 - 1 downto ((cnt_nbyte - 1)*8)) <= data_rd;
                    end if;
                when COMPLETED =>
                    if (iic_ready = '1' and iic_ready_delayed = '0' and rw = '1') then
                        data_out_buf(cnt_nbyte*8 - 1 downto ((cnt_nbyte - 1)*8)) <= data_wr;
                    end if;
                    if (iic_ready = '1' and iic_ready_delayed = '1') then
                        state <= IDLE;
                        data_out <= data_out_buf;
                        iic_addr <= (others => '0');
                        bus_ready <= '1';
                        x_done <= '1';
                    end if;
                    
                    ena <= '0';
                    
            end case;
        end if;
    end process;
U_I2C :  i2c_master 
  GENERIC MAP(
    input_clk => 100_000_000, --input clock speed from user logic in Hz
    bus_clk   => 400_000
    )   --speed the i2c bus (scl) will run at in Hz 
  PORT MAP(
    clk       => clk100,                    --system clock
    reset_n   => rstn_100,                    --active low reset
    ena       => ena,                    --latch in command
    addr      => iic_addr,  --address of target slave
    rw        => rw,                    --'0' is write, '1' is read
    data_wr   => data_wr, --data to write to slave
    busy      => busy,                    --indicates transaction in progress
    data_rd   => data_rd, --data read from slave
    ack_error => ack_error,                    --flag if improper acknowledge from slave
    sda       => sda,                    --serial data output of i2c bus
    scl       => scl
    );                   --serial clock output of i2c bus 
    
    
end Behavioral;
