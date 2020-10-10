
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

			
			

entity mpu6050_wrapper is
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
   
   mag_x_out : out std_logic_vector(15 downto 0);
   mag_y_out : out std_logic_vector(15 downto 0);
   mag_z_out : out std_logic_vector(15 downto 0);
   
   mag_valid : out std_logic;
   gyro_valid : out std_logic;
   acel_valid : out std_logic
   
);
end mpu6050_wrapper;
			
		


architecture rtl of mpu6050_wrapper is
   -- declarative_items (signal declarations, component declarations, etc.)

	   
   
   signal boot_delay_counter : integer := 0;
      
    component i2c_top is
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
    end component;
    
       TYPE STATE_TYPE IS (IDLE, BUSY, READY);
   SIGNAL state   : STATE_TYPE := IDLE;
   
   TYPE STAGE_TYPE IS (DELAY, BOOT, CONFIG1, CONFIG2, CONFIG3, CONFIG4, CONFIG5, CONFIG0_MAG, READ_OFF_MAG,  MAIN_START,
                READ_OFF_GYR, READ_OFF_ACEL0, READ_OFF_ACEL1, READ_OFF_ACEL2, READ_GYRO, READ_ACEL, READ_MAG, MAIN_DONE, RECOVERING_ERROR, BUSY);
   signal stage, stage_next : STAGE_TYPE := DELAY;
   
   constant REG_GYRO : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(67, 8));
   constant REG_ACEL : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(59, 8));
   constant REG_MAG : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(67, 8));
   constant REG_INT_PIN_CFG : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(55, 8));
   constant REG_INT_ENABLE : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(56, 8));
   constant REG_INT_STATUS : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(58, 8));
   constant REG_PWR_MGMNT_1 : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(107, 8));
   constant REG_GYRO_CONFIG : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(27, 8));
   constant REG_ACEL_CONFIG : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(28, 8));
   constant REG_FIFO_CONFIG : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(26, 8));
   constant REG_ACEL0_OFFSET : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(119, 8));
   constant REG_ACEL1_OFFSET : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(122, 8));
   constant REG_ACEL2_OFFSET : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(125, 8));
   constant REG_GYRO_OFFSET : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(19, 8));
   
   constant REG_MAG_OFFSET : std_logic_vector(7 downto 0) := x"10";
   constant REG_MAG_CRTL : std_logic_vector(7 downto 0) := x"0A";
   constant REG_MAGXYZ : std_logic_vector(7 downto 0) := x"03";
   constant  MAX_DATA_SIZE_BYTES  : natural := 6;
    
    signal nbytes_i   : integer range 1 to MAX_DATA_SIZE_BYTES;
    signal addr       :    STD_LOGIC_VECTOR(6 DOWNTO 0) := "1101000";
    signal data_in    : std_logic_vector((8*MAX_DATA_SIZE_BYTES - 1) downto 0);
    signal data_out   : std_logic_vector((8*MAX_DATA_SIZE_BYTES - 1) downto 0);
    signal read_write :  std_logic;
    signal x_valid    :  std_logic;
    signal bus_ready  :  std_logic;
    signal x_done     :  std_logic;
    signal x_err      :  std_logic;
    signal has_reg    :  std_logic := '1';
    signal reg_addr   : std_logic_vector(7 downto 0);
    
    signal delay_counter, delay_climit : integer := 0;
    signal delay_accel : integer range 0 to 8:= 0;
    
    signal off_set_gyro_x, off_set_gyro_y, off_set_gyro_z   : std_logic_vector(15 downto 0);
    signal off_set_acel_x, off_set_acel_y, off_set_acel_z   : std_logic_vector(15 downto 0);
    signal off_set_mag_x, off_set_mag_y, off_set_mag_z   : std_logic_vector(7 downto 0);
    
    ATTRIBUTE MARK_DEBUG : string;
    ATTRIBUTE MARK_DEBUG of delay_counter, x_err, x_done, bus_ready, stage, gyro_valid, mag_valid, acel_valid, stage_next, gyro_x_out, gyro_z_out, gyro_y_out, mpu6050_interrupt: SIGNAL IS "TRUE";
    ATTRIBUTE MARK_DEBUG of delay_accel, off_set_gyro_x, off_set_gyro_y, off_set_gyro_z, off_set_acel_x, off_set_acel_y, off_set_acel_z  : SIGNAL IS "TRUE";

