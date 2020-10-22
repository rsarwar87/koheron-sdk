--Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
--Date        : Sun Dec 15 13:52:38 2019
--Host        : ukaea-fpga running 64-bit KDE neon User Edition 5.16
--Command     : generate_target design_1_wrapper.bd
--Design      : design_1_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity system_top is
  port (
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    Vaux0_0_v_n : in STD_LOGIC;
    Vaux0_0_v_p : in STD_LOGIC;
    Vaux12_0_v_n : in STD_LOGIC;
    Vaux12_0_v_p : in STD_LOGIC;
    Vaux13_0_v_n : in STD_LOGIC;
    Vaux13_0_v_p : in STD_LOGIC;
    Vaux15_0_v_n : in STD_LOGIC;
    Vaux15_0_v_p : in STD_LOGIC;
    Vaux1_0_v_n : in STD_LOGIC;
    Vaux1_0_v_p : in STD_LOGIC;
    Vaux5_0_v_n : in STD_LOGIC;
    Vaux5_0_v_p : in STD_LOGIC;
    Vaux6_0_v_n : in STD_LOGIC;
    Vaux6_0_v_p : in STD_LOGIC;
    Vaux8_0_v_n : in STD_LOGIC;
    Vaux8_0_v_p : in STD_LOGIC;
    Vaux9_0_v_n : in STD_LOGIC;
    Vaux9_0_v_p : in STD_LOGIC;
    Vp_Vn_0_v_n : in STD_LOGIC;
    Vp_Vn_0_v_p : in STD_LOGIC;
    
    pmod_ja : inout STD_LOGIC_VECTOR ( 7 downto 0 );
    pmod_jb : inout STD_LOGIC_VECTOR ( 7 downto 0 );
    
    btns : in STD_LOGIC_VECTOR ( 1 downto 0 );
    ck_inner_io : inout STD_LOGIC_VECTOR ( 13 downto 0 );
    ck_outer_io : inout STD_LOGIC_VECTOR ( 15 downto 0 );
    
    led0 : out STD_LOGIC_VECTOR ( 2 downto 0 );
    led1 : out STD_LOGIC_VECTOR ( 2 downto 0 );
    
    
    ck_iic_scl : inout STD_LOGIC;
    ck_iic_sda : inout STD_LOGIC;
    ck_spi_sck : out std_logic;
    ck_spi_ss : out std_logic;
    ck_spi_mosi : out std_logic;
    ck_spi_miso : in std_logic;
    
    user_dio : inout STD_LOGIC_VECTOR ( 12 downto 0 )
  );
end system_top;

