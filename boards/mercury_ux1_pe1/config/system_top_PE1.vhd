---------------------------------------------------------------------------------------------------
-- Project          : Mercury+ XU1 Reference Design
-- File description : Top Level
-- File name        : system_top_PE1.vhd
-- Author           : Diana Ungureanu
---------------------------------------------------------------------------------------------------
-- Copyright (c) 2018 by Enclustra GmbH, Switzerland. All rights are reserved. 
-- Unauthorized duplication of this document, in whole or in part, by any means is prohibited
-- without the prior written permission of Enclustra GmbH, Switzerland.
-- 
-- Although Enclustra GmbH believes that the information included in this publication is correct
-- as of the date of publication, Enclustra GmbH reserves the right to make changes at any time
-- without notice.
-- 
-- All information in this document may only be published by Enclustra GmbH, Switzerland.
---------------------------------------------------------------------------------------------------
-- Description:
-- This is a top-level file for Mercury+ XU1 Reference Design
--    
---------------------------------------------------------------------------------------------------
-- File history:
--
-- Version | Date       | Author           | Remarks
-- ------------------------------------------------------------------------------------------------
-- 1.0     | 24.04.2016 | D. Ungureanu     | First released version
-- 2.0     | 20.10.2017 | D. Ungureanu     | Consistency checks
-- 3.0     | 11.06.2018 | D. Ungureanu     | Consistency checks
--
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- libraries
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

---------------------------------------------------------------------------------------------------
-- entity declaration
---------------------------------------------------------------------------------------------------

entity system_top is
  port (
  
  	-------------------------------------------------------------------------------------------
	-- processor system
	-------------------------------------------------------------------------------------------
	
	-- LEDs
	Led2_N							: out	std_logic;

    -- I2C on PL side
    I2c_Scl							: inout	std_logic;
    I2c_Sda							: inout	std_logic
  );
end system_top;

---------------------------------------------------------------------------------------------------
-- architecture declaration
---------------------------------------------------------------------------------------------------

architecture rtl of system_top is

  component system is
  port (
    pl_resetn0 : out std_logic;
    pl_clk1 : out std_logic;
    gpio : out std_logic_vector ( 7 downto 0 )
  );
  end component system;
  
-----------------------------------------------------------------------------------------------
-- signals
-----------------------------------------------------------------------------------------------

  signal Rst_N 			: std_logic := '1';
  
  signal Rst            : std_logic := '0';
  signal Clk			: std_logic;
  signal RstCnt         : unsigned (15 downto 0) := (others => '0');
  signal LedCount       : unsigned (23 downto 0);  
  
  signal Gpio			: std_logic_vector (7 downto 0);
  
begin

-----------------------------------------------------------------------------------------------
-- processor system
-----------------------------------------------------------------------------------------------	

	MercuryXU1_i: component system
       port map (
        gpio(7 downto 0) => Gpio(7 downto 0),
        pl_clk1 => Clk,
        pl_resetn0 => Rst_N
      );

    ------------------------------------------------------------------------------------------------
    --  Clock and Reset
    ------------------------------------------------------------------------------------------------ 

    process (Clk)
    begin
        if rising_edge (Clk) then
            if (not RstCnt) = 0 then
                Rst         <= '0';
            else
                Rst         <= '1';
                RstCnt      <= RstCnt + 1;
            end if;
        end if;
    end process;
    
    ------------------------------------------------------------------------------------------------
    -- Blinking LED counter & LED assignment
    ------------------------------------------------------------------------------------------------
   
    process (Clk)
    begin
        if rising_edge (Clk) then
            if Rst = '1' then
                LedCount    <= (others => '0');
            else
                LedCount <= LedCount + 1;
            end if;
        end if;
    end process;
    
    Led2_N <= LedCount(23);	
--    Led2_N <= Gpio(2);


    I2c_Sda <= 'Z';
    I2c_Scl <= 'Z';
	
	-- --LVDS example
	-- -- note: only diff inputs supported in HD banks
	--LDVS_in : IBUFDS 
	--port map (
	--	O  => IO_B48_L5_HDGC_in,
	--	I  => IO_B48_L5_HDGC_E12_P,
	--	IB => IO_B48_L5_HDGC_D12_N
    --);
	
end rtl;


---------------------------------------------------------------------------------------------------
-- eof
---------------------------------------------------------------------------------------------------

