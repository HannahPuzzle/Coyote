library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.vcomponents.all;

library xpm;
use xpm.vcomponents.all;

use work.eci_defs.all;

entity module_inst is
port (
    clk_sys     : out std_logic;
    reset_sys   : out std_logic;

    -- 156.25MHz transceiver reference clocks
    F_CCPIC_CLK_P_LINK1 : in std_logic_vector(2 downto 0);
    F_CCPIC_CLK_N_LINK1 : in std_logic_vector(2 downto 0);

    F_CCPIC_CLK_P_LINK2 : in std_logic_vector(5 downto 3);
    F_CCPIC_CLK_N_LINK2 : in std_logic_vector(5 downto 3);
    -- free-running clocks
    F_PRGC0_CLK_P   : in std_logic;
    F_PRGC0_CLK_N   : in std_logic;
    F_PRGC1_CLK_P   : in std_logic;
    F_PRGC1_CLK_N   : in std_logic;
    -- RX differential pairs
    CCPI_C2F_P_LINK1 : in std_logic_vector(11 downto 0);
    CCPI_C2F_N_LINK1 : in std_logic_vector(11 downto 0);
    CCPI_C2F_P_LINK2 : in std_logic_vector(11 downto 0);
    CCPI_C2F_N_LINK2 : in std_logic_vector(11 downto 0);
    -- TX differential pairs
    CCPI_F2C_P_LINK1 : out std_logic_vector(11 downto 0);
    CCPI_F2C_N_LINK1 : out std_logic_vector(11 downto 0);
    CCPI_F2C_P_LINK2 : out std_logic_vector(11 downto 0);
    CCPI_F2C_N_LINK2 : out std_logic_vector(11 downto 0);

    -- AXIL
    m_io_axil_link_awaddr    : out std_logic_vector(43 downto 0);
    m_io_axil_link_awvalid   : out std_logic;
    m_io_axil_link_awready   : in  std_logic;
    m_io_axil_link_wdata     : out std_logic_vector(63 downto 0);
    m_io_axil_link_wstrb     : out std_logic_vector(7 downto 0);
    m_io_axil_link_wvalid    : out std_logic;
    m_io_axil_link_wready    : in  std_logic;
    m_io_axil_link_bresp     : in  std_logic_vector(1 downto 0);
    m_io_axil_link_bvalid    : in  std_logic;
    m_io_axil_link_bready    : out std_logic;
    m_io_axil_link_araddr    : out std_logic_vector(43 downto 0);
    m_io_axil_link_arvalid   : out std_logic;
    m_io_axil_link_arready   : in  std_logic;
    m_io_axil_link_rdata     : in std_logic_vector(63 downto 0);
    m_io_axil_link_rresp     : in std_logic_vector(1 downto 0);
    m_io_axil_link_rvalid    : in std_logic;
    m_io_axil_link_rready    : out std_logic;

    s_io_axil_link_awaddr    : in std_logic_vector(43 downto 0);
    s_io_axil_link_awvalid   : in std_logic;
    s_io_axil_link_awready   : out std_logic;
    s_io_axil_link_wdata     : in std_logic_vector(63 downto 0);
    s_io_axil_link_wstrb     : in std_logic_vector(7 downto 0);
    s_io_axil_link_wvalid    : in std_logic;
    s_io_axil_link_wready    : out std_logic;
    s_io_axil_link_bresp     : out std_logic_vector(1 downto 0);
    s_io_axil_link_bvalid    : out std_logic;
    s_io_axil_link_bready    : in std_logic;
    s_io_axil_link_araddr    : in std_logic_vector(43 downto 0);
    s_io_axil_link_arvalid   : in std_logic;
    s_io_axil_link_arready   : out  std_logic;
    s_io_axil_link_rdata     : out std_logic_vector(63 downto 0);
    s_io_axil_link_rresp     : out std_logic_vector(1 downto 0);
    s_io_axil_link_rvalid    : out std_logic;
    s_io_axil_link_rready    : in std_logic
);
end module_inst;

architecture behavioural of module_inst is

