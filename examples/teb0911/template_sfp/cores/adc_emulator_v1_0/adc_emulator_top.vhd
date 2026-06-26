---------------------------------------------------------------------------------------------------
--! @brief Top-level entity for ADC emulator with integrated register map wrapper
--!    This entity combines the register_map_wrapper and adc_emulator logic into a single
--!    top-level component with clean interface separation.
--!
--! @author Martin Krzisnik, Cosylab (martin.krzisnik@cosylab.com)
--! @file adc_emulator_top.vhd
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------------------------------------------------------------------------------
--! Top-level ADC emulator entity with integrated register map wrapper
entity adc_emulator is
   generic (
      RST_POLARITY_G : std_logic := '1';     --! Reset polarity ('1' = active-high, '0' = active-low)
      MARK_DEBUG_G   : string    := "false"  --! Enable ILA debug probes ("true"/"false")
      );
   port (
      --! Clock and Reset
      axi_clk : in std_logic;                --! System AXI clock
      axi_rst : in std_logic;                --! System reset (polarity defined by RST_POLARITY_G)

      --! @virtualbus axil_control_status AXI4-Lite Control/Status Interface (axi_clk domain)
      s00_axil_conf_stat_awaddr  : in  std_logic_vector(5 downto 0);   --! Write address
      s00_axil_conf_stat_awprot  : in  std_logic_vector(2 downto 0);   --! Write protection type
      s00_axil_conf_stat_awvalid : in  std_logic;                      --! Write address valid
      s00_axil_conf_stat_awready : out std_logic;                      --! Write address ready
      s00_axil_conf_stat_wdata   : in  std_logic_vector(31 downto 0);  --! Write data
      s00_axil_conf_stat_wstrb   : in  std_logic_vector(3 downto 0);   --! Write strobes
      s00_axil_conf_stat_wvalid  : in  std_logic;                      --! Write valid
      s00_axil_conf_stat_wready  : out std_logic;                      --! Write ready
      s00_axil_conf_stat_bresp   : out std_logic_vector(1 downto 0);   --! Write response
      s00_axil_conf_stat_bvalid  : out std_logic;                      --! Write response valid
      s00_axil_conf_stat_bready  : in  std_logic;                      --! Write response ready
      s00_axil_conf_stat_araddr  : in  std_logic_vector(5 downto 0);   --! Read address
      s00_axil_conf_stat_arprot  : in  std_logic_vector(2 downto 0);   --! Read protection type
      s00_axil_conf_stat_arvalid : in  std_logic;                      --! Read address valid
      s00_axil_conf_stat_arready : out std_logic;                      --! Read ready
      s00_axil_conf_stat_rdata   : out std_logic_vector(31 downto 0);  --! Read data
      s00_axil_conf_stat_rresp   : out std_logic_vector(1 downto 0);   --! Read response
      s00_axil_conf_stat_rvalid  : out std_logic;                      --! Read valid
      s00_axil_conf_stat_rready  : in  std_logic;                      --! Read ready
      --! @end

      --! @virtualbus aurora_tx_axis Aurora TX AXI-Stream Master Interface (axi_clk domain)
      m_axis_tvalid : out std_logic;                      --! TX valid signal
      m_axis_tdata  : out std_logic_vector(63 downto 0);  --! TX data (quadruplicated 16-bit count)
      m_axis_tkeep  : out std_logic_vector(7 downto 0);   --! TX byte enable
      m_axis_tlast  : out std_logic;                      --! TX last transfer in packet
      m_axis_tready : in  std_logic;                      --! TX ready (back-pressure from downstream)
      m_axis_tuser  : out std_logic_vector(1 downto 0);   --! TX user signals (SOF/EOF indicators)
      --! @end

      --! @virtualbus aurora_rx_axis Aurora RX AXI-Stream Slave Interface (axi_clk domain)
      usr_irq_req : out std_logic;
      usr_irq_ack : in std_logic;

      s_axis_tvalid : in  std_logic;                      --! RX valid signal
      s_axis_tdata  : in  std_logic_vector(63 downto 0);  --! RX data (checked for quadrupling and sequential order)
      s_axis_tkeep  : in  std_logic_vector(7 downto 0);   --! RX byte enable
      s_axis_tlast  : in  std_logic;                      --! RX last transfer in packet
      s_axis_tready : out std_logic                       --! RX ready (back-pressure to upstream)

      --! @end
      );
end adc_emulator;
---------------------------------------------------------------------------------------------------
architecture rtl of adc_emulator is
   --! Internal signals for register map interface
   signal emulator_control : std_logic_vector(31 downto 0);
   signal emulator_status  : std_logic_vector(31 downto 0);
   signal tlast_count      : std_logic_vector(31 downto 0);
   signal dbg_control      : std_logic_vector(31 downto 0);
   signal dbg_status       : std_logic_vector(31 downto 0);

   --! AXI active-low reset (converted from axi_rst based on RST_POLARITY_G)
   signal sAxiAresetn : std_logic;
   signal tlast : std_logic;

   ---------------------------------------------------------------------------------------------------
   -- Debug declarations
   ---------------------------------------------------------------------------------------------------
   attribute mark_debug : string;
   attribute mark_debug of emulator_control : signal is MARK_DEBUG_G;
   attribute mark_debug of emulator_status  : signal is MARK_DEBUG_G;
   attribute mark_debug of dbg_control      : signal is MARK_DEBUG_G;
   attribute mark_debug of dbg_status       : signal is MARK_DEBUG_G;

