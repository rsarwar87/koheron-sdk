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


# BUTTONS
set_property -dict {PACKAGE_PIN K14   IOSTANDARD LVCMOS18  } [get_ports {BTN1_N}]

# Clock Generator CLK0
set_property -dict {PACKAGE_PIN F11   IOSTANDARD DIFF_SSTL18_I} [get_ports {CLK_USR_N}]
set_property -dict {PACKAGE_PIN F12   IOSTANDARD DIFF_SSTL18_I} [get_ports {CLK_USR_P}]

# Oscillator 100 MHz
set_property -dict {PACKAGE_PIN J14   IOSTANDARD LVCMOS18  } [get_ports {CLK_100_CAL}]


# I2C FPGA
set_property -dict {PACKAGE_PIN C14   IOSTANDARD LVCMOS18  } [get_ports {I2C_SCL_FPGA}]
set_property -dict {PACKAGE_PIN C13   IOSTANDARD LVCMOS18  } [get_ports {I2C_SDA_FPGA}]


# I2C_MIPI_SEL
set_property -dict {PACKAGE_PIN A15   IOSTANDARD LVCMOS18  } [get_ports {I2C_MIPI_SEL}]

# I2C PL
set_property -dict {PACKAGE_PIN V3    IOSTANDARD LVCMOS18  } [get_ports {I2C_SCL}]
set_property -dict {PACKAGE_PIN Y7    IOSTANDARD LVCMOS18  } [get_ports {I2C_SDA}]

# HDMI
set_property -dict {PACKAGE_PIN B15   IOSTANDARD LVCMOS18  } [get_ports {HDMI_HPD}]
# set_property PACKAGE_PIN P5    [get_ports {HDMI_D0_N}] # GTH
# set_property PACKAGE_PIN P6    [get_ports {HDMI_D0_P}] # GTH
# set_property PACKAGE_PIN N3    [get_ports {HDMI_D1_N}] # GTH
# set_property PACKAGE_PIN N4    [get_ports {HDMI_D1_P}] # GTH
# set_property PACKAGE_PIN M5    [get_ports {HDMI_D2_N}] # GTH
# set_property PACKAGE_PIN M6    [get_ports {HDMI_D2_P}] # GTH
set_property -dict {PACKAGE_PIN AK11  IOSTANDARD LVDS      } [get_ports {HDMI_CLK_N}]
set_property -dict {PACKAGE_PIN AJ11  IOSTANDARD LVDS      } [get_ports {HDMI_CLK_P}]

# Display Port
set_property -dict {PACKAGE_PIN AG9   IOSTANDARD LVCMOS18  } [get_ports {DP_HPD}]
set_property -dict {PACKAGE_PIN AG4   IOSTANDARD LVCMOS18  } [get_ports {DP_AUX_IN}]
set_property -dict {PACKAGE_PIN AH11  IOSTANDARD LVCMOS18  } [get_ports {DP_AUX_OE}]
set_property -dict {PACKAGE_PIN AJ1   IOSTANDARD LVCMOS18  } [get_ports {DP_AUX_OUT}]

# -------------------------------------------------------------------------------------------------
# LEDs
# -------------------------------------------------------------------------------------------------


# ST1 LED
set_property -dict {PACKAGE_PIN AH4   IOSTANDARD LVCMOS18  } [get_ports {led[0]}]
set_property -dict {PACKAGE_PIN AJ4   IOSTANDARD LVCMOS18  } [get_ports {led[1]}]

# SoM LED
set_property -dict {PACKAGE_PIN AE8   IOSTANDARD LVCMOS18  } [get_ports {led[2]}]

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

