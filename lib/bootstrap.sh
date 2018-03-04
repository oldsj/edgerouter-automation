#!/bin/vbash
username=$1
password_hash=$2
ssh_public_key=$3

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

$SET system login user $username authentication encrypted-password $password_hash
$SET system login user $username level admin

# Writing ssh private ket to the config
#$LOADKEY vyatta /tmp/my-key
if [ -e /tmp/$ssh_public_key ]; then
    echo "Loading key for user $username"
    $LOADKEY $username /tmp/$ssh_public_key
fi

$COMMIT
$SAVE

#Tear down the session
$SHELL_API teardownSession
  if [ $? -ne 0 ]; then
    echo "An error occured while tearing down the session!"
    exit 0
  fi