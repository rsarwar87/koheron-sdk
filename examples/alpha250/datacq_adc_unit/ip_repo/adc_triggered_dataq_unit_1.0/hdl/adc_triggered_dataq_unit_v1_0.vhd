library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adc_triggered_dataq_unit_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 7;

		-- Parameters of Axi Master Bus Interface M00_AXIS
		C_M00_AXIS_TDATA_WIDTH	: integer	:= 16
	);
	port (
		-- Users to add ports here
        adc_clk             : in std_logic;
        adc_rst_n           : in std_logic;
        adc_ch0             : in std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
        adc_ch1             : in std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
        adc_ch2             : in std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
        adc_ch3             : in std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
        
        ext_trigger         : in std_logic;
        clk_ref                          : in std_logic;
        
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
		s00_axi_rready	: in std_logic;

		-- Ports of Axi Master Bus Interface M00_AXIS
		m00_axis_tvalid	: out std_logic;
		m00_axis_tdata	: out std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
		m00_axis_tready	: in std_logic;
		m00_axis_tkeep	: out std_logic_vector(1 downto 0)
	);
end adc_triggered_dataq_unit_v1_0;

architecture arch_imp of adc_triggered_dataq_unit_v1_0 is
    component unit_top is
        generic (
            C_M00_AXIS_TDATA_WIDTH	: integer	:= 16
        );
      Port ( 
        clk_adc                         : in std_logic;
        clk_adc_rst_n                   : in std_logic;
        clk_ip                          : in std_logic;
        clk_ip_rst_n                    : in std_logic;
        
        adc_ch0                         : in std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
        adc_ch1                         : in std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
        adc_ch2                         : in std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
        adc_ch3                         : in std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
        up_time                         : out std_logic_vector(31 downto 0);
      
        ext_trigger                     : in std_logic;
        
        unit_status_in                  : out  std_logic_vector(31 downto 0); 
        bus_error_count                 : out std_logic_vector(31 downto 0); 
        bus_error_integrator            : out std_logic_vector(31 downto 0); 
        unit_control                    : in  std_logic_vector(31 downto 0);
        datac_delay                     : in  std_logic_vector(31 downto 0);
        datac_window                    : in  std_logic_vector(31 downto 0);
        datac_processed                 : out std_logic_vector(31 downto 0);
        
        tick_counter                    : out std_logic_vector(31 downto 0);
        adc_freq                        : out std_logic_vector(31 downto 0);
        
        m00_axis_tvalid	                : out std_logic;
        m00_axis_tdata	                : out std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
        m00_axis_tready	                : in std_logic
        
        
      );
    end component;

	-- component declaration
	component adc_triggered_dataq_unit_v1_0_S00_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 7
		);
		port (
		
        unit_status_in          : in std_logic_vector(31 downto 0);
        bus_error_count         : in std_logic_vector(31 downto 0);
        bus_error_integrator    : in std_logic_vector(31 downto 0);
        unit_control            : out std_logic_vector(31 downto 0);
        datac_delay             : out std_logic_vector(31 downto 0);
        datac_window            : out std_logic_vector(31 downto 0);
        datac_processed         : in  std_logic_vector(31 downto 0);
        tick_counter            : in std_logic_vector(31 downto 0);
        adc_freq                : in std_logic_vector(31 downto 0);
        up_time                         : in std_logic_vector(31 downto 0);
		
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
	end component adc_triggered_dataq_unit_v1_0_S00_AXI;


signal  unit_status_in          : std_logic_vector(31 downto 0);
signal  bus_error_count         : std_logic_vector(31 downto 0);
signal  bus_error_integrator    : std_logic_vector(31 downto 0);
signal  unit_control            : std_logic_vector(31 downto 0);
signal  datac_delay             : std_logic_vector(31 downto 0);
signal  datac_window            : std_logic_vector(31 downto 0);
signal  datac_processed         : std_logic_vector(31 downto 0);
signal  tick_counter            : std_logic_vector(31 downto 0);
signal  adc_freq, up_time       : std_logic_vector(31 downto 0);
begin

m00_axis_tkeep <= "11";
UNIT_TOP_ADC: unit_top 
      generic map (
        C_M00_AXIS_TDATA_WIDTH	=> C_M00_AXIS_TDATA_WIDTH
      )
      Port map ( 
        clk_adc                         => adc_clk,
        clk_adc_rst_n                   => adc_rst_n,
        clk_ip                          => clk_ref,
        clk_ip_rst_n                    => s00_axi_aresetn,
        
        adc_ch0                         => adc_ch0     ,
        adc_ch1                         => adc_ch1     ,
        adc_ch2                         => adc_ch2     ,
        adc_ch3                         => adc_ch3     ,
        adc_freq                        => adc_freq,
        up_time                         => up_time,
      
        ext_trigger                     => ext_trigger,
        
        unit_status_in                  => unit_status_in               ,
        bus_error_count                 => bus_error_count              ,
        bus_error_integrator            => bus_error_integrator         ,
        unit_control                    => unit_control                 ,
        datac_delay                     => datac_delay                  ,
        datac_window                    => datac_window                 ,
        datac_processed                 => datac_processed              ,
        tick_counter                    => tick_counter,
                                        
        m00_axis_tvalid	                => m00_axis_tvalid	            ,
        m00_axis_tdata	                => m00_axis_tdata	            , 
        m00_axis_tready	                => m00_axis_tready	            
        
        
      );

-- Instantiation of Axi Bus Interface S00_AXI
adc_triggered_dataq_unit_v1_0_S00_AXI_inst : adc_triggered_dataq_unit_v1_0_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
	    unit_status_in         => unit_status_in        ,
        bus_error_count        => bus_error_count       ,
        bus_error_integrator   => bus_error_integrator  ,
        unit_control           => unit_control          ,
        datac_delay            => datac_delay           ,
        datac_window           => datac_window          ,
        datac_processed        => datac_processed       ,
        tick_counter           => tick_counter,
        adc_freq                        => adc_freq,
        up_time                         => up_time,
        
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
