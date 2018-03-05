#!/bin/vbash
fqdn=$1

export PATH=$PATH:/opt/vyatta/bin:/opt/vyatta/sbin
export vyatta_sbindir=/opt/vyatta/sbin
SHELL_API=/bin/cli-shell-api
SET=/opt/vyatta/sbin/my_set
DELETE=/opt/vyatta/sbin/my_delete
COMMIT=/opt/vyatta/sbin/my_commit
SAVE=/opt/vyatta/sbin/vyatta-save-config.pl
LOADKEY=/opt/vyatta/sbin/vyatta-load-user-key.pl

#Setup config session
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

# Check if patch is installed, install if not adding needed Debian repositories
command -v patch >/dev/null 2>&1 || { 
    $SET system package repository wheezy components 'main contrib'
    $SET system package repository wheezy distribution wheezy 
    $SET system package repository wheezy url http://http.us.debian.org/debian
    $COMMIT
    sudo apt-get -y update
    sudo apt-get -y install patch
}

sudo vbash /config/letsencrypt-edgemax/install.sh -t $fqdn
#Tear down the session
$SHELL_API teardownSession
  if [ $? -ne 0 ]; then
    echo "An error occured while tearing down the session!"
    exit 0
  fi

