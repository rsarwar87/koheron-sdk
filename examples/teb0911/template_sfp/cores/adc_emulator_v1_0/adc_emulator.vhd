---------------------------------------------------------------------------------------------------
--! @brief ADC emulator core logic (counts up on TX AXIS and checks RX AXIS loopback data)
--!    This unit emulates the ADC by emitting 16-bit sequential counter value quadrupled across
--!    the whole word width on m_axis* interface and checks the incoming data on s_axis*
--!    interface for validity.
--!    Control and status signals are provided directly (AXI4-Lite interface handled externally).
--!
--! @author Martin Krzisnik, Cosylab (martin.krzisnik@cosylab.com)
--! @file adc_emulator.vhd
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
---------------------------------------------------------------------------------------------------
entity adc_emulator_ip is
   generic (
      RST_POLARITY_G : std_logic := '1';     --! Reset polarity ('1' = active-high, '0' = active-low)
      MARK_DEBUG_G   : string    := "false"  --! Enable ILA debug probes ("true"/"false")
      );
   port (
      --! Clock and Reset
      axi_clk : in std_logic;                --! System AXI clock
      axi_rst : in std_logic;                --! System reset (polarity defined by RST_POLARITY_G)

      --! Control and Status Signals (connected to register_map_wrapper)
      emulator_control : in  std_logic_vector(31 downto 0);  --! Control register input
      emulator_status  : out std_logic_vector(31 downto 0);  --! Status register output
      tlast_count      : out std_logic_vector(31 downto 0);  --! tlast counter output
      dbg_control      : in  std_logic_vector(31 downto 0);  --! Debug control input
      dbg_status       : out std_logic_vector(31 downto 0);  --! Debug status output

      --! @virtualbus aurora_tx_axis Aurora TX AXI-Stream Master Interface (axi_clk domain)
      m_axis_tvalid : out std_logic;                      --! TX valid signal
      m_axis_tdata  : out std_logic_vector(63 downto 0);  --! TX data (quadruplicated 16-bit count)
      m_axis_tkeep  : out std_logic_vector(7 downto 0);   --! TX byte enable
      m_axis_tlast  : out std_logic;                      --! TX last transfer in packet
      m_axis_tready : in  std_logic;                      --! TX ready (back-pressure from downstream)
      m_axis_tuser  : out std_logic_vector(1 downto 0);   --! TX user signals (SOF/EOF indicators)
      --! @end

      --! @virtualbus aurora_rx_axis Aurora RX AXI-Stream Slave Interface (axi_clk domain)
      s_axis_tvalid : in  std_logic;                      --! RX valid signal
      s_axis_tdata  : in  std_logic_vector(63 downto 0);  --! RX data (checked for quadrupling and sequential order)
      s_axis_tkeep  : in  std_logic_vector(7 downto 0);   --! RX byte enable
      s_axis_tlast  : in  std_logic;                      --! RX last transfer in packet
      s_axis_tready : out std_logic                       --! RX ready (back-pressure to upstream)
      --! @end
      );
