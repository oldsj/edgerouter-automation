#!/bin/bash
source ./vars.sh

runBaseRoleBootstrap() {
    if [ -z ${password_hash+x} ]; then 
        echo "var password_hash is unset";
        # Get admin password and store as hash
        echo "Enter password for user $admin_username:" 
        password_hash=$(mkpasswd -m sha-512)
    fi

    # Copy SSH public key
    ssh_public_key_name=$(basename $ssh_public_key)
    echo "    ***Copying SSH public key $ssh_public_key"
    sshpass -p 'ubnt' scp -q $ssh_public_key ubnt@192.168.1.1:/tmp/$ssh_public_key_name
    # Make key file writable by users group so later users can overwrite if needed
    sshpass -p 'ubnt' ssh -q ubnt@192.168.1.1 "sudo chmod 775 /tmp/er01.pub"
    echo "    ***Configuring admin user"
    runRemoteBootstrap ./lib/admin_user.sh $admin_username $password_hash $ssh_public_key_name >/dev/null
    echo "    ***Configuring firewall"
    runRemoteBootstrap ./lib/firewall.sh $wan_port >/dev/null
    echo "    ***Configuring base role"
    runRemoteBootstrap ./lib/base.sh $hostname $domain $wan_port $lan_port $lan_ip $lan_net $lan_mask $lan_dhcp_start $lan_dhcp_stop $ext_dns1 $ext_dns2 >/dev/null
}

runBaseRole() {
    if [ -z ${password_hash+x} ]; then 
        echo "var password_hash is unset";
        # Get admin password and store as hash
        echo "Enter password for user $admin_username:" 
        password_hash=$(mkpasswd -m sha-512)
    fi

    # Copy SSH public key
    ssh_public_key_name=$(basename $ssh_public_key)
    echo "    ***Copying SSH public key $ssh_public_key"
    scp -q $ssh_public_key $admin_username@$lan_ip:/tmp/$ssh_public_key_name
    # Make key file writable by users group so later users can overwrite if needed
    ssh -q $admin_username@$lan_ip "sudo chmod 775 /tmp/er01.pub"
    echo "    ***Configuring admin user"
    runRemote ./lib/admin_user.sh $admin_username $password_hash $ssh_public_key_name >/dev/null
    echo "    ***Configuring firewall"
    runRemote ./lib/firewall.sh $wan_port >/dev/null
    echo "    ***Configuring base role"
    runRemote ./lib/base.sh $hostname $domain $wan_port $lan_port $lan_ip $lan_net $lan_mask $lan_dhcp_start $lan_dhcp_stop $ext_dns1 $ext_dns2 >/dev/null
}

runUpgradeFirmwareRole() {
    # If 'show version' does not display the version in $firmware_file then upgrade
    full_firmware_path='files/'$firmware_file
    new_firmware_ver=$(echo $firmware_file | grep -oP "v[0-9]+\.[0-9]+\.[0-9]+")
    if ! $(runRemote ./lib/getver.sh | grep -q $new_firmware_ver); then
        echo "    ***Uploading firmware file $firmware_file"
        scp -q $full_firmware_path $admin_username@$lan_ip:/tmp/
        echo "    ***Upgrading..."
        runRemote ./lib/upgrade_firmware.sh $firmware_file
        echo "    ***Upgrade Complete"
    else
        echo "    ***Already on Version $(runRemote ./lib/getver.sh | grep -oP "v[0-9]+\.[0-9]+\.[0-9]+") Skipping..."
    fi
}

runLetsEncryptRole() {
    echo "    ***Copying letsencrypt scripts to device..."
    # First create /config/.acme.sh directory
    ssh -q $admin_username@$lan_ip "mkdir -p /config/.acme.sh"
    ssh -q $admin_username@$lan_ip "sudo chown -R root:root /config/.acme.sh"
    ssh -q $admin_username@$lan_ip "sudo chmod -R 755 /config/.acme.sh"
    # Copy lib/letsencrypt scripts 
    scp -q ./lib/letsencrypt/{acme.sh,renew.acme.sh} $admin_username@$lan_ip:/tmp/
    runRemote ./lib/letsencrypt/prep.sh
        # Copy modified ubnt-gen-lighty-conf.sh
        #scp -q ./lib/letsencrypt/ubnt-gen-lighty-conf.sh $admin_username@$lan_ip:/config/ubnt-gen-lighty-conf.sh
    # Fix permissions
        #ssh -q $admin_username@$lan_ip "sudo mv /config/ubnt-gen-lighty-conf.sh /usr/sbin/ubnt-gen-lighty-conf.sh"
   
        #ssh -q $admin_username@$lan_ip "sudo chown root:root /usr/sbin/ubnt-gen-lighty-conf.sh"
        #ssh -q $admin_username@$lan_ip "sudo chmod 755 /usr/sbin/ubnt-gen-lighty-conf.sh"

    echo "    ***Configuring Let's Encrypt..."
    ssh -q $admin_username@$lan_ip "sudo /config/scripts/renew.acme.sh -d $hostname.$domain"
    runRemote ./lib/letsencrypt.sh $hostname.$domain $lan_ip
}

runRemote() {
    
    local args script

    script=$1; shift

    # generate eval-safe quoted version of current argument list
    printf -v args '%q ' "$@"

    # pass that through on the command line to bash -s
    # note that $args is parsed remotely by /bin/vbash, not by bash!
    ssh -q $admin_username@$lan_ip "vbash -s -- $args" < "$script"
}

runRemoteBootstrap() {
    local args script

    script=$1; shift

    # generate eval-safe quoted version of current argument list
    printf -v args '%q ' "$@"

    # pass that through on the command line to bash -s
    # note that $args is parsed remotely by /bin/vbash, not by bash!
    sshpass -p 'ubnt' ssh -q ubnt@192.168.1.1 "vbash -s -- $args" < "$script"
}