architecture STRUCTURE of system_top is
  component system is
  port (
    Vaux0_0_v_n : in STD_LOGIC;
    Vaux0_0_v_p : in STD_LOGIC;
    Vaux12_0_v_n : in STD_LOGIC;
    Vaux12_0_v_p : in STD_LOGIC;
    Vaux13_0_v_n : in STD_LOGIC;
    Vaux13_0_v_p : in STD_LOGIC;
    Vaux15_0_v_n : in STD_LOGIC;
    Vaux15_0_v_p : in STD_LOGIC;
    Vaux1_0_v_n : in STD_LOGIC;
    Vaux1_0_v_p : in STD_LOGIC;
    Vaux5_0_v_n : in STD_LOGIC;
    Vaux5_0_v_p : in STD_LOGIC;
    Vaux6_0_v_n : in STD_LOGIC;
    Vaux6_0_v_p : in STD_LOGIC;
    Vaux8_0_v_n : in STD_LOGIC;
    Vaux8_0_v_p : in STD_LOGIC;
    Vaux9_0_v_n : in STD_LOGIC;
    Vaux9_0_v_p : in STD_LOGIC;
    Vp_Vn_0_v_n : in STD_LOGIC;
    Vp_Vn_0_v_p : in STD_LOGIC;
    DDR_cas_n : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    btns : in STD_LOGIC_VECTOR ( 1 downto 0 );
    led0 : out STD_LOGIC_VECTOR ( 2 downto 0 );
    led1 : out STD_LOGIC_VECTOR ( 2 downto 0 );
    user_io_i : in STD_LOGIC_VECTOR ( 12 downto 0 );
    user_io_o : out STD_LOGIC_VECTOR ( 12 downto 0 );
    user_io_t : out STD_LOGIC_VECTOR ( 12 downto 0 );
    pmod_ja_pin1_o : out STD_LOGIC;
    pmod_ja_pin7_i : in STD_LOGIC;
    pmod_ja_pin2_o : out STD_LOGIC;
    pmod_ja_pin8_i : in STD_LOGIC;
    pmod_ja_pin3_o : out STD_LOGIC;
    pmod_ja_pin9_i : in STD_LOGIC;
    pmod_ja_pin10_o : out STD_LOGIC;
    pmod_ja_pin4_o : out STD_LOGIC;
    pmod_ja_pin3_i : in STD_LOGIC;
    pmod_ja_pin4_i : in STD_LOGIC;
    pmod_ja_pin1_i : in STD_LOGIC;
    pmod_ja_pin2_i : in STD_LOGIC;
    pmod_ja_pin10_t : out STD_LOGIC;
    pmod_ja_pin8_t : out STD_LOGIC;
    pmod_ja_pin9_t : out STD_LOGIC;
    pmod_ja_pin4_t : out STD_LOGIC;
    pmod_ja_pin9_o : out STD_LOGIC;
    pmod_ja_pin10_i : in STD_LOGIC;
    pmod_ja_pin7_t : out STD_LOGIC;
    pmod_ja_pin1_t : out STD_LOGIC;
    pmod_ja_pin2_t : out STD_LOGIC;
    pmod_ja_pin7_o : out STD_LOGIC;
    pmod_ja_pin3_t : out STD_LOGIC;
    pmod_ja_pin8_o : out STD_LOGIC;
    pmod_jb_pin1_o : out STD_LOGIC;
    pmod_jb_pin7_i : in STD_LOGIC;
    pmod_jb_pin2_o : out STD_LOGIC;
    pmod_jb_pin8_i : in STD_LOGIC;
    pmod_jb_pin3_o : out STD_LOGIC;
    pmod_jb_pin9_i : in STD_LOGIC;
    pmod_jb_pin10_o : out STD_LOGIC;
    pmod_jb_pin4_o : out STD_LOGIC;
    pmod_jb_pin3_i : in STD_LOGIC;
    pmod_jb_pin4_i : in STD_LOGIC;
    pmod_jb_pin1_i : in STD_LOGIC;
    pmod_jb_pin2_i : in STD_LOGIC;
    pmod_jb_pin10_t : out STD_LOGIC;
    pmod_jb_pin8_t : out STD_LOGIC;
    pmod_jb_pin9_t : out STD_LOGIC;
    pmod_jb_pin4_t : out STD_LOGIC;
    pmod_jb_pin9_o : out STD_LOGIC;
    pmod_jb_pin10_i : in STD_LOGIC;
    pmod_jb_pin7_t : out STD_LOGIC;
    pmod_jb_pin1_t : out STD_LOGIC;
    pmod_jb_pin2_t : out STD_LOGIC;
    pmod_jb_pin7_o : out STD_LOGIC;
    pmod_jb_pin3_t : out STD_LOGIC;
    pmod_jb_pin8_o : out STD_LOGIC;
    ck_outer_io_i : in STD_LOGIC_VECTOR ( 15 downto 0 );
    ck_outer_io_o : out STD_LOGIC_VECTOR ( 15 downto 0 );
    ck_outer_io_t : out STD_LOGIC_VECTOR ( 15 downto 0 );
    ck_inner_io_i : in STD_LOGIC_VECTOR ( 13 downto 0 );
    ck_inner_io_t : out STD_LOGIC_VECTOR ( 13 downto 0 );
    ck_inner_io_o : out STD_LOGIC_VECTOR ( 13 downto 0 );
    IIC_scl_i : in STD_LOGIC;
    IIC_scl_o : out STD_LOGIC;
    IIC_scl_t : out STD_LOGIC;
    IIC_sda_i : in STD_LOGIC;
    IIC_sda_o : out STD_LOGIC;
    IIC_sda_t : out STD_LOGIC;
    spi_clk_i : in STD_LOGIC;
    spi_clk_o : out STD_LOGIC;
    spi_csn_i : in STD_LOGIC_VECTOR ( 0 to 0 );
    spi_csn_o : out STD_LOGIC_VECTOR ( 0 to 0 );
    spi_sdi_i : in STD_LOGIC;
    spi_sdo_i : in STD_LOGIC;
    spi_sdo_o : out STD_LOGIC
  );
  end component system;
  component IOBUF is
  port (
    I : in STD_LOGIC;
    O : out STD_LOGIC;
    T : in STD_LOGIC;
    IO : inout STD_LOGIC
  );
  end component IOBUF;
  signal pmod_ja_pin10_i : STD_LOGIC;
  signal pmod_ja_pin10_o : STD_LOGIC;
  signal pmod_ja_pin10_t : STD_LOGIC;
  signal pmod_ja_pin1_i : STD_LOGIC;
  signal pmod_ja_pin1_o : STD_LOGIC;
  signal pmod_ja_pin1_t : STD_LOGIC;
  signal pmod_ja_pin2_i : STD_LOGIC;
  signal pmod_ja_pin2_o : STD_LOGIC;
  signal pmod_ja_pin2_t : STD_LOGIC;
  signal pmod_ja_pin3_i : STD_LOGIC;
  signal pmod_ja_pin3_o : STD_LOGIC;
  signal pmod_ja_pin3_t : STD_LOGIC;
  signal pmod_ja_pin4_i : STD_LOGIC;
  signal pmod_ja_pin4_o : STD_LOGIC;
  signal pmod_ja_pin4_t : STD_LOGIC;
  signal pmod_ja_pin7_i : STD_LOGIC;
  signal pmod_ja_pin7_o : STD_LOGIC;
  signal pmod_ja_pin7_t : STD_LOGIC;
  signal pmod_ja_pin8_i : STD_LOGIC;
  signal pmod_ja_pin8_o : STD_LOGIC;
  signal pmod_ja_pin8_t : STD_LOGIC;
  signal pmod_ja_pin9_i : STD_LOGIC;
  signal pmod_ja_pin9_o : STD_LOGIC;
  signal pmod_ja_pin9_t : STD_LOGIC;
  signal pmod_jb_pin10_i : STD_LOGIC;
  signal pmod_jb_pin10_o : STD_LOGIC;
  signal pmod_jb_pin10_t : STD_LOGIC;
  signal pmod_jb_pin1_i : STD_LOGIC;
  signal pmod_jb_pin1_o : STD_LOGIC;
  signal pmod_jb_pin1_t : STD_LOGIC;
  signal pmod_jb_pin2_i : STD_LOGIC;
  signal pmod_jb_pin2_o : STD_LOGIC;
  signal pmod_jb_pin2_t : STD_LOGIC;
  signal pmod_jb_pin3_i : STD_LOGIC;
  signal pmod_jb_pin3_o : STD_LOGIC;
  signal pmod_jb_pin3_t : STD_LOGIC;
  signal pmod_jb_pin4_i : STD_LOGIC;
  signal pmod_jb_pin4_o : STD_LOGIC;
  signal pmod_jb_pin4_t : STD_LOGIC;
  signal pmod_jb_pin7_i : STD_LOGIC;
  signal pmod_jb_pin7_o : STD_LOGIC;
  signal pmod_jb_pin7_t : STD_LOGIC;
  signal pmod_jb_pin8_i : STD_LOGIC;
  signal pmod_jb_pin8_o : STD_LOGIC;
  signal pmod_jb_pin8_t : STD_LOGIC;
  signal pmod_jb_pin9_i : STD_LOGIC;
  signal pmod_jb_pin9_o : STD_LOGIC;
  signal pmod_jb_pin9_t : STD_LOGIC;
  
  signal ck_inner_io_i :  STD_LOGIC_VECTOR ( 13 downto 0 );
  signal ck_inner_io_o :  STD_LOGIC_VECTOR ( 13 downto 0 );
  signal ck_inner_io_t :  STD_LOGIC_VECTOR ( 13 downto 0 );
  signal ck_outer_io_i :  STD_LOGIC_VECTOR ( 15 downto 0 );
  signal ck_outer_io_o :  STD_LOGIC_VECTOR ( 15 downto 0 );
  signal ck_outer_io_t :  STD_LOGIC_VECTOR ( 15 downto 0 );
  
  signal user_io_i : STD_LOGIC_VECTOR ( 12 downto 0 );
  signal user_io_o : STD_LOGIC_VECTOR ( 12 downto 0 );
  signal user_io_t : STD_LOGIC_VECTOR ( 12 downto 0 );
  
  signal spi_clk : STD_LOGIC;
  signal spi_csn : STD_LOGIC_VECTOR ( 7 downto 0);
  signal spi_sdi : STD_LOGIC;
  signal spi_sdo : STD_LOGIC;
  
  
  signal IIC_scl_i : STD_LOGIC;
  signal IIC_scl_o : STD_LOGIC;
  signal IIC_scl_t : STD_LOGIC;
  signal IIC_sda_i : STD_LOGIC;
  signal IIC_sda_o : STD_LOGIC;
  signal IIC_sda_t : STD_LOGIC;
