#!/bin/vbash
ddns_service=$1
ddns_username=$2
ddns_password=$3
wan_port=$4

ddns_host='all.dnsomatic.com'

source /opt/vyatta/etc/functions/script-template

configure
delete service dns dynamic

set service dns dynamic interface $wan_port service $ddns_service host-name $ddns_host
set service dns dynamic interface $wan_port service $ddns_service login $ddns_username
set service dns dynamic interface $wan_port service $ddns_service password $ddns_password
set service dns dynamic interface $wan_port service $ddns_service server updates.dnsomatic.com

commit
exit