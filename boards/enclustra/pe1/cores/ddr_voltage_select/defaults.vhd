library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity DDR3_PE1 is
  
  port (
 DDR3_VSEL                      : inout   std_logic;

);
end DDR3_PE1;

architecture rtl of DDR3_PE1 is


  DDR3_VSEL <= 'Z';



end rtl;

