
################################################################
# This is a generated script based on design: design_static_eci
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2023.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_static_eci_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcu55c-fsvh2892-2L-e
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_static_eci

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:xlconstant:1.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: clk_rst
proc create_hier_cell_clk_rst { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_clk_rst() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 prgc0


  # Create pins
  create_bd_pin -dir O -type clk pclk
  create_bd_pin -dir O -from 0 -to 0 -type rst presetn
  create_bd_pin -dir O -type clk xclk
  create_bd_pin -dir I -type rst eos_resetn
  create_bd_pin -dir O -from 0 -to 0 -type rst xresetn
  create_bd_pin -dir I -type rst reset_sys
  create_bd_pin -dir O -from 0 -to 0 -type rst sresetn
  create_bd_pin -dir O -type clk dclk
  create_bd_pin -dir O -from 0 -to 0 -type rst dresetn
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir I -type clk clk_sys

  # Create instance: rst_pclk, and set properties
  set rst_pclk [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_pclk ]
  set_property -dict [list \
    CONFIG.C_AUX_RST_WIDTH {1} \
    CONFIG.C_EXT_RST_WIDTH {1} \
  ] $rst_pclk


  # Create instance: rst_xclk, and set properties
  set rst_xclk [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_xclk ]
  set_property -dict [list \
    CONFIG.C_AUX_RST_WIDTH {1} \
    CONFIG.C_EXT_RST_WIDTH {1} \
  ] $rst_xclk


  # Create instance: rst_xclk_sys, and set properties
  set rst_xclk_sys [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_xclk_sys ]
  set_property -dict [list \
    CONFIG.C_AUX_RST_WIDTH {1} \
    CONFIG.C_EXT_RST_WIDTH {1} \
  ] $rst_xclk_sys


  # Create instance: rst_dclk, and set properties
  set rst_dclk [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_dclk ]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [list \
    CONFIG.CLKOUT1_JITTER {110.209} \
    CONFIG.CLKOUT1_PHASE_ERROR {98.575} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {250} \
    CONFIG.CLKOUT2_JITTER {114.829} \
    CONFIG.CLKOUT2_PHASE_ERROR {98.575} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {200} \
    CONFIG.CLKOUT2_USED {true} \
    CONFIG.CLKOUT3_JITTER {130.958} \
    CONFIG.CLKOUT3_PHASE_ERROR {98.575} \
    CONFIG.CLKOUT3_USED {true} \
    CONFIG.CLK_OUT1_PORT {xclk} \
    CONFIG.CLK_OUT2_PORT {pclk} \
    CONFIG.CLK_OUT3_PORT {dclk} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {10.000} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {4.000} \
    CONFIG.MMCM_CLKOUT1_DIVIDE {5} \
    CONFIG.MMCM_CLKOUT2_DIVIDE {10} \
    CONFIG.NUM_OUT_CLKS {3} \
    CONFIG.OPTIMIZE_CLOCKING_STRUCTURE_EN {true} \
    CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
    CONFIG.USE_LOCKED {false} \
    CONFIG.USE_RESET {false} \
  ] $clk_wiz_0


  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: rst_clk_sys_322M, and set properties
  set rst_clk_sys_322M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_sys_322M ]

  # Create interface connections
  connect_bd_intf_net -intf_net prgc0_1 [get_bd_intf_pins prgc0] [get_bd_intf_pins clk_wiz_0/CLK_IN1_D]

  # Create port connections
  connect_bd_net -net clk_sys_1 [get_bd_pins clk_sys] [get_bd_pins rst_clk_sys_322M/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_dclk [get_bd_pins clk_wiz_0/dclk] [get_bd_pins dclk] [get_bd_pins rst_dclk/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_pclk [get_bd_pins clk_wiz_0/pclk] [get_bd_pins pclk] [get_bd_pins rst_pclk/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_xclk [get_bd_pins clk_wiz_0/xclk] [get_bd_pins xclk] [get_bd_pins rst_xclk_sys/slowest_sync_clk] [get_bd_pins rst_xclk/slowest_sync_clk]
  connect_bd_net -net eos_resetn_1 [get_bd_pins eos_resetn] [get_bd_pins rst_xclk/aux_reset_in]
  connect_bd_net -net reset_sys_1 [get_bd_pins reset_sys] [get_bd_pins rst_xclk_sys/ext_reset_in] [get_bd_pins rst_clk_sys_322M/ext_reset_in]
  connect_bd_net -net rst_clk_sys_322M_peripheral_aresetn [get_bd_pins rst_clk_sys_322M/peripheral_aresetn] [get_bd_pins peripheral_aresetn]
  connect_bd_net -net rst_dclk_peripheral_aresetn [get_bd_pins rst_dclk/peripheral_aresetn] [get_bd_pins dresetn]
  connect_bd_net -net rst_pclk_peripheral_aresetn [get_bd_pins rst_pclk/peripheral_aresetn] [get_bd_pins presetn]
  connect_bd_net -net rst_xclk_peripheral_aresetn [get_bd_pins rst_xclk/peripheral_aresetn] [get_bd_pins xresetn]
  connect_bd_net -net rst_xclk_sys_peripheral_aresetn [get_bd_pins rst_xclk_sys/peripheral_aresetn] [get_bd_pins sresetn]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconstant_0/dout] [get_bd_pins rst_pclk/ext_reset_in] [get_bd_pins rst_dclk/ext_reset_in] [get_bd_pins rst_xclk/ext_reset_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set prgc0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 prgc0 ]

  set s_io_axil [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_io_axil ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {44} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.FREQ_HZ {322265625} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {1} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $s_io_axil

  set axi_main [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 axi_main ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {64} \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.PROTOCOL {AXI4} \
   ] $axi_main

  set axi_cnfg [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 axi_cnfg ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $axi_cnfg


  # Create ports
  set xclk [ create_bd_port -dir O -type clk xclk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {axi_main:axi_cnfg} \
   CONFIG.ASSOCIATED_RESET {sresetn:xresetn} \
 ] $xclk
  set pclk [ create_bd_port -dir O -type clk pclk ]
  set dclk [ create_bd_port -dir O -type clk dclk ]
  set presetn [ create_bd_port -dir O -from 0 -to 0 -type rst presetn ]
  set dresetn [ create_bd_port -dir O -from 0 -to 0 -type rst dresetn ]
  set reset_sys [ create_bd_port -dir I -type rst reset_sys ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset_sys
  set sresetn [ create_bd_port -dir O -from 0 -to 0 -type rst sresetn ]
  set eos_resetn [ create_bd_port -dir I -type rst eos_resetn ]
  set xresetn [ create_bd_port -dir O -from 0 -to 0 -type rst xresetn ]
  set clk_sys [ create_bd_port -dir I -type clk -freq_hz 322265625 clk_sys ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {s_io_axil} \
 ] $clk_sys

  # Create instance: clk_rst
  create_hier_cell_clk_rst [current_bd_instance .] clk_rst

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [list \
    CONFIG.NUM_MI {2} \
    CONFIG.NUM_SI {1} \
    CONFIG.S00_HAS_DATA_FIFO {2} \
    CONFIG.STRATEGY {2} \
  ] $axi_interconnect_0


  # Create interface connections
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_ports axi_main] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_ports axi_cnfg] [get_bd_intf_pins axi_interconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net prgc0_1 [get_bd_intf_ports prgc0] [get_bd_intf_pins clk_rst/prgc0]
  connect_bd_intf_net -intf_net s_io_axil_1 [get_bd_intf_ports s_io_axil] [get_bd_intf_pins axi_interconnect_0/S00_AXI]

  # Create port connections
  connect_bd_net -net S00_ARESETN_1 [get_bd_pins clk_rst/peripheral_aresetn] [get_bd_pins axi_interconnect_0/S00_ARESETN]
  connect_bd_net -net clk_sys_1 [get_bd_ports clk_sys] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins clk_rst/clk_sys]
  connect_bd_net -net clk_wiz_0_dclk [get_bd_pins clk_rst/dclk] [get_bd_ports dclk]
  connect_bd_net -net clk_wiz_0_pclk [get_bd_pins clk_rst/pclk] [get_bd_ports pclk]
  connect_bd_net -net clk_wiz_0_xclk [get_bd_pins clk_rst/xclk] [get_bd_ports xclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK]
  connect_bd_net -net eos_resetn_1 [get_bd_ports eos_resetn] [get_bd_pins clk_rst/eos_resetn]
  connect_bd_net -net reset_sys_1 [get_bd_ports reset_sys] [get_bd_pins clk_rst/reset_sys]
  connect_bd_net -net rst_dclk_peripheral_aresetn [get_bd_pins clk_rst/dresetn] [get_bd_ports dresetn]
  connect_bd_net -net rst_pclk_peripheral_aresetn [get_bd_pins clk_rst/presetn] [get_bd_ports presetn]
  connect_bd_net -net rst_xclk_peripheral_aresetn [get_bd_pins clk_rst/xresetn] [get_bd_ports xresetn] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN]
  connect_bd_net -net rst_xclk_sys_peripheral_aresetn [get_bd_pins clk_rst/sresetn] [get_bd_ports sresetn]

  # Create address segments
  assign_bd_address -offset 0xA0000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces s_io_axil] [get_bd_addr_segs axi_cnfg/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces s_io_axil] [get_bd_addr_segs axi_main/Reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


