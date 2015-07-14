# ------------------------------------------------------------------------------------
# Name      : xena_api.tcl
# Purpose   : Provide wrapper functions for easier usage
# Create By : Dan Amzulescu - Xena Networks inc.
#			  dsa@xenanetworks.com
#
#  Updated  : 6 Mar 2015
#  Version  : v0.6
# -----------------------------------------------------------------------------------


# ---------------- Connect --------------------------------
proc Connect {chassis_ip chassis_port} {
	global connected
	after 3000 {set connected timeout}
    set s [socket -async $chassis_ip $chassis_port]
	fileevent $s w {set connected ok}
	vwait connected
	fileevent $s w {}
	if {$connected == "timeout"} {
		return null
	} else {
		fconfigure $s -buffering line
		return $s
	} 
}
#
# ---------------------------------------------------------

# ---------------- Login ----------------
proc Login {s chassis_pass chassis_user console} {

	set pf_flag 1

   puts $s "c_logon $chassis_pass"
   gets $s response
   if {$response == ""} { gets $s response	}
   
   if {$response != "<OK>"}    {set pf_flag 0}
   if {$console == 1} { puts "Logging | $response" }	  	
   

   puts $s "c_owner $chassis_user"
   gets $s response
   if {$response == ""} { gets $s response	}
   
   if {$console == 1} { puts "Owner   | $response" }	
   if {$response != "<OK>"}    {set pf_flag 0}
   
   return $pf_flag
}
#
# -----------------------------------------

# ---------------- IsPortReserved ----------------
proc IsPortReserved {s port console} {

	set pf_flag 0
	
	puts $s "$port P_RESERVEDBY ?"
	gets $s response
	if {$response == ""} { gets $s response	}
	set results [split $response " "]
	
	if {$console == 1} { puts "$port P_RESERVEDBY  | $response" }	

	if {[lindex $results 4] == "\"\""}    {set pf_flag 1}	
  
   return $pf_flag
}
#
# ----------------------------------------

# ---------------- IsPortReservedByMe ----------------
proc IsPortReservedByMe {s port console} {

	set pf_flag 0
	
	puts $s "$port P_RESERVATION ? "
	gets $s response
	if {$response == ""} { gets $s response	}
	set results [split $response " "]
	
	if {$console == 1} { puts "$port P_RESERVATION ? | $response" }	

	if {[lindex $results 4] == "RESERVED_BY_YOU"}    {set pf_flag 1}	
  
   return $pf_flag
}
#
# ------------------------------------------

# ---------------- Unlock_Port ----------------
proc UnlockPort {s port console} {

	set pf_flag 1
	
	puts $s "$port P_RESERVATION RELINQUISH"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	if {$console == 1} { puts "$port P_RESERVATION RELINQUISH   | $response" }	
	if {$response != "<OK>"}    {set pf_flag 0}	
  
   return $pf_flag
}
#
# -----------------------------------------

# ---------------- Reserve_Port ----------------
proc ReservePort {s port console} {

	set pf_flag 1
	
	puts $s "$port P_RESERVATION RESERVE"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	if {$console == 1} { puts "$port P_RESERVATION RESERVE   | $response" }	
	if {$response != "<OK>"}    {set pf_flag 0}	
  
   return $pf_flag
}
#
# -----------------------------------------

# ---------------- Release_Port ----------------
proc ReleasePort {s port console} {

	set pf_flag 1
	
	puts $s "$port P_RESERVATION RELEASE"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	if {$console == 1} { puts "$port P_RESERVATION RELEASE   | $response" }	
	if {$response != "<OK>"}    {set pf_flag 0}	
  
   return $pf_flag
}
#
# -----------------------------------------

# ---------------- ClearPort ----------------
proc ResetPort {s port console} {

	set pf_flag 1
	
	puts $s "$port P_RESET"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	if {$console == 1} { puts "$port P_RESET  | $response" }	
	if {$response != "<OK>"}    {set pf_flag 0}	
  
   return $pf_flag
}
#
# -----------------------------------------

# ---------------- HasLink ----------------
proc HasLink {s port console} {

	set has_link_flag 0
	
	puts $s "$port P_RECEIVESYNC ?"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	if {$console == 1} { puts "$port P_RECEIVESYNC | $response" }	
	if {$response == "$port  P_RECEIVESYNC  IN_SYNC"}    { set has_link_flag 1}	
  
   return $has_link_flag
}
#
# -----------------------------------------

