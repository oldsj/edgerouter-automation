#!/bin/bash
source ./lib/validate.sh
source ./lib/functions.sh

# Execute roles if enabled in vars.sh
if [ -z ${base_role+x} ]; then
    echo "ERROR: base_role must be set, exiting."
else
    if $(sshpass -p 'ubnt' ssh -q -oStrictHostKeyChecking=no ubnt@192.168.1.1 "exit"); then
        echo "***Default configuration detected, running boostrap base role"
        runBaseRoleBootstrap
        echo "    ***Removing default ubnt user"
        runRemote ./lib/remove_ubnt_user.sh
    elif $(sshpass -p 'ubnt' ssh -q -oStrictHostKeyChecking=no ubnt@$lan_ip "exit"); then
        echo "    ***Removing default ubnt user"
        runRemote ./lib/remove_ubnt_user.sh
    else
        echo "***Running base role..."
        # accept new host key if lan_ip changed
        ssh -q -oStrictHostKeyChecking=no $admin_username@$lan_ip "exit"
        runBaseRole
    fi
fi
if ! [ -z ${upgrade_firmware_role+x} ]; then
    echo ***Running upgrade firmware role...
    runUpgradeFirmwareRole
fi
if ! [ -z ${ddns_role+x} ]; then 
    echo ***Running ddns role...
    if [ "$ddns_service" = "dyndns" ]; then 
            runRemote ./lib/ddns_dyndns.sh $ddns_service $ddns_username $ddns_password $wan_port >/dev/null
    else
            runRemote ./lib/ddns.sh $ddns_service $ddns_host $ddns_username $ddns_password $wan_port >/dev/null
    fi
fi 
if ! [ -z ${letsencrypt_role+x} ]; then 
    echo "***Running Let's Encrypt role..."
    runLetsEncryptRole 
fi 
if ! [ -z ${ipsec_server_role+x} ]; then 
    echo "***Running IPSec server role..."
    runRemote ./lib/ipsec_server.sh $ipsec_username $ipsec_user_pass $ipsec_psk $client_ip_pool_start $client_ip_pool_stop $wan_port $lan_port $mgmt_ip >/dev/null
    runRemote ./lib/ipsec_firewall.sh >/dev/null
fi 

# Save the configuration changes
runRemote ./lib/save.sh