component eci_platform is
generic (
    SHELL_VERSION : string
);
port (
    clk_sys         : out std_logic;
    clk_icap        : out std_logic;
    reset_sys       : out std_logic;

    -- 156.25MHz transceiver reference clocks
    eci_gt_clk_p_link1  : in std_logic_vector(2 downto 0);
    eci_gt_clk_n_link1  : in std_logic_vector(2 downto 0);

    eci_gt_clk_p_link2  : in std_logic_vector(5 downto 3);
    eci_gt_clk_n_link2  : in std_logic_vector(5 downto 3);

    -- RX differential pairs
    eci_gt_rx_p_link1   : in std_logic_vector(11 downto 0);
    eci_gt_rx_n_link1   : in std_logic_vector(11 downto 0);
    eci_gt_rx_p_link2   : in std_logic_vector(11 downto 0);
    eci_gt_rx_n_link2   : in std_logic_vector(11 downto 0);

    -- TX differential pairs
    eci_gt_tx_p_link1   : out std_logic_vector(11 downto 0);
    eci_gt_tx_n_link1   : out std_logic_vector(11 downto 0);
    eci_gt_tx_p_link2   : out std_logic_vector(11 downto 0);
    eci_gt_tx_n_link2   : out std_logic_vector(11 downto 0);

    link1_in_data           : out WORDS(6 downto 0);
    link1_in_vc_no          : out VCS(6 downto 0);
    link1_in_we2            : out std_logic_vector(6 downto 0);
    link1_in_we3            : out std_logic_vector(6 downto 0);
    link1_in_we4            : out std_logic_vector(6 downto 0);
    link1_in_we5            : out std_logic_vector(6 downto 0);
    link1_in_valid          : out std_logic;
    link1_in_credit_return  : in std_logic_vector(12 downto 2);
    link1_out_hi_vc         : in ECI_CHANNEL;
    link1_out_hi_vc_ready   : out std_logic;
    link1_out_lo_vc         : in ECI_CHANNEL;
    link1_out_lo_vc_ready   : out std_logic;
    link1_out_credit_return : out std_logic_vector(12 downto 2);

    link2_in_data           : out WORDS(6 downto 0);
    link2_in_vc_no          : out VCS(6 downto 0);
    link2_in_we2            : out std_logic_vector(6 downto 0);
    link2_in_we3            : out std_logic_vector(6 downto 0);
    link2_in_we4            : out std_logic_vector(6 downto 0);
    link2_in_we5            : out std_logic_vector(6 downto 0);
    link2_in_valid          : out std_logic;
    link2_in_credit_return  : in std_logic_vector(12 downto 2);
    link2_out_hi_vc         : in ECI_CHANNEL;
    link2_out_hi_vc_ready   : out std_logic;
    link2_out_lo_vc         : in ECI_CHANNEL;
    link2_out_lo_vc_ready   : out std_logic;
    link2_out_credit_return : out std_logic_vector(12 downto 2);

    link_up                 : out std_logic;
    link1_link_up           : out std_logic;
    link2_link_up           : out std_logic;

    disable_2nd_link        : in std_logic;

    -- AXI Lite master interface IO addr space
    m_io_axil_awaddr    : out std_logic_vector(43 downto 0);
    m_io_axil_awvalid   : buffer std_logic; 
    m_io_axil_awready   : in  std_logic;

    m_io_axil_wdata     : out std_logic_vector(63 downto 0);
    m_io_axil_wstrb     : out std_logic_vector(7 downto 0);
    m_io_axil_wvalid    : buffer std_logic;
    m_io_axil_wready    : in  std_logic;

    m_io_axil_bresp     : in  std_logic_vector(1 downto 0);
    m_io_axil_bvalid    : in  std_logic;
    m_io_axil_bready    : buffer std_logic;

    m_io_axil_araddr    : out std_logic_vector(43 downto 0);
    m_io_axil_arvalid   : buffer std_logic;
    m_io_axil_arready   : in  std_logic;

    m_io_axil_rdata     : in std_logic_vector(63 downto 0);
    m_io_axil_rresp     : in std_logic_vector(1 downto 0);
    m_io_axil_rvalid    : in std_logic;
    m_io_axil_rready    : buffer std_logic;

    -- AXI Lite slave interface IO addr space
    s_io_axil_awaddr    : in std_logic_vector(43 downto 0);
    s_io_axil_awvalid   : in std_logic;
    s_io_axil_awready   : out std_logic;
    s_io_axil_wdata     : in std_logic_vector(63 downto 0);
    s_io_axil_wstrb     : in std_logic_vector(7 downto 0);
    s_io_axil_wvalid    : in std_logic;
    s_io_axil_wready    : out std_logic;
    s_io_axil_bresp     : out std_logic_vector(1 downto 0);
    s_io_axil_bvalid    : out std_logic;
    s_io_axil_bready    : in std_logic;
    s_io_axil_araddr    : in std_logic_vector(43 downto 0);
    s_io_axil_arvalid   : in std_logic;
    s_io_axil_arready   : out  std_logic;
    s_io_axil_rdata     : out std_logic_vector(63 downto 0);
    s_io_axil_rresp     : out std_logic_vector(1 downto 0);
    s_io_axil_rvalid    : out std_logic;
    s_io_axil_rready    : in std_logic;

    -- ICAP AXI Lite master interface
    m_icap_axi_awaddr   : out std_logic_vector(8 downto 0);
    m_icap_axi_awvalid  : buffer std_logic;
    m_icap_axi_awready  : in  std_logic;

    m_icap_axi_wdata    : out std_logic_vector(31 downto 0);
    m_icap_axi_wstrb    : out std_logic_vector(3 downto 0);
    m_icap_axi_wvalid   : buffer std_logic;
    m_icap_axi_wready   : in  std_logic;

    m_icap_axi_bresp    : in  std_logic_vector(1 downto 0);
    m_icap_axi_bvalid   : in  std_logic;
    m_icap_axi_bready   : buffer std_logic;

    m_icap_axi_araddr   : out std_logic_vector(8 downto 0);
    m_icap_axi_arvalid  : buffer std_logic;
    m_icap_axi_arready  : in  std_logic;

    m_icap_axi_rdata    : in std_logic_vector(31 downto 0);
    m_icap_axi_rresp    : in std_logic_vector(1 downto 0);
    m_icap_axi_rvalid   : in std_logic;
    m_icap_axi_rready   : buffer std_logic;

    shell_status_reg    : in std_logic_vector(63 downto 0);
    shell_control_reg   : out std_logic_vector(63 downto 0);

    gpo_regs            : out WORDS(15 downto 0); -- ?
    gpi_regs            : in WORDS(15 downto 0) -- ?
);
end component;

