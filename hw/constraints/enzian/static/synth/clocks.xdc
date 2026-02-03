# Fabric clocks

create_clock -period 10.000 -name clk_prgc0 [get_ports F_PRGC0_CLK_P]
create_clock -period 3.333 -name clk_prgc1 [get_ports F_PRGC1_CLK_P]