begin
   -- architecture body
   --TYPE STAGE_TYPE IS (DELAY, BOOT, CONFIG1, CONFIG2, CONFIG3, CONFIG4, MAIN_GYRO, READ_ACEL, READ_MAG, MAIN_DONE, RECOVERING_ERROR);
    process (clk_100, rstn_100) 
    begin
        if (rstn_100 = '0') then
            state <= IDLE;
            stage <= DELAY;
            delay_counter <= 0;
            stage_next <= stage;
            gyro_valid <= '0';
            acel_valid <= '0';
            mag_valid <= '0';
            gyro_x_out <= (others => '0');
            gyro_y_out <= (others => '0');
            gyro_z_out <= (others => '0');
            acel_x_out <= (others => '0');
            acel_y_out <= (others => '0');
            acel_z_out <= (others => '0');
            delay_accel <= 0;
        elsif (rising_edge (clk_100) ) then
            --stage <= stage_next;
            gyro_valid <= '0';
            mag_valid <= '0';
            acel_valid  <= '0';
            if (stage = BUSY) then
                if (bus_ready = '0') then
                    x_valid <= '0';
                end if;
                if (x_err = '1') then
                    stage <= RECOVERING_ERROR;
                end if;
                if (x_done = '1' ) then -- or bus_ready = '0') then
                    stage <= MAIN_START;
                    if (stage_next = READ_ACEL) then
                        gyro_x_out (15 downto 8) <= data_out(7 downto 0);
                        gyro_x_out (7 downto 0) <= data_out(15 downto 8);
                        gyro_y_out (15 downto 8) <= data_out(23 downto 16);
                        gyro_y_out (7 downto 0) <= data_out(31 downto 24);
                        gyro_z_out (15 downto 8) <= data_out(39 downto 32);
                        gyro_z_out (7 downto 0) <= data_out(47 downto 40);
                        gyro_valid <= '1';
                    elsif (stage_next = MAIN_DONE) then
                        acel_x_out (15 downto 8) <= data_out(7 downto 0);
                        acel_x_out (7 downto 0) <= data_out(15 downto 8);
                        acel_x_out (15 downto 8) <= data_out(23 downto 16);
                        acel_x_out (7 downto 0) <= data_out(31 downto 24);
                        acel_x_out (15 downto 8) <= data_out(39 downto 32);
                        acel_x_out (7 downto 0) <= data_out(47 downto 40);
                        acel_valid <= '1';
                    elsif (stage_next = READ_OFF_ACEL0) then
                        off_set_acel_x (15 downto 0) <= data_out(15 downto 0);
                    elsif (stage_next = READ_OFF_ACEL1) then
                        off_set_acel_y (15 downto 0) <= data_out(15 downto 0);
                    elsif (stage_next = READ_OFF_ACEL2) then
                        off_set_acel_z (15 downto 0) <= data_out(15 downto 0);
                    elsif (stage_next = READ_OFF_GYR) then
                        off_set_gyro_x (15 downto 0) <= data_out(15 downto 0);
                        off_set_gyro_y (15 downto 0) <= data_out(31 downto 16);
                        off_set_gyro_z (15 downto 0) <= data_out(47 downto 32);
                    elsif (stage_next = READ_OFF_MAG) then
                        off_set_mag_x  <= data_out(7 downto 0);
                        off_set_mag_y  <= data_out(15 downto 8);
                        off_set_mag_z  <= data_out(23 downto 16);
                    elsif (stage_next = MAIN_DONE) then
                        mag_x_out <= data_out(15 downto 0);
                        mag_y_out <= data_out(31 downto 16);
                        mag_z_out <= data_out(47 downto 32);
                        mag_valid <= '0';
                    end if;
                end if;
            elsif (stage = DELAY) then
                delay_counter <= delay_counter + 1;
                if (delay_counter = boot_delay) then
                    stage <= BOOT;
                    delay_counter <= 1;
                    delay_climit <= 10000000;
                end if; 
            elsif (stage = BOOT) then
                stage_next <= CONFIG1;
                stage <= BUSY;
                read_write <= '0';
                nbytes_i <= 1;
                reg_addr <= REG_INT_ENABLE;
                x_valid <= '1';
                addr <= "1101000";
                data_in(7 downto 0) <= "00000001"; -- enable data ready interrupt
            elsif (stage = CONFIG1) then
                stage_next <= CONFIG2;
                stage <= BUSY;
                read_write <= '0';
                nbytes_i <= 1;
                reg_addr <= REG_INT_PIN_CFG;
                x_valid <= '1';
                addr <= "1101000";
                data_in(7 downto 0) <= "00110000"; -- enable int latch and any read clears
            elsif (stage = CONFIG2) then
                stage_next <= CONFIG3;
                stage <= BUSY;
                read_write <= '0';
                nbytes_i <= 1;
                reg_addr <= REG_PWR_MGMNT_1;
                x_valid <= '1';
                addr <= "1101000";
                data_in(7 downto 0) <= "00000001"; -- select x axis gyroscope reference for clock
            elsif (stage = CONFIG3) then
                stage_next <= READ_OFF_GYR;
                stage <= BUSY;
                read_write <= '0';
                nbytes_i <= 1;
                reg_addr <= REG_GYRO_CONFIG;
                x_valid <= '1';
                addr <= "1101000";
                data_in(7 downto 0) <= "00010000"; -- select 0b10 FS (1000 deg/s)
            elsif (stage = CONFIG4) then
                stage_next <= READ_OFF_GYR;
                stage <= BUSY;
                read_write <= '0';
                nbytes_i <= 1;
                reg_addr <= REG_ACEL_CONFIG;
                addr <= "1101000";
                data_in(7 downto 0) <= "00010000";
            elsif (stage = CONFIG5) then
                stage_next <= READ_OFF_GYR;
                stage <= BUSY;
                read_write <= '0';
                nbytes_i <= 1;
                reg_addr <= REG_FIFO_CONFIG;
                addr <= "1101000";
                data_in(7 downto 0) <= "00000000";
            
                
            elsif (stage = READ_OFF_GYR) then
                stage_next <= READ_OFF_ACEL0;
                stage <= BUSY;
                read_write <= '1';
                nbytes_i <= 6;
                reg_addr <= REG_GYRO_OFFSET;
                x_valid <= '1';
                addr <= "1101000";
                data_in <= (others => '0'); -- select 0b10 FS (1000 deg/s)    
            elsif (stage = READ_OFF_ACEL0) then
                stage_next <= READ_OFF_ACEL1;
                stage <= BUSY;
                read_write <= '1';
                nbytes_i <= 2;
                reg_addr <= REG_ACEL0_OFFSET;
                x_valid <= '1';
                addr <= "1101000";
                data_in <= (others => '0'); -- select 0b10 FS (1000 deg/s)
            elsif (stage = READ_OFF_ACEL1) then
                stage_next <= READ_OFF_ACEL2;
                stage <= BUSY;
                read_write <= '1';
                nbytes_i <= 2;
                reg_addr <= REG_ACEL1_OFFSET;
                x_valid <= '1';
                addr <= "1101000";
                data_in <= (others => '0'); -- select 0b10 FS (1000 deg/s)
            elsif (stage = READ_OFF_ACEL2) then
                stage_next <= READ_GYRO;
                stage <= BUSY;
                read_write <= '1';
                nbytes_i <= 2;
                reg_addr <= REG_ACEL2_OFFSET;
                x_valid <= '1';
                addr <= "1101000";
                data_in <= (others => '0'); -- select 0b10 FS (1000 deg/s)        
                
                
            elsif (stage = CONFIG0_MAG) then
                stage_next <= READ_OFF_MAG;
                stage <= BUSY;
                read_write <= '0';
                nbytes_i <= 1;
                reg_addr <= REG_MAG_CRTL;
                addr <= "0001100";
                data_in(7 downto 0) <= "00010110";
            elsif (stage = READ_OFF_MAG) then
                stage_next <= READ_GYRO;
                stage <= BUSY;
                read_write <= '1';
                nbytes_i <= 3;
                reg_addr <= REG_GYRO;
                x_valid <= '1';
                addr <= "1101000";
                data_in <= (others => '0'); -- select 0b10 FS (1000 deg/s)
                
                
            elsif (stage = READ_GYRO) then
                
                stage <= BUSY;
                read_write <= '1';
                nbytes_i <= 6;
                reg_addr <= REG_GYRO;
                x_valid <= '1';
                addr <= "1101000";
                data_in <= (others => '0'); -- select 0b10 FS (1000 deg/s)
                delay_climit <= 200000;--50000;
                delay_accel <= delay_accel + 1;
                if (delay_accel = 0) then
                    stage_next <= READ_ACEL ;
                    delay_accel <= 0;
                else
                    stage_next <= MAIN_DONE;
                end if;
            elsif (stage = READ_ACEL) then
                    stage_next <= MAIN_DONE;
                    stage <= BUSY;
                    read_write <= '1';
                    nbytes_i <= 6;
                    reg_addr <= REG_ACEL;
                    x_valid <= '1';
                    addr <= "1101000";
                data_in <= (others => '0'); -- select 0b10 FS (1000 deg/s)
            elsif (stage = READ_MAG) then
                stage_next <= MAIN_DONE;
                stage <= BUSY;
                read_write <= '1';
                nbytes_i <= 6;
                reg_addr <= REG_MAG;
                x_valid <= '1';
                addr <= "0001100";
                data_in <= (others => '0'); -- select 0b10 FS (1000 deg/s)
            elsif (stage = MAIN_DONE) then
                delay_counter <= delay_counter + 1;
                if (delay_counter = delay_climit or mpu6050_interrupt = '1') then
                    stage <= READ_GYRO;
                    delay_counter <= 2;
                end if; 
            elsif (stage = MAIN_START) then
                delay_counter <= delay_counter + 1;
                if (delay_counter = delay_climit) then
                    stage <= stage_next;
                    delay_counter <= 3;
                end if; 
            elsif (stage = RECOVERING_ERROR) then
                stage <= DELAY;
            end if;
        end if;
    end process;
   
   
   
   I2C_U: i2c_top
     generic map (
        MAX_DATA_SIZE_BYTES  => MAX_DATA_SIZE_BYTES
     )
     Port map(
        clk100      => clk_100, 
        rstn_100    => rstn_100,
        
        nbytes_i   => nbytes_i,
        addr       => addr,
        data_in    => data_in,
        data_out   => data_out,
        read_write => read_write,
        x_valid    => x_valid,
        bus_ready  => bus_ready,
        x_done     => x_done,
        x_err      => x_err,
        has_reg    => has_reg,
        reg_addr   => reg_addr,
        
        sda       => sda,
        scl       => scl
     );
   
   
   
end rtl;
			
		