# ---------------- StartPortCapture -------------
proc StartPortTraffic {s port console} {

	set pf_flag 1
	
	puts $s "$port P_TRAFFIC ON"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	if {$console == 1} { puts "$port P_TRAFFIC ON   | $response" }	
	if {$response != "<OK>"}    {set pf_flag 0}	
  
   return $pf_flag
}
#
# -----------------------------------------

# ---------------- StopPortTraffic -------------
proc StopPortTraffic {s port console} {

	set pf_flag 1
	
	puts $s "$port P_TRAFFIC OFF"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	if {$console == 1} { puts "$port P_TRAFFIC OFF   | $response" }	
	if {$response != "<OK>"}    {set pf_flag 0}	
  
   return $pf_flag
}
#
# -----------------------------------------

# ---------------- StartPortTraffic -------------
proc StartPortCapture {s port console} {

	set pf_flag 1
	
	puts $s "$port P_CAPTURE ON"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	if {$console == 1} { puts "$port P_CAPTURE ON   | $response" }	
	if {$response != "<OK>"}    {set pf_flag 0}	
  
   return $pf_flag
}
#
# -----------------------------------------

# ---------------- StopPortCapture -------------
proc StopPortCapture {s port console} {

	set pf_flag 1
	
	puts $s "$port P_CAPTURE OFF"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	if {$console == 1} { puts "$port P_CAPTURE OFF   | $response" }	
	if {$response != "<OK>"}    {set pf_flag 0}	
  
   return $pf_flag
}
#
# -----------------------------------------

# ---------------- ClearPortResults -------------
proc ClearPortResults {s port console} {

	set pf_flag 1
	
	puts $s "$port PT_CLEAR"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	if {$console == 1} { puts "$port PT_CLEAR | $response" }	
	if {$response != "<OK>"}    {set pf_flag 0}

	puts $s "$port PR_CLEAR"
	gets $s response
	if {$console == 1} { puts "$port PR_CLEAR | $response" }	
	if {$response != "<OK>"}    {set pf_flag 0}		
  
   return $pf_flag
}
#
# -----------------------------------------

# ---------------- PortLinkDown -------------
proc PortLinkDown {s port console} {

	set pf_flag 1
	
	puts $s "$port P_TXENABLE OFF"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	if {$console == 1} { puts "$port P_TXENABLE OFF   | $response" }	
	if {$response != "<OK>"}    {set pf_flag 0}	
  
   return $pf_flag
}
#
# -----------------------------------------

# ---------------- PortLinkUp -------------
proc PortLinkUp {s port console} {

	set pf_flag 1
	
	puts $s "$port P_TXENABLE ON"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	if {$console == 1} { puts "$port P_TXENABLE ON   | $response" }	
	if {$response != "<OK>"}    {set pf_flag 0}	
  
   return $pf_flag
}
#
# -----------------------------------------

# ---------------- Logout ----------------
proc Logout {s} {

	puts $s "c_logoff"
	close $s
}
#
# -----------------------------------------

# ----------------PortTxTotalResults-------------------------
proc PortTxTotalResults {s port result_type console} {
	
	puts $s "$port PT_TOTAL ?"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	set results [split $response " "]
	
	switch $result_type {
		"BPS" { return [lindex $results 4] }
		"PPS" { return [lindex $results 5] }
		"BYTES" { return [lindex $results 6]}		
		"PACKETS" { return [lindex $results 7]}
		default { return -1 }	
	}
}
#
# -----------------------------------------

# ----------------PortRxTotalResults-------------------------
proc PortRxTotalResults {s port result_type console} {
	
	puts $s "$port PR_TOTAL ?"
	gets $s response	
	if {$response == ""} { gets $s response	}
	
	set results [split $response " "]
	
	switch $result_type {
		"BPS" { return [lindex $results 4] }
		"PPS" { return [lindex $results 5] }
		"BYTES" { return [lindex $results 6]}		
		"PACKETS" { return [lindex $results 7]}
		default { return -1 }	
	}
}
#
# -----------------------------------------

# ----------------PortTxNoTPLDResults-------------------------
proc PortTxNoTPLDResults {s port result_type console} {
	puts $s "$port PT_NOTPLD ?"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	set results [split $response " "]
	
	switch $result_type {
		"BPS" { return [lindex $results 4] }
		"PPS" { return [lindex $results 5] }
		"BYTES" { return [lindex $results 6]}		
		"PACKETS" { return [lindex $results 7]}
		default { return -1 }	
	}
}
#
# -----------------------------------------

