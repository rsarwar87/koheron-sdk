---------------------------------------------------------------------------------------------------
--! @brief AXI4-Stream Resize
--!    Module for resizing AXI4-Stream to different number of parallel data units.
--!    All generalizations are done through constrains applied to unconstrained ports.
--!    The number of data units (bytes or custom) in receiver `RX_TKEEP_WIDTH_C` and transmitter `TX_TKEEP_WIDTH_C` ports
--!    is determined at compile time and the resulting ratio `RATIO_C` is used to define
--!    one of the implementations: passthrough, widen and narrow.
--!
--!    Architecture implements three modes based on width ratio:
--!    - **Passthrough (GEN_EQ)**: Equal widths, direct signal mapping
--!    - **Widen (GEN_WIDEN)**: Narrow RX to wider TX, accumulates multiple RX transfers
--!    - **Narrow (GEN_NARROW)**: Wide RX to narrower TX, splits single RX into multiple TX transfers
--!
--!    ### Limitations
--!
--!    1. Only integer ratios are supported.
--!       Non integer ratios can be implemented by first widening and than narrowing the bus.
--!    2. The size of the packet is not limited anyhow by
--!       the number of parallel data units on RX or TX side.
--!    3. The module is designed and tested only for continuous aligned and unaligned streams.
--!       In case a sparse stream is provided at the RX side.
--!       The same sparsity will be present at the TX side.
--!       Also further testing might be needed for proper sparse stream operation.
--!
--!    ### Timing diagrams
--!
--!    In case of a width change from narrow (RX) to wider (TX),
--!    there are fewer transactions on the TX side compared to the RX.
--!    With a continuous `VALID` signal at RX side,
--!    this results in an intermittent `VALID` signal at the TX side.
--!
--!    In case of a width change from wide (RX) to narrower (TX),
--!    there are more transactions on the TX side compared to the RX.
--!    With a continuous `READY` signal at the TX side,
--!    this results in an intermittent `READY` backpressure signal at the RX side.
--!
--! @author Domen Cvenkel, Cosylab (domen.cvenkel@cosylab.com)
--! @file Axi4StreamResize.vhd
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- CslLib packages
use work.Axi4StreamPkg.all;

---------------------------------------------------------------------------------------------------
--! AXI4-Stream width resize implementation with passthrough, widen, and narrow modes
entity Axi4StreamResize is
   generic (
      RST_POLARITY_G : std_logic := '1'  --! Reset polarity ('1' = active-high, '0' = active-low)
      );
   port (
      --! Clock and Reset
      clk_i : in std_logic;              --! System clock
      rst_i : in std_logic;              --! System reset (polarity defined by RST_POLARITY_G)

      --! @virtualbus rx_interface RX AXI4-Stream Record Interface
      axi4sRxSrc_i : in  Axi4StreamSourceType;       --! RX source signals (from upstream)
      axi4sRxDst_o : out Axi4StreamDestinationType;  --! RX destination signals (back-pressure to upstream)
      --! @end

      --! @virtualbus tx_interface TX AXI4-Stream Record Interface
      axi4sTxSrc_o : out Axi4StreamSourceType;      --! TX source signals (to downstream)
      axi4sTxDst_i : in  Axi4StreamDestinationType  --! TX destination signals (back-pressure from downstream)
    --! @end
      );
end Axi4StreamResize;

architecture rtl of Axi4StreamResize is

   --! RX data width in bits
   constant RX_TDATA_WIDTH_C : positive := axi4sRxSrc_i.tdata'length;
   --! RX user data width in bits
   constant RX_TUSER_WIDTH_C : positive := axi4sRxSrc_i.tuser'length;
   --! RX data width in bytes (determines width ratio)
   constant RX_TKEEP_WIDTH_C : positive := axi4sRxSrc_i.tkeep'length;
   --! TX data width in bits
   constant TX_TDATA_WIDTH_C : positive := axi4sTxSrc_o.tdata'length;
   --! TX user data width in bits
   constant TX_TUSER_WIDTH_C : positive := axi4sTxSrc_o.tuser'length;
   --! TX data width in bytes (determines width ratio)
   constant TX_TKEEP_WIDTH_C : positive := axi4sTxSrc_o.tkeep'length;

   --! Width ratio segment counter (used in widen/narrow modes)
   signal cnt   : natural;
   --! Intermediate ready signal for handshaking logic (narrow mode)
   signal ready : std_logic;

