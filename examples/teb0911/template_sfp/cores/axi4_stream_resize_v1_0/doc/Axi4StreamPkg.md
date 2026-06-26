
# Package: Axi4StreamPkg 
- **File**: Axi4StreamPkg.vhd
- **Brief:**  AXI4-Stream RTL package
- **Author:**  Domen Cvenkel, Cosylab (domen.cvenkel@cosylab.com)
- **File:**  Axi4StreamPkg.vhd

## Description

This package contains type and function/procedure definitions
to be used in RTL (synthesizable) and testbench code.


## Records


### *Axi4StreamSourceType*
 AXI4-Stream source signals record (VHDL-2008 unconstrained arrays):<br>   Encapsulates all AXI4-Stream master-to-slave signals.   Uses unconstrained arrays for flexible data width configuration.
| Name   | Type             | Description                                                 |
| ------ | ---------------- | ----------------------------------------------------------- |
| tValid | std_logic        | Valid signal indicating data is available                   |
| tData  | std_logic_vector | Data payload (unconstrained width)                          |
| tStrb  | std_logic_vector | Data strobe indicating valid byte positions (unconstrained) |
| tKeep  | std_logic_vector | Data keep indicating byte positions to keep (unconstrained) |
| tLast  | std_logic        | Last transfer in packet                                     |
| tDest  | std_logic_vector | Destination routing identifier (unconstrained)              |
| tId    | std_logic_vector | Transaction identifier (unconstrained)                      |
| tUser  | std_logic_vector | User-defined sideband data (unconstrained)                  |


### *Axi4StreamDestinationType*
 AXI4-Stream destination signals record (back-pressure)<br>
   Encapsulates back-pressure signaling from slave to master.

| Name   | Type      | Description                                   |
| ------ | --------- | --------------------------------------------- |
| tReady | std_logic | Ready signal indicating slave can accept data |

