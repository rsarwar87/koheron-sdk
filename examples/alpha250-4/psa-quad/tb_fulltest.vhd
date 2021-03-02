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

entity tb_fulltest is
--  Port ( );
end tb_fulltest;

architecture Behavioral of tb_fulltest is

signal CLK     : STD_LOGIC;
signal RST     : STD_LOGIC;
signal ADC0_IN : STD_LOGIC_VECTOR (16-1 downto 0):= (others => '0');
signal ADC1_IN : STD_LOGIC_VECTOR (16-1 downto 0):= (others => '0');
signal ADC2_IN : STD_LOGIC_VECTOR (16-1 downto 0):= (others => '0');
signal ADC3_IN : STD_LOGIC_VECTOR (16-1 downto 0):= (others => '0');
signal ADC4_IN : STD_LOGIC_VECTOR (16-1 downto 0):= (others => '0');
signal ADC5_IN : STD_LOGIC_VECTOR (16-1 downto 0):= (others => '0');
signal ADC6_IN : STD_LOGIC_VECTOR (16-1 downto 0):= (others => '0');
signal ADC7_IN : STD_LOGIC_VECTOR (16-1 downto 0):= (others => '0');
 
signal PSA_RST : STD_LOGIC_VECTOR (7 downto 0):= (others => '1');
signal LIST_MODE: STD_LOGIC_VECTOR (1 downto 0):= (others => '1');
signal DEBUG: STD_LOGIC_VECTOR (1 downto 0):= (others => '0');
signal TIMEOUT : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');

signal GATE_SETTINGS7 : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
signal TRIGGER_SETTINGS7: STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
 
type t_dbus_array is array (0 to 7) of std_logic_vector(31 downto 0);

signal DMA_FULLNESS     :   t_dbus_array;
    
signal m_axis_aclk    : STD_LOGIC;
signal m_axis_aresetn : STD_LOGIC;
signal m_psa_tvalid   :  STD_LOGIC;
signal m_psa_tlast    :  STD_LOGIC;
signal m_psa_tready   : STD_LOGIC;
signal m_psa_tdata    :  STD_LOGIC_VECTOR (127 downto 0):= (others => '0');
signal m_adc_tvalid   :  STD_LOGIC;
signal m_adc_tready   : STD_LOGIC;
signal m_adc_tdata    :  STD_LOGIC_VECTOR (63 downto 0):= (others => '0');
signal m_adc_tlast :  STD_LOGIC;
    
    
signal clka  :STD_LOGIC;
signal ena   :STD_LOGIC;
signal wea   :STD_LOGIC_VECTOR(3 DOWNTO 0):= (others => '0');
signal addra :STD_LOGIC_VECTOR(12 DOWNTO 0):= (others => '0');
signal dina  :STD_LOGIC_VECTOR(31 DOWNTO 0):= (others => '0');
signal rsta  :STD_LOGIC;
signal douta : STD_LOGIC_VECTOR(31 DOWNTO 0):= (others => '0');
signal m_psa_tkeep : STD_LOGIC_VECTOR(15 DOWNTO 0):= (others => '0');
signal m_adc_tkeep : STD_LOGIC_VECTOR(7 DOWNTO 0):= (others => '0');

signal clkc  :STD_LOGIC;
signal enc   :STD_LOGIC;
signal wec   :STD_LOGIC_VECTOR(3 DOWNTO 0):= (others => '0');
signal addrc :STD_LOGIC_VECTOR(12 DOWNTO 0):= (others => '0');
signal dinc  :STD_LOGIC_VECTOR(31 DOWNTO 0):= (others => '0');
signal rstc  :STD_LOGIC;
signal doutc : STD_LOGIC_VECTOR(31 DOWNTO 0):= (others => '0');


signal clkd  :STD_LOGIC;  
signal en_d  :STD_LOGIC;
signal wed   :STD_LOGIC_VECTOR(3 DOWNTO 0):= (others => '0');
signal addrd :STD_LOGIC_VECTOR(12 DOWNTO 0):= (others => '0');
signal dind  :STD_LOGIC_VECTOR(31 DOWNTO 0):= (others => '0');
signal rstd  :STD_LOGIC;
signal doutd : STD_LOGIC_VECTOR(31 DOWNTO 0):= (others => '0');

