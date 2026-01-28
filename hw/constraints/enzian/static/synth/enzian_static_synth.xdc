# ECI
create_clock -period 10.000 [get_ports {prgc_clk_p[0]}]
create_clock -period 3.333 [get_ports {prgc_clk_p[1]}]