    clk_fsm_i  : in std_logic; -- fast always on 
    clk_init_i : in std_logic; -- slow always on 

    fmc_adc_fr_p : in std_logic; -- adc frame start
    fmc_adc_fr_n : in std_logic;

    fmc_adc_clk_p : in std_logic;
    fmc_adc_clk_n : in std_logic;
    fmc_adc0_n    : in std_logic_vector (3 downto 0) := (others => '0');
    fmc_adc0_p    : in std_logic_vector (3 downto 0) := (others => '0');
    fmc_adc1_n    : in std_logic_vector (3 downto 0) := (others => '0');
    fmc_adc1_p    : in std_logic_vector (3 downto 0) := (others => '0');
    fmc_adc2_n    : in std_logic_vector (3 downto 0) := (others => '0');
    fmc_adc2_p    : in std_logic_vector (3 downto 0) := (others => '0');
    fmc_adc3_n    : in std_logic_vector (3 downto 0) := (others => '0');
    fmc_adc3_p    : in std_logic_vector (3 downto 0) := (others => '0');
    fmc_trig_in_n : in std_logic;
    fmc_trig_in_p : in std_logic;

    fmc_trig_led     : out std_logic; -- inverted
    fmc_acq_led      : out std_logic;
    fmc_ads_spi_sclk : out std_logic;
    fmc_ads_spi_miso : in std_logic; -- inverted
    fmc_ads_spi_mosi : out std_logic;
    fmc_ads_spi_csn  : out std_logic; -- inverted
    fmc_osc_en       : out std_logic;
    gpio_ssr_ch0_o   : out std_logic_vector(6 downto 0) := "0000000";
    gpio_ssr_ch1_o   : out std_logic_vector(6 downto 0) := "0000000";
    gpio_ssr_ch2_o   : out std_logic_vector(6 downto 0) := "0000000";
vim co    gpio_ssr_ch3_o   : out std_logic_vector(6 downto 0) := "0000000";
