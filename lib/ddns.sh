#!/bin/bash
source /opt/vyatta/etc/functions/script-template

dyndnsservice=$1
host=$2
username=$3
password=$4
wan_port=$5

configure
set service dns dynamic interface eth0 service <dyndnsservice> host-name <host>
set service dns dynamic interface eth0 service <dyndnsservice> login <username>
set service dns dynamic interface eth0 service <dyndnsservice> password <password>
commit
save
exit