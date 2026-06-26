---------------------------------------------------------------------------------------------------
--! @brief Testbench for adc_emulator - Tests TX (sending) functionality
--!
--! @author Testbench generated for adc_emulator
--! @file adc_emulator_tb.vhd
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library work;

---------------------------------------------------------------------------------------------------
-- Testbench Entity
---------------------------------------------------------------------------------------------------
entity adc_emulator_tb is
end adc_emulator_tb;
---------------------------------------------------------------------------------------------------
architecture tb of adc_emulator_tb is

   --! Custom integer vector type for packet sizes
   type integer_vector is array (natural range <>) of integer;

   --! Testbench constants
   constant CLK_PERIOD_C : time := 10 ns;  -- 100 MHz clock
   constant RST_POLARITY_C : std_logic := '1';

   --! Testbench signals
   signal axi_clk       : std_logic := '0';
   signal axi_rst       : std_logic := '0';

   --! Control and Status Signals
   signal emulator_control : std_logic_vector(31 downto 0) := (others => '0');
   signal emulator_status  : std_logic_vector(31 downto 0);
   signal tlast_count      : std_logic_vector(31 downto 0);
   signal dbg_control      : std_logic_vector(31 downto 0) := (others => '0');
   signal dbg_status       : std_logic_vector(31 downto 0);

   --! Aurora TX AXI-Stream Master Interface (m_axis)
   signal m_axis_tvalid : std_logic := '0';
   signal m_axis_tdata  : std_logic_vector(63 downto 0) := (others => '0');
   signal m_axis_tkeep  : std_logic_vector(7 downto 0) := (others => '0');
   signal m_axis_tlast  : std_logic := '0';
   signal m_axis_tready : std_logic := '1';  -- DUT always ready to accept back-pressure
   signal m_axis_tuser  : std_logic_vector(1 downto 0);

   --! Aurora RX AXI-Stream Slave Interface (s_axis) - Not used in TX-only test
   signal s_axis_tvalid : std_logic := '0';
   signal s_axis_tdata  : std_logic_vector(63 downto 0) := (others => '0');
   signal s_axis_tkeep  : std_logic_vector(7 downto 0) := (others => '0');
   signal s_axis_tlast  : std_logic := '0';
   signal s_axis_tready : std_logic;

   --! Test configuration
   subtype PACKET_SIZE_C is natural range 15 downto 0;
   subtype PAUSE_LENGTH_C is natural range 27 downto 16;
   constant PAUSE_EN_C          : positive := 28;
   constant RESET_TLAST_COUNT_C : positive := 29;
   constant RESET_ERRORS_C      : positive := 30;
   constant LOOPBACK_EN_C       : positive := 31;

   --! Test result tracking
   signal test_passed : boolean := true;
   signal test_count  : natural := 0;
   signal pass_count  : natural := 0;
   signal fail_count  : natural := 0;

   --! Stop simulation flag
   signal stop_sim : std_logic := '0';

   --! Test mode selection
   type test_mode_t is (
      TEST_IDLE,
      TEST_BASIC_SEQUENTIAL,
      TEST_PACKET_SIZE,
      TEST_PAUSE_BETWEEN_PACKETS,
      TEST_TLAST_COUNTER,
      TEST_BACK_PRESSURE,
      TEST_QUADRUPLICATED_DATA,
      TEST_SOF_INDICATOR
   );
   signal current_test : test_mode_t := TEST_IDLE;

