set display_name {ADC EMULATOR}

set core [ipx::current_core]

set_property DISPLAY_NAME $display_name $core
set_property DESCRIPTION $display_name $core

set_property VENDOR {CCFE} $core
set_property VENDOR_DISPLAY_NAME {CCFE} $core
set_property COMPANY_URL {http://www.ccfe.ac.uk} $core

# Define a clock (this is used in the later commands, where axi interfaces are associated with the clock domains)
ipx::infer_bus_interface axi_clk  xilinx.com:signal:clock_rtl:1.0 $core

# Associate the bus interface with a clock
ipx::associate_bus_interfaces -busif m_axis -clock axi_clk $core
ipx::associate_bus_interfaces -busif s_axis -clock axi_clk $core
ipx::associate_bus_interfaces -busif s00_axil_conf_stat -clock axi_clk $core