component eci_gateway is
generic (
    RX_CROSSBAR_TYPE    : string;
    DEBUG_BRIDGE_PRESENT: boolean;
    TX_NO_CHANNELS      : integer;
    RX_NO_CHANNELS      : integer;
    RX_FILTER_VC        : VC_BITFIELDS;
    RX_FILTER_TYPE_MASK : ECI_TYPE_MASKS;
    RX_FILTER_TYPE      : ECI_TYPE_MASKS;
    RX_FILTER_CLI_MASK  : CLI_ARRAY;
    RX_FILTER_CLI       : CLI_ARRAY
);
port (
    clk_sys                 : in std_logic;
    clk_io_out              : out std_logic;
    clk_prgc0_out           : out std_logic; -- ?
    clk_prgc1_out           : out std_logic; -- ?

    prgc0_clk_p             : in std_logic; -- ? (see input)
    prgc0_clk_n             : in std_logic; -- ?
    prgc1_clk_p             : in std_logic; -- ?
    prgc1_clk_n             : in std_logic; -- ?

    reset_sys               : in std_logic;
    reset_out               : out std_logic;
    reset_n_out             : out std_logic;
    link1_up                : in std_logic;
    link2_up                : in std_logic;

    link1_in_data           : in std_logic_vector(447 downto 0);
    link1_in_vc_no          : in std_logic_vector(27 downto 0);
    link1_in_we2            : in std_logic_vector(6 downto 0);
    link1_in_we3            : in std_logic_vector(6 downto 0);
    link1_in_we4            : in std_logic_vector(6 downto 0);
    link1_in_we5            : in std_logic_vector(6 downto 0);
    link1_in_valid          : in std_logic;
    link1_in_credit_return  : out std_logic_vector(12 downto 2);

    link1_out_hi_data       : out std_logic_vector(575 downto 0);
    link1_out_hi_vc_no      : out std_logic_vector(3 downto 0);
    link1_out_hi_size       : out std_logic_vector(2 downto 0);
    link1_out_hi_valid      : out std_logic;
    link1_out_hi_ready      : in std_logic;

    link1_out_lo_data       : out std_logic_vector(63 downto 0);
    link1_out_lo_vc_no      : out std_logic_vector(3 downto 0);
    link1_out_lo_valid      : out std_logic;
    link1_out_lo_ready      : in std_logic;
    link1_out_credit_return : in std_logic_vector(12 downto 2);

    link2_in_data           : in std_logic_vector(447 downto 0);
    link2_in_vc_no          : in std_logic_vector(27 downto 0);
    link2_in_we2            : in std_logic_vector(6 downto 0);
    link2_in_we3            : in std_logic_vector(6 downto 0);
    link2_in_we4            : in std_logic_vector(6 downto 0);
    link2_in_we5            : in std_logic_vector(6 downto 0);
    link2_in_valid          : in std_logic;
    link2_in_credit_return  : out std_logic_vector(12 downto 2);

    link2_out_hi_data       : out std_logic_vector(575 downto 0);
    link2_out_hi_vc_no      : out std_logic_vector(3 downto 0);
    link2_out_hi_size       : out std_logic_vector(2 downto 0);
    link2_out_hi_valid      : out std_logic;
    link2_out_hi_ready      : in std_logic;

    link2_out_lo_data       : out std_logic_vector(63 downto 0);
    link2_out_lo_vc_no      : out std_logic_vector(3 downto 0);
    link2_out_lo_valid      : out std_logic;
    link2_out_lo_ready      : in std_logic;
    link2_out_credit_return : in std_logic_vector(12 downto 2);

    s_bscan_bscanid_en      : in std_logic;
    s_bscan_capture         : in std_logic;
    s_bscan_drck            : in std_logic;
    s_bscan_reset           : in std_logic;
    s_bscan_runtest         : in std_logic;
    s_bscan_sel             : in std_logic;
    s_bscan_shift           : in std_logic;
    s_bscan_tck             : in std_logic;
    s_bscan_tdi             : in std_logic;
    s_bscan_tdo             : out std_logic;
    s_bscan_tms             : in std_logic;
    s_bscan_update          : in std_logic;

    m0_bscan_bscanid_en     : out std_logic;
    m0_bscan_capture        : out std_logic;
    m0_bscan_drck           : out std_logic;
    m0_bscan_reset          : out std_logic;
    m0_bscan_runtest        : out std_logic;
    m0_bscan_sel            : out std_logic;
    m0_bscan_shift          : out std_logic;
    m0_bscan_tck            : out std_logic;
    m0_bscan_tdi            : out std_logic;
    m0_bscan_tdo            : in std_logic;
    m0_bscan_tms            : out std_logic;
    m0_bscan_update         : out std_logic;

    rx_eci_channels         : out ARRAY_ECI_CHANNELS(RX_NO_CHANNELS-1 downto 0);
    rx_eci_channels_ready   : in std_logic_vector(RX_NO_CHANNELS-1 downto 0);

    tx_eci_channels         : in ARRAY_ECI_CHANNELS(TX_NO_CHANNELS-1 downto 0);
    tx_eci_channels_ready   : out std_logic_vector(TX_NO_CHANNELS-1 downto 0)
);
end component;

