#!/bin/vbash
wan_port=$1

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
$CFG set firewall name WAN_IN default-action drop
$CFG set firewall name WAN_IN description 'WAN to internal'
 
$CFG set firewall name WAN_IN rule 10 action accept
$CFG set firewall name WAN_IN rule 10 description 'Allow established/related'
$CFG set firewall name WAN_IN rule 10 state established enable
$CFG set firewall name WAN_IN rule 10 state related enable
 
$CFG set firewall name WAN_IN rule 20 action drop
$CFG set firewall name WAN_IN rule 20 description 'Drop invalid state'
$CFG set firewall name WAN_IN rule 20 state invalid enable

$CFG set firewall name WAN_LOCAL default-action drop
$CFG set firewall name WAN_LOCAL description 'WAN to router'
 
$CFG set firewall name WAN_LOCAL rule 10 action accept
$CFG set firewall name WAN_LOCAL rule 10 description 'Allow established/related'
$CFG set firewall name WAN_LOCAL rule 10 state established enable
$CFG set firewall name WAN_LOCAL rule 10 state related enable

$CFG set firewall name WAN_LOCAL rule 20 action drop
$CFG set firewall name WAN_LOCAL rule 20 description 'Drop invalid state'
$CFG set firewall name WAN_LOCAL rule 20 state invalid enable

$CFG set interfaces ethernet $wan_port firewall in name WAN_IN
$CFG set interfaces ethernet $wan_port firewall local name WAN_LOCAL

$CFG commit
$CFG end

