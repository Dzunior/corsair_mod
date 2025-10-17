


-- Created with Corsair vgit-latest
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regs is
generic(
    ADDR_W : integer := 16;
    DATA_W : integer := 32;
    STRB_W : integer := 4;
    BASE_ADDR : std_logic_vector(31 downto 0) := x"80080000"
);
port(
    clk    : in std_logic;
    rst    : in std_logic;
    -- CONFIG.MODE
    csr_config_mode_out : out std_logic_vector(2 downto 0);
    -- CONFIG.ENABLE
    csr_config_enable_out : out std_logic;
    -- CONFIG.RESERVED
    -- CONFIG.CLK_DIV
    csr_config_clk_div_out : out std_logic_vector(7 downto 0);
    -- CONFIG.ARCH_ID

    -- STATUS.READY
    csr_status_ready_in : in std_logic;
    -- STATUS.OVERFLOW
    csr_status_overflow_in : in std_logic;
    -- STATUS.UNDERFLOW
    csr_status_underflow_in : in std_logic;
    -- STATUS.PROCESSING
    csr_status_processing_in : in std_logic;
    -- STATUS.FIFO_LEVEL
    csr_status_fifo_level_in : in std_logic_vector(9 downto 0);

    -- CONTROL.START
    csr_control_start_out : out std_logic;
    -- CONTROL.STOP
    csr_control_stop_out : out std_logic;
    -- CONTROL.RESET_FIFO
    csr_control_reset_fifo_out : out std_logic;
    -- CONTROL.AUTO_RESTART
    csr_control_auto_restart_out : out std_logic;
    -- CONTROL.DEBUG_EN
    csr_control_debug_en_out : out std_logic;

    -- THRESHOLD.LOW_THRESH
    csr_threshold_low_thresh_out : out std_logic_vector(15 downto 0);
    -- THRESHOLD.HIGH_THRESH
    csr_threshold_high_thresh_out : out std_logic_vector(15 downto 0);

    -- GAIN.COARSE_GAIN
    csr_gain_coarse_gain_out : out std_logic_vector(3 downto 0);
    -- GAIN.FINE_GAIN
    csr_gain_fine_gain_out : out std_logic_vector(7 downto 0);
    -- GAIN.GAIN_FORMAT
    -- GAIN.AGC_EN
    csr_gain_agc_en_en : in std_logic;
    csr_gain_agc_en_in : in std_logic;
    csr_gain_agc_en_out : out std_logic;

    -- INT_MASK.DONE_MASK
    csr_int_mask_done_mask_out : out std_logic;
    -- INT_MASK.ERROR_MASK
    csr_int_mask_error_mask_out : out std_logic;
    -- INT_MASK.OVERFLOW_MASK
    csr_int_mask_overflow_mask_out : out std_logic;
    -- INT_MASK.UNDERFLOW_MASK
    csr_int_mask_underflow_mask_out : out std_logic;
    -- INT_MASK.THRESHOLD_MASK
    csr_int_mask_threshold_mask_out : out std_logic;

    -- INT_STATUS.DONE_INT
    csr_int_status_done_int_set : in std_logic;
    -- INT_STATUS.ERROR_INT
    csr_int_status_error_int_set : in std_logic;
    -- INT_STATUS.OVERFLOW_INT
    csr_int_status_overflow_int_set : in std_logic;
    -- INT_STATUS.UNDERFLOW_INT
    csr_int_status_underflow_int_set : in std_logic;
    -- INT_STATUS.THRESHOLD_INT
    csr_int_status_threshold_int_set : in std_logic;

    -- VERSION.MINOR
    -- VERSION.MAJOR
    -- VERSION.CORE_ID

    -- AXI-Lite (absolute addressing)
    axil_awaddr   : in  std_logic_vector(ADDR_W-1 downto 0);
    axil_awprot   : in  std_logic_vector(2 downto 0);
    axil_awvalid  : in  std_logic;
    axil_awready  : out std_logic;
    axil_wdata    : in  std_logic_vector(DATA_W-1 downto 0);
    axil_wstrb    : in  std_logic_vector(STRB_W-1 downto 0);
    axil_wvalid   : in  std_logic;
    axil_wready   : out std_logic;
    axil_bresp    : out std_logic_vector(1 downto 0);
    axil_bvalid   : out std_logic;
    axil_bready   : in  std_logic;
    axil_araddr   : in  std_logic_vector(ADDR_W-1 downto 0);
    axil_arprot   : in  std_logic_vector(2 downto 0);
    axil_arvalid  : in  std_logic;
    axil_arready  : out std_logic;
    axil_rdata    : out std_logic_vector(DATA_W-1 downto 0);
    axil_rresp    : out std_logic_vector(1 downto 0);
    axil_rvalid   : out std_logic;
    axil_rready   : in  std_logic

);
end entity;

architecture rtl of regs is

-- Clock Interface
attribute X_INTERFACE_INFO : string;
attribute X_INTERFACE_PARAMETER : string;

attribute X_INTERFACE_INFO of clk : signal is "xilinx.com:signal:clock:1.0 clk CLK";
attribute X_INTERFACE_PARAMETER of clk : signal is "ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET rst, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN regs_clk";

