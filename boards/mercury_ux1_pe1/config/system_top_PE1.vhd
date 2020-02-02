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
    I2c_Sda							: inout	std_logic;
    
	-- Bank 64
	IO_B64_AG4						: inout	std_logic       := 'Z';
	IO_B64_AG9						: inout	std_logic       := 'Z';
	IO_B64_AH11						: inout	std_logic       := 'Z';
	IO_B64_AJ1						: inout	std_logic       := 'Z';
	IO_B64_L10_AD4_AK8_N			: inout	std_logic       := 'Z';
	IO_B64_L10_AD4_AK9_P			: inout	std_logic       := 'Z';
	IO_B64_L11_GC_AH7_P				: inout	std_logic       := 'Z';
	IO_B64_L11_GC_AJ7_N				: inout	std_logic       := 'Z';
	IO_B64_L12_GC_AG8_P				: inout	std_logic       := 'Z';
	IO_B64_L12_GC_AH8_N				: inout	std_logic       := 'Z';
	IO_B64_L13_GC_AG5_N				: inout	std_logic       := 'Z';
	IO_B64_L13_GC_AG6_P				: inout	std_logic       := 'Z';
	IO_B64_L14_GC_AH6_P				: inout	std_logic       := 'Z';
	IO_B64_L14_GC_AJ6_N				: inout	std_logic       := 'Z';
	IO_B64_L15_AD11_AK6_N			: inout	std_logic       := 'Z';
	IO_B64_L15_AD11_AK7_P			: inout	std_logic       := 'Z';
	IO_B64_L16_AD3_AF5_N			: inout	std_logic       := 'Z';
	IO_B64_L16_AD3_AF6_P			: inout	std_logic       := 'Z';
	IO_B64_L17_AD10_AJ5_P			: inout	std_logic       := 'Z';
	IO_B64_L17_AD10_AK5_N			: inout	std_logic       := 'Z';
	IO_B64_L18_AD2_AH4_P			: inout	std_logic       := 'Z';
	IO_B64_L18_AD2_AJ4_N			: inout	std_logic       := 'Z';
	IO_B64_L19_AD9_AK3_N			: inout	std_logic       := 'Z';
	IO_B64_L19_AD9_AK4_P			: inout	std_logic       := 'Z';
	IO_B64_L1_AF11_P				: inout	std_logic       := 'Z';
	IO_B64_L1_AG11_N				: inout	std_logic       := 'Z';
	IO_B64_L20_AD1_AH2_N			: inout	std_logic       := 'Z';
	IO_B64_L20_AD1_AH3_P			: inout	std_logic       := 'Z';
	IO_B64_L21_AD8_AJ2_P			: inout	std_logic       := 'Z';
	IO_B64_L21_AD8_AK2_N			: inout	std_logic       := 'Z';
	IO_B64_L22_AD0_AG1_P			: inout	std_logic       := 'Z';
	IO_B64_L22_AD0_AH1_N			: inout	std_logic       := 'Z';
	IO_B64_L23_AF3_P				: inout	std_logic       := 'Z';
	IO_B64_L23_AG3_N				: inout	std_logic       := 'Z';
	IO_B64_L24_AF1_N				: inout	std_logic       := 'Z';
	IO_B64_L24_AF2_P				: inout	std_logic       := 'Z';
	IO_B64_L2_AG13_P				: inout	std_logic       := 'Z';
	IO_B64_L2_AH13_N				: inout	std_logic       := 'Z';
	IO_B64_L3_AD15_AH12_P			: inout	std_logic       := 'Z';
	IO_B64_L3_AD15_AJ12_N			: inout	std_logic       := 'Z';
	IO_B64_L4_AD7_AK12_N			: inout	std_logic       := 'Z';
	IO_B64_L4_AD7_AK13_P			: inout	std_logic       := 'Z';
	IO_B64_L5_AD14_AJ11_P			: inout	std_logic       := 'Z';
	IO_B64_L5_AD14_AK11_N			: inout	std_logic       := 'Z';
	IO_B64_L6_AD6_AJ10_P			: inout	std_logic       := 'Z';
	IO_B64_L6_AD6_AK10_N			: inout	std_logic       := 'Z';
	IO_B64_L7_AD13_AF7_N			: inout	std_logic       := 'Z';
	IO_B64_L7_AD13_AF8_P			: inout	std_logic       := 'Z';
	IO_B64_L8_AD5_AF10_P			: inout	std_logic       := 'Z';
	IO_B64_L8_AD5_AG10_N			: inout	std_logic       := 'Z';
	IO_B64_L9_AD12_AH9_P			: inout	std_logic       := 'Z';
	IO_B64_L9_AD12_AJ9_N			: inout	std_logic       := 'Z';
	
	-- Bank 65
	IO_B65_AE1						: inout	std_logic       := 'Z';
	IO_B65_AE7						: inout	std_logic       := 'Z';
	IO_B65_L10_AD4_AA7_N			: inout	std_logic       := 'Z';
	IO_B65_L10_AD4_AA8_P			: inout	std_logic       := 'Z';
	IO_B65_L11_GC_AC7_P				: inout	std_logic       := 'Z';
	IO_B65_L11_GC_AD7_N				: inout	std_logic       := 'Z';
	IO_B65_L12_GC_AB8_P				: inout	std_logic       := 'Z';
	IO_B65_L12_GC_AC8_N				: inout	std_logic       := 'Z';
	IO_B65_L13_GC_AB5_N				: inout	std_logic       := 'Z';
	IO_B65_L13_GC_AB6_P				: inout	std_logic       := 'Z';
	IO_B65_L14_GC_AC6_P				: inout	std_logic       := 'Z';
	IO_B65_L14_GC_AD6_N				: inout	std_logic       := 'Z';
	IO_B65_L15_AD11_AA5_N			: inout	std_logic       := 'Z';
	IO_B65_L15_AD11_AA6_P			: inout	std_logic       := 'Z';
	IO_B65_L16_AD3_AD5_P			: inout	std_logic       := 'Z';
	IO_B65_L16_AD3_AE5_N			: inout	std_logic       := 'Z';
	IO_B65_L17_AD10_AD4_P			: inout	std_logic       := 'Z';
	IO_B65_L17_AD10_AE4_N			: inout	std_logic       := 'Z';
	IO_B65_L18_AD2_AB4_P			: inout	std_logic       := 'Z';
	IO_B65_L18_AD2_AC4_N			: inout	std_logic       := 'Z';
	IO_B65_L19_AD9_AB3_P			: inout	std_logic       := 'Z';
	IO_B65_L19_AD9_AC3_N			: inout	std_logic       := 'Z';
	IO_B65_L1_AB13_P				: inout	std_logic       := 'Z';
	IO_B65_L1_AC13_N				: inout	std_logic       := 'Z';
	IO_B65_L20_AD1_AE2_N			: inout	std_logic       := 'Z';
	IO_B65_L20_AD1_AE3_P			: inout	std_logic       := 'Z';
	IO_B65_L21_AD8_AC2_P			: inout	std_logic       := 'Z';
	IO_B65_L21_AD8_AD2_N			: inout	std_logic       := 'Z';
	IO_B65_L22_AD0_AC1_P			: inout	std_logic       := 'Z';
	IO_B65_L22_AD0_AD1_N			: inout	std_logic       := 'Z';
	IO_B65_L23_AA2_N				: inout	std_logic       := 'Z';
	IO_B65_L23_SCLK_AA3_P			: inout	std_logic       := 'Z';
	IO_B65_L24_PERST_AB1_N_n		: inout	std_logic       := 'Z';
	IO_B65_L24_SDA_AA1_P			: inout	std_logic       := 'Z';
	IO_B65_L2_AE13_P				: inout	std_logic       := 'Z';
	IO_B65_L2_AF13_N				: inout	std_logic       := 'Z';
	IO_B65_L3_AD15_AD12_P			: inout	std_logic       := 'Z';
	IO_B65_L3_AD15_AE12_N			: inout	std_logic       := 'Z';
	IO_B65_L4_AD7_AC11_P			: inout	std_logic       := 'Z';
	IO_B65_L4_AD7_AD11_N			: inout	std_logic       := 'Z';
	IO_B65_L5_AD14_AA11_N			: inout	std_logic       := 'Z';
	IO_B65_L5_AD14_AA12_P			: inout	std_logic       := 'Z';
	IO_B65_L6_AD6_AB10_N			: inout	std_logic       := 'Z';
	IO_B65_L6_AD6_AB11_P			: inout	std_logic       := 'Z';
	IO_B65_L7_AD13_AB9_P			: inout	std_logic       := 'Z';
	IO_B65_L7_AD13_AC9_N			: inout	std_logic       := 'Z';
	IO_B65_L8_AD5_AD10_P			: inout	std_logic       := 'Z';
	IO_B65_L8_AD5_AE10_N			: inout	std_logic       := 'Z';
	IO_B65_L9_AD12_AD9_P			: inout	std_logic       := 'Z';
	IO_B65_L9_AD12_AE9_N			: inout	std_logic       := 'Z';
	
	-- Bank 66
	IO_B66_L10_AD4_U6_N				: inout	std_logic       := 'Z';
	IO_B66_L10_AD4_U7_P				: inout	std_logic       := 'Z';
	IO_B66_L11_GC_V6_N				: inout	std_logic       := 'Z';
	IO_B66_L11_GC_V7_P				: inout	std_logic       := 'Z';
	IO_B66_L12_GC_W6_N				: inout	std_logic       := 'Z';
	IO_B66_L12_GC_W7_P				: inout	std_logic       := 'Z';
	IO_B66_L13_GC_U8_P				: inout	std_logic       := 'Z';
	IO_B66_L13_GC_V8_N				: inout	std_logic       := 'Z';
	IO_B66_L14_GC_Y8_N				: inout	std_logic       := 'Z';
	IO_B66_L14_GC_Y9_P				: inout	std_logic       := 'Z';
	IO_B66_L15_AD11_U11_P			: inout	std_logic       := 'Z';
	IO_B66_L15_AD11_V11_N			: inout	std_logic       := 'Z';
	IO_B66_L16_AD3_W10_N			: inout	std_logic       := 'Z';
	IO_B66_L16_AD3_W11_P			: inout	std_logic       := 'Z';
	IO_B66_L17_AD10_U9_P			: inout	std_logic       := 'Z';
	IO_B66_L17_AD10_V9_N			: inout	std_logic       := 'Z';
	IO_B66_L18_AD2_T11_P			: inout	std_logic       := 'Z';
	IO_B66_L18_AD2_U10_N			: inout	std_logic       := 'Z';
	IO_B66_L19_AD9_T10_N			: inout	std_logic       := 'Z';
	IO_B66_L19_AD9_R10_P			: inout	std_logic       := 'Z';
	IO_B66_L1_Y3_N					: inout	std_logic       := 'Z';
	IO_B66_L1_Y4_P					: inout	std_logic       := 'Z';
	IO_B66_L20_AD1_P10_N			: inout	std_logic       := 'Z';
	IO_B66_L20_AD1_P11_P			: inout	std_logic       := 'Z';
	IO_B66_L21_AD8_M12_N			: inout	std_logic       := 'Z';
	IO_B66_L21_AD8_N12_P			: inout	std_logic       := 'Z';
	IO_B66_L22_AD0_M10_N			: inout	std_logic       := 'Z';
	IO_B66_L22_AD0_N10_P			: inout	std_logic       := 'Z';
	IO_B66_L23_L11_N				: inout	std_logic       := 'Z';
	IO_B66_L23_L12_P				: inout	std_logic       := 'Z';
	IO_B66_L24_K10_N				: inout	std_logic       := 'Z';
	IO_B66_L24_L10_P				: inout	std_logic       := 'Z';
	IO_B66_L2_Y1_N					: inout	std_logic       := 'Z';
	IO_B66_L2_Y2_P					: inout	std_logic       := 'Z';
	IO_B66_L3_AD15_W1_N				: inout	std_logic       := 'Z';
	IO_B66_L3_AD15_W2_P				: inout	std_logic       := 'Z';
	IO_B66_L4_AD7_V1_N				: inout	std_logic       := 'Z';
	IO_B66_L4_AD7_V2_P				: inout	std_logic       := 'Z';
	IO_B66_L5_AD14_U2_P				: inout	std_logic       := 'Z';
	IO_B66_L5_AD14_U3_N				: inout	std_logic       := 'Z';
	IO_B66_L6_AD6_T1_P				: inout	std_logic       := 'Z';
	IO_B66_L6_AD6_U1_N				: inout	std_logic       := 'Z';
	IO_B66_L7_AD13_W5_P				: inout	std_logic       := 'Z';
	IO_B66_L7_AD13_Y5_N				: inout	std_logic       := 'Z';
	IO_B66_L8_AD5_V4_P				: inout	std_logic       := 'Z';
	IO_B66_L8_AD5_W4_N				: inout	std_logic       := 'Z';
	IO_B66_L9_AD12_U4_N				: inout	std_logic       := 'Z';
	IO_B66_L9_AD12_U5_P				: inout	std_logic       := 'Z';
	IO_B66_N11						: inout	std_logic       := 'Z';
	IO_B66_Y10						: inout	std_logic       := 'Z';
	
	-- Bank 48
	IO_B48_L10_AD10_G11_N				: inout	std_logic       := 'Z';
	IO_B48_L10_AD10_H12_P				: inout	std_logic       := 'Z';
	IO_B48_L11_AD9_H11_N				: inout	std_logic       := 'Z';
	IO_B48_L11_AD9_J12_P				: inout	std_logic       := 'Z';
	IO_B48_L12_AD8_J10_N				: inout	std_logic       := 'Z';
	IO_B48_L12_AD8_J11_P				: inout	std_logic       := 'Z';
	IO_B48_L1_AD15_B11_N				: inout	std_logic       := 'Z';
	IO_B48_L1_AD15_C12_P				: inout	std_logic       := 'Z';
	IO_B48_L2_AD14_A11_N				: inout	std_logic       := 'Z';
	IO_B48_L2_AD14_A12_P				: inout	std_logic       := 'Z';
	IO_B48_L3_AD13_A10_N				: inout	std_logic       := 'Z';
	IO_B48_L3_AD13_B10_P				: inout	std_logic       := 'Z';
	IO_B48_L4_AD12_C11_N				: inout	std_logic       := 'Z';
	IO_B48_L4_AD12_D11_P				: inout	std_logic       := 'Z';
	IO_B48_L5_HDGC_D12_N				: inout	std_logic       := 'Z';
	IO_B48_L5_HDGC_E12_P				: inout	std_logic       := 'Z';
	IO_B48_L6_HDGC_D10_N				: inout	std_logic       := 'Z';
	IO_B48_L6_HDGC_E10_P				: inout	std_logic       := 'Z';
	IO_B48_L7_HDGC_F11_N				: inout	std_logic       := 'Z';
	IO_B48_L7_HDGC_F12_P				: inout	std_logic       := 'Z';
	IO_B48_L8_HDGC_F10_N				: inout	std_logic       := 'Z';
	IO_B48_L8_HDGC_G10_P				: inout	std_logic       := 'Z';
	IO_B48_L9_AD11_K12_N				: inout	std_logic       := 'Z';
	IO_B48_L9_AD11_K13_P				: inout	std_logic       := 'Z';
	
	-- Bank 47
	IO_B47_L10_AD2_J15_N				: inout	std_logic       := 'Z';
	IO_B47_L10_AD2_K15_P				: inout	std_logic       := 'Z';
	IO_B47_L11_AD1_J14_N				: inout	std_logic       := 'Z';
	IO_B47_L11_AD1_K14_P				: inout	std_logic       := 'Z';
	IO_B47_L12_AD0_H13_N				: inout	std_logic       := 'Z';
	IO_B47_L12_AD0_H14_P				: inout	std_logic       := 'Z';
	IO_B47_L1_AD11_A15_N				: inout	std_logic       := 'Z';
	IO_B47_L1_AD11_B15_P				: inout	std_logic       := 'Z';
	IO_B47_L2_AD10_A14_N				: inout	std_logic       := 'Z';
	IO_B47_L2_AD10_B14_P				: inout	std_logic       := 'Z';
	IO_B47_L3_AD9_A13_N					: inout	std_logic       := 'Z';
	IO_B47_L3_AD9_B13_P					: inout	std_logic       := 'Z';
	IO_B47_L4_AD8_C13_N					: inout	std_logic       := 'Z';
	IO_B47_L4_AD8_C14_P					: inout	std_logic       := 'Z';
	IO_B47_L5_HDGC_AD7_D14_N			: inout	std_logic       := 'Z';
	IO_B47_L5_HDGC_AD7_D15_P			: inout	std_logic       := 'Z';
	IO_B47_L6_HDGC_AD6_E13_N			: inout	std_logic       := 'Z';
	IO_B47_L6_HDGC_AD6_E14_P			: inout	std_logic       := 'Z';
	IO_B47_L7_HDGC_AD5_E15_N			: inout	std_logic       := 'Z';
	IO_B47_L7_HDGC_AD5_F15_P			: inout	std_logic       := 'Z';
	IO_B47_L8_HDGC_AD4_F13_N			: inout	std_logic       := 'Z';
	IO_B47_L8_HDGC_AD4_G13_P			: inout	std_logic       := 'Z';
	IO_B47_L9_AD3_G14_N					: inout	std_logic       := 'Z';
	IO_B47_L9_AD3_G15_P					: inout	std_logic       := 'Z'
	
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

