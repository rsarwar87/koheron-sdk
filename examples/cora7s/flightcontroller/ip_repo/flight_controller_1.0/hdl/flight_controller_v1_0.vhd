library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flight_controller_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 8
	);
	port (
		-- Users to add ports here
		clk_200          : in  std_logic;
        spi_mosi  : out std_logic;
        spi_miso  : in  std_logic;
        spi_nsel  : out std_logic_vector(0 downto 0);
        spi_sclk  : out std_logic;
        esp_out   : out std_logic_vector(3 downto 0);
        
        radio_pwm   : in std_logic_vector(15 downto 0);
        radio_cppm   : in std_logic;
        radio_sbus   : in std_logic;
        radio_ibus   : in std_logic;
        
        sda       : INOUT  STD_LOGIC;                    --serial data output of i2c bus
        scl       : INOUT  STD_LOGIC;
        
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
	);
end flight_controller_v1_0;

architecture arch_imp of flight_controller_v1_0 is
    constant MAX_DATA_SIZE_BYTES  : natural := 33;   
    component device_top is
    generic (
        MAX_DATA_SIZE_BYTES  : natural := 33;
        slv_bits: natural := 3
    );
     Port ( 
        clk100  : in  std_logic;
        clk_200          : in  std_logic;
        rstn  : in  std_logic;
        
        esp_status : out std_logic_vector(31 downto 0);
        esp_control : in std_logic_vector(127 downto 0);
        i2c_control : in std_logic_vector(31 downto 0);
        i2c_status : out std_logic_vector(31 downto 0);
        i2c_data_in : in std_logic_vector(8*MAX_DATA_SIZE_BYTES-1 downto 0);
        i2c_data_out : out std_logic_vector(8*MAX_DATA_SIZE_BYTES-1 downto 0);
        
        spi_control : in std_logic_vector(31 downto 0);
        spi_status : out std_logic_vector(31 downto 0);
        spi_data_in : in std_logic_vector(8*MAX_DATA_SIZE_BYTES-1 downto 0);
        spi_data_out : out std_logic_vector(8*MAX_DATA_SIZE_BYTES-1 downto 0);
        
        radio_pwm   : in std_logic_vector(15 downto 0);
        radio_cppm   : in std_logic;
        radio_sbus   : in std_logic;
        radio_ibus   : in std_logic;
        radio_select : in std_logic_vector(3 downto 0);
        channel_out00 : out std_logic_vector(15 downto 0);
        channel_out01 : out std_logic_vector(15 downto 0);
        channel_out02 : out std_logic_vector(15 downto 0);
        channel_out03 : out std_logic_vector(15 downto 0);
        channel_out04 : out std_logic_vector(15 downto 0);
        channel_out05 : out std_logic_vector(15 downto 0);
        channel_out06 : out std_logic_vector(15 downto 0);
        channel_out07 : out std_logic_vector(15 downto 0);
        channel_out08 : out std_logic_vector(15 downto 0);
        channel_out09 : out std_logic_vector(15 downto 0);
        channel_out10 : out std_logic_vector(15 downto 0);
        channel_out11 : out std_logic_vector(15 downto 0);
        channel_out12 : out std_logic_vector(15 downto 0);
        channel_out13 : out std_logic_vector(15 downto 0);
        channel_out14 : out std_logic_vector(15 downto 0);
        channel_out15 : out std_logic_vector(15 downto 0);
        
        sda       : INOUT  STD_LOGIC;                    --serial data output of i2c bus
        scl       : INOUT  STD_LOGIC;
        esp_out   : out std_logic_vector(3 downto 0);
        spi_mosi  : out std_logic;
        spi_miso  : in  std_logic;
        spi_nsel  : out std_logic_vector(0 downto 0);
        spi_sclk  : out std_logic
     );
    end component;
	-- component declaration
	component flight_controller_v1_0_S00_AXI is
		generic (
		MAX_DATA_SIZE_BYTES  : natural := 33;
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 8
		);
		port (
		
        i2c_control : out std_logic_vector(31 downto 0);
        i2c_status : in std_logic_vector(31 downto 0);
        i2c_data_in : out std_logic_vector(8*MAX_DATA_SIZE_BYTES-1 downto 0);
        i2c_data_out : in std_logic_vector(8*MAX_DATA_SIZE_BYTES-1 downto 0);
        esp_control : out std_logic_vector(127 downto 0);
        esp_status : in std_logic_vector(31 downto 0);
        
        spi_control : out std_logic_vector(31 downto 0);
        spi_status : in std_logic_vector(31 downto 0);
        spi_data_in : out std_logic_vector(8*MAX_DATA_SIZE_BYTES-1 downto 0);
        spi_data_out : in std_logic_vector(8*MAX_DATA_SIZE_BYTES-1 downto 0);
        
        radio_select : out std_logic_vector(3 downto 0);
        radio_01 : in std_logic_vector(31 downto 0);
        radio_23 : in std_logic_vector(31 downto 0);
        radio_45 : in std_logic_vector(31 downto 0);
        radio_67 : in std_logic_vector(31 downto 0);
        radio_89 : in std_logic_vector(31 downto 0);
        radio_AB : in std_logic_vector(31 downto 0);
        radio_CD : in std_logic_vector(31 downto 0);
        radio_EF : in std_logic_vector(31 downto 0);
        
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component flight_controller_v1_0_S00_AXI;
    signal i2c_control : std_logic_vector(31 downto 0);
    signal i2c_status :  std_logic_vector(31 downto 0);
    signal i2c_data_in :  std_logic_vector(8*MAX_DATA_SIZE_BYTES-1 downto 0);
    signal i2c_data_out :  std_logic_vector(8*MAX_DATA_SIZE_BYTES-1 downto 0);
        
    signal spi_control :  std_logic_vector(31 downto 0);
    signal spi_status :  std_logic_vector(31 downto 0);
    signal spi_data_in :  std_logic_vector(8*MAX_DATA_SIZE_BYTES-1 downto 0);
    signal spi_data_out :  std_logic_vector(8*MAX_DATA_SIZE_BYTES-1 downto 0);    
    signal esp_control : std_logic_vector(127 downto 0);  
    signal esp_status : std_logic_vector(31 downto 0);
    
    signal radio_01 :  std_logic_vector(31 downto 0);
    signal radio_23 :  std_logic_vector(31 downto 0);
    signal radio_45 :  std_logic_vector(31 downto 0);
    signal radio_67 :  std_logic_vector(31 downto 0);
    signal radio_89 :  std_logic_vector(31 downto 0);
    signal radio_AB :  std_logic_vector(31 downto 0);
    signal radio_CD :  std_logic_vector(31 downto 0);
    signal radio_EF :  std_logic_vector(31 downto 0);
    signal radio_select :  std_logic_vector(3 downto 0);
begin

-- Instantiation of Axi Bus Interface S00_AXI
U_DEV : device_top 
    generic map(
        MAX_DATA_SIZE_BYTES  => MAX_DATA_SIZE_BYTES,
        slv_bits => 3
    )
     Port map ( 
        clk100  => s00_axi_aclk,
        clk_200 => clk_200,
        rstn    => s00_axi_aresetn,
        
        esp_status => esp_status,
        esp_control => esp_control,
	    i2c_control => i2c_control,             
	    i2c_status  => i2c_status,
	    i2c_data_in => i2c_data_in,
	    i2c_data_out => i2c_data_out,
	    spi_control => spi_control,             
	    spi_status  => spi_status,
	    spi_data_in => spi_data_in,
	    spi_data_out =>spi_data_out,
	    
	    radio_pwm   =>    radio_pwm   ,
        radio_cppm  =>    radio_cppm,
        radio_sbus  =>    radio_sbus,
        radio_ibus  =>    radio_ibus,
        radio_select=> radio_select,
        
        channel_out00 => radio_01(15 downto  0),
        channel_out01 => radio_01(31 downto 16),
        channel_out02 => radio_23(15 downto  0),
        channel_out03 => radio_23(31 downto 16),
        channel_out04 => radio_45(15 downto  0),
        channel_out05 => radio_45(31 downto 16),
        channel_out06 => radio_67(15 downto  0),
        channel_out07 => radio_67(31 downto 16),
        channel_out08 => radio_89(15 downto  0),
        channel_out09 => radio_89(31 downto 16),
        channel_out10 => radio_AB(15 downto  0),
        channel_out11 => radio_AB(31 downto 16),
        channel_out12 => radio_CD(15 downto  0),
        channel_out13 => radio_CD(31 downto 16),
        channel_out14 => radio_EF(15 downto  0),
        channel_out15 => radio_EF(31 downto 16),
        
        
        spi_mosi  => spi_mosi,
        spi_miso  => spi_miso,
        spi_nsel  => spi_nsel,
        spi_sclk  => spi_sclk,
        
        esp_out => esp_out,
        
        sda       => sda,                    --serial data output of i2c bus
        scl       => scl
     );

flight_controller_v1_0_S00_AXI_inst : flight_controller_v1_0_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
	    esp_status => esp_status,
	    esp_control => esp_control,
	    i2c_control => i2c_control,             
	    i2c_status  => i2c_status,
	    i2c_data_in => i2c_data_in,
	    i2c_data_out => i2c_data_out,
	    spi_control => spi_control,             
	    spi_status  => spi_status,
	    spi_data_in => spi_data_in,
	    spi_data_out =>spi_data_out,
	    
	    radio_select=> radio_select,
	    radio_01    => radio_01 ,
        radio_23    => radio_23 ,
        radio_45    => radio_45 ,
        radio_67    => radio_67 ,
        radio_89    => radio_89 ,
        radio_AB    => radio_AB ,
        radio_CD    => radio_CD ,
        radio_EF    => radio_EF ,
	
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

	-- Add user logic here

	-- User logic ends

end arch_imp;