---------------------------------------------------------------------------------------------------
begin

   --! Clock generation (100 MHz)
   axi_clk <= not axi_clk after CLK_PERIOD_C / 2;

   --! Device Under Test (DUT) instantiation
   u_dut : entity work.adc_emulator
      generic map (
         RST_POLARITY_G => RST_POLARITY_C,
         MARK_DEBUG_G   => "false"
         )
      port map (
         -- Clock and Reset
         axi_clk        => axi_clk,
         axi_rst        => axi_rst,

         -- Control and Status Signals
         emulator_control => emulator_control,
         emulator_status  => emulator_status,
         tlast_count      => tlast_count,
         dbg_control      => dbg_control,
         dbg_status       => dbg_status,

         -- Aurora TX AXI-Stream Master Interface
         m_axis_tvalid    => m_axis_tvalid,
         m_axis_tdata     => m_axis_tdata,
         m_axis_tkeep     => m_axis_tkeep,
         m_axis_tlast     => m_axis_tlast,
         m_axis_tready    => m_axis_tready,
         m_axis_tuser     => m_axis_tuser,

         -- Aurora RX AXI-Stream Slave Interface
         s_axis_tvalid    => s_axis_tvalid,
         s_axis_tdata     => s_axis_tdata,
         s_axis_tkeep     => s_axis_tkeep,
         s_axis_tlast     => s_axis_tlast,
         s_axis_tready    => s_axis_tready
         );

   --! Test stimulus process
   p_stimulus : process
      variable count_val : unsigned(15 downto 0);
      variable expected_val : unsigned(15 downto 0);
      variable errors : natural := 0;
      variable samples_count : natural := 0;
      variable packet_sizes : integer_vector(0 to 4) := (15, 31, 63, 127, 255);
      variable pause_cycles : natural := 0;
      variable prev_valid : std_logic := '0';
      variable in_pause : boolean := false;
      variable expected_tlast_count : unsigned(31 downto 0);
      variable actual_tlast_count : unsigned(31 downto 0);
      variable data_0 : unsigned(15 downto 0);
      variable data_1 : unsigned(15 downto 0);
      variable data_2 : unsigned(15 downto 0);
      variable data_3 : unsigned(15 downto 0);
      variable check_count : natural := 0;
      variable sof_seen_after_pause : boolean := false;
      variable stall_cycles : natural := 0;
      variable packet_num : natural := 0;
   begin
      --! Initialize test
      report "=== ADC Emulator TX Testbench Started ===" severity note;

      --! Apply reset
      axi_rst <= '1';
      emulator_control <= (others => '0');
      wait for CLK_PERIOD_C * 10;

      --! Release reset
      axi_rst <= '0';
      wait for CLK_PERIOD_C * 5;

     
      report "=== Running Test 3: Pause Between Packets ===" severity note;
      test_count <= test_count + 1;

      -- Configure packet size and pause
      emulator_control(PACKET_SIZE_C) <= std_logic_vector(to_unsigned(15, 16));  -- 16 samples
      emulator_control(PAUSE_EN_C) <= '1';
      emulator_control(PAUSE_LENGTH_C) <= std_logic_vector(to_unsigned(99, 12));  -- 100 cycle pause (12-bit field)

      wait for CLK_PERIOD_C * 10;

      -- Wait for first packet to complete
      wait until m_axis_tlast = '1';
      wait for CLK_PERIOD_C;
      prev_valid := m_axis_tvalid;

      -- Count pause cycles until next packet starts
      in_pause := true;
      pause_cycles := 0;

      while in_pause loop
         wait for CLK_PERIOD_C;
         if prev_valid = '1' and m_axis_tvalid = '0' then
            pause_cycles := pause_cycles + 1;
         elsif m_axis_tvalid = '1' then
            in_pause := false;
         end if;
         prev_valid := m_axis_tvalid;
      end loop;

      report "    Detected pause of " & integer'image(pause_cycles) & " cycles" severity note;

      -- Pause should be approximately 100 cycles (allowing for some tolerance)
      if pause_cycles >= 95 and pause_cycles <= 105 then
         pass_count <= pass_count + 1;
         report "  Test 3 PASSED: Pause between packets verification passed" severity note;
      else
         fail_count <= fail_count + 1;
         report "  Test 3 FAILED: Pause between packets verification failed: expected ~100 cycles, got " &
                integer'image(pause_cycles) severity error;
      end if;

      -- Reset for next test
      axi_rst <= '1';
      wait for CLK_PERIOD_C * 5;
      axi_rst <= '0';
      wait for CLK_PERIOD_C * 2;

      -- ============================================================
      -- TEST 4: tlast Counter Functionality
      -- ============================================================
      report "=== Running Test 4: tlast Counter Functionality ===" severity note;
      test_count <= test_count + 1;
      errors := 0;

      -- Reset tlast counter
      emulator_control(RESET_TLAST_COUNT_C) <= '1';
      wait for CLK_PERIOD_C;
      emulator_control(RESET_TLAST_COUNT_C) <= '0';

      -- Configure packet size
      emulator_control(PACKET_SIZE_C) <= std_logic_vector(to_unsigned(15, 16));

      -- Wait for 5 packets
      for packet_num in 1 to 5 loop
         -- Wait for tlast
         wait until m_axis_tlast = '1';
         wait for CLK_PERIOD_C;

         -- Check tlast counter
         expected_tlast_count := to_unsigned(packet_num, 32);
         actual_tlast_count := unsigned(tlast_count);

         if actual_tlast_count /= expected_tlast_count then
            report "    Error: After packet " & integer'image(packet_num) &
                   " expected tlast_count=" & integer'image(to_integer(expected_tlast_count)) &
                   " but got " & integer'image(to_integer(actual_tlast_count)) severity warning;
            errors := errors + 1;
         end if;
      end loop;

      if errors = 0 then
         pass_count <= pass_count + 1;
         report "  Test 4 PASSED: tlast counter verification passed" severity note;
      else
         fail_count <= fail_count + 1;
         report "  Test 4 FAILED: tlast counter verification failed with " &
                integer'image(errors) & " errors" severity error;
      end if;

      -- Reset for next test
      axi_rst <= '1';
      wait for CLK_PERIOD_C * 5;
      axi_rst <= '0';
      wait for CLK_PERIOD_C * 2;

      -- ============================================================
      -- TEST 5: Back-Pressure Handling
      -- ============================================================
      report "=== Running Test 5: Back-Pressure Handling ===" severity note;
      test_count <= test_count + 1;
      errors := 0;

      -- Configure packet size
      emulator_control(PACKET_SIZE_C) <= std_logic_vector(to_unsigned(31, 16));

      wait for CLK_PERIOD_C * 5;

      -- Wait for first valid
      wait until m_axis_tvalid = '1';
      expected_val := (others => '0');

      -- Let a few samples through
      for i in 0 to 4 loop
         wait until m_axis_tvalid = '1' and m_axis_tready = '1';
         count_val := unsigned(m_axis_tdata(15 downto 0));
         if count_val /= expected_val then
            errors := errors + 1;
         end if;
         expected_val := expected_val + 1;
         wait for CLK_PERIOD_C;
      end loop;

      -- Apply back-pressure
      m_axis_tready <= '0';
      wait for CLK_PERIOD_C * 10;
      stall_cycles := 10;

      -- Release back-pressure
      m_axis_tready <= '1';
      wait for CLK_PERIOD_C;

      -- Continue receiving
      for i in 5 to 10 loop
         wait until m_axis_tvalid = '1' and m_axis_tready = '1';
         count_val := unsigned(m_axis_tdata(15 downto 0));
         if count_val /= expected_val then
            report "    Error: After back-pressure expected " &
                   integer'image(to_integer(expected_val)) & " but got " &
                   integer'image(to_integer(count_val)) severity warning;
            errors := errors + 1;
         end if;
         expected_val := expected_val + 1;
         wait for CLK_PERIOD_C;
      end loop;

      if errors = 0 then
         pass_count <= pass_count + 1;
         report "  Test 5 PASSED: Back-pressure handling verification passed" severity note;
      else
         fail_count <= fail_count + 1;
         report "  Test 5 FAILED: Back-pressure handling verification failed with " &
                integer'image(errors) & " errors" severity error;
      end if;

      m_axis_tready <= '1';

      -- Reset for next test
      axi_rst <= '1';
      wait for CLK_PERIOD_C * 5;
      axi_rst <= '0';
      wait for CLK_PERIOD_C * 2;

      -- ============================================================
      -- TEST 6: Quadruplicated Data Pattern Verification
      -- ============================================================
      report "=== Running Test 6: Quadruplicated Data Pattern ===" severity note;
      test_count <= test_count + 1;
      errors := 0;

      -- Configure packet size
      emulator_control(PACKET_SIZE_C) <= std_logic_vector(to_unsigned(63, 16));

      wait for CLK_PERIOD_C * 5;

      -- Check quadruplicated pattern for multiple samples
      check_count := 0;
      while check_count < 20 loop
         wait until m_axis_tvalid = '1' and m_axis_tready = '1';
         wait for CLK_PERIOD_C;

         data_0 := unsigned(m_axis_tdata(15 downto 0));
         data_1 := unsigned(m_axis_tdata(31 downto 16));
         data_2 := unsigned(m_axis_tdata(47 downto 32));
         data_3 := unsigned(m_axis_tdata(63 downto 48));

         -- All four 16-bit segments should be identical
         if data_0 /= data_1 or data_0 /= data_2 or data_0 /= data_3 then
            report "    Error: Data not quadruplicated at sample " & integer'image(check_count) &
                   ": [" & integer'image(to_integer(data_3)) & ", " &
                   integer'image(to_integer(data_2)) & ", " &
                   integer'image(to_integer(data_1)) & ", " &
                   integer'image(to_integer(data_0)) & "]" severity warning;
            errors := errors + 1;
         end if;

         check_count := check_count + 1;

         exit when m_axis_tlast = '1';
      end loop;

      if errors = 0 then
         pass_count <= pass_count + 1;
         report "  Test 6 PASSED: Quadruplicated data pattern verification passed" severity note;
      else
         fail_count <= fail_count + 1;
         report "  Test 6 FAILED: Quadruplicated data pattern verification failed with " &
                integer'image(errors) & " errors" severity error;
      end if;

      -- Reset for next test
      axi_rst <= '1';
      wait for CLK_PERIOD_C * 5;
      axi_rst <= '0';
      wait for CLK_PERIOD_C * 2;

      -- ============================================================
      -- TEST 7: SOF (Start of Frame) Indicator Verification
      -- ============================================================
      report "=== Running Test 7: SOF Indicator Verification ===" severity note;
      test_count <= test_count + 1;

      -- Configure packet size and pause
      emulator_control(PACKET_SIZE_C) <= std_logic_vector(to_unsigned(15, 16));
      emulator_control(PAUSE_EN_C) <= '1';
      emulator_control(PAUSE_LENGTH_C) <= std_logic_vector(to_unsigned(49, 12));

      wait for CLK_PERIOD_C * 10;

      -- Wait for first packet to complete
      wait until m_axis_tlast = '1';
      wait for CLK_PERIOD_C;

      -- Wait for pause to complete and next packet to start
      -- SOF should be '1' on the first cycle after pause
      sof_seen_after_pause := false;
      for i in 0 to 100 loop
         wait for CLK_PERIOD_C;
         if m_axis_tvalid = '1' and m_axis_tuser(1) = '1' then
            sof_seen_after_pause := true;
            report "    SOF detected after pause (cycle " & integer'image(i) & ")" severity note;
            exit;
         end if;
      end loop;

      if sof_seen_after_pause then
         pass_count <= pass_count + 1;
         report "  Test 7 PASSED: SOF indicator verification passed" severity note;
      else
         fail_count <= fail_count + 1;
         report "  Test 7 FAILED: SOF indicator verification failed: SOF not detected after pause" severity error;
      end if;

      -- ============================================================
      -- END OF ALL TESTS
      -- ============================================================
      report "=== All Tests Completed ===" severity note;
      report "Passed: " & integer'image(pass_count) severity note;
      report "Failed: " & integer'image(fail_count) severity note;

      wait for CLK_PERIOD_C * 10;
      stop_sim <= '1';
      wait;
   end process p_stimulus;

   --! Test result checker process
   p_result_checker : process
   begin
      wait until stop_sim = '1';

      -- Wait for final results
      wait for CLK_PERIOD_C * 10;

      -- Final report
      if fail_count = 0 then
         report "=== ALL TESTS PASSED ===" severity note;
      else
         report "=== SOME TESTS FAILED ===" severity error;
      end if;

      wait;
   end process p_result_checker;

   --! Monitor process for debugging
   p_monitor : process
   begin
      wait until rising_edge(axi_clk);

      -- Optional: Add monitoring here if needed
      -- if m_axis_tvalid = '1' and m_axis_tready = '1' then
      --    report "TX: count=" & integer'image(to_integer(unsigned(m_axis_tdata(15 downto 0))))
      --           & " tlast=" & std_logic'image(m_axis_tlast) severity note;
      -- end if;

   end process p_monitor;

end tb;
---------------------------------------------------------------------------------------------------
