
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library src_lib;
--
library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.vc_context;

use work.axil_pkg.all;

entity regs_tb is
  generic (
    runner_cfg : string
  );
end;

architecture bench of regs_tb is 
  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics
  constant ADDR_W : integer := 16;
  constant DATA_W : integer := 32;
  constant STRB_W : integer := 4;
  --other constants
  constant axil_bus : bus_master_t := new_bus(data_length => 32, address_length => 32);
  --
  signal net : network_t;
  signal clk : std_logic;
  signal rst : std_logic;
  signal axil_m2s : axil_m2s_t := axil_m2s_init;
  signal axil_s2m : axil_s2m_t;

  signal csr_data_fifo_rvalid : std_logic;
  signal csr_data_fifo_ren : std_logic;
  signal csr_data_fifo_in : std_logic_vector(7 downto 0);
  signal csr_data_fifo_out : std_logic_vector(7 downto 0);
  signal csr_data_fifo_wready : std_logic;
  signal csr_data_fifo_wen : std_logic;
  signal csr_data_ferr_in : std_logic;
  signal csr_data_perr_in : std_logic;
  signal csr_stat_busy_en : std_logic;
  signal csr_stat_busy_in : std_logic;
  signal csr_stat_rxe_in : std_logic;
  signal csr_stat_txf_in : std_logic;
  signal csr_ctrl_baud_out : std_logic_vector(1 downto 0);
  signal csr_ctrl_txen_en : std_logic;
  signal csr_ctrl_txen_in : std_logic;
  signal csr_ctrl_txen_out : std_logic;
  signal csr_ctrl_rxen_en : std_logic;
  signal csr_ctrl_rxen_in : std_logic;
  signal csr_ctrl_rxen_out : std_logic;
  signal csr_ctrl_txst_out : std_logic;
  signal csr_lpmode_div_out : std_logic_vector(7 downto 0);
  signal csr_lpmode_en_out : std_logic;
  signal csr_intstat_tx_set : std_logic;
  signal csr_intstat_rx_set : std_logic;