begin
 ck_spi_ss <= spi_csn(0);
 spi_sdi <= ck_spi_miso;
 ck_spi_sck <= spi_clk;
 spi_sdi <= ck_spi_miso;
 ck_spi_mosi <= spi_sdo;
design_1_i: component system
     port map (
     
      
      spi_clk_i => spi_clk,
      spi_clk_o => spi_clk,
      spi_csn_i(0) => spi_csn(0),
      spi_csn_o(0) => spi_csn(0),
      spi_sdi_i => spi_sdi,
      spi_sdo_i => spi_sdo,
      spi_sdo_o => spi_sdo,
     
      DDR_addr(14 downto 0) => DDR_addr(14 downto 0),
      DDR_ba(2 downto 0) => DDR_ba(2 downto 0),
      DDR_cas_n => DDR_cas_n,
      DDR_ck_n => DDR_ck_n,
      DDR_ck_p => DDR_ck_p,
      DDR_cke => DDR_cke,
      DDR_cs_n => DDR_cs_n,
      DDR_dm(3 downto 0) => DDR_dm(3 downto 0),
      DDR_dq(31 downto 0) => DDR_dq(31 downto 0),
      DDR_dqs_n(3 downto 0) => DDR_dqs_n(3 downto 0),
      DDR_dqs_p(3 downto 0) => DDR_dqs_p(3 downto 0),
      DDR_odt => DDR_odt,
      DDR_ras_n => DDR_ras_n,
      DDR_reset_n => DDR_reset_n,
      DDR_we_n => DDR_we_n,
      FIXED_IO_ddr_vrn => FIXED_IO_ddr_vrn,
      FIXED_IO_ddr_vrp => FIXED_IO_ddr_vrp,
      FIXED_IO_mio(53 downto 0) => FIXED_IO_mio(53 downto 0),
      FIXED_IO_ps_clk => FIXED_IO_ps_clk,
      FIXED_IO_ps_porb => FIXED_IO_ps_porb,
      FIXED_IO_ps_srstb => FIXED_IO_ps_srstb,
      Vaux0_0_v_n => Vaux0_0_v_n,
      Vaux0_0_v_p => Vaux0_0_v_p,
      Vaux12_0_v_n => Vaux12_0_v_n,
      Vaux12_0_v_p => Vaux12_0_v_p,
      Vaux13_0_v_n => Vaux13_0_v_n,
      Vaux13_0_v_p => Vaux13_0_v_p,
      Vaux15_0_v_n => Vaux15_0_v_n,
      Vaux15_0_v_p => Vaux15_0_v_p,
      Vaux1_0_v_n => Vaux1_0_v_n,
      Vaux1_0_v_p => Vaux1_0_v_p,
      Vaux5_0_v_n => Vaux5_0_v_n,
      Vaux5_0_v_p => Vaux5_0_v_p,
      Vaux6_0_v_n => Vaux6_0_v_n,
      Vaux6_0_v_p => Vaux6_0_v_p,
      Vaux8_0_v_n => Vaux8_0_v_n,
      Vaux8_0_v_p => Vaux8_0_v_p,
      Vaux9_0_v_n => Vaux9_0_v_n,
      Vaux9_0_v_p => Vaux9_0_v_p,
      Vp_Vn_0_v_n => Vp_Vn_0_v_n,
      Vp_Vn_0_v_p => Vp_Vn_0_v_p,
      btns(1 downto 0) => btns(1 downto 0),
      ck_inner_io_i(13 downto 0) => ck_inner_io_i(13 downto 0),
      ck_inner_io_o(13 downto 0) => ck_inner_io_o(13 downto 0),
      ck_inner_io_t(13 downto 0) => ck_inner_io_t(13 downto 0),
      ck_outer_io_i(15 downto 0) => ck_outer_io_i(15 downto 0),
      ck_outer_io_o(15 downto 0) => ck_outer_io_o(15 downto 0),
      ck_outer_io_t(15 downto 0) => ck_outer_io_t(15 downto 0),
      led0(2 downto 0) => led0(2 downto 0),
      led1(2 downto 0) => led1(2 downto 0),
      pmod_ja_pin10_i => pmod_ja_pin10_i,
      pmod_ja_pin10_o => pmod_ja_pin10_o,
      pmod_ja_pin10_t => pmod_ja_pin10_t,
      pmod_ja_pin1_i => pmod_ja_pin1_i,
      pmod_ja_pin1_o => pmod_ja_pin1_o,
      pmod_ja_pin1_t => pmod_ja_pin1_t,
      pmod_ja_pin2_i => pmod_ja_pin2_i,
      pmod_ja_pin2_o => pmod_ja_pin2_o,
      pmod_ja_pin2_t => pmod_ja_pin2_t,
      pmod_ja_pin3_i => pmod_ja_pin3_i,
      pmod_ja_pin3_o => pmod_ja_pin3_o,
      pmod_ja_pin3_t => pmod_ja_pin3_t,
      pmod_ja_pin4_i => pmod_ja_pin4_i,
      pmod_ja_pin4_o => pmod_ja_pin4_o,
      pmod_ja_pin4_t => pmod_ja_pin4_t,
      pmod_ja_pin7_i => pmod_ja_pin7_i,
      pmod_ja_pin7_o => pmod_ja_pin7_o,
      pmod_ja_pin7_t => pmod_ja_pin7_t,
      pmod_ja_pin8_i => pmod_ja_pin8_i,
      pmod_ja_pin8_o => pmod_ja_pin8_o,
      pmod_ja_pin8_t => pmod_ja_pin8_t,
      pmod_ja_pin9_i => pmod_ja_pin9_i,
      pmod_ja_pin9_o => pmod_ja_pin9_o,
      pmod_ja_pin9_t => pmod_ja_pin9_t,
      pmod_jb_pin10_i => pmod_jb_pin10_i,
      pmod_jb_pin10_o => pmod_jb_pin10_o,
      pmod_jb_pin10_t => pmod_jb_pin10_t,
      pmod_jb_pin1_i => pmod_jb_pin1_i,
      pmod_jb_pin1_o => pmod_jb_pin1_o,
      pmod_jb_pin1_t => pmod_jb_pin1_t,
      pmod_jb_pin2_i => pmod_jb_pin2_i,
      pmod_jb_pin2_o => pmod_jb_pin2_o,
      pmod_jb_pin2_t => pmod_jb_pin2_t,
      pmod_jb_pin3_i => pmod_jb_pin3_i,
      pmod_jb_pin3_o => pmod_jb_pin3_o,
      pmod_jb_pin3_t => pmod_jb_pin3_t,
      pmod_jb_pin4_i => pmod_jb_pin4_i,
      pmod_jb_pin4_o => pmod_jb_pin4_o,
      pmod_jb_pin4_t => pmod_jb_pin4_t,
      pmod_jb_pin7_i => pmod_jb_pin7_i,
      pmod_jb_pin7_o => pmod_jb_pin7_o,
      pmod_jb_pin7_t => pmod_jb_pin7_t,
      pmod_jb_pin8_i => pmod_jb_pin8_i,
      pmod_jb_pin8_o => pmod_jb_pin8_o,
      pmod_jb_pin8_t => pmod_jb_pin8_t,
      pmod_jb_pin9_i => pmod_jb_pin9_i,
      pmod_jb_pin9_o => pmod_jb_pin9_o,
      pmod_jb_pin9_t => pmod_jb_pin9_t,
      
      IIC_scl_i => IIC_scl_i,
      IIC_scl_o => IIC_scl_o,
      IIC_scl_t => IIC_scl_t,
      IIC_sda_i => IIC_sda_i,
      IIC_sda_o => IIC_sda_o,
      IIC_sda_t => IIC_sda_t,
      
      user_io_i(12 downto 0) => user_io_i(12 downto 0),
      user_io_o(12 downto 0) => user_io_o(12 downto 0),
      user_io_t(12 downto 0) => user_io_t(12 downto 0)
    );