-- Reset Interface  
attribute X_INTERFACE_INFO of rst : signal is "xilinx.com:signal:reset:1.0 rst RST";
attribute X_INTERFACE_PARAMETER of rst : signal is "POLARITY ACTIVE_HIGH";

-- AXI-Lite Interface Write Address Channel
attribute X_INTERFACE_INFO of axil_awaddr  : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWADDR";
attribute X_INTERFACE_INFO of axil_awprot  : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWPROT";
attribute X_INTERFACE_INFO of axil_awvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWVALID";
attribute X_INTERFACE_INFO of axil_awready : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWREADY";

-- AXI-Lite Interface Write Data Channel
attribute X_INTERFACE_INFO of axil_wdata   : signal is "xilinx.com:interface:aximm:1.0 S_AXI WDATA";
attribute X_INTERFACE_INFO of axil_wstrb   : signal is "xilinx.com:interface:aximm:1.0 S_AXI WSTRB";
attribute X_INTERFACE_INFO of axil_wvalid  : signal is "xilinx.com:interface:aximm:1.0 S_AXI WVALID";
attribute X_INTERFACE_INFO of axil_wready  : signal is "xilinx.com:interface:aximm:1.0 S_AXI WREADY";

-- AXI-Lite Interface Write Response Channel
attribute X_INTERFACE_INFO of axil_bresp   : signal is "xilinx.com:interface:aximm:1.0 S_AXI BRESP";
attribute X_INTERFACE_INFO of axil_bvalid  : signal is "xilinx.com:interface:aximm:1.0 S_AXI BVALID";
attribute X_INTERFACE_INFO of axil_bready  : signal is "xilinx.com:interface:aximm:1.0 S_AXI BREADY";

-- AXI-Lite Interface Read Address Channel
attribute X_INTERFACE_INFO of axil_araddr  : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARADDR";
attribute X_INTERFACE_INFO of axil_arprot  : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARPROT";
attribute X_INTERFACE_INFO of axil_arvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARVALID";
attribute X_INTERFACE_INFO of axil_arready : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARREADY";

-- AXI-Lite Interface Read Data Channel
attribute X_INTERFACE_INFO of axil_rdata   : signal is "xilinx.com:interface:aximm:1.0 S_AXI RDATA";
attribute X_INTERFACE_INFO of axil_rresp   : signal is "xilinx.com:interface:aximm:1.0 S_AXI RRESP";
attribute X_INTERFACE_INFO of axil_rvalid  : signal is "xilinx.com:interface:aximm:1.0 S_AXI RVALID";
attribute X_INTERFACE_INFO of axil_rready  : signal is "xilinx.com:interface:aximm:1.0 S_AXI RREADY";


signal wready : std_logic;
signal waddr  : std_logic_vector(ADDR_W-1 downto 0);
signal wdata  : std_logic_vector(DATA_W-1 downto 0);
signal wen    : std_logic;
signal wstrb  : std_logic_vector(STRB_W-1 downto 0);
signal rdata  : std_logic_vector(DATA_W-1 downto 0);
signal rvalid : std_logic;
signal raddr  : std_logic_vector(ADDR_W-1 downto 0);
signal ren    : std_logic;

-- Address translation signals
signal waddr_int       : std_logic_vector(ADDR_W-1 downto 0);
signal raddr_int       : std_logic_vector(ADDR_W-1 downto 0);
signal waddr_absolute  : std_logic_vector(ADDR_W-1 downto 0);
signal raddr_absolute  : std_logic_vector(ADDR_W-1 downto 0);
signal waddr_relative  : std_logic_vector(ADDR_W-1 downto 0);
signal raddr_relative  : std_logic_vector(ADDR_W-1 downto 0);

-- Control signals
signal wdata_int       : std_logic_vector(DATA_W-1 downto 0);
signal strb_int        : std_logic_vector(STRB_W-1 downto 0);
signal awflag          : std_logic;
signal wflag           : std_logic;
signal arflag          : std_logic;
signal rflag           : std_logic;
signal wen_int         : std_logic;
signal ren_int         : std_logic;
signal axil_bvalid_int : std_logic;
signal axil_rdata_int  : std_logic_vector(DATA_W-1 downto 0);
signal axil_rvalid_int : std_logic;

-- Address range checking aaa
signal addr_in_range_w : std_logic;
signal addr_in_range_r : std_logic;

signal csr_config_rdata : std_logic_vector(31 downto 0);
signal csr_config_wen : std_logic;
signal csr_config_ren : std_logic;
signal csr_config_ren_ff : std_logic;
signal csr_config_mode_ff : std_logic_vector(2 downto 0);
signal csr_config_enable_ff : std_logic;
signal csr_config_reserved_ff : std_logic_vector(2 downto 0);
signal csr_config_clk_div_ff : std_logic_vector(7 downto 0);
signal csr_config_arch_id_ff : std_logic_vector(3 downto 0);

signal csr_status_rdata : std_logic_vector(31 downto 0);
signal csr_status_wen : std_logic;
signal csr_status_ren : std_logic;
signal csr_status_ren_ff : std_logic;
signal csr_status_ready_ff : std_logic;
signal csr_status_overflow_ff : std_logic;
signal csr_status_underflow_ff : std_logic;
signal csr_status_processing_ff : std_logic;
signal csr_status_fifo_level_ff : std_logic_vector(9 downto 0);

