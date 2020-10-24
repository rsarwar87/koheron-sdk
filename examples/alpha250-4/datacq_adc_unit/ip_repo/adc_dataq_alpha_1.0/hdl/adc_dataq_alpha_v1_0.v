
`timescale 1 ns / 1 ps

	module adc_dataq_alpha_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Master Bus Interface M_AXI
		parameter integer C_M_AXI_TDATA_WIDTH	= 32,
		parameter integer C_M_AXI_START_COUNT	= 32
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Master Bus Interface M_AXI
		input wire  m_axi_aclk,
		input wire  m_axi_aresetn,
		output wire  m_axi_tvalid,
		output wire [C_M_AXI_TDATA_WIDTH-1 : 0] m_axi_tdata,
		output wire [(C_M_AXI_TDATA_WIDTH/8)-1 : 0] m_axi_tstrb,
		output wire  m_axi_tlast,
		input wire  m_axi_tready
	);
// Instantiation of Axi Bus Interface M_AXI
	adc_dataq_alpha_v1_0_M_AXI # ( 
		.C_M_AXIS_TDATA_WIDTH(C_M_AXI_TDATA_WIDTH),
		.C_M_START_COUNT(C_M_AXI_START_COUNT)
	) adc_dataq_alpha_v1_0_M_AXI_inst (
		.M_AXIS_ACLK(m_axi_aclk),
		.M_AXIS_ARESETN(m_axi_aresetn),
		.M_AXIS_TVALID(m_axi_tvalid),
		.M_AXIS_TDATA(m_axi_tdata),
		.M_AXIS_TSTRB(m_axi_tstrb),
		.M_AXIS_TLAST(m_axi_tlast),
		.M_AXIS_TREADY(m_axi_tready)
	);

	// Add user logic here

	// User logic ends

	endmodule