IIC_scl_iobuf: component IOBUF
     port map (
      I => IIC_scl_o,
      IO => ck_iic_scl,
      O => IIC_scl_i,
      T => IIC_scl_t
    );
IIC_sda_iobuf: component IOBUF
     port map (
      I => IIC_sda_o,
      IO => ck_iic_sda,
      O => IIC_sda_i,
      T => IIC_sda_t
    );

  GEN_USER: for I in 1 to 12 generate
    user_iobuf: component IOBUF
     port map (
      I => user_io_o(I),
      IO => user_dio(I),
      O => user_io_i(I),
      T => user_io_t(I)
    );
  end generate GEN_USER;
  
  GEN_OUTER: for I in 0 to 15 generate
    user_iobuf: component IOBUF
     port map (
      I => ck_outer_io_o(I),
      IO =>ck_outer_io(I),
      O => ck_outer_io_i(I),
      T => ck_outer_io_t(I)
    );
  end generate GEN_OUTER;
  
  
  GEN_INNER: for I in 0 to 13 generate
    user_iobuf: component IOBUF
     port map (
      I => ck_inner_io_o(I),
      IO => ck_inner_io(I),
      O => ck_inner_io_i(I),
      T => ck_inner_io_t(I)
    );
  end generate GEN_INNER;
  
    