signal csr_control_rdata : std_logic_vector(31 downto 0);
signal csr_control_wen : std_logic;
signal csr_control_ren : std_logic;
signal csr_control_ren_ff : std_logic;
signal csr_control_start_ff : std_logic;
signal csr_control_stop_ff : std_logic;
signal csr_control_reset_fifo_ff : std_logic;
signal csr_control_auto_restart_ff : std_logic;
signal csr_control_debug_en_ff : std_logic;

signal csr_threshold_rdata : std_logic_vector(31 downto 0);
signal csr_threshold_wen : std_logic;
signal csr_threshold_ren : std_logic;
signal csr_threshold_ren_ff : std_logic;
signal csr_threshold_low_thresh_ff : std_logic_vector(15 downto 0);
signal csr_threshold_high_thresh_ff : std_logic_vector(15 downto 0);

signal csr_gain_rdata : std_logic_vector(31 downto 0);
signal csr_gain_wen : std_logic;
signal csr_gain_ren : std_logic;
signal csr_gain_ren_ff : std_logic;
signal csr_gain_coarse_gain_ff : std_logic_vector(3 downto 0);
signal csr_gain_fine_gain_ff : std_logic_vector(7 downto 0);
signal csr_gain_gain_format_ff : std_logic_vector(1 downto 0);
signal csr_gain_agc_en_ff : std_logic;

signal csr_int_mask_rdata : std_logic_vector(31 downto 0);
signal csr_int_mask_wen : std_logic;
signal csr_int_mask_ren : std_logic;
signal csr_int_mask_ren_ff : std_logic;
signal csr_int_mask_done_mask_ff : std_logic;
signal csr_int_mask_error_mask_ff : std_logic;
signal csr_int_mask_overflow_mask_ff : std_logic;
signal csr_int_mask_underflow_mask_ff : std_logic;
signal csr_int_mask_threshold_mask_ff : std_logic;

signal csr_int_status_rdata : std_logic_vector(31 downto 0);
signal csr_int_status_wen : std_logic;
signal csr_int_status_ren : std_logic;
signal csr_int_status_ren_ff : std_logic;
signal csr_int_status_done_int_ff : std_logic;
signal csr_int_status_error_int_ff : std_logic;
signal csr_int_status_overflow_int_ff : std_logic;
signal csr_int_status_underflow_int_ff : std_logic;
signal csr_int_status_threshold_int_ff : std_logic;

signal csr_version_rdata : std_logic_vector(31 downto 0);
signal csr_version_ren : std_logic;
signal csr_version_ren_ff : std_logic;
signal csr_version_minor_ff : std_logic_vector(7 downto 0);
signal csr_version_major_ff : std_logic_vector(7 downto 0);
signal csr_version_core_id_ff : std_logic_vector(15 downto 0);

signal rdata_ff : std_logic_vector(31 downto 0);
signal rvalid_ff : std_logic;
begin

-- Address translation: Convert AXI absolute addresses to local bus relative addresses
waddr_relative <= std_logic_vector(unsigned(waddr_absolute) - unsigned(BASE_ADDR(ADDR_W-1 downto 0)));
raddr_relative <= std_logic_vector(unsigned(raddr_absolute) - unsigned(BASE_ADDR(ADDR_W-1 downto 0)));

-- Address range checking (optional - can be used for error responses)
addr_in_range_w <= '1' when unsigned(waddr_absolute) >= unsigned(BASE_ADDR(ADDR_W-1 downto 0)) else '0';
addr_in_range_r <= '1' when unsigned(raddr_absolute) >= unsigned(BASE_ADDR(ADDR_W-1 downto 0)) else '0';

axil_awready <= not awflag;
axil_wready  <= not wflag;
axil_bvalid  <= axil_bvalid_int;
waddr        <= waddr_relative;  -- Output relative address to local bus
wdata        <= wdata_int;
wstrb        <= strb_int;
wen_int      <= awflag and wflag and addr_in_range_w;  -- Include range check
wen          <= wen_int;
axil_bresp   <= b"00" when addr_in_range_w = '1' else b"10";  -- SLVERR if out of range

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    waddr_absolute <= (others => '0');
    wdata_int <= (others => '0');
    strb_int <= (others => '0');
    awflag <= '0';
    wflag <= '0';
    axil_bvalid_int <= '0';
else
    if (axil_awvalid = '1' and awflag = '0') then
        awflag         <= '1';
        waddr_absolute <= axil_awaddr;  -- Store absolute address
    elsif (wen_int = '1' and wready = '1') then
        awflag         <= '0';
    end if;
    if (axil_wvalid = '1' and wflag = '0') then
        wflag     <= '1';
        wdata_int <= axil_wdata;
        strb_int  <= axil_wstrb;
    elsif (wen_int = '1' and wready = '1') then
        wflag     <= '0';
    end if;
    if (axil_bvalid_int = '1' and axil_bready = '1') then
        axil_bvalid_int <= '0';
    elsif ((axil_wvalid = '1' and awflag = '1') or (axil_awvalid = '1' and wflag = '1') or (wflag = '1' and awflag = '1')) then
        axil_bvalid_int <= '1';  -- Always generate response (wready checking moved to wen_int)
    end if;
