
library IEEE;               
use IEEE.STD_LOGIC_1164.ALL;
library ieee_proposed;
USE ieee.numeric_std.ALL;

entity esp_dshot is
generic (
    DELAY_BETWEEN_FRAME : integer := 2
);
port (
       clk_100          : in  std_logic;
       rstn_100         : in  std_logic;
       grade            : in  std_logic_vector(7 downto 0);
       enabled          : in  std_logic;
       update           : in  std_logic;
       request_tele     : in  std_logic;
       speed            : in  std_logic_vector(11 downto 0);
       ack              : out std_logic;
       pin_out          : out std_logic
);
end esp_dshot;

			
architecture rtl of esp_dshot is
    type array_int is array (0 to 3) of integer ;
   -- grade 0 => 1200 (312-625 : 835), 600 (625 1250 : 1670), 300 (1250 - 2500: 3340), 150 (2500 - 5000: 6680)
   constant ZHIGH_SIG : array_int  := (31, 62,  125,  250);
   constant OHIGH_SIG : array_int := (62, 125, 250, 500);
   constant BIT_SIG : array_int := (83, 167, 334, 668);
   constant LOOP_SIG : array_int := (2500, 5000, 10000, 20000);
   
   TYPE STATE_TYPE IS (IDLE, UPDATEPARAM, UPDATETELE, CRC, PREPARE, DELAY0, DELAY1, ACTIVE, DELAY);
   SIGNAL state   : STATE_TYPE;
   
   signal grade_int : integer range 0 to 3 := 0;
   signal digital_signal, digital_buf, digital_shift : std_logic_vector(15 downto 0) := (others => '0');
   signal high_int : integer range 0 to 100000*2 := OHIGH_SIG(0);
   signal low_int : integer range 0 to 250000*2 := ZHIGH_SIG(0);
   signal count_int : integer := 0;
   signal count_bit : integer range 0 to 15:= 0;
   signal length_bit : integer := BIT_SIG(0);
   signal length_sig : integer := LOOP_SIG(0);
   
   
   signal bit_active, stream_done : std_logic :='0';
   
   signal needs_update, update_delayed, acked : std_logic := '0';
   signal needs_tele, tele_delayed, tele_acked : std_logic := '0';
   
   --type array_int16 is array (0 to 15) of integer ;
   --signal bit_limits : array_int16 := (others => 0);
   --signal bit_high_limits : array_int16 := (others => 0);
   signal bit_limit, bit_high_limit : integer := 0;
