-- Created with Corsair vgit-latest
-- AXI-Lite Testbench for regs

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regs_tb is
end entity regs_tb;

architecture behavioral of regs_tb is

  constant CLK_PERIOD   : time := 10 ns;
  constant ADDR_W : integer := 16;
  constant DATA_W : integer := 32;
  constant BASE_ADDR : std_logic_vector(31 downto 0) := x"80080000";

  -- Clock and Reset
  signal clk            : std_logic := '0';
  signal rst            : std_logic := '1';
  
  -- AXI-Lite Write Address Channel
  signal axil_awaddr   : std_logic_vector(ADDR_W-1 downto 0) := (others => '0');
  signal axil_awvalid  : std_logic := '0';
  signal axil_awready  : std_logic;
  
  -- AXI-Lite Write Data Channel
  signal axil_wdata    : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal axil_wstrb    : std_logic_vector(3 downto 0) := (others => '0');
  signal axil_wvalid   : std_logic := '0';
  signal axil_wready   : std_logic;
  
  -- AXI-Lite Write Response Channel
  signal axil_bresp    : std_logic_vector(1 downto 0);
  signal axil_bvalid   : std_logic;
  signal axil_bready   : std_logic := '0';
  
  -- AXI-Lite Read Address Channel
  signal axil_araddr   : std_logic_vector(ADDR_W-1 downto 0) := (others => '0');
  signal axil_arvalid  : std_logic := '0';
  signal axil_arready  : std_logic;
  
  -- AXI-Lite Read Data Channel
  signal axil_rdata    : std_logic_vector(DATA_W-1 downto 0);
  signal axil_rresp    : std_logic_vector(1 downto 0);
  signal axil_rvalid   : std_logic;
  signal axil_rready   : std_logic := '0';
  
  -- Global read data signal
  signal read_data      : std_logic_vector(DATA_W-1 downto 0) := (others => '0');

  -- CSR Signals
  signal csr_config_mode_out : std_logic_vector(2 downto 0);
  signal csr_config_enable_out : std_logic;
  signal csr_config_clk_div_out : std_logic_vector(7 downto 0);

  signal csr_status_ready_in : std_logic;
  signal csr_status_overflow_in : std_logic;
  signal csr_status_underflow_in : std_logic;
  signal csr_status_processing_in : std_logic;
  signal csr_status_fifo_level_in : std_logic_vector(9 downto 0);

  signal csr_control_start_out : std_logic;
  signal csr_control_stop_out : std_logic;
  signal csr_control_reset_fifo_out : std_logic;
  signal csr_control_auto_restart_out : std_logic;
  signal csr_control_debug_en_out : std_logic;

  signal csr_threshold_low_thresh_out : std_logic_vector(15 downto 0);
  signal csr_threshold_high_thresh_out : std_logic_vector(15 downto 0);

  signal csr_gain_coarse_gain_out : std_logic_vector(3 downto 0);
  signal csr_gain_fine_gain_out : std_logic_vector(7 downto 0);
  signal csr_gain_agc_en_out : std_logic;
  signal csr_gain_agc_en_in : std_logic;
  signal csr_gain_agc_en_en : std_logic;

  signal csr_int_mask_done_mask_out : std_logic;
  signal csr_int_mask_error_mask_out : std_logic;
  signal csr_int_mask_overflow_mask_out : std_logic;
  signal csr_int_mask_underflow_mask_out : std_logic;
  signal csr_int_mask_threshold_mask_out : std_logic;

  signal csr_int_status_done_int_set : std_logic;
  signal csr_int_status_error_int_set : std_logic;
  signal csr_int_status_overflow_int_set : std_logic;
  signal csr_int_status_underflow_int_set : std_logic;
  signal csr_int_status_threshold_int_set : std_logic;