end if;
end if;
end process;


axil_arready <= not arflag;
axil_rdata   <= axil_rdata_int;
axil_rvalid  <= axil_rvalid_int;
raddr        <= raddr_relative;  -- Output relative address to local bus
ren_int      <= arflag and (not rflag) and addr_in_range_r;  -- Include range check
ren          <= ren_int;
axil_rresp   <= b"00" when addr_in_range_r = '1' else b"10";  -- SLVERR if out of range

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    raddr_absolute <= (others => '0');
    arflag <= '0';
    rflag <= '0';
    axil_rdata_int <= (others => '0');
    axil_rvalid_int <= '0';
else
    if (axil_arvalid = '1' and arflag = '0') then
        arflag         <= '1';
        raddr_absolute <= axil_araddr;  -- Store absolute address
    elsif (axil_rvalid_int = '1' and axil_rready = '1') then
        arflag         <= '0';
    end if;
    if (rvalid = '1' and ren_int = '1' and rflag = '0') then
        rflag <= '1';
    elsif (axil_rvalid_int = '1' and axil_rready = '1') then
        rflag <= '0';
    end if;
    if (rvalid = '1' and axil_rvalid_int = '0') then
        axil_rdata_int  <= rdata;
        axil_rvalid_int <= '1';
    elsif (axil_rvalid_int = '1' and axil_rready = '1') then
        axil_rvalid_int <= '0';
    elsif (addr_in_range_r = '0' and arflag = '1' and axil_rvalid_int = '0') then
        -- Generate error response for out-of-range addresses
        axil_rdata_int  <= (others => '0');
        axil_rvalid_int <= '1';
    end if;
end if;
end if;
end process;


--------------------------------------------------------------------------------
-- CSR:
-- [0x0] - CONFIG - Global configuration register
--------------------------------------------------------------------------------
csr_config_rdata(3) <= '0';
csr_config_rdata(27 downto 16) <= (others => '0');

csr_config_wen <= wen when (waddr = std_logic_vector(to_unsigned(0, ADDR_W))) else '0'; -- 0x0

csr_config_ren <= ren when (raddr = std_logic_vector(to_unsigned(0, ADDR_W))) else '0'; -- 0x0
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_config_ren_ff <= '0'; -- 0x0
else
        csr_config_ren_ff <= csr_config_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- CONFIG(2 downto 0) - MODE - Operating mode selection
-- access: rw, hardware: o
-----------------------

csr_config_rdata(2 downto 0) <= csr_config_mode_ff;

csr_config_mode_out <= csr_config_mode_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_config_mode_ff <= "000"; -- 0x0
else
        if (csr_config_wen = '1') then
            if (wstrb(0) = '1') then
                csr_config_mode_ff(2 downto 0) <= wdata(2 downto 0);
            end if;
        else
            csr_config_mode_ff <= csr_config_mode_ff;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- CONFIG(4) - ENABLE - Global enable bit
-- access: rw, hardware: o
-----------------------

csr_config_rdata(4) <= csr_config_enable_ff;

csr_config_enable_out <= csr_config_enable_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_config_enable_ff <= '0'; -- 0x0
else
        if (csr_config_wen = '1') then
            if (wstrb(0) = '1') then
                csr_config_enable_ff <= wdata(4);
            end if;
        else
            csr_config_enable_ff <= csr_config_enable_ff;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- CONFIG(7 downto 5) - RESERVED - Reserved bits (constant 0)
-- access: ro, hardware: f
-----------------------

csr_config_rdata(7 downto 5) <= csr_config_reserved_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_config_reserved_ff <= "000"; -- 0x0
else
        
            csr_config_reserved_ff <= csr_config_reserved_ff;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- CONFIG(15 downto 8) - CLK_DIV - Clock divider ratio
-- access: rw, hardware: o
-----------------------

csr_config_rdata(15 downto 8) <= csr_config_clk_div_ff;

csr_config_clk_div_out <= csr_config_clk_div_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_config_clk_div_ff <= "00000001"; -- 0x1
else
        if (csr_config_wen = '1') then
            if (wstrb(1) = '1') then
                csr_config_clk_div_ff(7 downto 0) <= wdata(15 downto 8);
            end if;
        else
            csr_config_clk_div_ff <= csr_config_clk_div_ff;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- CONFIG(31 downto 28) - ARCH_ID - Architecture identifier (constant)
-- access: ro, hardware: f
-----------------------

csr_config_rdata(31 downto 28) <= csr_config_arch_id_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_config_arch_id_ff <= "0101"; -- 0x5
else
        
            csr_config_arch_id_ff <= csr_config_arch_id_ff;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x4] - STATUS - System status register
--------------------------------------------------------------------------------
csr_status_rdata(3) <= '0';
csr_status_rdata(15 downto 5) <= (others => '0');
csr_status_rdata(31 downto 26) <= (others => '0');

csr_status_wen <= wen when (waddr = std_logic_vector(to_unsigned(4, ADDR_W))) else '0'; -- 0x4

csr_status_ren <= ren when (raddr = std_logic_vector(to_unsigned(4, ADDR_W))) else '0'; -- 0x4
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_status_ren_ff <= '0'; -- 0x0
else
        csr_status_ren_ff <= csr_status_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- STATUS(0) - READY - System ready flag
