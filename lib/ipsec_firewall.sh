#!/bin/vbash

export PATH=$PATH:/opt/vyatta/bin:/opt/vyatta/sbin
export vyatta_sbindir=/opt/vyatta/sbin
SHELL_API=/bin/cli-shell-api
CFG=/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper
DELETE=/opt/vyatta/sbin/my_delete
COMMIT=/opt/vyatta/sbin/my_commit
SAVE=/opt/vyatta/sbin/vyatta-save-config.pl
LOADKEY=/opt/vyatta/sbin/vyatta-load-user-key.pl

### Configuration
$CFG begin
$CFG set firewall name WAN_LOCAL rule 30 action accept
$CFG set firewall name WAN_LOCAL rule 30 description IKE
$CFG set firewall name WAN_LOCAL rule 30 destination port 500
$CFG set firewall name WAN_LOCAL rule 30 log disable
$CFG set firewall name WAN_LOCAL rule 30 protocol udp

$CFG set firewall name WAN_LOCAL rule 40 action accept
$CFG set firewall name WAN_LOCAL rule 40 description ESP
$CFG set firewall name WAN_LOCAL rule 40 log disable
$CFG set firewall name WAN_LOCAL rule 40 protocol esp

$CFG set firewall name WAN_LOCAL rule 50 action accept
$CFG set firewall name WAN_LOCAL rule 50 description NAT-T
$CFG set firewall name WAN_LOCAL rule 50 destination port 4500
$CFG set firewall name WAN_LOCAL rule 50 log disable
$CFG set firewall name WAN_LOCAL rule 50 protocol udp

$CFG set firewall name WAN_LOCAL rule 60 action accept
$CFG set firewall name WAN_LOCAL rule 60 description L2TP
$CFG set firewall name WAN_LOCAL rule 60 destination port 1701
$CFG set firewall name WAN_LOCAL rule 60 ipsec match-ipsec
$CFG set firewall name WAN_LOCAL rule 60 log disable
$CFG set firewall name WAN_LOCAL rule 60 protocol udp

$CFG commit
$CFG end