end adc_emulator_ip;
---------------------------------------------------------------------------------------------------
architecture rtl of adc_emulator_ip is
   --! Register type for Two-Process design pattern
   type RegType is record
      resetCounter    : std_logic;                        --! Counter reset signal (triggers tlast)
      rxData          : unsigned(15 downto 0);            --! Last received RX data value
      firstPacketFlag : std_logic;                        --! Flag indicating first transfer after tlast
      tlastCounter    : unsigned(31 downto 0);            --! Count of tlast events received
      pauseCounter    : unsigned(11 downto 0);            --! Inter-packet pause counter
      pause           : std_logic;                        --! Pause TX transmission flag
      sof             : std_logic;                        --! Start-of-frame indicator
      emulatorStatus  : std_logic_vector(31 downto 0);    --! Latched error status register
   end record RegType;

   --! Initial and reset values for all register elements
   constant REG_INIT_C : RegType := (
      resetCounter    => '0',
      rxData          => (others => '0'),
      firstPacketFlag => '1',
      tlastCounter    => (others => '0'),
      pauseCounter    => (others => '0'),
      pause           => '0',
      sof             => '0',
      emulatorStatus  => (others => '0')
      );

   --! 16-bit counter value from TestCounter (quadruplicated for TX data)
   signal count       : std_logic_vector(15 downto 0);

   --! Bits in emulator_control
   subtype PACKET_SIZE_C is natural range 15 downto 0;
   subtype PAUSE_LENGTH_C is natural range 27 downto 16;
   constant PAUSE_EN_C          : positive := 28;
   constant RESET_TLAST_COUNT_C : positive := 29;
   constant RESET_ERRORS_C      : positive := 30;
   constant LOOPBACK_EN_C       : positive := 31;

   --! Bits in emulator_status
   constant ERR_TX_HANDSHAKE_C      : natural  := 0;
   constant ERR_RX_NOT_QUADRUPLED_C : positive := 1;
   constant ERR_RX_NOT_SEQUENTIAL_C : positive := 2;

   --! Output of registers
   signal r : RegType;


   signal enable_count : std_logic;
   SIGNAL PAULEN : std_logic_vector(11 DOWNTO 0);

   ---------------------------------------------------------------------------------------------------
   -- Debug declarations
   ---------------------------------------------------------------------------------------------------
   attribute mark_debug                     : string;
   attribute mark_debug of r                : signal is MARK_DEBUG_G;
   attribute mark_debug of count            : signal is MARK_DEBUG_G;
   attribute mark_debug of enable_count     : signal is MARK_DEBUG_G;
   attribute mark_debug of emulator_control : signal is MARK_DEBUG_G;
   attribute mark_debug of emulator_status  : signal is MARK_DEBUG_G;
   attribute mark_debug of dbg_control      : signal is MARK_DEBUG_G;
   attribute mark_debug of dbg_status       : signal is MARK_DEBUG_G;
   attribute mark_debug of m_axis_tvalid    : signal is MARK_DEBUG_G;
   attribute mark_debug of m_axis_tdata     : signal is MARK_DEBUG_G;
   attribute mark_debug of m_axis_tkeep     : signal is MARK_DEBUG_G;
   attribute mark_debug of m_axis_tlast     : signal is MARK_DEBUG_G;
   attribute mark_debug of m_axis_tready    : signal is MARK_DEBUG_G;
 ---------------------------------------------------------------------------------------------------
 begin

    --! Loopback debug control to status register for readback verification
    dbg_status <= dbg_control;

    --! Combinatorial process for next-state logic:
    --!   Implements TX packet generation with configurable pause, RX loopback verification,
    --!   and error detection logic. Updates all register next values based on current state..
    PAULEN <= emulator_control(PAUSE_LENGTH_C);
    p_Comb : process(axi_clk)
    begin
       if rising_edge(axi_clk) then
       --! default assignment
       r.resetCounter <= '0';
       r.sof          <= '0';

       --------------------------------------------------------------------------
       -- TX logic
       --------------------------------------------------------------------------
       -- reset counter (and tLast signal)
       if m_axis_tvalid = '1' and m_axis_tready = '1' then
          if (unsigned(count) >= unsigned(emulator_control(PACKET_SIZE_C)) - 1) then
             r.resetCounter <= '1';

             -- Pause tx of next packet at the end of current packet if pause is enabled.
             if (emulator_control(PAUSE_EN_C) = '1') then
                r.pause <= '1';
             end if;
          end if;

       end if;

          -- Pause transmission logic
          if (r.pause = '1') then
             if (r.pauseCounter < unsigned(emulator_control(PAUSE_LENGTH_C)) - 1) then
                r.pauseCounter <= r.pauseCounter + 1;
             else
                r.pause        <= '0';
                r.sof          <= '1';
                r.pauseCounter <= (others => '0');
             end if;
          end if;
       -- Kept for retro-compatibility
       if m_axis_tready = '0' then
          r.emulatorStatus(ERR_TX_HANDSHAKE_C) <= '1';
       end if;

       --------------------------------------------------------------------------
       -- Rx logic
       --------------------------------------------------------------------------
       -- RX checking
       if s_axis_tvalid = '1' then
          r.rxData          <= unsigned(s_axis_tdata(15 downto 0));
          r.firstPacketFlag <= '0';

          -- Check if data is quadrupled
          if (s_axis_tdata(15 downto 0) /= s_axis_tdata(31 downto 16)) or
             (s_axis_tdata(15 downto 0) /= s_axis_tdata(47 downto 32)) or
             (s_axis_tdata(15 downto 0) /= s_axis_tdata(63 downto 48)) then
             r.emulatorStatus(ERR_RX_NOT_QUADRUPLED_C) <= '1';
          end if;

          -- Handle tlast
          if s_axis_tlast then
             r.firstPacketFlag <= '1';
             r.tlastCounter    <= r.tlastCounter + 1;
          end if;

          -- Check if received data is sequential
          if r.firstPacketFlag = '0' and (s_axis_tdata(15 downto 0) /= std_logic_vector(r.rxData + 1)) then
             -- Received data is not sequential
             r.emulatorStatus(ERR_RX_NOT_SEQUENTIAL_C) <= '1';
          end if;
       end if;

       --------------------------------------------------------------------------
       -- tLast counter reset
       --------------------------------------------------------------------------
       if (emulator_control(RESET_TLAST_COUNT_C) = '1') then
          r.tlastCounter <= (others => '0');
       end if;

       --------------------------------------------------------------------------
       -- Latched errors reset
       --------------------------------------------------------------------------
       if (emulator_control(RESET_ERRORS_C)) = '1' then
          r.emulatorStatus(ERR_TX_HANDSHAKE_C)      <= '0';
          r.emulatorStatus(ERR_RX_NOT_QUADRUPLED_C) <= '0';
          r.emulatorStatus(ERR_RX_NOT_SEQUENTIAL_C) <= '0';
       end if;

       --------------------------------------------------------------------------
       -- reset condition
       --------------------------------------------------------------------------
       if (axi_rst = RST_POLARITY_G) then
          r <= REG_INIT_C;
       end if;
       --! drive outputs
       emulator_status <= r.emulatorStatus;
       tlast_count     <= std_logic_vector(r.tlastCounter);
        end if;
    end process p_Comb;


    --! 16-bit test counter for TX data generation:
    --!   Generates incrementing 16-bit count value with pause and reset control.
    --!   Configured for saturation at maximum value to prevent rollover.
    u_TestCounter : entity work.TestCounter
       generic map (
          RST_POLARITY_G => RST_POLARITY_G,
          WIDTH_G        => 16,
          WAIT_WIDTH_G   => 1,
          REVERSE_G      => false,
          SATURATE_G     => true
          )
       port map (
          clk_i        => axi_clk,
          rst_i        => axi_rst,
          ext_rst_i    => r.resetCounter,
          en_i         => enable_count,
          count_o      => count,
          endReached_o => open,
          countUpd_o   => open
          );

    enable_count <= m_axis_tvalid and m_axis_tready and (not(r.pause));

    --! TX AXI-Stream output multiplexing: Loopback mode or test pattern mode:
    --!   When loopback enabled (bit 31 of emulator_control), pass RX directly to TX.
    --!   Otherwise, drive TX with quadruplicated counter value and pause control.
    m_axis_tvalid <= s_axis_tvalid when (emulator_control(LOOPBACK_EN_C) = '1') else not(r.pause);
    m_axis_tdata  <= s_axis_tdata  when (emulator_control(LOOPBACK_EN_C) = '1') else count & count & count & count;
    m_axis_tkeep  <= s_axis_tkeep  when (emulator_control(LOOPBACK_EN_C) = '1') else (others => '1');
    m_axis_tlast  <= s_axis_tlast  when (emulator_control(LOOPBACK_EN_C) = '1') else r.resetCounter;
    s_axis_tready <= m_axis_tready when (emulator_control(LOOPBACK_EN_C) = '1') else '1';

    --! TX tuser sideband signals for SOF/EOF indication
    --!   Bit 1: Start-of-frame (SOF) pulse after pause
    --!   Bit 0: End-of-frame (EOF) - unused, tied to '0'
    m_axis_tuser(1) <= r.sof;
    m_axis_tuser(0) <= '0';

end rtl;
---------------------------------------------------------------------------------------------------
