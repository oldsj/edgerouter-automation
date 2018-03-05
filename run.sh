#!/bin/bash
source ./lib/validate.sh
source ./lib/functions.sh

echo Configuring WAN
runRemote ./lib/configureWan.sh $wan_port

# Execute if bootstrap_role= role is enabled in roles.sh
if ! [ -z ${bootstrap_role+x} ]; then
    echo Running bootstrap role
    runBootstrapRole
fi
if ! [ -z ${ddns_role+x} ]; then 
    echo Running ddns role
    runRemote ./lib/ddns.sh $ddns_service $ddns_host $ddns_username $ddns_password $wan_port
fi 
if ! [ -z ${letsencrypt_role+x} ]; then 
    echo "Running Let's Encrypt role"
    letsEncrypt
fi 
# Commit and save the configuration changes
runRemote ./lib/save.sh