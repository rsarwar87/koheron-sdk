library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity spi_top is
generic (
    MAX_DATA_SIZE_BYTES  : natural := 33;
    slv_bits: natural := 1
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
end spi_top;

architecture Behavioral of spi_top is
     
    component SPI_MASTER is
    Generic (
        CLK_FREQ    : natural := 100e6; -- set system clock frequency in Hz
        SCLK_FREQ   : natural := 10e6;  -- set SPI clock frequency in Hz (condition: SCLK_FREQ <= CLK_FREQ/10)
        SLAVE_COUNT : natural := 1     -- count of SPI slaves
    );
    Port (
        CLK      : in  std_logic; -- system clock
        RST      : in  std_logic; -- high active synchronous reset
        -- SPI MASTER INTERFACE
        SCLK     : out std_logic; -- SPI clock
        CS_N     : out std_logic_vector(SLAVE_COUNT-1 downto 0); -- SPI chip select, active in low
        MOSI     : out std_logic; -- SPI serial data from master to slave
        MISO     : in  std_logic; -- SPI serial data from slave to master
        -- INPUT USER INTERFACE
        ADDR     : in  std_logic_vector(integer(ceil(log2(real(SLAVE_COUNT))))-1 downto 0); -- SPI slave address
        DIN      : in  std_logic_vector(7 downto 0); -- input data for SPI slave
        DIN_LAST : in  std_logic; -- when DIN_LAST = 1, after transmit these input data is asserted CS_N
        DIN_VLD  : in  std_logic; -- when DIN_VLD = 1, input data are valid
        READY    : out std_logic; -- when READY = 1, valid input data are accept
        -- OUTPUT USER INTERFACE
        DOUT     : out std_logic_vector(7 downto 0); -- output data from SPI slave
        DOUT_VLD : out std_logic  -- when DOUT_VLD = 1, output data are valid
    );
    end component;
    signal RST, x_valid_buf : std_logic := '0';
    signal DIN, DOUT : std_logic_vector (7 downto 0) := (others => '0');
    signal SPI_READY : std_logic := '0';
    signal DIN_VLD, DOUT_VLD   : std_logic := '0';
    signal IS_LAST   : std_logic := '0';
    
    TYPE STATE_TYPE IS (IDLE, PREPARE, ISSUE, DELAY1, POLL, COMPLETED);
    SIGNAL state   : STATE_TYPE := IDLE;
   
    signal reg_nbyte    : integer range 1 to MAX_DATA_SIZE_BYTES + 1 := 1;
    signal cnt_nbyte    : integer range 1 to MAX_DATA_SIZE_BYTES + 1 := 1;
    signal data_in_buf  : std_logic_vector((8*MAX_DATA_SIZE_BYTES - 1) downto 0) := (others => '0');
    signal data_out_buf : std_logic_vector((8*MAX_DATA_SIZE_BYTES - 1) downto 0) := (others => '0');
begin
    
    
    process (clk100, rstn)
    begin
        if (rstn = '0') then
            state       <= IDLE;
            reg_nbyte   <= 1;
            DIN         <= (others => '0');
            data_out_buf<= (others => '0');
            data_in_buf <= (others => '0');
            DIN_VLD     <= '0';
            IS_LAST     <= '0';
            x_valid_buf <= '0';
            cnt_nbyte   <= 1;
        elsif rising_edge(clk100) then
            data_out_buf <= data_out_buf;
            data_in_buf  <= data_in_buf;
            x_valid_buf <= x_valid;
            x_done      <= '0';
            case state is
                when IDLE => 
                    DIN_VLD     <= '0';
                    IS_LAST     <= '0';
                    bus_ready   <= '1';
                    reg_nbyte   <= 1;
                    cnt_nbyte   <= 1;
                    if (x_valid_buf = '0' and x_valid = '1' and SPI_READY = '1') then
                        data_in_buf <= data_in;
                        data_out_buf<= (others => '0');
                        bus_ready   <= '0';
                        data_out    <= (others => '0');
                        reg_nbyte   <= nbytes_i;
                        state       <= PREPARE;
                    end if;
                when PREPARE => 
                    if (reg_nbyte = cnt_nbyte) then
                        IS_LAST <= '1';
                    else
                        IS_LAST <= '0';
                    end if;
                    DIN <= data_in_buf(cnt_nbyte*8 - 1 downto ((cnt_nbyte - 1)*8));
                    if (SPI_READY = '1') then
                        state <= ISSUE;
                    end if;
                when ISSUE => 
                    if (SPI_READY = '1') then
                        state <= DELAY1;
                        DIN_VLD <= '1';
                    end if;
                
                when DELAY1 => 
                    if (SPI_READY = '0') then
                        DIN_VLD <= '0';
                        state <= POLL;
                    end if;
                when POLL =>
                    DIN_VLD <= '0';
                    if (DOUT_VLD = '1') then
                        data_out_buf(cnt_nbyte*8 - 1 downto ((cnt_nbyte - 1)*8)) <= DOUT;
                    end if;
                    if (SPI_READY = '1') then
                        if (IS_LAST = '1') then
                            state <= COMPLETED;
                        else
                            cnt_nbyte <= cnt_nbyte + 1;
                            state <= PREPARE;
                        end if;
                    end if;
                when COMPLETED =>
                    data_out <= data_out_buf;
                    bus_ready <= '1';
                    x_done <= '1';
                    state <= IDLE;
            end case;
        end if;
    end process;
    
    RST <= not rstn;
    UI_SPI : SPI_MASTER
    generic map (
        CLK_FREQ    => 100e6,
        SCLK_FREQ   => 10e6,
        SLAVE_COUNT => slv_bits
    )
    port map (
        CLK         => clk100,
        RST         => RST,
        
        SCLK        => spi_sclk,
        CS_N        => spi_nsel,
        MOSI        => spi_mosi,
        MISO        => spi_miso,
        
        DIN         => DIN,
        READY       => SPI_READY,
        DIN_VLD     => DIN_VLD,
        DIN_LAST    => IS_LAST,
        ADDR        => (others => '0'),
        DOUT        => DOUT,
        DOUT_VLD    => DOUT_VLD
    );
end Behavioral;