signal clkb  :STD_LOGIC;
signal enb   :STD_LOGIC;
signal web   :STD_LOGIC_VECTOR(3 DOWNTO 0):= (others => '0');
signal rstb  :STD_LOGIC;
signal addrb :STD_LOGIC_VECTOR (12 downto 0):= (others => '0');
signal dinb  :STD_LOGIC_VECTOR(31 DOWNTO 0):= (others => '0');
signal doutb : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
signal clke  :STD_LOGIC;                           
signal ene   :STD_LOGIC;                            
signal wee   :STD_LOGIC_VECTOR(3 DOWNTO 0):= (others => '0');         
signal addre :STD_LOGIC_VECTOR(12 DOWNTO 0):= (others => '0');      
signal dine  :STD_LOGIC_VECTOR(31 DOWNTO 0):= (others => '0');       
signal rste  :STD_LOGIC;                           
signal doute : STD_LOGIC_VECTOR(31 DOWNTO 0):= (others => '0');   
          
signal clkf  :STD_LOGIC;                           
signal enf   :STD_LOGIC;                            
signal wef   :STD_LOGIC_VECTOR(3 DOWNTO 0):= (others => '0');         
signal addrf :STD_LOGIC_VECTOR(12 DOWNTO 0):= (others => '0');      
signal dinf  :STD_LOGIC_VECTOR(31 DOWNTO 0):= (others => '0');       
signal rstf  :STD_LOGIC;                           
signal doutf : STD_LOGIC_VECTOR(31 DOWNTO 0):= (others => '0');     
                                               
signal clkg  :STD_LOGIC;                           
signal eng   :STD_LOGIC ;                           
signal weg   :STD_LOGIC_VECTOR(3 DOWNTO 0):= (others => '0');         
signal addrg :STD_LOGIC_VECTOR(12 DOWNTO 0):= (others => '0');      
signal ding  :STD_LOGIC_VECTOR(31 DOWNTO 0):= (others => '0');       
signal rstg  :STD_LOGIC;                           
signal doutg : STD_LOGIC_VECTOR(31 DOWNTO 0):= (others => '0');     
                                            