# ----------------PortRxNoTPLDResults-------------------------
proc PortRxNoTPLDResults {s port result_type console} {
	puts $s "$port PR_NOTPLD ?"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	set results [split $response " "]
	
	switch $result_type {
		"BPS" { return [lindex $results 4] }
		"PPS" { return [lindex $results 5] }
		"BYTES" { return [lindex $results 6]}		
		"PACKETS" { return [lindex $results 7]}
		default { return -1 }	
	}
}
#
# -----------------------------------------

# ----------------StreamTxTrafficResults-------------------------
proc StreamTxTrafficResults {s port stream_id result_type console} {

	puts $s "$port PT_STREAM \[$stream_id\] ?\n"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	set results [split $response " "]
	
	switch $result_type {
		"BPS" { return [lindex $results 6] }
		"PPS" { return [lindex $results 7] }
		"BYTES" { return [lindex $results 8]}		
		"PACKETS" { return [lindex $results 9]}
		default { return -1 }	
	}
}
#
# -----------------------------------------

# -------------------StreamRxTrafficResults----------------------
proc StreamRxTrafficResults {s port stream_tid result_type console} {

	puts $s "$port PR_TPLDTRAFFIC \[$stream_tid\] ?\n"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	set results [split $response " "]
	
	switch $result_type {
		"BPS" { return [lindex $results 6] }
		"PPS" { return [lindex $results 7] }
		"BYTES" { return [lindex $results 8]}		
		"PACKETS" { return [lindex $results 9]}
		default { return -1 }	
	}
}
#
# -----------------------------------------

# -------------------StreamRxLatencyResults----------------------
proc StreamRxLatencyResults {s port stream_tid result_type console} {

	puts $s "$port PR_TPLDLATENCY \[$stream_tid\] ?\n"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	set results [split $response " "]
	
	switch $result_type {
		"MIN" { return [lindex $results 6] }
		"AVG" { return [lindex $results 7] }
		"MAX" { return [lindex $results 8]}		
		"SEC" { return [lindex $results 9]}
		default { return -1 }	
	}
}

#
# -----------------------------------------

# -------------------StreamRxJitterResults----------------------
proc StreamRxJitterResults {s port stream_tid result_type console} {

	puts $s "$port PR_TPLDJITTER \[$stream_tid\] ?\n"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	set results [split $response " "]
	
	switch $result_type {
		"MIN" { return [lindex $results 6] }
		"AVG" { return [lindex $results 7] }
		"MAX" { return [lindex $results 8]}		
		"SEC" { return [lindex $results 9]}
		default { return -1 }	
	}
}
#
# -----------------------------------------

# -------------------StreamRxErrorsResults----------------------
proc StreamRxErrorsResults {s port stream_tid result_type console} {

	puts $s "$port PR_TPLDERRORS \[$stream_tid\] ?\n"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	set results [split $response " "]
	
	switch $result_type {
		"SEQ" { return [lindex $results 7]}
		"MIS" { return [lindex $results 8]}
		"PLD" { return [lindex $results 9]}
		default { return -1 }	
	}
}
#
# -----------------------------------------

# -------------------PortRxFilterResults----------------------
proc PortRxFilterResults {s port filter_id result_type console} {

	puts $s "$port PR_FILTER \[$filter_id\] ?\n"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	set results [split $response " "]
	
	switch $result_type {
		"BPS" { return [lindex $results 6]	}
		"PPS" { return [lindex $results 7]}
		"BYTES" { return [lindex $results 8]}
		"PACKETS" { return [lindex $results 9]}
		default { return -1 }	
	}
}
#
# -----------------------------------------

# ----------------------------------------------------------------------------------------------------------------------------------------------


# ---------------- LoadPortConfig ----------------
proc LoadPortConfig { s port file_name console} {
	set pf_flag 1
	
	if {[catch {set fp [open $file_name r]} errmsg]} {
		if {$console == 1} { puts "\n---Error---: $errmsg \n" }
		return 0
	}
	
    set file_data [read $fp]
    set data [split $file_data "\n"]
	
	if {$console == 1} { puts "\n------------- Loading Port Configuration ($file_name) for Port($port) -------------\n"}
	
    foreach line $data { 
		if {$line==""} {break}
		if !{[string match ";*" $line]} {
			puts $s "$port $line"
			gets $s response
			if {$console == 1} { puts "$port $line | $response" }	
		}
	}
    
	if {$console == 1} { puts "-----------------------------------------------------------------------------------\n"}
    close $fp  
	return $pf_flag
}
#
# -----------------------------------------


