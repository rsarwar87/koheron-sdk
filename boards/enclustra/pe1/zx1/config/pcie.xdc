# -------------------------------------------------------------------------------------------------
# PCIe
# -------------------------------------------------------------------------------------------------
#----------
# reset
set_property PACKAGE_PIN Y16 [get_ports {PCIE_PERST}]
set_property IOSTANDARD LVCMOS25 [get_ports {PCIE_PERST}]
# Clock
set_property PACKAGE_PIN R6  [get_ports {MGT_RCLK0_PCIE_REFCLK_clk_p[0]}]
set_property PACKAGE_PIN R5  [get_ports {MGT_RCLK0_PCIE_REFCLK_clk_n[0]}]

set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_rxp[3]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_rxn[3]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_txp[3]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_txn[3]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_rxp[2]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_rxn[2]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_txp[2]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_txn[2]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_rxp[1]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_rxn[1]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_txp[1]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_txn[1]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_rxp[0]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_rxn[0]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_txp[0]}]
set_property PACKAGE_PIN {} [get_ports {PCIE_MGT_txn[0]}]

set_property PACKAGE_PIN AB4 [get_ports {PCIE_MGT_rxp[0]}]
set_property PACKAGE_PIN Y4  [get_ports {PCIE_MGT_rxp[1]}]
set_property PACKAGE_PIN V4  [get_ports {PCIE_MGT_rxp[2]}]
set_property PACKAGE_PIN T4  [get_ports {PCIE_MGT_rxp[3]}]

set_property PACKAGE_PIN AB3 [get_ports {PCIE_MGT_rxn[0]}]
set_property PACKAGE_PIN Y3  [get_ports {PCIE_MGT_rxn[1]}]
set_property PACKAGE_PIN V3  [get_ports {PCIE_MGT_rxn[2]}]
set_property PACKAGE_PIN T3  [get_ports {PCIE_MGT_rxn[3]}]

set_property PACKAGE_PIN AA2 [get_ports {PCIE_MGT_txp[0]}]
set_property PACKAGE_PIN W2  [get_ports {PCIE_MGT_txp[1]}]
set_property PACKAGE_PIN U2  [get_ports {PCIE_MGT_txp[2]}]
set_property PACKAGE_PIN R2  [get_ports {PCIE_MGT_txp[3]}]

set_property PACKAGE_PIN AA1 [get_ports {PCIE_MGT_txn[0]}]
set_property PACKAGE_PIN W1  [get_ports {PCIE_MGT_txn[1]}]
set_property PACKAGE_PIN U1  [get_ports {PCIE_MGT_txn[2]}]
set_property PACKAGE_PIN R1  [get_ports {PCIE_MGT_txn[3]}]