signal clkh  :STD_LOGIC;                           
signal enh   :STD_LOGIC;                            
signal weh   :STD_LOGIC_VECTOR(3 DOWNTO 0):= (others => '0');         
signal rsth  :STD_LOGIC;                           
signal addrh :STD_LOGIC_VECTOR (12 downto 0):= (others => '0');     
signal dinh  :STD_LOGIC_VECTOR(31 DOWNTO 0):= (others => '0');       
signal douth : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');


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
     
        file_open(file_VECTORS, "/media/2TB/workspace/rsarwar/psa/Cf_output",  read_mode);
        wait for CLK_PERIOD*15; 
        while not endfile(file_VECTORS) loop
          readline(file_VECTORS, v_ILINE);
          read(v_ILINE, v_ADD_TERM1);
          --read(v_ILINE, v_SPACE);           -- read in the space character
          --read(v_ILINE, v_ADD_TERM2);
     
          -- Pass the variable to a signal to allow the ripple-carry to use it
          v_value := to_integer(unsigned(v_ADD_TERM1));
          v_value := 8192 - 16384 + (v_value) ;
          v_value := v_value*4;
          ADC0_IN <= std_logic_vector(to_signed(v_value, ADC0_IN'length)); --"0000000000000001";--
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
          DEBUG <= "00";
          PSA_RST <= (others => '1');   
          GATE_SETTINGS7(3 downto 0)                 <= "0011";                -- FIFO Full Flag
          GATE_SETTINGS7(7 downto 4)                 <= "1010";                -- FIFO Empty Flag
          GATE_SETTINGS7(13 downto 8)                <= "010100";
          GATE_SETTINGS7(21 downto 14)               <= "10100000";
          GATE_SETTINGS7(30 downto 22)               <= "010110100";
          TRIGGER_SETTINGS7(1 downto 0)              <= "00";
          TRIGGER_SETTINGS7(17 downto 2)             <= "0000000111111111";
          TRIGGER_SETTINGS7(26 downto 18)            <= "001111111";
          TRIGGER_SETTINGS7(30 downto 27)            <= "0011";
         
          m_adc_tready <= '1';
          m_psa_tready <= '1';
          LIST_MODE <= "01";
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

psacore: entity work.system_psa_core_0_0_psa_core_top
     port map (
      ADC0_IN(15 downto 0) => ADC0_IN(15 downto 0),
      ADC1_IN(15 downto 0) => ADC1_IN(15 downto 0),
      ADC2_IN(15 downto 0) => ADC0_IN(15 downto 0),
      ADC3_IN(15 downto 0) => ADC3_IN(15 downto 0),
      ADC4_IN(15 downto 0) => ADC0_IN(15 downto 0),
      ADC5_IN(15 downto 0) => B"0000000000000000",
      ADC6_IN(15 downto 0) => B"0000000000000000",
      ADC7_IN(15 downto 0) => B"0000000000000000",
      SIM_IN(15 downto 0) => B"0000000000000000",
      CLK => CLK,
      \DMA_FULLNESS[0]\(31 downto 0) => DMA_FULLNESS(0)(31 downto 0),
      \DMA_FULLNESS[1]\(31 downto 0) => DMA_FULLNESS(1)(31 downto 0),
      \DMA_FULLNESS[2]\(31 downto 0) => DMA_FULLNESS(2)(31 downto 0),
      \DMA_FULLNESS[3]\(31 downto 0) => DMA_FULLNESS(3)(31 downto 0),
      \DMA_FULLNESS[4]\(31 downto 0) => DMA_FULLNESS(4)(31 downto 0),
      \DMA_FULLNESS[5]\(31 downto 0) => DMA_FULLNESS(5)(31 downto 0),
      \DMA_FULLNESS[6]\(31 downto 0) => DMA_FULLNESS(6)(31 downto 0),
      \DMA_FULLNESS[7]\(31 downto 0) => DMA_FULLNESS(7)(31 downto 0),
      GATE_SETTINGS0 => GATE_SETTINGS7,
      GATE_SETTINGS1 => GATE_SETTINGS7,
      GATE_SETTINGS2 => GATE_SETTINGS7,
      GATE_SETTINGS3 => GATE_SETTINGS7,
      GATE_SETTINGS4 => GATE_SETTINGS7,
      GATE_SETTINGS5 => GATE_SETTINGS7,
      GATE_SETTINGS6 => GATE_SETTINGS7,
      GATE_SETTINGS7 => GATE_SETTINGS7,
      LIST_MODE(1 downto 0) => LIST_MODE(1 downto 0),
      DEBUG(1 downto 0) => DEBUG(1 downto 0),
      PSA_RST(7) => '0',
      PSA_RST(6 downto 0) => PSA_RST(6 downto 0),
      RST => RST,
      TIMEOUT(31 downto 0) => TIMEOUT,
      
      TRIGGER_SETTINGS0 => TRIGGER_SETTINGS7,
      TRIGGER_SETTINGS1 => TRIGGER_SETTINGS7,
      TRIGGER_SETTINGS2 => TRIGGER_SETTINGS7,
      TRIGGER_SETTINGS3 => TRIGGER_SETTINGS7,
      TRIGGER_SETTINGS4 => TRIGGER_SETTINGS7,
      TRIGGER_SETTINGS5 => TRIGGER_SETTINGS7,
      TRIGGER_SETTINGS6 => TRIGGER_SETTINGS7,
      TRIGGER_SETTINGS7 => TRIGGER_SETTINGS7,
      
      addra(12 downto 0) => addra(12 downto 0),
      addrb(12 downto 0) => addrb(12 downto 0),
      addrc(12 downto 0) => addrc(12 downto 0),
      addrd(12 downto 0) => addrd(12 downto 0),
      addre(12 downto 0) => addre(12 downto 0),
      addrf(12 downto 0) => addrf(12 downto 0),
      addrg(12 downto 0) => addrg(12 downto 0),
      addrh(12 downto 0) => B"0000000000000",
      m_adc_tdata(63 downto 0) => m_adc_tdata(63 downto 0),
      m_adc_tlast => m_adc_tlast,
      m_adc_tready => m_adc_tready,
      m_adc_tvalid => m_adc_tvalid,
      m_psa_tdata(127 downto 0) => m_psa_tdata(127 downto 0),
      m_psa_tlast => m_psa_tlast,
      m_psa_tready => m_psa_tready,
      m_psa_tvalid => m_psa_tvalid,
      m_psa_tkeep => m_psa_tkeep,
      m_adc_tkeep => m_adc_tkeep,
      clka => clka,
      clkb => clkb,
      clkc => clkc,
      clkd => clkd,
      clke => clke,
      clkf => clkf,
      clkg => clkg,
      clkh => '0',
      dina(31 downto 0) => dina(31 downto 0),
      dinb(31 downto 0) => dinb(31 downto 0),
      dinc(31 downto 0) => dinc(31 downto 0),
      dind(31 downto 0) => dind(31 downto 0),
      dine(31 downto 0) => dine(31 downto 0),
      dinf(31 downto 0) => dinf(31 downto 0),
      ding(31 downto 0) => ding(31 downto 0),
      dinh(31 downto 0) => B"00000000000000000000000000000000",
      douta(31 downto 0) => douta(31 downto 0),
      doutb(31 downto 0) => doutb(31 downto 0),
      doutc(31 downto 0) => doutc(31 downto 0),
      doutd(31 downto 0) => doutd(31 downto 0),
      doute(31 downto 0) => doute(31 downto 0),
      doutf(31 downto 0) => doutf(31 downto 0),
      doutg(31 downto 0) => doutg(31 downto 0),
      douth(31 downto 0) => douth(31 downto 0),
      
--      \peripheral_aresetn[0]_bufg_place\    => RST,
--      \peripheral_aresetn[0]_repN_10_alias\ => RST,
--      \peripheral_aresetn[0]_repN_14_alias\ => RST,
--      \peripheral_aresetn[0]_repN_23_alias\ => RST,
--      \peripheral_aresetn[0]_repN_29_alias\ => RST,
--      \peripheral_aresetn[0]_repN_2_alias\  => RST,
--      \peripheral_aresetn[0]_repN_33_alias\ => RST,
--      \peripheral_aresetn[0]_repN_3_alias\  => RST,
--      \peripheral_aresetn[0]_repN_4_alias\  => RST,
--      \peripheral_aresetn[0]_repN_5_alias\  => RST,
--      \peripheral_aresetn[0]_repN_7_alias\  => RST,

--      \peripheral_aresetn[0]_repN_1_alias\  => RST,
--      \peripheral_aresetn[0]_repN_2_alias\  => RST,
--      \peripheral_aresetn[0]_repN_3_alias\  => RST,
--      \peripheral_aresetn[0]_repN_alias\    => RST,
         
--   pwropt => '0',
      
      en_d => en_d,
      ena => ena,
      enb => enb,
      enc => enc,
      ene => ene,
      enf => enf,
      eng => eng,
      enh => '0',
      m_axis_aclk => m_axis_aclk,
      m_axis_aresetn => '1',
      rsta => rsta,
      rstb => rstb,
      rstc => rstc,
      rstd => rstd,
      rste => rste,
      rstf => rstf,
      rstg => rstg,
      rsth => '0',
      wea(3 downto 1) => B"000",
      wea(0) => wea(0),
      web(3 downto 1) => B"000",
      web(0) => web(0),
      wec(3 downto 1) => B"000",
      wec(0) => wec(0),
      wed(3 downto 1) => B"000",
      wed(0) => wed(0),
      wee(3 downto 1) => B"000",
      wee(0) => wee(0),
      wef(3 downto 1) => B"000",
      wef(0) => wef(0),
      weg(3 downto 1) => B"000",
      weg(0) => weg(0),
      weh(3 downto 0) => B"0000"
    );



end Behavioral;