begin

   update_state : process(clk_100, rstn_100)
    
    begin
        if (rstn_100 = '0') then
            state <= IDLE;
            digital_signal <= (others => '0');
            low_int <= ZHIGH_SIG(0);
            high_int  <= OHIGH_SIG(0);
            length_bit <= BIT_SIG(0);
            length_sig <= LOOP_SIG(0);
            acked <= '0';
            tele_acked <= '0';
        elsif (rising_edge (clk_100) ) then
            case state is 
                when IDLE =>
                    if (enabled = '1') then
                        state <= UPDATEPARAM;
                    end if;
                when UPDATEPARAM => 
                    if (needs_update = '0') then
                        state <= UPDATETELE;
                        acked <= '0';
                    elsif (needs_update = '1') then
                        acked <= '1';
                        digital_signal(15 downto 5) <= digital_buf(15 downto 5);
                        digital_signal(3 downto 0) <= "0000";
                        low_int  <= ZHIGH_SIG(grade_int);
                        high_int <= OHIGH_SIG(grade_int);
                        length_bit <= BIT_SIG(grade_int);
                        length_sig <= LOOP_SIG(grade_int);
                    end if;
               when UPDATETELE =>
                    if (needs_tele = '0') then
                        state <= CRC;
                        tele_acked <= '0';
                    elsif (needs_tele = '1') then
                        tele_acked <= '1';
                        digital_signal(4) <= '1';
                    end if;
                when CRC => 
                    digital_signal(3 downto 0) <= digital_signal(15 downto 12) xor digital_signal(11 downto 8)
                                xor digital_signal(7 downto 4);
                    state <= PREPARE;
                when PREPARE =>
                    --limits_bracket : for I in 0 to 15 loop
                    --    bit_limits(I) <= (15-I) * length_bit;
                    --end loop limits_bracket;
                    state <= DELAY0;
                when DELAY0 =>
                    --limits_bracket2 : for I in 0 to 15 loop
                    --    bit_limits(I) <= bit_limits(I) + length_bit;
                    --    if digital_signal(I) = '1'  then
                    --        bit_high_limits(I) <= bit_limits(I) + high_int;
                    --     else
                    --        bit_high_limits(I) <= bit_limits(I) + low_int;
                    --     end if;
                    --end loop limits_bracket2;
                    state <= DELAY1;
                    
                when DELAY1 =>
                    state <= ACTIVE;
                when ACTIVE =>
                    if (stream_done = '1') then
                        state <= DELAY;
                    end if;
                
                when DELAY =>
                    state <= DELAY1;
                    if (digital_signal(4) = '1') then
                        digital_signal(4) <= '0';
                        state <= CRC;
                    end if;
                    if (needs_update = '1') then
                        state <= UPDATEPARAM;
                    end if;
                    if (enabled = '0') then
                        state <= IDLE;
                    end if;
            end case;
        end if;
    end process;

   update_param: process(clk_100, rstn_100)
    
    begin
        if (rstn_100 = '0') then
            grade_int <= 0;
            needs_update <= '0';
            update_delayed <= '0';
            digital_buf <= (others => '0');
        elsif rising_edge (clk_100) then
            update_delayed <= update;
            ack <= '0';
            if (update_delayed = '0' and update = '1') then
                grade_int <= to_integer(unsigned(grade));
                digital_buf(15 downto 5) <= speed(11 downto 1);
                needs_update <= '1';
            elsif (acked = '1') then
                needs_update <= '0';
                ack <= '1';
            end if;
            
            tele_delayed <= request_tele;
            if (update_delayed = '0' and update = '1') then
                needs_tele <= '1';
            elsif (tele_acked = '1') then
                needs_tele <= '0';
            end if;
            
        end if;
    end process;
    
    update_ticks: process(clk_100, rstn_100)
    
    begin
        if (rstn_100 = '0') then
            count_int <= 0;
            stream_done <= '0';
            count_bit <= 15;
            pin_out <= '0';
            bit_limit <= 0;
            bit_high_limit <= 0;
            digital_shift <= (others => '0');
        elsif (rising_edge (clk_100) ) then
            if (state = ACTIVE) then
                count_int <= count_int + 1;
            else
                count_int <= 0;
            end if;
            
            pin_out <= '0';
            if (state = ACTIVE) then
                if (count_int > length_sig) then
                    stream_done <= '1';
                end if;
                if (count_int < bit_high_limit) then
                    pin_out <= '1';
                else
                    pin_out <= '0';
                end if; 
                if (count_bit > 0) then
                    if (count_int = bit_limit) then
                        count_bit <= count_bit - 1;
                        bit_limit <= bit_limit + length_bit;
                        digital_shift(15 downto 1) <= digital_shift(14 downto 0);
                        if (digital_shift(15) = '0') then
                            bit_high_limit <= bit_limit + low_int;
                        else
                            bit_high_limit <= bit_limit + high_int;
                        end if;
                    end if; 
                end if;
            else
                count_bit <= 15;
                stream_done <= '0';
                bit_limit <= length_bit;
                digital_shift(15 downto 1) <= digital_signal(14 downto 0);
                if (digital_signal(15) = '0') then
                    bit_high_limit <= low_int;
                else
                    bit_high_limit <= high_int;
                end if;
            end if;
        end if;
    end process;
 

  
end rtl;
			
			