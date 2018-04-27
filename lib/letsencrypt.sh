#!/bin/vbash
fqdn=$1
mgmt_ip=$2

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

$CFG set system static-host-mapping host-name $fqdn inet $mgmt_ip
$CFG set service gui cert-file /config/ssl/server.pem
$CFG set service gui ca-file /config/ssl/ca.pem
$CFG set system task-scheduler task renew.acme executable path /config/scripts/renew.acme.sh
$CFG set system task-scheduler task renew.acme interval 1d
$CFG set system task-scheduler task renew.acme executable arguments "-d $fqdn"

$CFG commit
$CFG end

# Regenerate the lighttpd configuration and restart it to reflect our patches
  #echo Regenerating lighttpd configuration files...
  #sudo vbash /usr/sbin/ubnt-gen-lighty-conf.sh

