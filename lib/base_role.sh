#!/bin/vbash
wan_port=$1
source /opt/vyatta/etc/functions/script-template

configure
set interfaces ethernet $wan_port address dhcp
set interfaces ethernet $wan_port description "WAN1"

commit