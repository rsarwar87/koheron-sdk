----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.11.2018 18:28:22
-- Design Name: 
-- Module Name: tb_fulltest - Behavioral
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
use ieee.numeric_std.all;
library xil_defaultlib;
use STD.textio.all;
use ieee.std_logic_textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_full_synt is
--  Port ( );
end tb_full_synt;

architecture Behavioral of tb_full_synt is

component system_psa_core_0_0 is
  port (
    CLK : in STD_LOGIC;
    RST : in STD_LOGIC;
    ADC0_IN : in STD_LOGIC_VECTOR ( 13 downto 0 );
    ADC1_IN : in STD_LOGIC_VECTOR ( 13 downto 0 );
    ADC2_IN : in STD_LOGIC_VECTOR ( 13 downto 0 );
    ADC3_IN : in STD_LOGIC_VECTOR ( 13 downto 0 );
    CONFIG0 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    CONFIG1 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    CONFIG2 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    CONFIG3 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    TIMEOUT : out STD_LOGIC_VECTOR ( 31 downto 0 );
    DMA_FULLNESS_0 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    DMA_FULLNESS_1 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    DMA_FULLNESS_2 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    DMA_FULLNESS_3 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_psa_tvalid : out STD_LOGIC;
    m_psa_tlast : out STD_LOGIC;
    m_psa_tready : in STD_LOGIC;
    m_psa_tdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    m_adc_tvalid : out STD_LOGIC;
    m_adc_tready : in STD_LOGIC;
    m_adc_tdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    clka : in STD_LOGIC;
    ena : in STD_LOGIC;
    wea : in STD_LOGIC_VECTOR ( 0 to 0 );
    addra : in STD_LOGIC_VECTOR ( 13 downto 0 );
    dina : in STD_LOGIC_VECTOR ( 31 downto 0 );
    rsta : in STD_LOGIC;
    douta : out STD_LOGIC_VECTOR ( 31 downto 0 );
    clkc : in STD_LOGIC;
    enc : in STD_LOGIC;
    wec : in STD_LOGIC_VECTOR ( 0 to 0 );
    addrc : in STD_LOGIC_VECTOR ( 13 downto 0 );
    dinc : in STD_LOGIC_VECTOR ( 31 downto 0 );
    rstc : in STD_LOGIC;
    doutc : out STD_LOGIC_VECTOR ( 31 downto 0 );
    clkd : in STD_LOGIC;
    en_d : in STD_LOGIC;
    wed : in STD_LOGIC_VECTOR ( 0 to 0 );
    addrd : in STD_LOGIC_VECTOR ( 13 downto 0 );
    dind : in STD_LOGIC_VECTOR ( 31 downto 0 );
    rstd : in STD_LOGIC;
    doutd : out STD_LOGIC_VECTOR ( 31 downto 0 );
    clkb : in STD_LOGIC;
    enb : in STD_LOGIC;
    web : in STD_LOGIC_VECTOR ( 0 to 0 );
    rstb : in STD_LOGIC;
    addrb : in STD_LOGIC_VECTOR ( 13 downto 0 );
    dinb : in STD_LOGIC_VECTOR ( 31 downto 0 );
    doutb : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  end component system_psa_core_0_0;
signal  clkb : STD_LOGIC;                        
signal  enb : STD_LOGIC := '0';                         
signal  web : STD_LOGIC := '0';                         
signal  rstb : STD_LOGIC := '0';                        
signal  addrb : STD_LOGIC_VECTOR (13 downto 0) := (others => '0');  
signal  dinb, doutb : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0'); 

signal m_psa_tvalid : STD_LOGIC := '0';
signal m_psa_tready : STD_LOGIC  := '1';
signal m_psa_tdata : STD_LOGIC_VECTOR (127 downto 0) := (others => '0');
signal m_adc_tvalid : STD_LOGIC := '0';
signal m_adc_tready : STD_LOGIC := '1';
signal m_adc_tdata : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
           
signal CLK : STD_LOGIC;
signal RST : STD_LOGIC := '1';
          
signal ADC0_IN : STD_LOGIC_VECTOR (13 downto 0);
signal ADC1_IN : STD_LOGIC_VECTOR (13 downto 0);
signal ADC2_IN : STD_LOGIC_VECTOR (13 downto 0);
signal ADC3_IN : STD_LOGIC_VECTOR (13 downto 0);
           
signal CONFIG0 : STD_LOGIC_VECTOR (63 downto 0);
signal CONFIG1 : STD_LOGIC_VECTOR (63 downto 0);
signal CONFIG2 : STD_LOGIC_VECTOR (63 downto 0);
signal CONFIG3 : STD_LOGIC_VECTOR (63 downto 0);
signal TIMEOUT : STD_LOGIC_VECTOR (31 downto 0);


signal DMA_FULLNESS_0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal DMA_FULLNESS_1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal DMA_FULLNESS_2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal DMA_FULLNESS_3 : STD_LOGIC_VECTOR(31 DOWNTO 0);
      
signal m_axis_aclk, m_axis_aresetn : std_logic;
constant CLK_PERIOD : time := 4 ns;

file file_VECTORS : text;
file file_RESULTS : text;

begin


     process
        variable v_ILINE     : line;
        variable v_OLINE     : line;
        variable v_ADD_TERM1 : std_logic_vector(13 downto 0);
        variable v_ADD_TERM2 : std_logic_vector(13 downto 0);
        variable v_SPACE     : character;
        variable v_value     : integer;
         
      begin
     
        file_open(file_VECTORS, "/media/2TB/workspace/rsarwar/Cf_output",  read_mode);
        wait for CLK_PERIOD*15; 
        while not endfile(file_VECTORS) loop
          readline(file_VECTORS, v_ILINE);
          read(v_ILINE, v_ADD_TERM1);
          --read(v_ILINE, v_SPACE);           -- read in the space character
          --read(v_ILINE, v_ADD_TERM2);
     
          -- Pass the variable to a signal to allow the ripple-carry to use it
          v_value := to_integer(unsigned(v_ADD_TERM1));
          v_value := 16384 - (v_value);
          v_value := 8192 - v_value;
          ADC0_IN <= std_logic_vector(to_signed(v_value, ADC0_IN'length)); --(13) & not v_ADD_TERM1(12 downto 0); 
          wait for CLK_PERIOD;
        end loop;
     
        file_close(file_VECTORS);
         
        wait;
      end process;

       -- Clock process definitions( clock with 50% duty cycle is generated here.
       Clk_process :process
       begin
            CLK <= '0';
            --adcin <= std_logic_vector(unsigned(adcin) + 1);
            wait for CLK_PERIOD/2;  --for half of clock period clk stays at '0'.
            CLK <= '1';
            wait for CLK_PERIOD/2;  --for next half of clock period clk stays at '1'.
       end process;

                                              

       -- Clock process definitions( clock with 50% duty cycle is generated here.
       Clk_process2 :process
       begin
            m_axis_aclk <= '0';
            --adcin <= std_logic_vector(unsigned(adcin) + 1);
            wait for CLK_PERIOD;  --for half of clock period clk stays at '0'.
            m_axis_aclk <= '1';
            wait for CLK_PERIOD;  --for next half of clock period clk stays at '1'.
       end process;

                      
    
    stim_proc: process
     begin        
            RST <= '0';
            
              CONFIG0( 3+32 downto  0+32) <= "1111";
          CONFIG0( 7+32 downto  4+32) <= "1010";                  -- FIFO Empty Flag
          CONFIG0(13+32 downto  8+32) <= "010100";                  -- FIFO Empty Flag
          CONFIG0(21+32 downto 14+32) <= "10100000";                  -- FIFO Empty Flag
          CONFIG0(29+32 downto 22+32) <= "10110100";                  -- FIFO Empty Flag
          
          CONFIG0(1 downto 0) <= "00";
          CONFIG0(15 downto 2) <= "00001111111111";
          CONFIG0(24 downto 16) <= "001111111";
          CONFIG0(28 downto 25) <= "0011";
          m_adc_tready <= '1';
          m_psa_tready <= '1';
           wait for CLK_PERIOD*15;
          RST <='1';                    --then apply reset for 2 clock cycles.
          wait for CLK_PERIOD*500; --wait for 10 clock cycles.
          
          RST <='1';                    --then apply reset for 2 clock cycles.
          wait for CLK_PERIOD*2000;
          RST <='0';
          wait for CLK_PERIOD*10;
          RST <='1';
          wait for CLK_PERIOD*100000; --wait for 10 clock cycles.
          wait;
    end process;

--CH_PSA : psa_core_v1_1 
--        port map (
--            CLK          => CLK,
--            RST          => RST,
            
--            ADC_IN       => ADC0_IN,
--            SETTINGS     => CONFIG0,
--            TIME_OUT     => TIMEOUT,
            
--            m_psa_tvalid => m_psa_tvalid,
--            m_psa_tready => m_adc_tready, --bus_psa_tready(I),
--            m_psa_tdata  => m_psa_tdata,
             
--            m_adc_tvalid => m_adc_tvalid,
--            m_adc_tready => m_adc_tready, --bus_adc_tready(I),
--            m_adc_tdata  => m_adc_m_psa_tdatatdata,
            
--            clkb         => clkb,
--            enb          => enb,
--            web(0)       => web,
--            addrb        => addrb(13 downto 0),
--            dinb         => dinb,
--            doutb        => doutb,
--            rstb         => rstb
--        );
U0: entity work.system_psa_core_0_0 

    Port map ( 
           CLK => CLK,
           RST => RST,
          -- \peripheral_aresetn[0]_repN_1_alias\ => '1',
          -- \peripheral_aresetn[0]_repN_2_alias\ => '1',
          -- \peripheral_aresetn[0]_repN_3_alias\ => '1',
          
           ADC0_IN => ADC0_IN,
           ADC1_IN => ADC1_IN,
           ADC2_IN => ADC2_IN,
           ADC3_IN => ADC3_IN,
           
           CONFIG0 => CONFIG0,
           CONFIG1 => CONFIG1,
           CONFIG2 => CONFIG1,
           CONFIG3 => CONFIG1,
           TIMEOUT => TIMEOUT,
           
           DMA_FULLNESS_0 => DMA_FULLNESS_0,
           DMA_FULLNESS_1 => DMA_FULLNESS_1,
           DMA_FULLNESS_2 => DMA_FULLNESS_2,
           DMA_FULLNESS_3 => DMA_FULLNESS_3,
           
           m_axis_aclk => m_axis_aclk,
           m_axis_aresetn=> RST,
           
           m_psa_tvalid => m_psa_tvalid,
           m_psa_tready => m_psa_tready,
           m_psa_tdata => m_psa_tdata,
           m_psa_tlast => open,
           m_adc_tvalid => m_adc_tvalid,
           m_adc_tready => m_adc_tready,
           m_adc_tdata => m_adc_tdata, 
           
                                        --pwropt => '0',
           
           clka => clkb,
           ena => enb,
           wea(0) => web,
           rsta => rstb,
           addra => addrb(13 DOWNTO 0),
           dina => dinb,
           douta => doutb,
           
           
           clkc => clkb,
           enc => enb,
           wec(0) => web,
           rstc => rstb,
           addrc => addrb(13 DOWNTO 0),
           dinc => dinb,
           doutc => doutb,
           
           
           clkd => clkb,
           en_d => enb,
           wed(0) => web,
           rstd => rstb,
           addrd => addrb(13 DOWNTO 0),
           dind => dinb,
           doutd => doutb,
           
           clkb => clkb,
           enb => enb,
           web(0) => web,
           rstb => rstb,
           addrb(13 DOWNTO 0) => addrb,
           dinb => dinb,
           doutb => open
           );


end Behavioral;