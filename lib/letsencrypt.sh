#!/bin/vbash
fqdn=$1
mgmt_ip=$2

export PATH=$PATH:/opt/vyatta/bin:/opt/vyatta/sbin
export vyatta_sbindir=/opt/vyatta/sbin
SHELL_API=/bin/cli-shell-api
SET=/opt/vyatta/sbin/my_set
DELETE=/opt/vyatta/sbin/my_delete
COMMIT=/opt/vyatta/sbin/my_commit
SAVE=/opt/vyatta/sbin/vyatta-save-config.pl
LOADKEY=/opt/vyatta/sbin/vyatta-load-user-key.pl

### Setup config session
session_env=$($SHELL_API getSessionEnv $PPID)
  if [ $? -ne 0 ]; then
    echo "An error occured while configuring session environment!"
    exit 0
  fi
eval $session_env
$SHELL_API setupSession
  if [ $? -ne 0 ]; then
    echo "An error occured while setting up the configuration session!"
    exit 0
  fi

### Configuration
sudo mv /tmp/acme.sh /config/.acme.sh/acme.sh
sudo mv /tmp/renew.acme.sh /config/scripts/renew.acme.sh
sudo chmod 755 /config/.acme.sh/acme.sh /config/scripts/renew.acme.sh
sudo chown -R root:root /config/.acme.sh /config/scripts/renew.acme.sh
sudo chmod -R 755 /config/.acme.sh /config/scripts/renew.acme.sh

$SET system static-host-mapping host-name $fqdn inet $mgmt_ip
$SET service gui cert-file /config/ssl/server.pem
$SET service gui ca-file /config/ssl/ca.pem
$SET system task-scheduler task renew.acme executable path /config/scripts/renew.acme.sh
$SET system task-scheduler task renew.acme interval 1d
$SET system task-scheduler task renew.acme executable arguments "-d $fqdn"

$COMMIT

# Regenerate the lighttpd configuration and restart it to reflect our patches
  #echo Regenerating lighttpd configuration files...
  #sudo vbash /usr/sbin/ubnt-gen-lighty-conf.sh

### Tear down the session
$SHELL_API teardownSession
  if [ $? -ne 0 ]; then
    echo "An error occured while tearing down the session!"
    exit 0
  fi