component loopback_vc_resp_nodata is
generic (
    WORD_WIDTH      : integer;
    GSDN_GSYNC_FN   : integer
);
port (
    clk, reset      : in std_logic;

    -- ECI Request input stream
    vc_req_i        : in std_logic_vector(63 downto 0);
    vc_req_valid_i  : in std_logic;
    vc_req_ready_o  : out std_logic;

    -- ECI Response output stream
    vc_resp_o       : out std_logic_vector(63 downto 0);
    vc_resp_valid_o : out std_logic;
    vc_resp_ready_i : in std_logic
);
end component;

type ECI_LINK_TX is record
    hi          : ECI_CHANNEL;
    hi_ready    : std_logic;
    lo          : ECI_CHANNEL;
    lo_ready    : std_logic;
end record ECI_LINK_TX;

type ICAP_AXI_LITE is record
    awaddr  :  std_logic_vector(8 downto 0);
    awvalid :  std_logic;
    awready :  std_logic;
    wdata   :  std_logic_vector(31 downto 0);
    wstrb   :  std_logic_vector(3 downto 0);
    wvalid  :  std_logic;
    wready  :  std_logic;
    bresp   :  std_logic_vector(1 downto 0);
    bvalid  :  std_logic;
    bready  :  std_logic;
    araddr  :  std_logic_vector(8 downto 0);
    arvalid :  std_logic;
    arready :  std_logic;
    rdata   :  std_logic_vector(31 downto 0);
    rresp   :  std_logic_vector(1 downto 0);
    rvalid  :  std_logic;
    rready  :  std_logic;
end record ICAP_AXI_LITE;

-- for eci gateway
type ECI_PACKET_RX is record
    c_gsync                 : ECI_CHANNEL;
    c_gsync_ready           : std_logic;
    c_ginv                  : ECI_CHANNEL;
    c6_data_loopback1       : ECI_CHANNEL;
    c6_data_loopback_ready1 : std_logic;
    c6_data_loopback2       : ECI_CHANNEL;
    c6_data_loopback_ready2 : std_logic;
    c7_data_loopback1       : ECI_CHANNEL;
    c7_data_loopback_ready1 : std_logic;
    c7_data_loopback2       : ECI_CHANNEL;
    c7_data_loopback_ready2 : std_logic;
end record ECI_PACKET_RX;

type ECI_PACKET_TX is record
-- VC packets inputs, from the ThunderX
-- GSYNC packets to be looped back
    c_gsdn                  : ECI_CHANNEL;
    c_gsdn_ready            : std_logic;
-- Responses with data (i.e. read response), to the ThunderX
    c4_data_loopback1       : ECI_CHANNEL;
    c4_data_loopback_ready1 : std_logic;
    c4_data_loopback2       : ECI_CHANNEL;
    c4_data_loopback_ready2 : std_logic;
    c5_data_loopback1       : ECI_CHANNEL;
    c5_data_loopback_ready1 : std_logic;
    c5_data_loopback2       : ECI_CHANNEL;
    c5_data_loopback_ready2 : std_logic;
end record ECI_PACKET_TX;

signal link_eci_packet_rx : ECI_PACKET_RX;
signal link_eci_packet_tx : ECI_PACKET_TX;

signal l1_eci_req         : ECI_CHANNEL;
signal l1_eci_req_ready   : std_logic;
signal l1_eci_rsp         : ECI_CHANNEL;
signal l1_eci_rsp_ready   : std_logic;
signal l2_eci_req         : ECI_CHANNEL;
signal l2_eci_req_ready   : std_logic;
signal l2_eci_rsp         : ECI_CHANNEL;
signal l2_eci_rsp_ready   : std_logic;


signal clk_system      : std_logic;
signal clk_icap        : std_logic;
signal clk_io          : std_logic;
signal reset_system    : std_logic;
signal reset           : std_logic;
signal reset_n         : std_logic;


signal link1_in_data            : WORDS(6 downto 0);
signal link1_in_vc_no           : VCS(6 downto 0);
signal link1_in_we2             : std_logic_vector(6 downto 0);
signal link1_in_we3             : std_logic_vector(6 downto 0);
signal link1_in_we4             : std_logic_vector(6 downto 0);
signal link1_in_we5             : std_logic_vector(6 downto 0);
signal link1_in_valid           : std_logic;
signal link1_in_credit_return   : std_logic_vector(12 downto 2);

