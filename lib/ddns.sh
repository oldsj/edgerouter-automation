#!/bin/vbash
ddns_service=$1
ddns_host=$2
ddns_username=$3
ddns_password=$4
wan_port=$5

source /opt/vyatta/etc/functions/script-template

configure
delete service dns dynamic
commit
configure
set service dns dynamic interface $wan_port service $ddns_service host-name $ddns_host
set service dns dynamic interface $wan_port service $ddns_service login $ddns_username
set service dns dynamic interface $wan_port service $ddns_service password $ddns_password

commit
exit