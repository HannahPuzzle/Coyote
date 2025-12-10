
################################################################
# This is a generated script based on design: design_static
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
set scripts_vivado_version 2025.1
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
# source design_static_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvu9p-flgb2104-3-e
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_static

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
  set axi_cnfg [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 axi_cnfg ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {64} \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $axi_cnfg

  set axi_main [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 axi_main ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {64} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {64} \
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
   CONFIG.NUM_READ_OUTSTANDING {4} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {4} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $axi_main

  set axi_ctrl_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 axi_ctrl_0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {64} \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $axi_ctrl_0


  # Create ports
  set aresetn [ create_bd_port -dir O -type rst aresetn ]
  set aclk [ create_bd_port -dir I -type clk -freq_hz 250000000 aclk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {axi_cnfg:axi_ctrl_0} \
   CONFIG.ASSOCIATED_RESET {aresetn} \
 ] $aclk
  set xresetn [ create_bd_port -dir I -type rst xresetn ]
  set xclk [ create_bd_port -dir I -type clk -freq_hz 322265625 xclk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {axi_main} \
   CONFIG.ASSOCIATED_RESET {xresetn} \
 ] $xclk
  set nclk [ create_bd_port -dir I -type clk -freq_hz 250000000 nclk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {nresetn} \
 ] $nclk
  set nresetn [ create_bd_port -dir O -type rst nresetn ]
  set uclk [ create_bd_port -dir I -type clk -freq_hz 300000000 uclk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {uresetn} \
 ] $uclk
  set uresetn [ create_bd_port -dir O -type rst uresetn ]
  set pclk [ create_bd_port -dir I -type clk -freq_hz 100000000 pclk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {presetn} \
 ] $pclk
  set presetn [ create_bd_port -dir O -type rst presetn ]
  set sys_reset [ create_bd_port -dir O -type rst sys_reset ]

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [list \
    CONFIG.M00_HAS_REGSLICE {4} \
    CONFIG.M01_HAS_REGSLICE {4} \
    CONFIG.NUM_MI {2} \
    CONFIG.S00_HAS_DATA_FIFO {2} \
    CONFIG.S00_HAS_REGSLICE {4} \
    CONFIG.STRATEGY {2} \
  ] $axi_interconnect_0


  # Create instance: proc_sys_reset_p, and set properties
  set proc_sys_reset_p [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_p ]

  # Create instance: proc_sys_reset_n, and set properties
  set proc_sys_reset_n [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_n ]

  # Create instance: proc_sys_reset_u, and set properties
  set proc_sys_reset_u [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_u ]

  # Create instance: proc_sys_reset_a, and set properties
  set proc_sys_reset_a [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_a ]

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property CONFIG.CONST_VAL {0} $xlconstant_1


  # Create interface connections
  connect_bd_intf_net -intf_net axi_ctrl_main_1 [get_bd_intf_ports axi_main] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_ports axi_cnfg] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_ports axi_ctrl_0] [get_bd_intf_pins axi_interconnect_0/M01_AXI]

  # Create port connections
  connect_bd_net -net a_aresetn_1  [get_bd_pins proc_sys_reset_a/peripheral_aresetn] \
  [get_bd_ports aresetn]
  connect_bd_net -net clk_wiz_0_clk_out1  [get_bd_ports pclk] \
  [get_bd_pins proc_sys_reset_p/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_clk_out2  [get_bd_ports aclk] \
  [get_bd_pins proc_sys_reset_a/slowest_sync_clk] \
  [get_bd_pins axi_interconnect_0/ACLK] \
  [get_bd_pins axi_interconnect_0/M00_ACLK] \
  [get_bd_pins axi_interconnect_0/M01_ACLK]
  connect_bd_net -net clk_wiz_0_clk_out3  [get_bd_ports nclk] \
  [get_bd_pins proc_sys_reset_n/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_clk_out4  [get_bd_ports uclk] \
  [get_bd_pins proc_sys_reset_u/slowest_sync_clk]
  connect_bd_net -net n_aresetn_1  [get_bd_pins proc_sys_reset_n/peripheral_aresetn] \
  [get_bd_ports nresetn]
  connect_bd_net -net p_aresetn_1  [get_bd_pins proc_sys_reset_p/peripheral_aresetn] \
  [get_bd_ports presetn]
  connect_bd_net -net proc_sys_reset_a_interconnect_aresetn  [get_bd_pins proc_sys_reset_a/interconnect_aresetn] \
  [get_bd_pins axi_interconnect_0/ARESETN] \
  [get_bd_pins axi_interconnect_0/M00_ARESETN] \
  [get_bd_pins axi_interconnect_0/M01_ARESETN]
  connect_bd_net -net u_aresetn_1  [get_bd_pins proc_sys_reset_u/peripheral_aresetn] \
  [get_bd_ports uresetn]
  connect_bd_net -net xclk_1  [get_bd_ports xclk] \
  [get_bd_pins axi_interconnect_0/S00_ACLK]
  connect_bd_net -net xlconstant_0_dout  [get_bd_pins xlconstant_0/dout] \
  [get_bd_pins proc_sys_reset_a/ext_reset_in] \
  [get_bd_pins proc_sys_reset_n/ext_reset_in] \
  [get_bd_pins proc_sys_reset_u/ext_reset_in] \
  [get_bd_pins proc_sys_reset_p/ext_reset_in]
  connect_bd_net -net xlconstant_1_dout  [get_bd_pins xlconstant_1/dout] \
  [get_bd_ports sys_reset]
  connect_bd_net -net xresetn_1  [get_bd_ports xresetn] \
  [get_bd_pins axi_interconnect_0/S00_ARESETN]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x00008000 -target_address_space [get_bd_addr_spaces axi_main] [get_bd_addr_segs axi_cnfg/Reg] -force
  assign_bd_address -offset 0x00100000 -range 0x00040000 -target_address_space [get_bd_addr_spaces axi_main] [get_bd_addr_segs axi_ctrl_0/Reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_gid_msg -ssname BD::TCL -id 2053 -severity "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

