---------------------------------------------------------------------------------------------------
--! @brief Koheron and Vivado block design ready wrapper for Axi4StreamResize component.
--!    The unit is a simple wrapper to allow core interface detection by xilinx IP
--!    packager.
--!
--! @author Domen Cvenkel, Cosylab (domen.cvenkel@cosylab.com)
--! @file axi4_stream_resize.vhd
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Axi4StreamPkg.all;

---------------------------------------------------------------------------------------------------
--! Wrapper entity for Axi4StreamResize with Vivado block design compatible AXI4-Stream ports
entity axi4_stream_resize is
   generic (
      RST_POLARITY_G      : std_logic := '1';  --! Reset polarity ('1' = active-high, '0' = active-low)
      S_TDATA_WIDTH_BYTES : positive  := 8;    --! Slave AXI-Stream data width in bytes
      M_TDATA_WIDTH_BYTES : positive  := 16    --! Master AXI-Stream data width in bytes
      );
   port (
      --! Clock and Reset
      axi_clk : in std_logic;                  --! AXI clock
      axi_rst : in std_logic;                  --! AXI reset (polarity defined by RST_POLARITY_G)

      --! @virtualbus slave_interface Slave AXI-Stream Interface
      s_axis_tvalid : in  std_logic;                                             --! Slave channel valid signal
      s_axis_tdata  : in  std_logic_vector(S_TDATA_WIDTH_BYTES*8 - 1 downto 0);  --! Slave channel data
      s_axis_tkeep  : in  std_logic_vector(S_TDATA_WIDTH_BYTES - 1 downto 0);    --! Slave channel byte enable
      s_axis_tlast  : in  std_logic;                                             --! Slave channel last transfer in packet
      s_axis_tready : out std_logic;                                             --! Slave channel ready (back-pressure to upstream)
      s_axis_tuser  : in  std_logic_vector(1 downto 0);                          --! Slave channel user-defined data
      --! @end

      --! @virtualbus master_interface Master AXI-Stream Interface
      m_axis_tvalid : out std_logic;                                             --! Master channel valid signal
      m_axis_tdata  : out std_logic_vector(M_TDATA_WIDTH_BYTES*8 - 1 downto 0);  --! Master channel data
      m_axis_tkeep  : out std_logic_vector(M_TDATA_WIDTH_BYTES - 1 downto 0);    --! Master channel byte enable
      m_axis_tlast  : out std_logic;                                             --! Master channel last transfer in packet
      m_axis_tuser  : out std_logic_vector(1 downto 0);                          --! Master channel user-defined data
      m_axis_tready : in  std_logic                                              --! Master channel ready (back-pressure from downstream)
    --! @end
      );
end axi4_stream_resize;
---------------------------------------------------------------------------------------------------
architecture rtl of axi4_stream_resize is

   --! Slave (RX) AXI-Stream source record
   signal axi4sRxSrc : Axi4StreamSourceType (
      tData (S_TDATA_WIDTH_BYTES*8 - 1 downto 0),
      tKeep (S_TDATA_WIDTH_BYTES - 1 downto 0),
      tUser (1 downto 0),
      tStrb (S_TDATA_WIDTH_BYTES - 1 downto 0),  -- unused but has to be the same length as tKeep
      tDest (0 downto 0),                        -- unused
      tId (0 downto 0)                           -- unused
      );

   --! Slave (RX) AXI-Stream destination record (back-pressure)
   signal axi4sRxDst : Axi4StreamDestinationType;

   --! Master (TX) AXI-Stream source record
   signal axi4sTxSrc : Axi4StreamSourceType (
      tData (M_TDATA_WIDTH_BYTES*8 - 1 downto 0),
      tKeep (M_TDATA_WIDTH_BYTES - 1 downto 0),
      tUser (1 downto 0),
      tStrb (M_TDATA_WIDTH_BYTES - 1 downto 0),  -- unused but has to be the same length as tKeep
      tDest (0 downto 0),                        -- unused
      tId (0 downto 0)                           -- unused
      );

   --! Master (TX) AXI-Stream destination record (back-pressure from downstream)
   signal axi4sTxDst : Axi4StreamDestinationType;

---------------------------------------------------------------------------------------------------
begin

   --! AXI4-Stream resize component instantiation:<br>
   --!   Performs width conversion between slave and master AXI-Stream interfaces.
   --!   Supports widening (narrow to wide), narrowing (wide to narrow), or passthrough (equal widths).
   u_Axi4StreamResize : entity work.Axi4StreamResize
      generic map (
         RST_POLARITY_G => RST_POLARITY_G
         )
      port map (
         clk_i        => axi_clk,
         rst_i        => axi_rst,
         axi4sRxSrc_i => axi4sRxSrc,
         axi4sRxDst_o => axi4sRxDst,
         axi4sTxSrc_o => axi4sTxSrc,
         axi4sTxDst_i => axi4sTxDst
         );

   --! Slave (RX) side: Map Vivado-style ports to record-based interface
   axi4sRxSrc.tValid <= s_axis_tvalid;
   axi4sRxSrc.tData  <= s_axis_tdata;
   axi4sRxSrc.tKeep  <= s_axis_tkeep;
   axi4sRxSrc.tLast  <= s_axis_tlast;
   axi4sRxSrc.tUser  <= s_axis_tuser;

   s_axis_tready <= axi4sRxDst.tReady;

   --! Master (TX) side: Map record-based interface to Vivado-style ports
   m_axis_tvalid <= axi4sTxSrc.tValid;
   m_axis_tdata  <= axi4sTxSrc.tData;
   m_axis_tkeep  <= axi4sTxSrc.tKeep;
   m_axis_tlast  <= axi4sTxSrc.tLast;
   m_axis_tuser  <= axi4sTxSrc.tUser;

   axi4sTxDst.tReady <= m_axis_tready;

end rtl;
---------------------------------------------------------------------------------------------------
