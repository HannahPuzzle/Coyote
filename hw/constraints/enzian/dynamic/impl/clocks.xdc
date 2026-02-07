# Fabric clocks

set_property PACKAGE_PIN AY26 [get_ports {F_PRGC0_CLK_P}]
set_property PACKAGE_PIN AY27 [get_ports {F_PRGC0_CLK_N}]
set_property PACKAGE_PIN AW28 [get_ports {F_PRGC1_CLK_P}]
set_property PACKAGE_PIN AY28 [get_ports {F_PRGC1_CLK_N}]

# Copy to your local constraints if needed
# create_clock -period 3.103 -name F_MAC0C_CLK_P [get_ports F_MAC0C_CLK_P]
# create_clock -period 3.103 -name F_MAC1C_CLK_P [get_ports F_MAC1C_CLK_P]
# create_clock -period 3.103 -name F_MAC2C_CLK_P [get_ports F_MAC2C_CLK_P]
# create_clock -period 3.103 -name F_MAC3C_CLK_P [get_ports F_MAC3C_CLK_P]
# create_clock -period 10.000 -name F_NVMEC_CLK_P [get_ports F_NVMEC_CLK_P]
# create_clock -period 10.000 -name F_PCIE16C_CLK_P [get_ports F_PCIE16C_CLK_P]