signal link2_in_data            : WORDS(6 downto 0);
signal link2_in_vc_no           : VCS(6 downto 0);
signal link2_in_we2             : std_logic_vector(6 downto 0);
signal link2_in_we3             : std_logic_vector(6 downto 0);
signal link2_in_we4             : std_logic_vector(6 downto 0);
signal link2_in_we5             : std_logic_vector(6 downto 0);
signal link2_in_valid           : std_logic;
signal link2_in_credit_return   : std_logic_vector(12 downto 2);

signal link1_out_credit_return  : std_logic_vector(12 downto 2);
signal link2_out_credit_return  : std_logic_vector(12 downto 2);


signal disable_2nd_link : std_logic;

signal link1_out : ECI_LINK_TX;
signal link2_out : ECI_LINK_TX;

signal icap_axil_link                   : ICAP_AXI_LITE;

signal eci_link_up          : std_logic;
signal link1_eci_link_up    : std_logic;
signal link2_eci_link_up    : std_logic;

-- Shell status/control register
signal shell_status_reg    : std_logic_vector(63 downto 0);
signal shell_control_reg   : std_logic_vector(63 downto 0) := (others => '0'); -- ?

signal gpi_regs, gpo_regs   : WORDS(15 downto 0);

type BSCAN_INTERFACE is record
    bscanid_en  : std_logic;
    capture     : std_logic;
    drck        : std_logic;
    reset       : std_logic;
    runtest     : std_logic;
    sel         : std_logic;
    shift       : std_logic;
    tck         : std_logic;
    tdi         : std_logic;
    tdo         : std_logic;
    tms         : std_logic;
    update      : std_logic;
end record;

signal m0_bscan, s_bscan   : BSCAN_INTERFACE;

signal canCallWhatever0 : std_logic; -- ? (läuft ins Leere)
signal canCallWhatever1 : std_logic;

begin

disable_2nd_link <= '0';

shell_status_reg <= shell_control_reg; -- ? (einfach übernommen)

-- tie down icap
icap_axil_link.awaddr   <= "00000000";
icap_axil_link.awvalid  <= '0';
icap_axil_link.wdata    <= "0";
icap_axil_link.wstrb    <= "000";
icap_axil_link.wvalid   <= '0';
icap_axil_link.bready   <= '0';
icap_axil_link.araddr   <= "00000000";
icap_axil_link.arvalid  <= '0';
icap_axil_link.rready   <= '0';

-- tie down bscan master (even possible/necessary?)
m0_bscan.tdo <= '0';

-- tie down bscan slave
s_bscan.bscanid_en  <= '0';
s_bscan.capture     <= '0';
s_bscan.drck        <= '0';
s_bscan.reset       <= '0';
s_bscan.runtest     <= '0';
s_bscan.sel         <= '0';
s_bscan.shift       <= '0';
s_bscan.tck         <= '0';
s_bscan.tdi         <= '0';
s_bscan.tms         <= '0';
s_bscan.update      <= '0';

-- Sample register routing
gpi_regs(0) <= x"000000000000dead";
gpi_regs(1) <= x"000000000000beaf";
gpi_regs(2) <= gpo_regs(2);
gpi_regs(3) <= gpo_regs(3);
gpi_regs(4) <= gpo_regs(4);
gpi_regs(5) <= gpo_regs(5);
gpi_regs(6) <= gpo_regs(6);
gpi_regs(7) <= gpo_regs(7);
gpi_regs(8) <= gpo_regs(8);
gpi_regs(9) <= gpo_regs(9);
gpi_regs(10) <= gpo_regs(10);
gpi_regs(11) <= gpo_regs(11);
gpi_regs(12) <= gpo_regs(12);
gpi_regs(13) <= gpo_regs(13);
gpi_regs(14) <= gpo_regs(14);
gpi_regs(15) <= gpo_regs(15);