# ---------------- SavePortCapture ----------------
proc SavePortCapture { s port console} {
	set pf_flag 1
	
	puts $s "$port P_CAPTURE ?\n"
	gets $s response
	if {$response == ""} { gets $s response	}
		
	if {$response == "$port  P_CAPTURE  ON"} {
		puts $s "$port P_CAPTURE OFF"
		gets $s response
		if {$response == ""} { gets $s response	}
	}
	
	set systemTime [clock seconds]
	
	
	
	regsub -all {[/]} $port {_} p
	
	set txt_file_name     [clock format $systemTime -format "Xena_Results/%d_%m_%Y/Capture/P_$p/%H_%M_%S.txt"]
	set txtpcap_file_name [clock format $systemTime -format "Xena_Results/%d_%m_%Y/Capture/P_$p/%H_%M_%S.pcap.txt"]
	set pcap_file_name    [clock format $systemTime -format "Xena_Results/%d_%m_%Y/Capture/P_$p/%H_%M_%S.pcap"]
	
	file mkdir [clock format $systemTime -format "Xena_Results/%d_%m_%Y/Capture/P_$p"]
	
	if {[catch {set fp1 [open $txt_file_name w]} errmsg]} {
		if {$console == 1} { puts "\n---Error---: $errmsg \n" }
		return 0
	}
	
	if {[catch {set fp2 [open $txtpcap_file_name w]} errmsg]} {
		if {$console == 1} { puts "\n---Error---: $errmsg \n" }
		return 0
	}
	
	puts $s "$port PC_STATS ?\n"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	set results [split $response " "]	
	set buffered_packets [lindex $results 5]
	
	
	
	if { $buffered_packets > 0 } {
		for {set i 0} {$i < $buffered_packets } {incr i} {

			puts $s "$port PC_PACKET \[$i\] ?\n"
			gets $s response
			if {$response == ""} { gets $s response	}
			
			set results [split $response " "]
			
			set packet_raw_data [lindex $results 6]
			puts $fp1 $packet_raw_data			
			
			set trimmed_string [string range $packet_raw_data 2 [string length $packet_raw_data]]
			set length [string length $trimmed_string]						
			
			for {set j 0;set loop_index 1} {$j < $length } {incr j;incr j;incr loop_index} {				
				if { $loop_index == 1} {	puts -nonewline $fp2 "[format "%6.6X" $j] "	}
				puts -nonewline $fp2 "[string range $trimmed_string $j [expr $j+1]] "								
				if { $loop_index % 16 == 0} {  puts -nonewline $fp2 "\n[format "%6.6X" $loop_index] " } 
			}
			puts $fp2 ""
		}
	}	
    
    close $fp1
	close $fp2
	
	set path [file normalize [info script]]
	set path [file dirname $path]
	
	if {[catch {[exec "C:/Program Files/Wireshark/text2pcap.exe" $path\\$txtpcap_file_name $path\\$pcap_file_name]} errmsg]} {
		if {$console == 1} { puts "\n--------Output From text2pcap.exe Exec--------:\n$errmsg\n-----------------------------------------------\n" }
		return 0
	}	
	
	return $pf_flag
}
#
# -----------------------------------------