begin

  axi_lite_master_inst: entity vunit_lib.axi_lite_master
    generic map (
      bus_handle => axil_bus)
    port map (
      aclk    => clk,
      arready => axil_s2m.ar.ready,
      arvalid => axil_m2s.ar.valid,
      araddr  => axil_m2s.ar.addr,
      rready  => axil_m2s.r.ready,
      rvalid  => axil_s2m.r.valid,
      rdata   => axil_s2m.r.data,
      rresp   => axil_s2m.r.resp,
      awready => axil_s2m.aw.ready,
      awvalid => axil_m2s.aw.valid,
      awaddr  => axil_m2s.aw.addr,
      wready  => axil_s2m.w.ready,
      wvalid  => axil_m2s.w.valid,
      wdata   => axil_m2s.w.data,
      wstrb   => axil_m2s.w.strb,
      bvalid  => axil_s2m.b.valid,
      bready  => axil_m2s.b.ready,
      bresp   => axil_s2m.b.resp);
      
  regs_inst : entity work.regs
  generic map (
    ADDR_W => ADDR_W,
    DATA_W => DATA_W,
    STRB_W => STRB_W
  )
  port map (
    clk => clk,
    rst => rst,
    csr_data_fifo_rvalid => csr_data_fifo_rvalid,
    csr_data_fifo_ren => csr_data_fifo_ren,
    csr_data_fifo_in => csr_data_fifo_in,
    csr_data_fifo_out => csr_data_fifo_out,
    csr_data_fifo_wready => csr_data_fifo_wready,
    csr_data_fifo_wen => csr_data_fifo_wen,
    csr_data_ferr_in => csr_data_ferr_in,
    csr_data_perr_in => csr_data_perr_in,
    csr_stat_busy_en => csr_stat_busy_en,
    csr_stat_busy_in => csr_stat_busy_in,
    csr_stat_rxe_in => csr_stat_rxe_in,
    csr_stat_txf_in => csr_stat_txf_in,
    csr_ctrl_baud_out => csr_ctrl_baud_out,
    csr_ctrl_txen_en => csr_ctrl_txen_en,
    csr_ctrl_txen_in => csr_ctrl_txen_in,
    csr_ctrl_txen_out => csr_ctrl_txen_out,
    csr_ctrl_rxen_en => csr_ctrl_rxen_en,
    csr_ctrl_rxen_in => csr_ctrl_rxen_in,
    csr_ctrl_rxen_out => csr_ctrl_rxen_out,
    csr_ctrl_txst_out => csr_ctrl_txst_out,
    csr_lpmode_div_out => csr_lpmode_div_out,
    csr_lpmode_en_out => csr_lpmode_en_out,
    csr_intstat_tx_set => csr_intstat_tx_set,
    csr_intstat_rx_set => csr_intstat_rx_set,
    axil_awaddr => axil_m2s.aw.addr(ADDR_W-1 downto 0),
    axil_awprot => axil_m2s.aw.prot,
    axil_awvalid => axil_m2s.aw.valid,
    axil_awready => axil_s2m.aw.ready,
    axil_wdata => axil_m2s.w.data,
    axil_wstrb => axil_m2s.w.strb,
    axil_wvalid => axil_m2s.w.valid,
    axil_wready => axil_s2m.w.ready,
    axil_bresp => axil_s2m.b.resp,
    axil_bvalid => axil_s2m.b.valid,
    axil_bready => axil_m2s.b.ready,
    axil_araddr => axil_m2s.ar.addr(ADDR_W-1 downto 0),
    axil_arprot => axil_m2s.ar.prot,
    axil_arvalid => axil_m2s.ar.valid,
    axil_arready => axil_s2m.ar.ready,
    axil_rdata => axil_s2m.r.data,
    axil_rresp => axil_s2m.r.resp,
    axil_rvalid => axil_s2m.r.valid,
    axil_rready => axil_m2s.r.ready
  );
  clk_process : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;

  main : process
    -- Register addresses from regs.json
    constant DATA_ADDR : std_logic_vector(31 downto 0) := x"00000004";
    constant STAT_ADDR : std_logic_vector(31 downto 0) := x"0000000C";
    constant CTRL_ADDR : std_logic_vector(31 downto 0) := x"00000010";
    constant LPMODE_ADDR : std_logic_vector(31 downto 0) := x"00000014";
    constant INTSTAT_ADDR : std_logic_vector(31 downto 0) := x"00000020";
    constant ID_ADDR : std_logic_vector(31 downto 0) := x"00000040";
    
    variable read_data : std_logic_vector(31 downto 0);
  begin
    test_runner_setup(runner, runner_cfg);
    
    -- Initialize hardware signals
    csr_data_fifo_rvalid <= '0';
    csr_data_fifo_in <= (others => '0');
    csr_data_fifo_wready <= '1';
    csr_data_ferr_in <= '0';
    csr_data_perr_in <= '0';
    csr_stat_busy_en <= '0';
    csr_stat_busy_in <= '0';
    csr_stat_rxe_in <= '0';
    csr_stat_txf_in <= '0';
    csr_ctrl_txen_en <= '0';
    csr_ctrl_txen_in <= '0';
    csr_ctrl_rxen_en <= '0';
    csr_ctrl_rxen_in <= '0';
    csr_intstat_tx_set <= '0';
    csr_intstat_rx_set <= '0';
    
    rst <= '1';
    wait for 10 * clk_period;
    rst <= '0';
    wait for 10 * clk_period;
    
    while test_suite loop
      if run("test_id_register") then
        info("Testing ID register - should read constant value");
        wait for 1000 * clk_period;
        write_bus(axil_bus, axil_m2s, axil_s2m, ID_ADDR, false);
        wait for 10000 * clk_period;

      end if;
    end loop;
    
    test_runner_cleanup(runner);
  end process main;


end;