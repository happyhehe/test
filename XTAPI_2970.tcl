#Load required libraries
package require SpirentHltApi

set path "HLTAPI_4.30_LDP_Basic_Test"

#Enable all HLTAPI logs
::sth::test_config  -logfile XTAPI_2970_hltLogfile \
                    -log 1\
                    -vendorlogfile XTAPI_2970_stcExport \
                    -vendorlog 1\
                    -hltlog 1\
                    -hltlogfile XTAPI_2970_hltExport \
                    -hlt2stcmappingfile XTAPI_2970_hlt2StcMapping \
                    -hlt2stcmapping 1\
                    -log_level 7

#Define global variables
#----------------------main interface varaibles

set device 10.61.44.2
set portlist {6/1 6/3}
set hPortlist {}
set hRouter12 {} 
set hRouter12_list {} 
set passFail PASS

##################################################################################
########### Connecting to chassis and reserving all ports 
##################################################################################
puts "\n STEP1 : Connect to the chassis and reserve ports  \n " 

set portIndex 0
foreach port $portlist {
    set cmdReturn [sth::connect -device $device -port_list $port -offline 0]
	set chassConnect [keylget cmdReturn status]

    if {$chassConnect} {
        set hPort($device.$port) [keylget cmdReturn port_handle.$device.$port]
        set hPortlist [concat $hPortlist $hPort($device.$port)]
		
		puts "\n reserved ports : $cmdReturn"
    } else {
        set passFail FAIL
        puts "\nFailed to retrieve port handle! Error message: $cmdReturn"
    }
	
 }     
###################################################################################
############### Retrieving port handles for further configurations 
###################################################################################
 
puts "\n Returned port handles : $hPortlist"

set p1Hnd [lindex $hPortlist 0]
puts $p1Hnd
set p2Hnd [lindex $hPortlist 1]
puts $p2Hnd

############################################################
# interface config
############################################################

# set int_ret0 [sth::interface_config \
		# -mode                                             config \
		# -port_handle                                      $p1Hnd \
		# -intf_mode                                        ethernet\
		# -phy_mode                                         fiber\
		# -scheduling_mode                                  PORT_BASED \
		# -enable_ping_response                             0 \
		# -control_plane_mtu                                1500 \
		# -transmit_clock_source                            INTERNAL \
		# -flow_control                                     false \
		# -deficit_idle_count                               false \
		# -speed                                            ether10000 \
		# -data_path_mode                                   normal \
		# -port_mode                                        LAN \
		# -autonegotiation                                  1 \
# ]

# set status [keylget int_ret0 status]
# if {$status == 0} {
	# puts "run sth::interface_config failed"
	# puts $int_ret0
# } else {
	# puts "***** run sth::interface_config successfully"
# }

# set int_ret1 [sth::interface_config \
		# -mode                                             config \
		# -port_handle                                      $p2Hnd \
		# -intf_mode                                        ethernet\
		# -phy_mode                                         fiber\
		# -scheduling_mode                                  PORT_BASED \
		# -enable_ping_response                             0 \
		# -control_plane_mtu                                1500 \
		# -transmit_clock_source                            INTERNAL \
		# -flow_control                                     false \
		# -deficit_idle_count                               false \
		# -speed                                            ether10000 \
		# -data_path_mode                                   normal \
		# -port_mode                                        LAN \
		# -autonegotiation                                  1 \
# ]

# set status [keylget int_ret1 status]
# if {$status == 0} {
	# puts "run sth::interface_config failed"
	# puts $int_ret1
# } else {
	# puts "***** run sth::interface_config successfully"
# }

##############################################################
#interface config
##############################################################

set int_ret0 [sth::interface_config \
		-mode                                             config \
		-port_handle                                      $p1Hnd \
		-intf_mode                                        ethernet\
		-phy_mode                                         fiber\
		-scheduling_mode                                  PORT_BASED \
		-enable_ping_response                             0 \
		-control_plane_mtu                                1500 \
		-transmit_clock_source                            INTERNAL \
		-flow_control                                     false \
		-deficit_idle_count                               false \
		-speed                                            ether10000 \
		-data_path_mode                                   normal \
		-port_mode                                        LAN \
		-autonegotiation                                  1 \
		-ipv6_intf_addr                                   2000::02 \
		-ipv6_prefix_length								  120 \
		-ipv6_gateway									  2000::01 \
]

set status [keylget int_ret0 status]
if {$status == 0} {
	puts "run sth::interface_config failed"
	puts $int_ret0
} else {
	puts "***** run sth::interface_config successfully"
}

set int_ret1 [sth::interface_config \
		-mode                                             config \
		-port_handle                                      $p2Hnd \
		-intf_mode                                        ethernet\
		-phy_mode                                         fiber\
		-scheduling_mode                                  PORT_BASED \
		-enable_ping_response                             0 \
		-control_plane_mtu                                1500 \
		-transmit_clock_source                            INTERNAL \
		-flow_control                                     false \
		-deficit_idle_count                               false \
		-speed                                            ether10000 \
		-data_path_mode                                   normal \
		-port_mode                                        LAN \
		-autonegotiation                                  1 \
		-ipv6_intf_addr                                   2000::01 \
		-ipv6_prefix_length								  120 \
		-ipv6_gateway									  2000::02 \
]

set status [keylget int_ret1 status]
if {$status == 0} {
	puts "run sth::interface_config failed"
	puts $int_ret1
} else {
	puts "***** run sth::interface_config successfully"
}

# set streamblock_ret1 [::sth::traffic_config  -l3_length_min 72 \
								# -ipv6_dst_mode increment \
								# -ipv6_src_count 1 \
								# -l3_length_max 9000 \
								# -length_mode fixed \
								# -rate_pps 90579 \
								# -ipv6_src_addr 2008:10:1::2 \
								# -mac_dst_mode fixed \
								# -l3_protocol ipv6 \
								# -ipv6_dst_addr ff07::1 \
								# -mac_dst 33.33.00.00.00.01 \
								# -mode create \
								# -transmit_mode continuous \
								# -pkts_per_burst 1000 \
								# -ipv6_dst_count 1 \
								# -mac_src 00.00.00.00.00.02 \
								# -port_handle $p1Hnd \
								# -ipv6_src_mode fixed \
								# -l3_length 120 \
								# -enable_stream 1 \
								# -enable_stream_only_gen 1]
								

set streamblock_ret1 [::sth::traffic_config  -l3_length_min 72 \
                                   -ipv6_dst_mode increment \
                                   -ipv6_src_count 1 \
                                   -l3_length_max 9000 \
                                   -length_mode fixed \
                                   -rate_pps 90579 \
                                   -ipv6_src_addr 2008:10:1::2 \
                                   -mac_dst_mode fixed \
                                   -l3_protocol ipv6 \
                                   -ipv6_dst_addr ff07::1 \
                                   -mac_dst 33.33.00.00.00.01 \
                                   -mode create \
                                   -transmit_mode continuous \
                                   -pkts_per_burst 1000 \
                                   -ipv6_dst_count 1 \
								   -ipv6_dst_step ::2 \
                                   -mac_src 00.00.00.00.00.02 \
                                   -port_handle port1 \
                                   -ipv6_src_mode fixed \
                                   -l3_length 120 \
                                   -enable_stream 0 \
                                   -enable_stream_only_gen 1]
								
set status [keylget streamblock_ret1 status]
if {$status == 0} {
	puts "run sth::traffic_config failed"
	puts $streamblock_ret1
} else {
	puts "***** run sth::traffic_config successfully"
}								
stc::perform saveasxml -FileName "D:/JTAPI/XML/traffic_config.xml"
stc::apply