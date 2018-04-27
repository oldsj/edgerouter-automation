#!/bin/vbash
wan_port=$1
lan_port=$2

source /opt/vyatta/etc/functions/script-template

configure 

edit firewall name allow-est-drop-inv
set default-action drop
set enable-default-log
set rule 1 action accept
set rule 1 state established enable
set rule 1 state related enable
set rule 2 action drop
set rule 2 log enable
set rule 2 state invalid enable
top

edit firewall
copy name allow-est-drop-inv to name allow-all
set name allow-all default-action accept
delete name allow-all enable-default-log
top

edit firewall
copy name allow-est-drop-inv to name lan-local
edit name lan-local
set rule 100 action accept
set rule 100 protocol icmp
set rule 200 description "Allow HTTP/HTTPS"
set rule 200 action accept
set rule 200 destination port 80,443
set rule 200 protocol tcp
set rule 600 description "Allow DNS"
set rule 600 action accept
set rule 600 destination port 53
set rule 600 protocol tcp_udp
set rule 700 description "Allow DHCP"
set rule 700 action accept
set rule 700 destination port 67,68
set rule 700 protocol udp
set rule 800 description "Allow SSH"
set rule 800 action accept
set rule 800 destination port 22
set rule 800 protocol tcp
top

# Local
edit zone-policy zone local
set default-action drop
set local-zone
set from WAN firewall name allow-est-drop-inv
set from LAN firewall name lan-local
top

# LAN
edit zone-policy zone LAN
set default-action drop
set interface $lan_port
set from WAN firewall name allow-est-drop-inv
set from LOCAL firewall name allow-est-drop-inv
top

# WAN
edit zone-policy zone WAN
set default-action drop
set interface $wan_port
set from LAN firewall name allow-all
set from LOCAL firewall name allow-all
top

delete firewall name WAN_IN
delete firewall name WAN_LOCAL

commit
