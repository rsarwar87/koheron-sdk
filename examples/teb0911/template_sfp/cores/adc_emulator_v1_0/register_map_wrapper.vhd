---------------------------------------------------------------------------------------------------
--! @brief Wrapper for AXI4-Lite register map with application-specific signal names
--!    Maps generic register interface to ADC emulator-specific control and status signals.
--!    Register mapping:
--!    - reg0: emulator_control (R/W)
--!    - reg1: dbg_control (R/W)
--!    - reg8: emulator_status (R-only)
--!    - reg9: tlast_count (R-only)
--!    - reg10: dbg_status (R-only)
--!
--! @author Martin Krzisnik, Cosylab (martin.krzisnik@cosylab.com)
--! @file register_map_wrapper.vhd
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------------------------------------------------------------------------------
--! Application-specific wrapper for register_map entity
entity register_map_wrapper is
   port (
      --! Application Register Interface
      emulator_control : out std_logic_vector(31 downto 0);  --! Emulator control register output
      emulator_status  : in  std_logic_vector(31 downto 0);  --! Emulator status register input
      tlast_count      : in  std_logic_vector(31 downto 0);  --! tlast event counter input
      dbg_control      : out std_logic_vector(31 downto 0);  --! Debug control register output
      dbg_status       : in  std_logic_vector(31 downto 0);  --! Debug status register input

      --! @virtualbus axi_lite_slave AXI4-Lite Slave Interface
      s_axi_lite_aclk    : in  std_logic;                      --! AXI clock
      s_axi_lite_aresetn : in  std_logic;                      --! AXI active-low reset
      s_axi_lite_awaddr  : in  std_logic_vector(5 downto 0);   --! Write address
      s_axi_lite_awprot  : in  std_logic_vector(2 downto 0);   --! Write protection type
      s_axi_lite_awvalid : in  std_logic;                      --! Write address valid
      s_axi_lite_awready : out std_logic;                      --! Write address ready
      s_axi_lite_wdata   : in  std_logic_vector(31 downto 0);  --! Write data
      s_axi_lite_wstrb   : in  std_logic_vector(3 downto 0);   --! Write strobes
      s_axi_lite_wvalid  : in  std_logic;                      --! Write valid
      s_axi_lite_wready  : out std_logic;                      --! Write ready
      s_axi_lite_bresp   : out std_logic_vector(1 downto 0);   --! Write response
      s_axi_lite_bvalid  : out std_logic;                      --! Write response valid
      s_axi_lite_bready  : in  std_logic;                      --! Write response ready
      s_axi_lite_araddr  : in  std_logic_vector(5 downto 0);   --! Read address
      s_axi_lite_arprot  : in  std_logic_vector(2 downto 0);   --! Read protection type
      s_axi_lite_arvalid : in  std_logic;                      --! Read address valid
      s_axi_lite_arready : out std_logic;                      --! Read address ready
      s_axi_lite_rdata   : out std_logic_vector(31 downto 0);  --! Read data
      s_axi_lite_rresp   : out std_logic_vector(1 downto 0);   --! Read response
      s_axi_lite_rvalid  : out std_logic;                      --! Read valid
      s_axi_lite_rready  : in  std_logic                       --! Read ready
      );
end register_map_wrapper;
---------------------------------------------------------------------------------------------------
architecture arch_imp of register_map_wrapper is

begin

   --! AXI4-Lite register map instantiation:<br>
   --!   Maps registers to application-specific signals:<br>
   --!   - Registers 0-1: Control outputs (emulator_control, dbg_control)<br>
   --!   - Registers 2-7: Unused (tied to open)<br>
   --!   - Registers 8-10: Status inputs (emulator_status, tlast_count, dbg_status)<br>
   --!   - Registers 11-15: Unused (tied to '0')
   u_register_map : entity work.register_map
      generic map (
         C_S_AXI_DATA_WIDTH => 32,
         C_S_AXI_ADDR_WIDTH => 6
         )
      port map (
         reg0_o        => emulator_control,
         reg1_o        => dbg_control,
         reg2_o        => open,
         reg3_o        => open,
         reg4_o        => open,
         reg5_o        => open,
         reg6_o        => open,
         reg7_o        => open,
         reg8_i        => emulator_status,
         reg9_i        => tlast_count,
         reg10_i       => dbg_status,
         reg11_i       => (others => '0'),
         reg12_i       => (others => '0'),
         reg13_i       => (others => '0'),
         reg14_i       => (others => '0'),
         reg15_i       => (others => '0'),
         wrReq_o       => open,
         rdReq_o       => open,
         S_AXI_ACLK    => s_axi_lite_aclk,
         S_AXI_ARESETN => s_axi_lite_aresetn,
         S_AXI_AWADDR  => s_axi_lite_awaddr,
         S_AXI_AWPROT  => s_axi_lite_awprot,
         S_AXI_AWVALID => s_axi_lite_awvalid,
         S_AXI_AWREADY => s_axi_lite_awready,
         S_AXI_WDATA   => s_axi_lite_wdata,
         S_AXI_WSTRB   => s_axi_lite_wstrb,
         S_AXI_WVALID  => s_axi_lite_wvalid,
         S_AXI_WREADY  => s_axi_lite_wready,
         S_AXI_BRESP   => s_axi_lite_bresp,
         S_AXI_BVALID  => s_axi_lite_bvalid,
         S_AXI_BREADY  => s_axi_lite_bready,
         S_AXI_ARADDR  => s_axi_lite_araddr,
         S_AXI_ARPROT  => s_axi_lite_arprot,
         S_AXI_ARVALID => s_axi_lite_arvalid,
         S_AXI_ARREADY => s_axi_lite_arready,
         S_AXI_RDATA   => s_axi_lite_rdata,
         S_AXI_RRESP   => s_axi_lite_rresp,
         S_AXI_RVALID  => s_axi_lite_rvalid,
         S_AXI_RREADY  => s_axi_lite_rready
         );

end arch_imp;