begin

   --! Validation assertion: Verify width ratio is an integer
   --!   Checks that RX and TX widths are integer multiples of each other.
   --!   Non-integer ratios require cascading widen+narrow stages.
   assert (((RX_TKEEP_WIDTH_C >= TX_TKEEP_WIDTH_C) and (RX_TKEEP_WIDTH_C mod TX_TKEEP_WIDTH_C = 0)) or
           ((TX_TKEEP_WIDTH_C >= RX_TKEEP_WIDTH_C) and (TX_TKEEP_WIDTH_C mod RX_TKEEP_WIDTH_C = 0)))
      report "Data widths must be even number multiples of each other" severity failure;

   --! **Passthrough mode**: Equal RX and TX widths, direct signal mapping
   GEN_EQ : if (RX_TKEEP_WIDTH_C = TX_TKEEP_WIDTH_C) generate
      --! Combinatorial process for trivial passthrough mapping
      p_Comb : process (all)
      begin
         -- just a trivial signal mapping
         axi4sTxSrc_o <= axi4sRxSrc_i;
         axi4sRxDst_o <= axi4sTxDst_i;
      end process p_Comb;
   end generate GEN_EQ;

   --! **Widen mode**: Narrow RX stream to wider TX stream (accumulates multiple RX transfers)
   GEN_WIDEN : if (RX_TKEEP_WIDTH_C < TX_TKEEP_WIDTH_C) generate
      --! RX ready combinatorial logic: Ready when TX can accept data or TX buffer is empty
      axi4sRxDst_o.tready <= axi4sTxDst_i.tready or (not axi4sTxSrc_o.tvalid);

      --! Sequential process for widening operation:<br>
      --!   Accumulates multiple narrow RX transfers into single wide TX transfer.
      --!   Uses counter to track which TX segment is being filled.
      p_Seq : process (clk_i)
      begin
         if (rising_edge(clk_i)) then
            -- reset
            if (rst_i = RST_POLARITY_G) then
               axi4sTxSrc_o.tvalid <= '0';
               cnt                 <= 0;
            else
               -- on transfer copy data from RX to TX
               if (axi4sRxSrc_i.tvalid and axi4sRxDst_o.tready) = '1' then
                  -- data path
                  axi4sTxSrc_o.tid                                                           <= axi4sRxSrc_i.tid;
                  axi4sTxSrc_o.tdest                                                         <= axi4sRxSrc_i.tdest;
                  axi4sTxSrc_o.tlast                                                         <= axi4sRxSrc_i.tlast;
                  axi4sTxSrc_o.tdata(RX_TDATA_WIDTH_C*(cnt+1)-1 downto RX_TDATA_WIDTH_C*cnt) <= axi4sRxSrc_i.tdata;
                  axi4sTxSrc_o.tuser(RX_TUSER_WIDTH_C*(cnt+1)-1 downto RX_TUSER_WIDTH_C*cnt) <= axi4sRxSrc_i.tuser;
                  axi4sTxSrc_o.tstrb(RX_TKEEP_WIDTH_C*(cnt+1)-1 downto RX_TKEEP_WIDTH_C*cnt) <= axi4sRxSrc_i.tstrb;
                  axi4sTxSrc_o.tkeep(RX_TKEEP_WIDTH_C*(cnt+1)-1 downto RX_TKEEP_WIDTH_C*cnt) <= axi4sRxSrc_i.tkeep;
                  -- control path
                  if (cnt = (TX_TKEEP_WIDTH_C/RX_TKEEP_WIDTH_C-1)) then
                     -- when all TX slots are full
                     axi4sTxSrc_o.tvalid <= '1';
                     cnt                 <= 0;
                  elsif (axi4sRxSrc_i.tlast = '1') then
                     -- clear unused STRB/KEEP signals
                     axi4sTxSrc_o.tstrb(TX_TKEEP_WIDTH_C-1 downto RX_TKEEP_WIDTH_C*(cnt+1)) <= (others => '0');
                     axi4sTxSrc_o.tkeep(TX_TKEEP_WIDTH_C-1 downto RX_TKEEP_WIDTH_C*(cnt+1)) <= (others => '0');
                     axi4sTxSrc_o.tvalid                                                    <= '1';
                     cnt                                                                    <= 0;
                  else
                     -- there are more TX slots to fill
                     axi4sTxSrc_o.tvalid <= '0';
                     cnt                 <= cnt+1;
                  end if;
               elsif ((axi4sTxSrc_o.tvalid and axi4sTxDst_i.tready) = '1') then
                  axi4sTxSrc_o.tvalid <= '0';
               end if;
            end if;
         end if;
      end process p_Seq;
   end generate GEN_WIDEN;

   --! **Narrow mode**: Wide RX stream to narrower TX stream (splits single RX into multiple TX)
   GEN_NARROW : if (RX_TKEEP_WIDTH_C > TX_TKEEP_WIDTH_C) generate
      --! Intermediate ready: TX can accept data or TX buffer is empty
      ready <= axi4sTxDst_i.tready or (not axi4sTxSrc_o.tvalid);

      --! RX ready combinatorial logic:
      --!   RX ready when transmitting last segment or when remaining segments are all empty (early termination).
      axi4sRxDst_o.tready <= ready when ((cnt = (RX_TKEEP_WIDTH_C/TX_TKEEP_WIDTH_C-1)) or
                                         ((or axi4sRxSrc_i.tkeep(RX_TKEEP_WIDTH_C-1 downto TX_TKEEP_WIDTH_C*(cnt+1))) = '0')) else '0';

      --! Sequential process for narrowing operation:<br>
      --!   Splits single wide RX transfer into multiple narrow TX transfers.
      --!   Uses counter to track which RX segment is being transmitted.
      p_Seq : process (clk_i)
      begin
         if (rising_edge(clk_i)) then
            -- reset
            if (rst_i = RST_POLARITY_G) then
               axi4sTxSrc_o.tvalid <= '0';
               cnt                 <= 0;
            else
               if ((axi4sRxSrc_i.tvalid and ready) = '1') then
                  axi4sTxSrc_o.tid   <= axi4sRxSrc_i.tid;
                  axi4sTxSrc_o.tdest <= axi4sRxSrc_i.tdest;
                  axi4sTxSrc_o.tlast <= axi4sRxSrc_i.tlast when axi4sRxDst_o.tready = '1'   else '0';
                  axi4sTxSrc_o.tdata <= axi4sRxSrc_i.tdata(TX_TDATA_WIDTH_C*(cnt+1)-1 downto TX_TDATA_WIDTH_C*cnt);
                  axi4sTxSrc_o.tuser <= axi4sRxSrc_i.tuser(TX_TUSER_WIDTH_C*(cnt+1)-1 downto TX_TUSER_WIDTH_C*cnt);
                  axi4sTxSrc_o.tstrb <= axi4sRxSrc_i.tstrb(TX_TKEEP_WIDTH_C*(cnt+1)-1 downto TX_TKEEP_WIDTH_C*cnt);
                  axi4sTxSrc_o.tkeep <= axi4sRxSrc_i.tkeep(TX_TKEEP_WIDTH_C*(cnt+1)-1 downto TX_TKEEP_WIDTH_C*cnt);
                  -- ratio counter
                  cnt                <= 0                  when (axi4sRxDst_o.tready = '1') else cnt+1;
               end if;
               if (ready = '1') then
                  axi4sTxSrc_o.tvalid <= axi4sRxSrc_i.tvalid;
               end if;
            end if;
         end if;
      end process p_Seq;
   end generate GEN_NARROW;

end rtl;