-- access: ro, hardware: i
-----------------------

csr_status_rdata(0) <= csr_status_ready_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_status_ready_ff <= '0'; -- 0x0
else
            csr_status_ready_ff <= csr_status_ready_in;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- STATUS(1) - OVERFLOW - Data overflow flag. Read to clear.
-- access: rolh, hardware: i
-----------------------

csr_status_rdata(1) <= csr_status_overflow_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_status_overflow_ff <= '0'; -- 0x0
else
        if (csr_status_ren = '1' and csr_status_ren_ff = '0' and csr_status_overflow_ff = '1') then
            csr_status_overflow_ff <= '0';
         elsif (csr_status_overflow_in = '1') then
            csr_status_overflow_ff <= csr_status_overflow_in;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- STATUS(2) - UNDERFLOW - Data underflow flag. Read to clear.
-- access: rolh, hardware: i
-----------------------

csr_status_rdata(2) <= csr_status_underflow_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_status_underflow_ff <= '0'; -- 0x0
else
        if (csr_status_ren = '1' and csr_status_ren_ff = '0' and csr_status_underflow_ff = '1') then
            csr_status_underflow_ff <= '0';
         elsif (csr_status_underflow_in = '1') then
            csr_status_underflow_ff <= csr_status_underflow_in;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- STATUS(4) - PROCESSING - Processing in progress
-- access: ro, hardware: i
-----------------------

csr_status_rdata(4) <= csr_status_processing_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_status_processing_ff <= '0'; -- 0x0
else
            csr_status_processing_ff <= csr_status_processing_in;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- STATUS(25 downto 16) - FIFO_LEVEL - Current FIFO fill level
-- access: ro, hardware: i
-----------------------

csr_status_rdata(25 downto 16) <= csr_status_fifo_level_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_status_fifo_level_ff <= "0000000000"; -- 0x0
else
            csr_status_fifo_level_ff <= csr_status_fifo_level_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x8] - CONTROL - System control register
--------------------------------------------------------------------------------
csr_control_rdata(7 downto 3) <= (others => '0');
csr_control_rdata(31 downto 10) <= (others => '0');

csr_control_wen <= wen when (waddr = std_logic_vector(to_unsigned(8, ADDR_W))) else '0'; -- 0x8

csr_control_ren <= ren when (raddr = std_logic_vector(to_unsigned(8, ADDR_W))) else '0'; -- 0x8
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_control_ren_ff <= '0'; -- 0x0
else
        csr_control_ren_ff <= csr_control_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- CONTROL(0) - START - Start processing (self-clearing)
-- access: wosc, hardware: o
-----------------------

csr_control_rdata(0) <= '0';

csr_control_start_out <= csr_control_start_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_control_start_ff <= '0'; -- 0x0
else
        if (csr_control_wen = '1') then
            if (wstrb(0) = '1') then
                csr_control_start_ff <= wdata(0);
            end if;
        else
            csr_control_start_ff <= '0';
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- CONTROL(1) - STOP - Stop processing (self-clearing)
-- access: wosc, hardware: o
-----------------------

csr_control_rdata(1) <= '0';

csr_control_stop_out <= csr_control_stop_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_control_stop_ff <= '0'; -- 0x0
else
        if (csr_control_wen = '1') then
            if (wstrb(0) = '1') then
                csr_control_stop_ff <= wdata(1);
            end if;
        else
            csr_control_stop_ff <= '0';
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- CONTROL(2) - RESET_FIFO - Reset FIFO (self-clearing)
-- access: wosc, hardware: o
-----------------------

csr_control_rdata(2) <= '0';

csr_control_reset_fifo_out <= csr_control_reset_fifo_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_control_reset_fifo_ff <= '0'; -- 0x0
else
        if (csr_control_wen = '1') then
            if (wstrb(0) = '1') then
                csr_control_reset_fifo_ff <= wdata(2);
            end if;
        else
            csr_control_reset_fifo_ff <= '0';
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- CONTROL(8) - AUTO_RESTART - Enable automatic restart on completion
-- access: rw, hardware: o
-----------------------

csr_control_rdata(8) <= csr_control_auto_restart_ff;

csr_control_auto_restart_out <= csr_control_auto_restart_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_control_auto_restart_ff <= '0'; -- 0x0
else
        if (csr_control_wen = '1') then
            if (wstrb(1) = '1') then
                csr_control_auto_restart_ff <= wdata(8);
            end if;
        else
            csr_control_auto_restart_ff <= csr_control_auto_restart_ff;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- CONTROL(9) - DEBUG_EN - Enable debug mode
-- access: rw, hardware: o
-----------------------

csr_control_rdata(9) <= csr_control_debug_en_ff;

csr_control_debug_en_out <= csr_control_debug_en_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_control_debug_en_ff <= '0'; -- 0x0
else
        if (csr_control_wen = '1') then
            if (wstrb(1) = '1') then
                csr_control_debug_en_ff <= wdata(9);
            end if;
        else
            csr_control_debug_en_ff <= csr_control_debug_en_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0xc] - THRESHOLD - Threshold configuration register
--------------------------------------------------------------------------------

