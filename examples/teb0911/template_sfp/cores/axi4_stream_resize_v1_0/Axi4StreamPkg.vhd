---------------------------------------------------------------------------------------------------
--! @brief AXI4-Stream RTL package
--!    This package contains type and function/procedure definitions
--!    to be used in RTL (synthesizable) and testbench code.
--!
--! @author Domen Cvenkel, Cosylab (domen.cvenkel@cosylab.com)
--! @file Axi4StreamPkg.vhd
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package Axi4StreamPkg is

   ---------------------------------------------------------------------------------------------------
   -- AXI4-Stream VHDL-2008 interface records (unconstrained)
   ---------------------------------------------------------------------------------------------------

   --! AXI4-Stream source signals record (VHDL-2008 unconstrained arrays):<br>
   --!   Encapsulates all AXI4-Stream master-to-slave signals.
   --!   Uses unconstrained arrays for flexible data width configuration.
   type Axi4StreamSourceType is record
      tValid : std_logic;               --! Valid signal indicating data is available
      tData  : std_logic_vector;        --! Data payload (unconstrained width)
      tStrb  : std_logic_vector;        --! Data strobe indicating valid byte positions (unconstrained)
      tKeep  : std_logic_vector;        --! Data keep indicating byte positions to keep (unconstrained)
      tLast  : std_logic;               --! Last transfer in packet
      tDest  : std_logic_vector;        --! Destination routing identifier (unconstrained)
      tId    : std_logic_vector;        --! Transaction identifier (unconstrained)
      tUser  : std_logic_vector;        --! User-defined sideband data (unconstrained)
   end record Axi4StreamSourceType;

   --! AXI4-Stream destination signals record (back-pressure)<br>
   --!   Encapsulates back-pressure signaling from slave to master.
   type Axi4StreamDestinationType is record
      tReady : std_logic;               --! Ready signal indicating slave can accept data
   end record Axi4StreamDestinationType;

end Axi4StreamPkg;

package body Axi4StreamPkg is

end package body Axi4StreamPkg;
