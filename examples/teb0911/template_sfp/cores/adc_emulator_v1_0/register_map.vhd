---------------------------------------------------------------------------------------------------
--! @brief AXI4-Lite register map with 16 32-bit registers
--!   Auto-generated AXI4-Lite slave providing 16 registers:
--!   - Registers 0-7: R/W configuration registers
--!   - Registers 8-15: R-only status registers
--!
--! @author Martin Krzisnik, Cosylab (martin.krzisnik@cosylab.com)
--! @file register_map.vhd
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------------------------------------------------------------------------------
--! AXI4-Lite register map with 16 registers (8 R/W, 8 R-only)
entity register_map is
   generic (
      C_S_AXI_DATA_WIDTH : integer := 32;                               --! AXI data bus width (bits)
      C_S_AXI_ADDR_WIDTH : integer := 6                                 --! AXI address bus width (bits, supports 16 registers)
      );
   port (
      --! @virtualbus user_registers User Register Interface
      reg0_o  : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  --! Configuration register 0 (R/W)
      reg1_o  : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  --! Configuration register 1 (R/W)
      reg2_o  : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  --! Configuration register 2 (R/W)
      reg3_o  : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  --! Configuration register 3 (R/W)
      reg4_o  : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  --! Configuration register 4 (R/W)
      reg5_o  : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  --! Configuration register 5 (R/W)
      reg6_o  : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  --! Configuration register 6 (R/W)
      reg7_o  : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  --! Configuration register 7 (R/W)
      reg8_i  : in  std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  --! Status register 8 (R-only)
      reg9_i  : in  std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  --! Status register 9 (R-only)
      reg10_i : in  std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  --! Status register 10 (R-only)
      reg11_i : in  std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  --! Status register 11 (R-only)
      reg12_i : in  std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  --! Status register 12 (R-only)
      reg13_i : in  std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  --! Status register 13 (R-only)
      reg14_i : in  std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  --! Status register 14 (R-only)
      reg15_i : in  std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);  --! Status register 15 (R-only)
      wrReq_o : out std_logic;                                          --! Write request strobe (single-cycle pulse)
      rdReq_o : out std_logic;                                          --! Read request strobe (single-cycle pulse)
      --! @end

      --! @virtualbus axi_lite_slave AXI4-Lite Slave Interface
      S_AXI_ACLK    : in  std_logic;                                            --! AXI clock
      S_AXI_ARESETN : in  std_logic;                                            --! AXI active-low reset
      S_AXI_AWADDR  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);      --! Write address
      S_AXI_AWPROT  : in  std_logic_vector(2 downto 0);                         --! Write protection type
      S_AXI_AWVALID : in  std_logic;                                            --! Write address valid
      S_AXI_AWREADY : out std_logic;                                            --! Write address ready
      S_AXI_WDATA   : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);      --! Write data
      S_AXI_WSTRB   : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);  --! Write strobes
      S_AXI_WVALID  : in  std_logic;                                            --! Write valid
      S_AXI_WREADY  : out std_logic;                                            --! Write ready
      S_AXI_BRESP   : out std_logic_vector(1 downto 0);                         --! Write response
      S_AXI_BVALID  : out std_logic;                                            --! Write response valid
      S_AXI_BREADY  : in  std_logic;                                            --! Write response ready
      S_AXI_ARADDR  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);      --! Read address
      S_AXI_ARPROT  : in  std_logic_vector(2 downto 0);                         --! Read protection type
      S_AXI_ARVALID : in  std_logic;                                            --! Read address valid
      S_AXI_ARREADY : out std_logic;                                            --! Read address ready
      S_AXI_RDATA   : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);      --! Read data
      S_AXI_RRESP   : out std_logic_vector(1 downto 0);                         --! Read response
      S_AXI_RVALID  : out std_logic;                                            --! Read valid
      S_AXI_RREADY  : in  std_logic                                             --! Read ready
      --! @end
      );