# -------------------SavePortResults--------------------------------------------------------
proc SavePortResults { s port console} {
	
	set pf_flag 1
		
	set systemTime [clock seconds]
	file mkdir [clock format $systemTime -format "Xena_Results/%d_%m_%Y"]
	set file_name [clock format $systemTime -format "Xena_Results/%d_%m_%Y/PortResults.csv"]
	
	set fexist [file exist $file_name]
	
	if {[catch {set fp1 [open $file_name a]} errmsg]} {
		if {$console == 1} { puts "\n---Error---: $errmsg \n" }
		return 0
	}	
	
	
	if {$fexist==0} {
		puts -nonewline $fp1 "Date,Time,,Port,,Todal_Tx_bPS,Todal_Tx_PPS,Todal_Tx_BYTES,Todal_Tx_PACKETS,"
		puts -nonewline $fp1 "NoTPLD_Tx_bPS,Todal_Tx_PPS,Todal_Tx_BYTES,Todal_Tx_PACKETS,"
		puts -nonewline $fp1 "Todal_Rx_bPS,Todal_Rx_PPS,Todal_Rx_BYTES,Todal_Rx_PACKETS,"
		puts -nonewline $fp1 "NoTPLD_Rx_bPS,NoTPLD_Rx_PPS,NoTPLD_Rx_BYTES,NoTPLD_Rx_PACKETS,\n"
	}
	
	puts $s "$port PT_TOTAL ?"
	gets $s response
	if {$response == ""} { gets $s response	}	
	set results [split $response " "]
	
	set date [clock format $systemTime -format %d_%m_%Y]
	set time [clock format $systemTime -format %H_%M_%S]
	
	puts -nonewline $fp1  "$date,$time,,P_$port,,[lindex $results 4],[lindex $results 5],[lindex $results 6],[lindex $results 7],"
	puts $s "$port PT_NOTPLD ?"
	gets $s response
	if {$response == ""} { gets $s response	}	
	set results [split $response " "]
	puts -nonewline $fp1  "[lindex $results 4],[lindex $results 5],[lindex $results 6],[lindex $results 7],"
	puts $s "$port PR_TOTAL ?"
	gets $s response
	if {$response == ""} { gets $s response	}	
	set results [split $response " "]
	puts -nonewline $fp1  "[lindex $results 4],[lindex $results 5],[lindex $results 6],[lindex $results 7],"
	puts $s "$port PR_NOTPLD ?"
	gets $s response
	if {$response == ""} { gets $s response	}	
	set results [split $response " "]
	puts -nonewline $fp1  "[lindex $results 4],[lindex $results 5],[lindex $results 6],[lindex $results 7],\n"
	
	close $fp1
	return $pf_flag		
}
#
# --------------------------------

# ---------------------SaveStreamStatistics------------------------------------------------------
proc SaveStreamResults{ s tx_port rx_port tx_sid rx_tid console} {
	
	set pf_flag 1

	set systemTime [clock seconds]
	file mkdir [clock format $systemTime -format "Xena_Results/%d_%m_%Y"]
	set file_name [clock format $systemTime -format "Xena_Results/%d_%m_%Y/StreamResults.csv"]
	
	set fexist [file exist $file_name]
	
	if {[catch {set fp1 [open $file_name a]} errmsg]} {
		if {$console == 1} { puts "\n---Error---: $errmsg \n" }
		return 0
	}	
	
	if {$fexist==0} {
		puts -nonewline $fp1 "Date,Time,,TxPort,RxPort,,Sid,Tid,,Tx_bPS,Tx_PPS,Tx_BYTES,Tx_PACKETS,,"	
		puts -nonewline $fp1 "Rx_bPS,Rx_PPS,Rx_BYTES,Rx_PACKETS,,"
		puts -nonewline $fp1 "PacketLoss,MisOrdered,PayloadErrors,,"
		puts -nonewline $fp1 "LatencyMIN,LatencyAVG,LatencyMAX,Latency1Sec,,JitterMIN,JitterAVG,JitterMAX,Jitter1Sec,\n"
	}
	
	
	puts $s "$tx_port PT_STREAM \[$tx_sid\] ?\n"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	set date [clock format $systemTime -format %d_%m_%Y]
	set time [clock format $systemTime -format %H_%M_%S]
	
	set results [split $response " "]
	puts -nonewline $fp1  "$date,$time,,P_$tx_port,P_$rx_port,,$tx_sid,$rx_tid,,[lindex $results 6],[lindex $results 7],[lindex $results 8],[lindex $results 9],,"
	

	puts $s "$rx_port PR_TPLDTRAFFIC \[$rx_tid\] ?\n"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	set results [split $response " "]
	puts -nonewline $fp1  "[lindex $results 6],[lindex $results 7],[lindex $results 8],[lindex $results 9],,"

	puts $s "$rx_port PR_TPLDERRORS \[$rx_tid\] ?\n"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	set results [split $response " "]
	puts -nonewline $fp1  "[lindex $results 7],[lindex $results 8],[lindex $results 9],,"

	puts $s "$rx_port PR_TPLDLATENCY \[$rx_tid\] ?\n"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	set results [split $response " "]
	puts -nonewline $fp1  "[lindex $results 6],[lindex $results 7],[lindex $results 8],[lindex $results 9],,"
	
	puts $s "$rx_port PR_TPLDJITTER \[$rx_tid\] ?\n"
	gets $s response
	if {$response == ""} { gets $s response	}
	
	set results [split $response " "]
	puts -nonewline $fp1  "[lindex $results 6],[lindex $results 7],[lindex $results 8],[lindex $results 9],\n"
	
	close $fp1
	return $pf_flag		
}