pmod_ja_pin10_iobuf: component IOBUF
     port map (
      I => pmod_ja_pin10_o,
      IO => pmod_ja(7),
      O => pmod_ja_pin10_i,
      T => pmod_ja_pin10_t
    );
pmod_ja_pin1_iobuf: component IOBUF
     port map (
      I => pmod_ja_pin1_o,
      IO => pmod_ja(0),
      O => pmod_ja_pin1_i,
      T => pmod_ja_pin1_t
    );
pmod_ja_pin2_iobuf: component IOBUF
     port map (
      I => pmod_ja_pin2_o,
      IO => pmod_ja(1),
      O => pmod_ja_pin2_i,
      T => pmod_ja_pin2_t
    );
pmod_ja_pin3_iobuf: component IOBUF
     port map (
      I => pmod_ja_pin3_o,
      IO => pmod_ja(2),
      O => pmod_ja_pin3_i,
      T => pmod_ja_pin3_t
    );
pmod_ja_pin4_iobuf: component IOBUF
     port map (
      I => pmod_ja_pin4_o,
      IO => pmod_ja(3),
      O => pmod_ja_pin4_i,
      T => pmod_ja_pin4_t
    );
pmod_ja_pin7_iobuf: component IOBUF
     port map (
      I => pmod_ja_pin7_o,
      IO => pmod_ja(4),
      O => pmod_ja_pin7_i,
      T => pmod_ja_pin7_t
    );
