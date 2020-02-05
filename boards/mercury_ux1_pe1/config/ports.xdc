# -------------------------------------------------------------------------------------------------
# -- Project          : Mercury+ XU1 Reference Design
# -- File description : Pin assignment and timing constraints file for Mercury PE1
# -- File name        : MercuryXU1_PE1.xdc
# -- Author           : Diana Ungureanu
# -------------------------------------------------------------------------------------------------
# -- Copyright (c) 2018 by Enclustra GmbH, Switzerland. All rights are reserved.
# -- Unauthorized duplication of this document, in whole or in part, by any means is prohibited
# -- without the prior written permission of Enclustra GmbH, Switzerland.
# --
# -- Although Enclustra GmbH believes that the information included in this publication is correct
# -- as of the date of publication, Enclustra GmbH reserves the right to make changes at any time
# -- without notice.
# --
# -- All information in this document may only be published by Enclustra GmbH, Switzerland.
# -------------------------------------------------------------------------------------------------
# -- Notes:
# -- The IO standards might need to be adapted to your design
# -------------------------------------------------------------------------------------------------
# -- File history:
# --
# -- Version | Date       | Author             | Remarks
# -- ----------------------------------------------------------------------------------------------
# -- 1.0     | 22.12.2016 | D. Ungureanu       | First released version
# -- 2.0     | 20.10.2017 | D. Ungureanu       | Consistency checks
# -- 3.0     | 11.06.2018 | D. Ungureanu       | Consistency checks
# --
# -------------------------------------------------------------------------------------------------

set_property BITSTREAM.CONFIG.OVERTEMPSHUTDOWN ENABLE [current_design]

# ----------------------------------------------------------------------------------
# Important! Do not remove this constraint!
# This property ensures that all unused pins are set to high impedance.
# If the constraint is removed, all unused pins have to be set to HiZ in the top level file.
set_property BITSTREAM.CONFIG.UNUSEDPIN PULLNONE [current_design]
# ----------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# LEDs
# -------------------------------------------------------------------------------------------------

set_property PACKAGE_PIN AE8 [get_ports {Led2_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {Led2_N}]

# -------------------------------------------------------------------------------------------------
# I2C on PL side
# -------------------------------------------------------------------------------------------------

set_property PACKAGE_PIN V3 [get_ports {I2c_Scl}]
set_property IOSTANDARD LVCMOS18 [get_ports {I2c_Scl}]

set_property PACKAGE_PIN Y7 [get_ports {I2c_Sda}]
set_property IOSTANDARD LVCMOS18 [get_ports {I2c_Sda}]

set_property PACKAGE_PIN D14  [get_ports {OSC_N}]
set_property PACKAGE_PIN D15  [get_ports {OSC_P}]


# -------------------------------------------------------------------------------------------------
# PS banks defined in the block design
# -------------------------------------------------------------------------------------------------

