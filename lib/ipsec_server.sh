#!/bin/vbash
ipsec_username=$1
ipsec_user_pass=$2
ipsec_psk=$3
client_ip_pool_start=$4
client_ip_pool_stop=$5
wan_port=$6
lan_port=$7
mgmt_ip=$8

source /opt/vyatta/etc/functions/script-template

configure


#https://help.ubnt.com/hc/en-us/articles/204950294#2
delete vpn l2tp
delete vpn ipsec

#Configure the L2TP authentication
set vpn l2tp remote-access ipsec-settings authentication mode pre-shared-secret
set vpn l2tp remote-access ipsec-settings authentication pre-shared-secret $ipsec_psk
#Setup authentication
set vpn l2tp remote-access authentication mode local
set vpn l2tp remote-access authentication local-users username $ipsec_username password $ipsec_user_pass
#Set the VPN client IP pool
set vpn l2tp remote-access client-ip-pool start $client_ip_pool_start
set vpn l2tp remote-access client-ip-pool stop $client_ip_pool_stop
#Configure DNS for clients
set vpn l2tp remote-access dns-servers server-1 8.8.8.8
set service dns forwarding options listen-address=$mgmt_ip
set service dns forwarding cache-size 150
set service dns forwarding listen-on $lan_port
#Set the MTU
set vpn l2tp remote-access mtu 1400
#Configure the external IP
set vpn l2tp remote-access dhcp-interface $wan_port
set vpn ipsec ipsec-interfaces interface $wan_port

commit
exit