csr_threshold_wen <= wen when (waddr = std_logic_vector(to_unsigned(12, ADDR_W))) else '0'; -- 0xc

csr_threshold_ren <= ren when (raddr = std_logic_vector(to_unsigned(12, ADDR_W))) else '0'; -- 0xc
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_threshold_ren_ff <= '0'; -- 0x0
else
        csr_threshold_ren_ff <= csr_threshold_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- THRESHOLD(15 downto 0) - LOW_THRESH - Lower threshold value
-- access: rw, hardware: o
-----------------------

csr_threshold_rdata(15 downto 0) <= csr_threshold_low_thresh_ff;

csr_threshold_low_thresh_out <= csr_threshold_low_thresh_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_threshold_low_thresh_ff <= "0000000001100100"; -- 0x64
else
        if (csr_threshold_wen = '1') then
            if (wstrb(0) = '1') then
                csr_threshold_low_thresh_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_threshold_low_thresh_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
        else
            csr_threshold_low_thresh_ff <= csr_threshold_low_thresh_ff;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- THRESHOLD(31 downto 16) - HIGH_THRESH - Upper threshold value
-- access: rw, hardware: o
-----------------------

csr_threshold_rdata(31 downto 16) <= csr_threshold_high_thresh_ff;

csr_threshold_high_thresh_out <= csr_threshold_high_thresh_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_threshold_high_thresh_ff <= "0000111110011011"; -- 0xf9b
else
        if (csr_threshold_wen = '1') then
            if (wstrb(2) = '1') then
                csr_threshold_high_thresh_ff(7 downto 0) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_threshold_high_thresh_ff(15 downto 8) <= wdata(31 downto 24);
            end if;
        else
            csr_threshold_high_thresh_ff <= csr_threshold_high_thresh_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x10] - GAIN - Gain control register
--------------------------------------------------------------------------------
csr_gain_rdata(15 downto 12) <= (others => '0');
csr_gain_rdata(30 downto 18) <= (others => '0');

csr_gain_wen <= wen when (waddr = std_logic_vector(to_unsigned(16, ADDR_W))) else '0'; -- 0x10

csr_gain_ren <= ren when (raddr = std_logic_vector(to_unsigned(16, ADDR_W))) else '0'; -- 0x10
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_gain_ren_ff <= '0'; -- 0x0
else
        csr_gain_ren_ff <= csr_gain_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- GAIN(3 downto 0) - COARSE_GAIN - Coarse gain control (dB steps)
-- access: rw, hardware: o
-----------------------

csr_gain_rdata(3 downto 0) <= csr_gain_coarse_gain_ff;

csr_gain_coarse_gain_out <= csr_gain_coarse_gain_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_gain_coarse_gain_ff <= "0000"; -- 0x0
else
        if (csr_gain_wen = '1') then
            if (wstrb(0) = '1') then
                csr_gain_coarse_gain_ff(3 downto 0) <= wdata(3 downto 0);
            end if;
        else
            csr_gain_coarse_gain_ff <= csr_gain_coarse_gain_ff;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- GAIN(11 downto 4) - FINE_GAIN - Fine gain adjustment
-- access: rw, hardware: o
-----------------------

csr_gain_rdata(11 downto 4) <= csr_gain_fine_gain_ff;

csr_gain_fine_gain_out <= csr_gain_fine_gain_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_gain_fine_gain_ff <= "10000000"; -- 0x80
else
        if (csr_gain_wen = '1') then
            if (wstrb(0) = '1') then
                csr_gain_fine_gain_ff(3 downto 0) <= wdata(7 downto 4);
            end if;
            if (wstrb(1) = '1') then
                csr_gain_fine_gain_ff(7 downto 4) <= wdata(11 downto 8);
            end if;
        else
            csr_gain_fine_gain_ff <= csr_gain_fine_gain_ff;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- GAIN(17 downto 16) - GAIN_FORMAT - Gain format indicator (constant)
-- access: ro, hardware: f
-----------------------

csr_gain_rdata(17 downto 16) <= csr_gain_gain_format_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_gain_gain_format_ff <= "10"; -- 0x2
else
        
            csr_gain_gain_format_ff <= csr_gain_gain_format_ff;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- GAIN(31) - AGC_EN - Automatic gain control enable
-- access: rw, hardware: oie
-----------------------

csr_gain_rdata(31) <= csr_gain_agc_en_ff;

csr_gain_agc_en_out <= csr_gain_agc_en_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_gain_agc_en_ff <= '0'; -- 0x0
else
        if (csr_gain_wen = '1') then
            if (wstrb(3) = '1') then
                csr_gain_agc_en_ff <= wdata(31);
            end if;
        elsif (csr_gain_agc_en_en = '1') then
            csr_gain_agc_en_ff <= csr_gain_agc_en_in;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x14] - INT_MASK - Interrupt mask register
--------------------------------------------------------------------------------
csr_int_mask_rdata(31 downto 5) <= (others => '0');

csr_int_mask_wen <= wen when (waddr = std_logic_vector(to_unsigned(20, ADDR_W))) else '0'; -- 0x14

csr_int_mask_ren <= ren when (raddr = std_logic_vector(to_unsigned(20, ADDR_W))) else '0'; -- 0x14
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_int_mask_ren_ff <= '0'; -- 0x0
else
        csr_int_mask_ren_ff <= csr_int_mask_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- INT_MASK(0) - DONE_MASK - Mask processing done interrupt