end register_map;
---------------------------------------------------------------------------------------------------
architecture arch_imp of register_map is

   --! AXI4-Lite protocol signals
   signal axi_awaddr  : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);  --! Latched write address
   signal axi_awready : std_logic;                                        --! Write address ready
   signal axi_wready  : std_logic;                                        --! Write data ready
   signal axi_bresp   : std_logic_vector(1 downto 0);                     --! Write response
   signal axi_bvalid  : std_logic;                                        --! Write response valid
   signal axi_araddr  : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);  --! Latched read address
   signal axi_arready : std_logic;                                        --! Read address ready
   signal axi_rdata   : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);  --! Read data
   signal axi_rresp   : std_logic_vector(1 downto 0);                     --! Read response
   signal axi_rvalid  : std_logic;                                        --! Read valid

   --! Address decode constants
   constant ADDR_LSB          : integer := (C_S_AXI_DATA_WIDTH/32)+ 1;  --! LSB for word addressing (2 for 32-bit, 3 for 64-bit)
   constant OPT_MEM_ADDR_BITS : integer := 3;                           --! Register address bits (supports 16 registers)

   --! Register array (internal storage)
   signal slv_reg0  : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);  --! Register 0 (R/W)
   signal slv_reg1  : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);  --! Register 1 (R/W)
   signal slv_reg2  : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);  --! Register 2 (R/W)
   signal slv_reg3  : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);  --! Register 3 (R/W)
   signal slv_reg4  : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);  --! Register 4 (R/W)
   signal slv_reg5  : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);  --! Register 5 (R/W)
   signal slv_reg6  : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);  --! Register 6 (R/W)
   signal slv_reg7  : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);  --! Register 7 (R/W)
   signal slv_reg8  : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);  --! Register 8 (R-only, external)
   signal slv_reg9  : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);  --! Register 9 (R-only, external)
   signal slv_reg10 : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);  --! Register 10 (R-only, external)
   signal slv_reg11 : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);  --! Register 11 (R-only, external)
   signal slv_reg12 : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);  --! Register 12 (R-only, external)
   signal slv_reg13 : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);  --! Register 13 (R-only, external)
   signal slv_reg14 : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);  --! Register 14 (R-only, external)
   signal slv_reg15 : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);  --! Register 15 (R-only, external)

   --! Control signals
   signal slv_reg_rden : std_logic;                                        --! Register read enable
   signal slv_reg_wren : std_logic;                                        --! Register write enable
   signal reg_data_out : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);  --! Register read data
   signal byte_index   : integer;                                          --! Byte lane index for partial writes
   signal aw_en        : std_logic;                                        --! Write address enable (prevents address overwrite)

