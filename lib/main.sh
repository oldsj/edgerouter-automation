#!/bin/vbash

ubnt_password=$1;

main.sh $ubnt_password

source /opt/vyatta/etc/functions/script-template
configure

set service ssh disable-password-authentication

set interfaces ethernet eth0 address '192.168.1.1/24'
set interfaces ethernet 'eth1'
set interfaces ethernet 'eth2'
set interfaces ethernet 'eth3'
set interfaces ethernet 'eth4'
set interfaces ethernet 'eth5'
set interfaces loopback 'lo'
set interfaces switch 'switch0'
set service 'gui'
set service 'ssh'
set system login user jamesolds authentication encrypted-password
set system login user jamesolds authentication plaintext-password ''
set system login user ubnt authentication encrypted-password '$1$zKNoUbAo$gomzUbYvgyUMcD436Wo66.'
set system login user ubnt level 'admin'
set system ntp server '0.ubnt.pool.ntp.org'
set system ntp server '1.ubnt.pool.ntp.org'
set system ntp server '2.ubnt.pool.ntp.org'
set system ntp server '3.ubnt.pool.ntp.org'
set system syslog global facility all level 'notice'
set system syslog global facility protocols level 'debug'

commit
#save
exit