-- access: rw, hardware: o
-----------------------

csr_int_mask_rdata(0) <= csr_int_mask_done_mask_ff;

csr_int_mask_done_mask_out <= csr_int_mask_done_mask_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_int_mask_done_mask_ff <= '0'; -- 0x0
else
        if (csr_int_mask_wen = '1') then
            if (wstrb(0) = '1') then
                csr_int_mask_done_mask_ff <= wdata(0);
            end if;
        else
            csr_int_mask_done_mask_ff <= csr_int_mask_done_mask_ff;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- INT_MASK(1) - ERROR_MASK - Mask error interrupt
-- access: rw, hardware: o
-----------------------

csr_int_mask_rdata(1) <= csr_int_mask_error_mask_ff;

csr_int_mask_error_mask_out <= csr_int_mask_error_mask_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_int_mask_error_mask_ff <= '0'; -- 0x0
else
        if (csr_int_mask_wen = '1') then
            if (wstrb(0) = '1') then
                csr_int_mask_error_mask_ff <= wdata(1);
            end if;
        else
            csr_int_mask_error_mask_ff <= csr_int_mask_error_mask_ff;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- INT_MASK(2) - OVERFLOW_MASK - Mask overflow interrupt
-- access: rw, hardware: o
-----------------------

csr_int_mask_rdata(2) <= csr_int_mask_overflow_mask_ff;

csr_int_mask_overflow_mask_out <= csr_int_mask_overflow_mask_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_int_mask_overflow_mask_ff <= '0'; -- 0x0
else
        if (csr_int_mask_wen = '1') then
            if (wstrb(0) = '1') then
                csr_int_mask_overflow_mask_ff <= wdata(2);
            end if;
        else
            csr_int_mask_overflow_mask_ff <= csr_int_mask_overflow_mask_ff;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- INT_MASK(3) - UNDERFLOW_MASK - Mask underflow interrupt
-- access: rw, hardware: o
-----------------------

csr_int_mask_rdata(3) <= csr_int_mask_underflow_mask_ff;

csr_int_mask_underflow_mask_out <= csr_int_mask_underflow_mask_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_int_mask_underflow_mask_ff <= '0'; -- 0x0
else
        if (csr_int_mask_wen = '1') then
            if (wstrb(0) = '1') then
                csr_int_mask_underflow_mask_ff <= wdata(3);
            end if;
        else
            csr_int_mask_underflow_mask_ff <= csr_int_mask_underflow_mask_ff;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- INT_MASK(4) - THRESHOLD_MASK - Mask threshold crossed interrupt
-- access: rw, hardware: o
-----------------------

csr_int_mask_rdata(4) <= csr_int_mask_threshold_mask_ff;

csr_int_mask_threshold_mask_out <= csr_int_mask_threshold_mask_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_int_mask_threshold_mask_ff <= '0'; -- 0x0
else
        if (csr_int_mask_wen = '1') then
            if (wstrb(0) = '1') then
                csr_int_mask_threshold_mask_ff <= wdata(4);
            end if;
        else
            csr_int_mask_threshold_mask_ff <= csr_int_mask_threshold_mask_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x18] - INT_STATUS - Interrupt status register
--------------------------------------------------------------------------------
csr_int_status_rdata(31 downto 5) <= (others => '0');

csr_int_status_wen <= wen when (waddr = std_logic_vector(to_unsigned(24, ADDR_W))) else '0'; -- 0x18

csr_int_status_ren <= ren when (raddr = std_logic_vector(to_unsigned(24, ADDR_W))) else '0'; -- 0x18
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_int_status_ren_ff <= '0'; -- 0x0
else
        csr_int_status_ren_ff <= csr_int_status_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- INT_STATUS(0) - DONE_INT - Processing done interrupt. Write 1 to clear.
-- access: rw1c, hardware: s
-----------------------

csr_int_status_rdata(0) <= csr_int_status_done_int_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_int_status_done_int_ff <= '0'; -- 0x0
else
        if (csr_int_status_done_int_set = '1') then
            csr_int_status_done_int_ff <= '1';
        elsif (csr_int_status_wen = '1') then
            if ((wstrb(0) = '1') and (wdata(0) = '1')) then
                csr_int_status_done_int_ff <= '0';
            end if;
        else
            csr_int_status_done_int_ff <= csr_int_status_done_int_ff;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- INT_STATUS(1) - ERROR_INT - Error interrupt. Write 1 to clear.
-- access: rw1c, hardware: s
-----------------------

csr_int_status_rdata(1) <= csr_int_status_error_int_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_int_status_error_int_ff <= '0'; -- 0x0
else
        if (csr_int_status_error_int_set = '1') then
            csr_int_status_error_int_ff <= '1';
        elsif (csr_int_status_wen = '1') then
            if ((wstrb(0) = '1') and (wdata(1) = '1')) then
                csr_int_status_error_int_ff <= '0';
            end if;
        else
            csr_int_status_error_int_ff <= csr_int_status_error_int_ff;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- INT_STATUS(2) - OVERFLOW_INT - Overflow interrupt. Write 1 to clear.