begin
   ---------------------------------------------------------------------------------------------------
   --! Output Assignments
   ---------------------------------------------------------------------------------------------------
   S_AXI_AWREADY <= axi_awready;
   S_AXI_WREADY  <= axi_wready;
   S_AXI_BRESP   <= axi_bresp;
   S_AXI_BVALID  <= axi_bvalid;
   S_AXI_ARREADY <= axi_arready;
   S_AXI_RDATA   <= axi_rdata;
   S_AXI_RRESP   <= axi_rresp;
   S_AXI_RVALID  <= axi_rvalid;

   ---------------------------------------------------------------------------------------------------
   --! Write Address Ready Process:
   --! Asserts axi_awready when both AWVALID and WVALID are present.
   ---------------------------------------------------------------------------------------------------
   p_awready: process (S_AXI_ACLK)
   begin
      if rising_edge(S_AXI_ACLK) then
         if S_AXI_ARESETN = '0' then
            axi_awready <= '0';
            aw_en       <= '1';
         else
            if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and aw_en = '1') then
               -- slave is ready to accept write address when
               -- there is a valid write address and write data
               -- on the write address and data bus. This design
               -- expects no outstanding transactions.
               axi_awready <= '1';
               aw_en       <= '0';
            elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then
               aw_en       <= '1';
               axi_awready <= '0';
            else
               axi_awready <= '0';
            end if;
         end if;
      end if;
   end process;

   ---------------------------------------------------------------------------------------------------
   --! Write Address Latch Process:
   --! Latches write address when AWVALID and WVALID are both asserted.
   ---------------------------------------------------------------------------------------------------
   p_awaddr: process (S_AXI_ACLK)
   begin
      if rising_edge(S_AXI_ACLK) then
         if S_AXI_ARESETN = '0' then
            axi_awaddr <= (others => '0');
         else
            if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and aw_en = '1') then
               -- Write Address latching
               axi_awaddr <= S_AXI_AWADDR;
            end if;
         end if;
      end if;
   end process;

   ---------------------------------------------------------------------------------------------------
   --! Write Data Ready Process:
   --! Asserts axi_wready for one cycle when AWVALID and WVALID are both present.
   ---------------------------------------------------------------------------------------------------
   p_wready: process (S_AXI_ACLK)
   begin
      if rising_edge(S_AXI_ACLK) then
         if S_AXI_ARESETN = '0' then
            axi_wready <= '0';
         else
            if (axi_wready = '0' and S_AXI_WVALID = '1' and S_AXI_AWVALID = '1' and aw_en = '1') then
               -- slave is ready to accept write data when
               -- there is a valid write address and write data
               -- on the write address and data bus. This design
               -- expects no outstanding transactions.
               axi_wready <= '1';
            else
               axi_wready <= '0';
            end if;
         end if;
      end if;
   end process;

   ---------------------------------------------------------------------------------------------------
   --! Register Write Enable
   ---------------------------------------------------------------------------------------------------
   slv_reg_wren <= axi_wready and S_AXI_WVALID and axi_awready and S_AXI_AWVALID;

   ---------------------------------------------------------------------------------------------------
   --! Register Write Process:
   --!   Writes data to registers 0-7 when write enable is asserted.
   --!   Supports byte-level write strobes for partial register updates.
   ---------------------------------------------------------------------------------------------------
   p_wr_reg: process (S_AXI_ACLK)
      variable loc_addr : std_logic_vector(OPT_MEM_ADDR_BITS downto 0);
   begin
      if rising_edge(S_AXI_ACLK) then
         if S_AXI_ARESETN = '0' then
            slv_reg0 <= (others => '0');
            slv_reg1 <= (others => '0');
            slv_reg2 <= (others => '0');
            slv_reg3 <= (others => '0');
            slv_reg4 <= (others => '0');
            slv_reg5 <= (others => '0');
            slv_reg6 <= (others => '0');
            slv_reg7 <= (others => '0');
         --  slv_reg8 <= (others => '0');
         --  slv_reg9 <= (others => '0');
         --  slv_reg10 <= (others => '0');
         --  slv_reg11 <= (others => '0');
         --  slv_reg12 <= (others => '0');
         --  slv_reg13 <= (others => '0');
         --  slv_reg14 <= (others => '0');
         --  slv_reg15 <= (others => '0');
         else
            loc_addr := axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
            if (slv_reg_wren = '1') then
               case loc_addr is
                  when b"0000" =>
                     for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                        if (S_AXI_WSTRB(byte_index) = '1') then
                           -- Respective byte enables are asserted as per write strobes
                           -- slave registor 0
                           slv_reg0(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                        end if;
                     end loop;
                  when b"0001" =>
                     for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                        if (S_AXI_WSTRB(byte_index) = '1') then
                           -- Respective byte enables are asserted as per write strobes
                           -- slave registor 1
                           slv_reg1(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                        end if;
                     end loop;
                  when b"0010" =>
                     for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                        if (S_AXI_WSTRB(byte_index) = '1') then
                           -- Respective byte enables are asserted as per write strobes
                           -- slave registor 2
                           slv_reg2(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                        end if;
                     end loop;
                  when b"0011" =>
                     for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                        if (S_AXI_WSTRB(byte_index) = '1') then
                           -- Respective byte enables are asserted as per write strobes
                           -- slave registor 3
                           slv_reg3(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                        end if;
                     end loop;
                  when b"0100" =>
                     for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                        if (S_AXI_WSTRB(byte_index) = '1') then
                           -- Respective byte enables are asserted as per write strobes
                           -- slave registor 4
                           slv_reg4(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                        end if;
                     end loop;
                  when b"0101" =>
                     for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                        if (S_AXI_WSTRB(byte_index) = '1') then
                           -- Respective byte enables are asserted as per write strobes
                           -- slave registor 5
                           slv_reg5(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                        end if;
                     end loop;
                  when b"0110" =>
                     for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                        if (S_AXI_WSTRB(byte_index) = '1') then
                           -- Respective byte enables are asserted as per write strobes
                           -- slave registor 6
                           slv_reg6(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                        end if;
                     end loop;
                  when b"0111" =>
                     for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                        if (S_AXI_WSTRB(byte_index) = '1') then
                           -- Respective byte enables are asserted as per write strobes
                           -- slave registor 7
                           slv_reg7(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                        end if;
                     end loop;
                  -- when b"1000" =>
                  --   for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  --     if ( S_AXI_WSTRB(byte_index) = '1' ) then
                  --       -- Respective byte enables are asserted as per write strobes
                  --       -- slave registor 8
                  --       slv_reg8(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  --     end if;
                  --   end loop;
                  -- when b"1001" =>
                  --   for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  --     if ( S_AXI_WSTRB(byte_index) = '1' ) then
                  --       -- Respective byte enables are asserted as per write strobes
                  --       -- slave registor 9
                  --       slv_reg9(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  --     end if;
                  --   end loop;
                  -- when b"1010" =>
                  --   for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  --     if ( S_AXI_WSTRB(byte_index) = '1' ) then
                  --       -- Respective byte enables are asserted as per write strobes
                  --       -- slave registor 10
                  --       slv_reg10(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  --     end if;
                  --   end loop;
                  -- when b"1011" =>
                  --   for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  --     if ( S_AXI_WSTRB(byte_index) = '1' ) then
                  --       -- Respective byte enables are asserted as per write strobes
                  --       -- slave registor 11
                  --       slv_reg11(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  --     end if;
                  --   end loop;
                  -- when b"1100" =>
                  --   for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  --     if ( S_AXI_WSTRB(byte_index) = '1' ) then
                  --       -- Respective byte enables are asserted as per write strobes
                  --       -- slave registor 12
                  --       slv_reg12(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  --     end if;
                  --   end loop;
                  -- when b"1101" =>
                  --   for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  --     if ( S_AXI_WSTRB(byte_index) = '1' ) then
                  --       -- Respective byte enables are asserted as per write strobes
                  --       -- slave registor 13
                  --       slv_reg13(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  --     end if;
                  --   end loop;
                  -- when b"1110" =>
                  --   for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  --     if ( S_AXI_WSTRB(byte_index) = '1' ) then
                  --       -- Respective byte enables are asserted as per write strobes
                  --       -- slave registor 14
                  --       slv_reg14(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  --     end if;
                  --   end loop;
                  -- when b"1111" =>
                  --   for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  --     if ( S_AXI_WSTRB(byte_index) = '1' ) then
                  --       -- Respective byte enables are asserted as per write strobes
                  --       -- slave registor 15
                  --       slv_reg15(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  --     end if;
                  --   end loop;
                  when others =>
                     slv_reg0 <= slv_reg0;
                     slv_reg1 <= slv_reg1;
                     slv_reg2 <= slv_reg2;
                     slv_reg3 <= slv_reg3;
                     slv_reg4 <= slv_reg4;
                     slv_reg5 <= slv_reg5;
                     slv_reg6 <= slv_reg6;
                     slv_reg7 <= slv_reg7;
               -- slv_reg8 <= slv_reg8;
               -- slv_reg9 <= slv_reg9;
               -- slv_reg10 <= slv_reg10;
               -- slv_reg11 <= slv_reg11;
               -- slv_reg12 <= slv_reg12;
               -- slv_reg13 <= slv_reg13;
               -- slv_reg14 <= slv_reg14;
               -- slv_reg15 <= slv_reg15;
               end case;
            end if;
         end if;
      end if;
   end process;

   ---------------------------------------------------------------------------------------------------
   --! Write Response Process:
   --! Asserts write response valid when write transaction completes successfully.
   ---------------------------------------------------------------------------------------------------
   p_write_resp: process (S_AXI_ACLK)
   begin
      if rising_edge(S_AXI_ACLK) then
         if S_AXI_ARESETN = '0' then
            axi_bvalid <= '0';
            axi_bresp  <= "00";                                   --need to work more on the responses
         else
            if (axi_awready = '1' and S_AXI_AWVALID = '1' and axi_wready = '1' and S_AXI_WVALID = '1' and axi_bvalid = '0') then
               axi_bvalid <= '1';
               axi_bresp  <= "00";
            elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then  --check if bready is asserted while bvalid is high)
               axi_bvalid <= '0';                                 -- (there is a possibility that bready is always asserted high)
            end if;
         end if;
      end if;
   end process;

   ---------------------------------------------------------------------------------------------------
   --! Read Address Process:
   --! Asserts axi_arready and latches read address when ARVALID is asserted.
   ---------------------------------------------------------------------------------------------------
   p_arready: process (S_AXI_ACLK)
   begin
      if rising_edge(S_AXI_ACLK) then
         if S_AXI_ARESETN = '0' then
            axi_arready <= '0';
            axi_araddr  <= (others => '1');
         else
            if (axi_arready = '0' and S_AXI_ARVALID = '1') then
               -- indicates that the slave has acceped the valid read address
               axi_arready <= '1';
               -- Read Address latching
               axi_araddr  <= S_AXI_ARADDR;
            else
               axi_arready <= '0';
            end if;
         end if;
      end if;
   end process;

   ---------------------------------------------------------------------------------------------------
   --! Read Valid Process:
   --! Asserts read valid when read transaction is ready with data.
   ---------------------------------------------------------------------------------------------------
   p_rvalid: process (S_AXI_ACLK)
   begin
      if rising_edge(S_AXI_ACLK) then
         if S_AXI_ARESETN = '0' then
            axi_rvalid <= '0';
            axi_rresp  <= "00";
         else
            if (axi_arready = '1' and S_AXI_ARVALID = '1' and axi_rvalid = '0') then
               -- Valid read data is available at the read data bus
               axi_rvalid <= '1';
               axi_rresp  <= "00";      -- 'OKAY' response
            elsif (axi_rvalid = '1' and S_AXI_RREADY = '1') then
               -- Read data is accepted by the master
               axi_rvalid <= '0';
            end if;
         end if;
      end if;
   end process;

   ---------------------------------------------------------------------------------------------------
   --! Register Read Enable
   ---------------------------------------------------------------------------------------------------
   slv_reg_rden <= axi_arready and S_AXI_ARVALID and (not axi_rvalid);

   ---------------------------------------------------------------------------------------------------
   --! Register Read Mux Process:
   --! Address decode for register read operations (combinatorial).
   ---------------------------------------------------------------------------------------------------
   p_read_mux: process (slv_reg0, slv_reg1, slv_reg2, slv_reg3, slv_reg4, slv_reg5, slv_reg6, slv_reg7, slv_reg8, slv_reg9, slv_reg10, slv_reg11, slv_reg12, slv_reg13, slv_reg14, slv_reg15, axi_araddr, S_AXI_ARESETN, slv_reg_rden)
      variable loc_addr : std_logic_vector(OPT_MEM_ADDR_BITS downto 0);
   begin
      -- Address decoding for reading registers
      loc_addr := axi_araddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
      case loc_addr is
         when b"0000" =>
            reg_data_out <= slv_reg0;
         when b"0001" =>
            reg_data_out <= slv_reg1;
         when b"0010" =>
            reg_data_out <= slv_reg2;
         when b"0011" =>
            reg_data_out <= slv_reg3;
         when b"0100" =>
            reg_data_out <= slv_reg4;
         when b"0101" =>
            reg_data_out <= slv_reg5;
         when b"0110" =>
            reg_data_out <= slv_reg6;
         when b"0111" =>
            reg_data_out <= slv_reg7;
         when b"1000" =>
            reg_data_out <= slv_reg8;
         when b"1001" =>
            reg_data_out <= slv_reg9;
         when b"1010" =>
            reg_data_out <= slv_reg10;
         when b"1011" =>
            reg_data_out <= slv_reg11;
         when b"1100" =>
            reg_data_out <= slv_reg12;
         when b"1101" =>
            reg_data_out <= slv_reg13;
         when b"1110" =>
            reg_data_out <= slv_reg14;
         when b"1111" =>
            reg_data_out <= slv_reg15;
         when others =>
            reg_data_out <= (others => '0');
      end case;
   end process;

   ---------------------------------------------------------------------------------------------------
   --! Read Output Register Process:
   --! Registers read data output when read enable is asserted.
   ---------------------------------------------------------------------------------------------------
   p_read_out: process(S_AXI_ACLK) is
   begin
      if (rising_edge (S_AXI_ACLK)) then
         if (S_AXI_ARESETN = '0') then
            axi_rdata <= (others => '0');
         else
            if (slv_reg_rden = '1') then
               axi_rdata <= reg_data_out;
            end if;
         end if;
      end if;
   end process;

   -- Add user logic here
   reg0_o    <= slv_reg0;
   reg1_o    <= slv_reg1;
   reg2_o    <= slv_reg2;
   reg3_o    <= slv_reg3;
   reg4_o    <= slv_reg4;
   reg5_o    <= slv_reg5;
   reg6_o    <= slv_reg6;
   reg7_o    <= slv_reg7;
   slv_reg8  <= reg8_i;
   slv_reg9  <= reg9_i;
   slv_reg10 <= reg10_i;
   slv_reg11 <= reg11_i;
   slv_reg12 <= reg12_i;
   slv_reg13 <= reg13_i;
   slv_reg14 <= reg14_i;
   slv_reg15 <= reg15_i;

   wrReq_o <= slv_reg_wren;
   rdReq_o <= slv_reg_rden;

   -- User logic ends

end arch_imp;