pmod_ja_pin8_iobuf: component IOBUF
     port map (
      I => pmod_ja_pin8_o,
      IO => pmod_ja(5),
      O => pmod_ja_pin8_i,
      T => pmod_ja_pin8_t
    );
pmod_ja_pin9_iobuf: component IOBUF
     port map (
      I => pmod_ja_pin9_o,
      IO => pmod_ja(6),
      O => pmod_ja_pin9_i,
      T => pmod_ja_pin9_t
    );
pmod_jb_pin10_iobuf: component IOBUF
     port map (
      I => pmod_jb_pin10_o,
      IO => pmod_jb(7),
      O => pmod_jb_pin10_i,
      T => pmod_jb_pin10_t
    );
pmod_jb_pin1_iobuf: component IOBUF
     port map (
      I => pmod_jb_pin1_o,
      IO => pmod_jb(0),
      O => pmod_jb_pin1_i,
      T => pmod_jb_pin1_t
    );
pmod_jb_pin2_iobuf: component IOBUF
     port map (
      I => pmod_jb_pin2_o,
      IO => pmod_jb(1),
      O => pmod_jb_pin2_i,
      T => pmod_jb_pin2_t
    );
pmod_jb_pin3_iobuf: component IOBUF
     port map (
      I => pmod_jb_pin3_o,
      IO => pmod_jb(2),
      O => pmod_jb_pin3_i,
      T => pmod_jb_pin3_t
    );
pmod_jb_pin4_iobuf: component IOBUF
     port map (
      I => pmod_jb_pin4_o,
      IO => pmod_jb(3),
      O => pmod_jb_pin4_i,
      T => pmod_jb_pin4_t
    );
pmod_jb_pin7_iobuf: component IOBUF
     port map (
      I => pmod_jb_pin7_o,
      IO => pmod_jb(4),
      O => pmod_jb_pin7_i,
      T => pmod_jb_pin7_t
    );
pmod_jb_pin8_iobuf: component IOBUF
     port map (
      I => pmod_jb_pin8_o,
      IO => pmod_jb(5),
      O => pmod_jb_pin8_i,
      T => pmod_jb_pin8_t
    );
pmod_jb_pin9_iobuf: component IOBUF
     port map (
      I => pmod_jb_pin9_o,
      IO => pmod_jb(6),
      O => pmod_jb_pin9_i,
      T => pmod_jb_pin9_t
    );
end STRUCTURE;