i_eci_platform : eci_platform
generic map (
    SHELL_VERSION => "02f19869" -- ? (just copied current version)
)
port map (
    clk_sys                 => clk_system,
    clk_icap                => clk_icap,
    reset_sys               => reset_system,

    eci_gt_clk_p_link1      => F_CCPIC_CLK_P_LINK1,
    eci_gt_clk_n_link1      => F_CCPIC_CLK_N_LINK1,

    eci_gt_clk_p_link2      => F_CCPIC_CLK_P_LINK2,
    eci_gt_clk_n_link2      => F_CCPIC_CLK_N_LINK2,

    eci_gt_rx_p_link1       => CCPI_C2F_P_LINK1,
    eci_gt_rx_n_link1       => CCPI_C2F_N_LINK1,
    eci_gt_rx_p_link2       => CCPI_C2F_P_LINK2,
    eci_gt_rx_n_link2       => CCPI_C2F_N_LINK2,

    eci_gt_tx_p_link1       => CCPI_F2C_P_LINK1,
    eci_gt_tx_n_link1       => CCPI_F2C_N_LINK1,
    eci_gt_tx_p_link2       => CCPI_F2C_P_LINK2,
    eci_gt_tx_n_link2       => CCPI_F2C_N_LINK2,

    link1_in_data           => link1_in_data,
    link1_in_vc_no          => link1_in_vc_no,
    link1_in_we2            => link1_in_we2,
    link1_in_we3            => link1_in_we3,
    link1_in_we4            => link1_in_we4,
    link1_in_we5            => link1_in_we5,
    link1_in_valid          => link1_in_valid,
    link1_in_credit_return  => link1_in_credit_return,
    link1_out_hi_vc         => link1_out.hi,
    link1_out_hi_vc_ready   => link1_out.hi_ready,
    link1_out_lo_vc         => link1_out.lo,
    link1_out_lo_vc_ready   => link1_out.lo_ready,
    link1_out_credit_return => link1_out_credit_return,

    link2_in_data           => link2_in_data,
    link2_in_vc_no          => link2_in_vc_no,
    link2_in_we2            => link2_in_we2,
    link2_in_we3            => link2_in_we3,
    link2_in_we4            => link2_in_we4,
    link2_in_we5            => link2_in_we5,
    link2_in_valid          => link2_in_valid,
    link2_in_credit_return  => link2_in_credit_return,
    link2_out_hi_vc         => link2_out.hi,
    link2_out_hi_vc_ready   => link2_out.hi_ready,
    link2_out_lo_vc         => link2_out.lo,
    link2_out_lo_vc_ready   => link2_out.lo_ready,
    link2_out_credit_return => link2_out_credit_return,

    link_up                 => eci_link_up,
    link1_link_up           => link1_eci_link_up,
    link2_link_up           => link2_eci_link_up,

    disable_2nd_link        => disable_2nd_link,

    -- AXI Lite master interface for IO addr space
    -- FPGA -> CPU
    m_io_axil_awaddr  => m_io_axil_link_awaddr,
    m_io_axil_awvalid => m_io_axil_link_awvalid,
    m_io_axil_awready => m_io_axil_link_awready,
    m_io_axil_wdata   => m_io_axil_link_wdata,
    m_io_axil_wstrb   => m_io_axil_link_wstrb,
    m_io_axil_wvalid  => m_io_axil_link_wvalid,
    m_io_axil_wready  => m_io_axil_link_wready,
    m_io_axil_bresp   => m_io_axil_link_bresp,
    m_io_axil_bvalid  => m_io_axil_link_bvalid,
    m_io_axil_bready  => m_io_axil_link_bready,
    m_io_axil_araddr  => m_io_axil_link_araddr,
    m_io_axil_arvalid => m_io_axil_link_arvalid,
    m_io_axil_arready => m_io_axil_link_arready,
    m_io_axil_rdata   => m_io_axil_link_rdata,
    m_io_axil_rresp   => m_io_axil_link_rresp,
    m_io_axil_rvalid  => m_io_axil_link_rvalid,
    m_io_axil_rready  => m_io_axil_link_rready,

    -- AXI Lite master interface for IO addr space
    -- CPU -> FPGA
    s_io_axil_awaddr  => s_io_axil_link_awaddr,
    s_io_axil_awvalid => s_io_axil_link_awvalid,
    s_io_axil_awready => s_io_axil_link_awready,
    s_io_axil_wdata   => s_io_axil_link_wdata,
    s_io_axil_wstrb   => s_io_axil_link_wstrb,
    s_io_axil_wvalid  => s_io_axil_link_wvalid,
    s_io_axil_wready  => s_io_axil_link_wready,
    s_io_axil_bresp   => s_io_axil_link_bresp,
    s_io_axil_bvalid  => s_io_axil_link_bvalid,
    s_io_axil_bready  => s_io_axil_link_bready,
    s_io_axil_araddr  => s_io_axil_link_araddr,
    s_io_axil_arvalid => s_io_axil_link_arvalid,
    s_io_axil_arready => s_io_axil_link_arready,
    s_io_axil_rdata   => s_io_axil_link_rdata,
    s_io_axil_rresp   => s_io_axil_link_rresp,
    s_io_axil_rvalid  => s_io_axil_link_rvalid,
    s_io_axil_rready  => s_io_axil_link_rready,

    m_icap_axi_awaddr   => icap_axil_link.awaddr,
    m_icap_axi_awvalid  => icap_axil_link.awvalid,
    m_icap_axi_awready  => icap_axil_link.awready,
    m_icap_axi_wdata    => icap_axil_link.wdata,
    m_icap_axi_wstrb    => icap_axil_link.wstrb,
    m_icap_axi_wvalid   => icap_axil_link.wvalid,
    m_icap_axi_wready   => icap_axil_link.wready,
    m_icap_axi_bresp    => icap_axil_link.bresp,
    m_icap_axi_bvalid   => icap_axil_link.bvalid,
    m_icap_axi_bready   => icap_axil_link.bready,
    m_icap_axi_araddr   => icap_axil_link.araddr,
    m_icap_axi_arvalid  => icap_axil_link.arvalid,
    m_icap_axi_arready  => icap_axil_link.arready,
    m_icap_axi_rdata    => icap_axil_link.rdata,
    m_icap_axi_rresp    => icap_axil_link.rresp,
    m_icap_axi_rvalid   => icap_axil_link.rvalid,
    m_icap_axi_rready   => icap_axil_link.rready,

    shell_status_reg    => shell_status_reg,
    shell_control_reg   => shell_control_reg,

    gpo_regs            => gpo_regs,
    gpi_regs            => gpi_regs
);

