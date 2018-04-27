#!/bin/vbash
hostname=$1
domain=$2
wan_port=$3
lan_port=$4
lan_ip=$5
lan_net=$6
lan_mask=$7
lan_dhcp_start=$8
lan_dhcp_stop=$9
ext_dns1=${10}
ext_dns2=${11}

source /opt/vyatta/etc/functions/script-template

configure
set interfaces ethernet $wan_port address dhcp
set interfaces ethernet $wan_port description "WAN1"
set interfaces ethernet $lan_port address $lan_ip$lan_mask
set interfaces ethernet $lan_port description "LAN1"

set system host-name $hostname
set system domain-name $domain

set system name-server 127.0.0.1
set service dns forwarding name-server $ext_dns1
set service dns forwarding name-server $ext_dns2
set service dns forwarding listen-on $lan_port
set service dns forwarding cache-size 400
set service dns forwarding system

set system static-host-mapping host-name $hostname inet $lan_ip

delete system static-host-mapping host-name $hostname inet 127.0.1.1
delete service dns forwarding listen-on $wan_port
delete service dns forwarding options listen-address=

set service dhcp-server shared-network-name LAN subnet $lan_net$lan_mask domain-name $domain
set service dhcp-server shared-network-name LAN subnet $lan_net$lan_mask default-router $lan_ip
set service dhcp-server shared-network-name LAN subnet $lan_net$lan_mask dns-server $lan_ip
set service dhcp-server shared-network-name LAN subnet $lan_net$lan_mask start $lan_dhcp_start stop $lan_dhcp_stop
set service dhcp-server dynamic-dns-update enable true

set service nat rule 5000 outbound-interface $wan_port
set service nat rule 5000 type masquerade

set system offload hwnat enable
set system offload ipsec enable

commit