#!/bin/vbash
lan_net=$1
lan_mask=$2

source /opt/vyatta/etc/functions/script-template

configure

set service dhcp-server shared-network-name LAN subnet $lan_net$lan_mask static-mapping james-pc mac-address 00:E0:4C:30:DC:03
set service dhcp-server shared-network-name LAN subnet $lan_net$lan_mask static-mapping james-pc ip-address 192.168.1.100

commit