begin

  -----------------------------------------------------------------------------
  -- Clock Generation
  -----------------------------------------------------------------------------
  clk_process : process
  begin
    clk <= '0';
    wait for CLK_PERIOD/2;
    clk <= '1';
    wait for CLK_PERIOD/2;
  end process;

  -----------------------------------------------------------------------------
  -- DUT Instantiation
  -----------------------------------------------------------------------------
  regs_inst : entity work.regs
    generic map (
      ADDR_W => ADDR_W,
      DATA_W => DATA_W,
      BASE_ADDR => BASE_ADDR(31 downto 0)
    )
    port map (
      clk => clk,
      rst => rst,
      csr_config_mode_out => csr_config_mode_out,
      csr_config_enable_out => csr_config_enable_out,
      csr_config_clk_div_out => csr_config_clk_div_out,
      csr_status_ready_in => csr_status_ready_in,
      csr_status_overflow_in => csr_status_overflow_in,
      csr_status_underflow_in => csr_status_underflow_in,
      csr_status_processing_in => csr_status_processing_in,
      csr_status_fifo_level_in => csr_status_fifo_level_in,
      csr_control_start_out => csr_control_start_out,
      csr_control_stop_out => csr_control_stop_out,
      csr_control_reset_fifo_out => csr_control_reset_fifo_out,
      csr_control_auto_restart_out => csr_control_auto_restart_out,
      csr_control_debug_en_out => csr_control_debug_en_out,
      csr_threshold_low_thresh_out => csr_threshold_low_thresh_out,
      csr_threshold_high_thresh_out => csr_threshold_high_thresh_out,
      csr_gain_coarse_gain_out => csr_gain_coarse_gain_out,
      csr_gain_fine_gain_out => csr_gain_fine_gain_out,
      csr_gain_agc_en_out => csr_gain_agc_en_out,
      csr_gain_agc_en_in => csr_gain_agc_en_in,
      csr_gain_agc_en_en => csr_gain_agc_en_en,
      csr_int_mask_done_mask_out => csr_int_mask_done_mask_out,
      csr_int_mask_error_mask_out => csr_int_mask_error_mask_out,
      csr_int_mask_overflow_mask_out => csr_int_mask_overflow_mask_out,
      csr_int_mask_underflow_mask_out => csr_int_mask_underflow_mask_out,
      csr_int_mask_threshold_mask_out => csr_int_mask_threshold_mask_out,
      csr_int_status_done_int_set => csr_int_status_done_int_set,
      csr_int_status_error_int_set => csr_int_status_error_int_set,
      csr_int_status_overflow_int_set => csr_int_status_overflow_int_set,
      csr_int_status_underflow_int_set => csr_int_status_underflow_int_set,
      csr_int_status_threshold_int_set => csr_int_status_threshold_int_set,
      axil_awaddr => axil_awaddr,
      axil_awprot => "000",
      axil_awvalid => axil_awvalid,
      axil_awready => axil_awready,
      axil_wdata => axil_wdata,
      axil_wstrb => axil_wstrb,
      axil_wvalid => axil_wvalid,
      axil_wready => axil_wready,
      axil_bresp => axil_bresp,
      axil_bvalid => axil_bvalid,
      axil_bready => axil_bready,
      axil_araddr => axil_araddr,
      axil_arprot => "000",
      axil_arvalid => axil_arvalid,
      axil_arready => axil_arready,
      axil_rdata => axil_rdata,
      axil_rresp => axil_rresp,
      axil_rvalid => axil_rvalid,
      axil_rready => axil_rready
    );

  -----------------------------------------------------------------------------
  -- Stimulus Process with Local Procedures
  -----------------------------------------------------------------------------
  stim_proc : process
  
    ---------------------------------------------------------------------------
    -- AXI-Lite Write Procedure (Local to Process - Accesses Architecture Signals)
    ---------------------------------------------------------------------------
    procedure axi_lite_write (
      constant addr : in std_logic_vector(ADDR_W-1 downto 0);
      constant data : in std_logic_vector(DATA_W-1 downto 0)
    ) is
      variable aw_done : boolean := false;
      variable w_done  : boolean := false;
    begin
      
      -- Initialize write response channel
      axil_bready <= '1';
      
      -- Wait for rising edge
      wait until rising_edge(clk);
      
      -- Drive write address channel
      axil_awaddr  <= addr;
      axil_awvalid <= '1';
      
      -- Drive write data channel
      axil_wdata   <= data;
      axil_wstrb   <= (others => '1');
      axil_wvalid  <= '1';
      
      -- Wait for both AW and W handshakes to complete
      while (not aw_done) or (not w_done) loop
        wait until rising_edge(clk);
        
        if axil_awvalid = '1' and axil_awready = '1' then
          aw_done := true;
          axil_awvalid <= '0';
        end if;
        
        if axil_wvalid = '1' and axil_wready = '1' then
          w_done := true;
          axil_wvalid <= '0';
        end if;
      end loop;
      
      -- Wait for write response
      while axil_bvalid /= '1' loop
        wait until rising_edge(clk);
      end loop;
      
      -- Check response
      if axil_bresp /= "00" then
        report "AXI Write Error at 0x" & to_hstring(addr) & 
               ", BRESP=" & integer'image(to_integer(unsigned(axil_bresp)))
               severity error;
      end if;
      
      wait until rising_edge(clk);
      axil_bready <= '0';
      
    end procedure axi_lite_write;

    ---------------------------------------------------------------------------
    -- AXI-Lite Read Procedure (Local to Process - Accesses Architecture Signals)
    ---------------------------------------------------------------------------
    procedure axi_lite_read (
      constant addr : in std_logic_vector(ADDR_W-1 downto 0)
    ) is
    begin
      
      -- Initialize read data channel
      axil_rready <= '1';
      
      -- Wait for rising edge
      wait until rising_edge(clk);
      
      -- Drive read address channel
      axil_araddr  <= addr;
      axil_arvalid <= '1';
      
      -- Wait for address handshake
      while axil_arready /= '1' loop
        wait until rising_edge(clk);
      end loop;
      
      -- Deassert address valid
      wait until rising_edge(clk);
      axil_arvalid <= '0';
      
      -- Wait for read data
      while axil_rvalid /= '1' loop
        wait until rising_edge(clk);
      end loop;
      
      -- Capture read data to global signal
      read_data <= axil_rdata;
      
      -- Check response
      if axil_rresp /= "00" then
        report "AXI Read Error at 0x" & to_hstring(addr) & 
               ", RRESP=" & integer'image(to_integer(unsigned(axil_rresp)))
               severity error;
      end if;
      
      wait until rising_edge(clk);
      axil_rready <= '0';
      
    end procedure axi_lite_read;

  begin
    
    --- Reset sequence
  rst <= '1';
  wait for 100 ns;
  rst <= '0';
  wait for 100 ns;

  -- Test stimulus
  report "Starting AXI-Lite Testbench for regs";
  wait for 50 ns;  -- Read CONFIG register (Global configuration register)
  report "Reading CONFIG";
  axi_lite_read(std_logic_vector(unsigned(BASE_ADDR(ADDR_W-1 downto 0)) + to_unsigned(16#0#, ADDR_W)));
  report "CONFIG = 0x" & to_hstring(read_data);
  wait for 50 ns;  -- Read STATUS register (System status register)
  report "Reading STATUS";
  axi_lite_read(std_logic_vector(unsigned(BASE_ADDR(ADDR_W-1 downto 0)) + to_unsigned(16#4#, ADDR_W)));
  report "STATUS = 0x" & to_hstring(read_data);
  wait for 50 ns;  -- Read CONTROL register (System control register)
  report "Reading CONTROL";
  axi_lite_read(std_logic_vector(unsigned(BASE_ADDR(ADDR_W-1 downto 0)) + to_unsigned(16#8#, ADDR_W)));
  report "CONTROL = 0x" & to_hstring(read_data);
  wait for 50 ns;  -- Read THRESHOLD register (Threshold configuration register)
  report "Reading THRESHOLD";
  axi_lite_read(std_logic_vector(unsigned(BASE_ADDR(ADDR_W-1 downto 0)) + to_unsigned(16#C#, ADDR_W)));
  report "THRESHOLD = 0x" & to_hstring(read_data);
  wait for 50 ns;  -- Read GAIN register (Gain control register)
  report "Reading GAIN";
  axi_lite_read(std_logic_vector(unsigned(BASE_ADDR(ADDR_W-1 downto 0)) + to_unsigned(16#10#, ADDR_W)));
  report "GAIN = 0x" & to_hstring(read_data);
  wait for 50 ns;  -- Read INT_MASK register (Interrupt mask register)
  report "Reading INT_MASK";
  axi_lite_read(std_logic_vector(unsigned(BASE_ADDR(ADDR_W-1 downto 0)) + to_unsigned(16#14#, ADDR_W)));
  report "INT_MASK = 0x" & to_hstring(read_data);
  wait for 50 ns;  -- Read INT_STATUS register (Interrupt status register)
  report "Reading INT_STATUS";
  axi_lite_read(std_logic_vector(unsigned(BASE_ADDR(ADDR_W-1 downto 0)) + to_unsigned(16#18#, ADDR_W)));
  report "INT_STATUS = 0x" & to_hstring(read_data);
  wait for 50 ns;  -- Read VERSION register (Version and identification register)
  report "Reading VERSION";
  axi_lite_read(std_logic_vector(unsigned(BASE_ADDR(ADDR_W-1 downto 0)) + to_unsigned(16#1C#, ADDR_W)));
  report "VERSION = 0x" & to_hstring(read_data);
  wait for 50 ns;  -- Write to CONFIG register
  report "Writing CONFIG = 0x00000001";
  axi_lite_write(std_logic_vector(unsigned(BASE_ADDR(ADDR_W-1 downto 0)) + to_unsigned(16#0#, ADDR_W)), X"00000001");
  wait for 10 ns;  -- Write to STATUS register
  report "Writing STATUS = 0x00000001";
  axi_lite_write(std_logic_vector(unsigned(BASE_ADDR(ADDR_W-1 downto 0)) + to_unsigned(16#4#, ADDR_W)), X"00000001");
  wait for 10 ns;  -- Write to CONTROL register
  report "Writing CONTROL = 0x00000001";
  axi_lite_write(std_logic_vector(unsigned(BASE_ADDR(ADDR_W-1 downto 0)) + to_unsigned(16#8#, ADDR_W)), X"00000001");
  wait for 10 ns;  -- Write to THRESHOLD register
  report "Writing THRESHOLD = 0x00000001";
  axi_lite_write(std_logic_vector(unsigned(BASE_ADDR(ADDR_W-1 downto 0)) + to_unsigned(16#C#, ADDR_W)), X"00000001");
  wait for 10 ns;  -- Write to GAIN register
  report "Writing GAIN = 0x00000001";
  axi_lite_write(std_logic_vector(unsigned(BASE_ADDR(ADDR_W-1 downto 0)) + to_unsigned(16#10#, ADDR_W)), X"00000001");
  wait for 10 ns;  -- Write to INT_MASK register
  report "Writing INT_MASK = 0x00000001";
  axi_lite_write(std_logic_vector(unsigned(BASE_ADDR(ADDR_W-1 downto 0)) + to_unsigned(16#14#, ADDR_W)), X"00000001");
  wait for 10 ns;  -- Write to INT_STATUS register
  report "Writing INT_STATUS = 0x00000001";
  axi_lite_write(std_logic_vector(unsigned(BASE_ADDR(ADDR_W-1 downto 0)) + to_unsigned(16#18#, ADDR_W)), X"00000001");
  wait for 10 ns;
  wait for 100 ns;
  report "Simulation completed successfully" severity note;
  std.env.stop;

    
  end process;

end architecture behavioral;