i_eci_gateway : eci_gateway
generic map (
    RX_CROSSBAR_TYPE        => "lite",
    DEBUG_BRIDGE_PRESENT    => false,
    TX_NO_CHANNELS      => 1,
    RX_NO_CHANNELS      => 2,
    RX_FILTER_VC        => (ECI_FILTER_VC_MASK((6, 7)),
                            ECI_FILTER_VC_MASK((6, 7))),
    RX_FILTER_TYPE_MASK => ("11111",
                            "11111"),
    RX_FILTER_TYPE      => (ECI_MREQ_GSYNC,
                            ECI_MREQ_GINV),
    RX_FILTER_CLI_MASK  => (ECI_FILTER_CLI_UNUSED,
                            ECI_FILTER_CLI_UNUSED),
    RX_FILTER_CLI       => (ECI_FILTER_CLI_UNUSED,
                            ECI_FILTER_CLI_UNUSED,
                            ECI_FILTER_CLI_UNUSED)
)
port map (
    clk_sys                 => clk_system,
    clk_io_out              => clk_io,
    clk_prgc0_out           => canCallWhatever0, -- ?
    clk_prgc1_out           => canCallWhatever1, -- ?

    prgc0_clk_p             => F_PRGC0_CLK_P,
    prgc0_clk_n             => F_PRGC0_CLK_N,
    prgc1_clk_p             => F_PRGC1_CLK_P,
    prgc1_clk_n             => F_PRGC1_CLK_N,

    reset_sys               => reset_system,
    reset_out               => reset,
    reset_n_out             => reset_n,
    link1_up                => link1_eci_link_up,
    link2_up                => link2_eci_link_up,

    link1_in_data(63 downto 0)           => link1_in_data(0),
    link1_in_data(127 downto 64)         => link1_in_data(1),
    link1_in_data(191 downto 128)        => link1_in_data(2),
    link1_in_data(255 downto 129)        => link1_in_data(3),
    link1_in_data(319 downto 256)        => link1_in_data(4),
    link1_in_data(383 downto 320)        => link1_in_data(5),
    link1_in_data(447 downto 384)        => link1_in_data(6),
    link1_in_vc_no(3 downto 0)           => link1_in_vc_no(0),
    link1_in_vc_no(7 downto 4)           => link1_in_vc_no(1),
    link1_in_vc_no(11 downto 8)          => link1_in_vc_no(2),
    link1_in_vc_no(15 downto 12)         => link1_in_vc_no(3),
    link1_in_vc_no(19 downto 16)         => link1_in_vc_no(4),
    link1_in_vc_no(23 downto 20)         => link1_in_vc_no(5),
    link1_in_vc_no(27 downto 24)         => link1_in_vc_no(6),
    link1_in_we2            => link1_in_we2,
    link1_in_we3            => link1_in_we3,
    link1_in_we4            => link1_in_we4,
    link1_in_we5            => link1_in_we5,
    link1_in_valid          => link1_in_valid,
    link1_in_credit_return  => link1_in_credit_return,

    link1_out_hi_data(63 downto 0)      => link1_out.hi.data(0),
    link1_out_hi_data(127 downto 64)    => link1_out.hi.data(1),
    link1_out_hi_data(191 downto 128)   => link1_out.hi.data(2),
    link1_out_hi_data(255 downto 192)   => link1_out.hi.data(3),
    link1_out_hi_data(319 downto 256)   => link1_out.hi.data(4),
    link1_out_hi_data(383 downto 320)   => link1_out.hi.data(5),
    link1_out_hi_data(447 downto 384)   => link1_out.hi.data(6),
    link1_out_hi_data(511 downto 448)   => link1_out.hi.data(7),
    link1_out_hi_data(575 downto 512)   => link1_out.hi.data(8),
    link1_out_hi_vc_no      => link1_out.hi.vc_no,
    link1_out_hi_size       => link1_out.hi.size,
    link1_out_hi_valid      => link1_out.hi.valid,
    link1_out_hi_ready      => link1_out.hi_ready,

    link1_out_lo_data       => link1_out.lo.data,
    link1_out_lo_vc_no      => link1_out.lo.vc_no,
    link1_out_lo_valid      => link1_out.lo.valid,
    link1_out_lo_ready      => link1_out.lo_ready,
    link1_out_credit_return => link1_out_credit_return,

    link2_in_data(63 downto 0)     => link2_in_data(0),
    link2_in_data(127 downto 64)   => link2_in_data(1),
    link2_in_data(191 downto 128)  => link2_in_data(2),
    link2_in_data(255 downto 192)  => link2_in_data(3),
    link2_in_data(319 downto 256)  => link2_in_data(4),
    link2_in_data(383 downto 320)  => link2_in_data(5),
    link2_in_data(447 downto 384)  => link2_in_data(6),
    link2_in_vc_no(3 downto 0)     => link2_in_vc_no(0),
    link2_in_vc_no(7 downto 4)     => link2_in_vc_no(1),
    link2_in_vc_no(11 downto 8)    => link2_in_vc_no(2),
    link2_in_vc_no(15 downto 12)   => link2_in_vc_no(3),
    link2_in_vc_no(19 downto 16)   => link2_in_vc_no(4),
    link2_in_vc_no(23 downto 20)   => link2_in_vc_no(5),
    link2_in_vc_no(27 downto 24)   => link2_in_vc_no(6),
    link2_in_we2            => link2_in_we2,
    link2_in_we3            => link2_in_we3,
    link2_in_we4            => link2_in_we4,
    link2_in_we5            => link2_in_we5,
    link2_in_valid          => link2_in_valid,
    link2_in_credit_return  => link2_in_credit_return,

    link2_out_hi_data(63 downto 0)      => link2_out.hi.data(0),
    link2_out_hi_data(127 downto 64)    => link2_out.hi.data(1),
    link2_out_hi_data(191 downto 128)   => link2_out.hi.data(2),
    link2_out_hi_data(255 downto 192)   => link2_out.hi.data(3),
    link2_out_hi_data(319 downto 256)   => link2_out.hi.data(4),
    link2_out_hi_data(383 downto 320)   => link2_out.hi.data(5),
    link2_out_hi_data(447 downto 384)   => link2_out.hi.data(6),
    link2_out_hi_data(511 downto 448)   => link2_out.hi.data(7),
    link2_out_hi_data(575 downto 512)   => link2_out.hi.data(8),
    link2_out_hi_vc_no      => link2_out.hi.vc_no,
    link2_out_hi_size       => link2_out.hi.size,
    link2_out_hi_valid      => link2_out.hi.valid,
    link2_out_hi_ready      => link2_out.hi_ready,

    link2_out_lo_data       => link2_out.lo.data,
    link2_out_lo_vc_no      => link2_out.lo.vc_no,
    link2_out_lo_valid      => link2_out.lo.valid,
    link2_out_lo_ready      => link2_out.lo_ready,
    link2_out_credit_return => link2_out_credit_return,

    s_bscan_bscanid_en      => s_bscan.bscanid_en, -- ? comes from outside in dyn_stub
    s_bscan_capture         => s_bscan.capture,
    s_bscan_drck            => s_bscan.drck,
    s_bscan_reset           => s_bscan.reset,
    s_bscan_runtest         => s_bscan.runtest,
    s_bscan_sel             => s_bscan.sel,
    s_bscan_shift           => s_bscan.shift,
    s_bscan_tck             => s_bscan.tck,
    s_bscan_tdi             => s_bscan.tdi,
    s_bscan_tdo             => s_bscan.tdo,
    s_bscan_tms             => s_bscan.tms,
    s_bscan_update          => s_bscan.update,

    m0_bscan_bscanid_en     => m0_bscan.bscanid_en,
    m0_bscan_capture        => m0_bscan.capture,
    m0_bscan_drck           => m0_bscan.drck,
    m0_bscan_reset          => m0_bscan.reset,
    m0_bscan_runtest        => m0_bscan.runtest,
    m0_bscan_sel            => m0_bscan.sel,
    m0_bscan_shift          => m0_bscan.shift,
    m0_bscan_tck            => m0_bscan.tck,
    m0_bscan_tdi            => m0_bscan.tdi,
    m0_bscan_tdo            => m0_bscan.tdo,
    m0_bscan_tms            => m0_bscan.tms,
    m0_bscan_update         => m0_bscan.update,

    rx_eci_channels(0)      => link_eci_packet_rx.c_gsync,
    rx_eci_channels(1)      => link_eci_packet_rx.c_ginv,

    rx_eci_channels_ready(0)   => link_eci_packet_rx.c_gsync_ready,
    rx_eci_channels_ready(1)   => '1',

    tx_eci_channels(0)      => link_eci_packet_tx.c_gsdn,

    tx_eci_channels_ready(0)   => link_eci_packet_tx.c_gsdn_ready
);

gsync_loopback : loopback_vc_resp_nodata
generic map (
    WORD_WIDTH => 64,
    GSDN_GSYNC_FN => 1 -- ? (einfach übernommen)
)
port map (
    clk => clk_system,
    reset => reset_system,

    vc_req_i       => link_eci_packet_rx.c_gsync.data(0),
    vc_req_valid_i => link_eci_packet_rx.c_gsync.valid,
    vc_req_ready_o => link_eci_packet_rx.c_gsync_ready,

    vc_resp_o       => link_eci_packet_tx.c_gsdn.data(0),
    vc_resp_valid_o => link_eci_packet_tx.c_gsdn.valid,
    vc_resp_ready_i => link_eci_packet_tx.c_gsdn_ready
);


end behavioural;