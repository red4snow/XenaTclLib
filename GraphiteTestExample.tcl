# ------------------------------------------------------------------------------------
# 
# Purpose   : To demonstrate the usage of XenaMainStart loading API and running this test Scenario.
#				Latency Test RFC2544 a la mode...
# Create By : Dan Amzulescu - Xena Networks Inc.
#			  dsa@xenanetworks.com
#
# -----------------------------------------------------------------------------------

# ----- Import the Xena TCL Command Library ------
#
source [file dirname [info script]]/xena_api_main.tcl
source [file dirname [info script]]/xena_api_port.tcl
source [file dirname [info script]]/xena_api_streams.tcl

# ------------------------------------------------

# ---------------- General Variables ----------
#
# Chassis IP
set xena1_ip 131.164.227.250
#
# Chassis scripting port
set xena1_port 22611
#
# Chassis password
set xena1_password \"xena\"
#
# Test port owner
set xena1_owner "\"TCLAPI\""
#
# -----------------------------------------------

set graphite1_ip 10.0.0.45
set graphite1_port 2005


# ---------------- Test Scenario Variables ----------------
#
# Tx port 1
set tx_port_1 "11/0"
# Rx port 1
set rx_port_1 "11/1"

# Tx port 2
set tx_port_2 "11/1"
# Rx port 2
set rx_port_2 "11/0"

# The TID`s used in 
set tx_tid_1 1
set tx_tid_2 2


set ports { "11/0" "11/1"}
set tids     {$tx_tid_1 $tx_tid_2}

set port_config_1 "1.xpc"
set port_config_2 "2.xpc"

# Setting the time for the traffic to run each trial in seconds
set trial_time 3

# Console flag
set console_flag 1
#
# ---------------------------------------------------------

# -------------------------------TEST MAIN-----------------------------------------
#
# --- Connect + Check Connected
set xena_socket [Connect $xena1_ip $xena1_port]
if {$xena_socket == "null"} {
	puts "Test Halted due to Xena connection time out"
	return
} 

set graphite_socket [Connect $xena1_ip $xena1_port]
if {$graphite_socket == "null"} {
	puts "Test Halted due to Graphite connection time out"
	return
}

puts "haha  $graphite_socket"

# --- Login and provide owner user-name
Login $xena_socket $xena1_password $xena1_owner $console_flag

set systemTime [clock seconds]
puts $graphite_socket "local.random.xenatest2 6 $systemTime"
puts $graphite_socket "local.random.xenatest2 10 $systemTime"




# --- Release all ports and disconnect

Logout $xena_socket
close $graphite_socket