-- access: rw1c, hardware: s
-----------------------

csr_int_status_rdata(2) <= csr_int_status_overflow_int_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_int_status_overflow_int_ff <= '0'; -- 0x0
else
        if (csr_int_status_overflow_int_set = '1') then
            csr_int_status_overflow_int_ff <= '1';
        elsif (csr_int_status_wen = '1') then
            if ((wstrb(0) = '1') and (wdata(2) = '1')) then
                csr_int_status_overflow_int_ff <= '0';
            end if;
        else
            csr_int_status_overflow_int_ff <= csr_int_status_overflow_int_ff;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- INT_STATUS(3) - UNDERFLOW_INT - Underflow interrupt. Write 1 to clear.
-- access: rw1c, hardware: s
-----------------------

csr_int_status_rdata(3) <= csr_int_status_underflow_int_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_int_status_underflow_int_ff <= '0'; -- 0x0
else
        if (csr_int_status_underflow_int_set = '1') then
            csr_int_status_underflow_int_ff <= '1';
        elsif (csr_int_status_wen = '1') then
            if ((wstrb(0) = '1') and (wdata(3) = '1')) then
                csr_int_status_underflow_int_ff <= '0';
            end if;
        else
            csr_int_status_underflow_int_ff <= csr_int_status_underflow_int_ff;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- INT_STATUS(4) - THRESHOLD_INT - Threshold crossed interrupt. Write 1 to clear.
-- access: rw1c, hardware: s
-----------------------

csr_int_status_rdata(4) <= csr_int_status_threshold_int_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_int_status_threshold_int_ff <= '0'; -- 0x0
else
        if (csr_int_status_threshold_int_set = '1') then
            csr_int_status_threshold_int_ff <= '1';
        elsif (csr_int_status_wen = '1') then
            if ((wstrb(0) = '1') and (wdata(4) = '1')) then
                csr_int_status_threshold_int_ff <= '0';
            end if;
        else
            csr_int_status_threshold_int_ff <= csr_int_status_threshold_int_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x1c] - VERSION - Version and identification register
--------------------------------------------------------------------------------


csr_version_ren <= ren when (raddr = std_logic_vector(to_unsigned(28, ADDR_W))) else '0'; -- 0x1c
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_version_ren_ff <= '0'; -- 0x0
else
        csr_version_ren_ff <= csr_version_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- VERSION(7 downto 0) - MINOR - Minor version number
-- access: ro, hardware: f
-----------------------

csr_version_rdata(7 downto 0) <= csr_version_minor_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_version_minor_ff <= "00000011"; -- 0x3
else
        
            csr_version_minor_ff <= csr_version_minor_ff;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- VERSION(15 downto 8) - MAJOR - Major version number
-- access: ro, hardware: f
-----------------------

csr_version_rdata(15 downto 8) <= csr_version_major_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_version_major_ff <= "00000010"; -- 0x2
else
        
            csr_version_major_ff <= csr_version_major_ff;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- VERSION(31 downto 16) - CORE_ID - IP core identifier
-- access: ro, hardware: f
-----------------------

csr_version_rdata(31 downto 16) <= csr_version_core_id_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_version_core_id_ff <= "1011101110111011"; -- 0xbbbb
else
        
            csr_version_core_id_ff <= csr_version_core_id_ff;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- Write ready
--------------------------------------------------------------------------------
wready <= '1';

--------------------------------------------------------------------------------
-- Read address decoder (Optimized with Case Statement)
--------------------------------------------------------------------------------
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    rdata_ff <= "00000000000000000000000000000000"; -- 0x0
else
    if (ren = '1') then
        case unsigned(raddr) is
            when to_unsigned(0, ADDR_W) => -- 0x0
                rdata_ff <= csr_config_rdata;
            when to_unsigned(4, ADDR_W) => -- 0x4
                rdata_ff <= csr_status_rdata;
            when to_unsigned(8, ADDR_W) => -- 0x8
                rdata_ff <= csr_control_rdata;
            when to_unsigned(12, ADDR_W) => -- 0xc
                rdata_ff <= csr_threshold_rdata;
            when to_unsigned(16, ADDR_W) => -- 0x10
                rdata_ff <= csr_gain_rdata;
            when to_unsigned(20, ADDR_W) => -- 0x14
                rdata_ff <= csr_int_mask_rdata;
            when to_unsigned(24, ADDR_W) => -- 0x18
                rdata_ff <= csr_int_status_rdata;
            when to_unsigned(28, ADDR_W) => -- 0x1c
                rdata_ff <= csr_version_rdata;
            when others =>
                rdata_ff <= "00000000000000000000000000000000"; -- 0x0
        end case;
    else
        rdata_ff <= "00000000000000000000000000000000"; -- 0x0
    end if;
end if;
end if;
end process;

rdata <= rdata_ff;

--------------------------------------------------------------------------------
-- Read data valid
--------------------------------------------------------------------------------
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    rvalid_ff <= '0'; -- 0x0
else
    if ((ren = '1') and (rvalid = '1')) then
        rvalid_ff <= '0';
    elsif (ren = '1') then
        rvalid_ff <= '1';
    end if;
end if;
end if;
end process;


rvalid <= rvalid_ff;

end architecture;