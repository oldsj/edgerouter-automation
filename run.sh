#!/bin/bash
source ./lib/validate.sh
source ./lib/functions.sh

# Execute roles if enabled in vars.sh
if ! [ -z ${base_role+x} ]; then
    echo ***Running base role...
    runRemote ./lib/base_role.sh $wan_port >/dev/null
fi
if ! [ -z ${upgrade_firmware_role+x} ]; then
    echo ***Running upgrade firmware role...
    runUpgradeFirmwareRole $firmware_file
fi
if ! [ -z ${admin_user_role+x} ]; then
    echo ***Running admin user role...
    runAdminUserRole $username $password_hash $ssh_public_key
fi
if ! [ -z ${ddns_role+x} ]; then 
    echo ***Running ddns role...
    runRemote ./lib/ddns.sh $ddns_service $ddns_host $ddns_username $ddns_password $wan_port >/dev/null
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