begin

  process(axi_clk, sAxiAresetn)
  begin
    if sAxiAresetn = '0' then
      usr_irq_req <= '0'; --m_axis_tvalid;
    elsif rising_edge(axi_clk) then
      if usr_irq_ack = '1' then
      usr_irq_req <= '0'; --m_axis_tvalid;
        elsif tlast = '1' then
      usr_irq_req <= '1'; --m_axis_tvalid;
          end if;
    end if;
  end process;
  m_axis_tvalid <= tlast;


   --! Reset polarity conversion: active-high to active-low for AXI-Lite interface
   GEN_AXI_RESET_INVERT : if RST_POLARITY_G = '1' generate
      sAxiAresetn <= not axi_rst;
   end generate GEN_AXI_RESET_INVERT;

   --! Reset polarity conversion: active-low passthrough for AXI-Lite interface
   GEN_AXI_RESET_PASS_THROUGH : if RST_POLARITY_G = '0' generate
      sAxiAresetn <= axi_rst;
   end generate GEN_AXI_RESET_PASS_THROUGH;

   --! AXI4-Lite register interface wrapper instantiation:<br>
   --!   Provides memory-mapped access to control and status registers:<br>
   --!   - emulator_control: Packet size, pause config, loopback enable, reset commands<br>
   --!   - emulator_status: Error flags (TX handshake, RX quadrupling, RX sequence)<br>
   --!   - tlast_count: Count of received tlast events<br>
   --!   - dbg_control/status: Debug registers
   u_register_map_wrapper : entity work.register_map_wrapper
      port map (
         --! Application signals
         emulator_control => emulator_control,
         emulator_status  => emulator_status,
         tlast_count      => tlast_count,
         dbg_control      => dbg_control,
         dbg_status       => dbg_status,
         --! AXI4-Lite interface
         s_axi_lite_aclk    => axi_clk,
         s_axi_lite_aresetn => sAxiAresetn,
         s_axi_lite_awaddr  => s00_axil_conf_stat_awaddr,
         s_axi_lite_awprot  => s00_axil_conf_stat_awprot,
         s_axi_lite_awvalid => s00_axil_conf_stat_awvalid,
         s_axi_lite_awready => s00_axil_conf_stat_awready,
         s_axi_lite_wdata   => s00_axil_conf_stat_wdata,
         s_axi_lite_wstrb   => s00_axil_conf_stat_wstrb,
         s_axi_lite_wvalid  => s00_axil_conf_stat_wvalid,
         s_axi_lite_wready  => s00_axil_conf_stat_wready,
         s_axi_lite_bresp   => s00_axil_conf_stat_bresp,
         s_axi_lite_bvalid  => s00_axil_conf_stat_bvalid,
         s_axi_lite_bready  => s00_axil_conf_stat_bready,
         s_axi_lite_araddr  => s00_axil_conf_stat_araddr,
         s_axi_lite_arprot  => s00_axil_conf_stat_arprot,
         s_axi_lite_arvalid => s00_axil_conf_stat_arvalid,
         s_axi_lite_arready => s00_axil_conf_stat_arready,
         s_axi_lite_rdata   => s00_axil_conf_stat_rdata,
         s_axi_lite_rresp   => s00_axil_conf_stat_rresp,
         s_axi_lite_rvalid  => s00_axil_conf_stat_rvalid,
         s_axi_lite_rready  => s00_axil_conf_stat_rready
         );

   --! ADC emulator core instantiation:<br>
   --!   Emulates ADC behavior with test pattern generation and loopback verification:<br>
   --!   - Generates sequential 16-bit counter values quadruplicated on TX<br>
   --!   - Verifies RX data for quadrupling and sequential order<br>
   --!   - Detects and latches error conditions<br>
   --!   - Supports configurable packet size and inter-packet pause
   u_adc_emulator : entity work.adc_emulator_ip
      generic map (
         RST_POLARITY_G => RST_POLARITY_G,
         MARK_DEBUG_G   => MARK_DEBUG_G
         )
      port map (
         --! Clock and Reset
         axi_clk => axi_clk,
         axi_rst => axi_rst,

         --! Control and Status Signals (connected to register_map_wrapper)
         emulator_control => emulator_control,
         emulator_status  => emulator_status,
         tlast_count      => tlast_count,
         dbg_control      => dbg_control,
         dbg_status       => dbg_status,

         --! Aurora TX AXI-Stream Master Interface
         m_axis_tvalid => tlast,
         m_axis_tdata  => m_axis_tdata,
         m_axis_tkeep  => m_axis_tkeep,
         m_axis_tlast  => m_axis_tlast,
         m_axis_tready => m_axis_tready,
         m_axis_tuser  => m_axis_tuser,

         --! Aurora RX AXI-Stream Slave Interface
         s_axis_tvalid => s_axis_tvalid,
         s_axis_tdata  => s_axis_tdata,
         s_axis_tkeep  => s_axis_tkeep,
         s_axis_tlast  => s_axis_tlast,
         s_axis_tready => s_axis_tready
         );

end rtl;
---------------------------------------------------------------------------------------------------
