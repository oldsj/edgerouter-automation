#!/bin/bash
source ./vars.sh

runLetsEncryptRole() {
    echo Copying letsencrypt scripts to device...
    # First create /config/.acme.sh directory
    ssh -q $username@$mgmt_ip "mkdir -p /config/.acme.sh"
    ssh -q $username@$mgmt_ip "sudo chown -R root:root /config/.acme.sh"
    ssh -q $username@$mgmt_ip "sudo chmod -R 755 /config/.acme.sh"
    # Copy lib/letsencrypt scripts 
    scp -q ./lib/letsencrypt/{acme.sh,renew.acme.sh} $username@$mgmt_ip:/tmp/
        # Copy modified ubnt-gen-lighty-conf.sh
        #scp -q ./lib/letsencrypt/ubnt-gen-lighty-conf.sh $username@$mgmt_ip:/config/ubnt-gen-lighty-conf.sh
    # Fix permissions
        #ssh -q $username@$mgmt_ip "sudo mv /config/ubnt-gen-lighty-conf.sh /usr/sbin/ubnt-gen-lighty-conf.sh"
   
        #ssh -q $username@$mgmt_ip "sudo chown root:root /usr/sbin/ubnt-gen-lighty-conf.sh"
        #ssh -q $username@$mgmt_ip "sudo chmod 755 /usr/sbin/ubnt-gen-lighty-conf.sh"

    echo "Configuring Let's Encrypt..."
    runRemote ./lib/letsencrypt.sh $hostname.$domain $mgmt_ip >/dev/null

    ssh -q $username@$mgmt_ip "sudo /config/scripts/renew.acme.sh -d $hostname.$domain"
}
runAdminUserRole() {
    ssh_public_key_name=$(basename $ssh_public_key)
    if [ -z ${password_hash+x} ]; then 
        echo "var password_hash is unset";
        # Get admin password and store as hash
        echo "Enter password for user $username:" 
        password_hash=`mkpasswd -m sha-512`
    fi

    # Copy SSH public key
    echo Copying SSH public key $ssh_public_key
    sshpass -p 'ubnt' scp -q $ssh_public_key ubnt@192.168.1.1:/tmp/$ssh_public_key_name
    runRemoteBootstrap ./lib/admin_user.sh $username $password_hash $ssh_public_key_name >/dev/null
}

runUpgradeFirmwareRole() {

    # Check if firmware needs upgrade
    echo Current Firmware $(runRemoteBootstrap ./lib/getver.sh | grep Version)
    firmware_file_name=$firmware_file
    # If 'show version' does not display the version in $firmware_file then upgrade
    _firmware_version=$(echo $firmware_file_name | grep -oP "v[0-9]+\.[0-9]+\.[0-9]+")
    if ! $(runRemoteBootstrap ./lib/getver.sh | grep -q $_firmware_version); then
        echo Uploading firmware file $firmware_file_name
        sshpass -p 'ubnt' scp -q ./$firmware_file_name ubnt@192.168.1.1:/tmp/
        echo Upgrading...
        runRemoteBootstrap ./lib/upgrade.sh $firmware_file_name
        # Sleep 120 seconds while device upgrades and reboots
        echo "Wait 120 seconds for reboot"
        sleep 120s
        echo Upgrade Complete
        echo New Firmware $(runRemoteBootstrap ./lib/getver.sh | grep Version)
    else
        echo Already on $(runRemoteBootstrap ./lib/getver.sh | grep Version) Skipping...
    fi
}

runRemote() {
    
    local args script host

    script=$1; shift

    # generate eval-safe quoted version of current argument list
    printf -v args '%q ' "$@"

    # pass that through on the command line to bash -s
    # note that $args is parsed remotely by /bin/sh, not by bash!
    ssh -q $username@$mgmt_ip "vbash -s -- $args" < "$script"
}

runRemoteSudo() {
    
    local args script host

    script=$1; shift

    # generate eval-safe quoted version of current argument list
    printf -v args '%q ' "$@"

    # pass that through on the command line to bash -s
    # note that $args is parsed remotely by /bin/sh, not by bash!
    ssh -q $username@$mgmt_ip "sudo vbash -s -- $args" < "$script"
}

runRemoteBootstrap() {

    local args script

    script=$1; shift

    # generate eval-safe quoted version of current argument list
    printf -v args '%q ' "$@"

    # pass that through on the command line to bash -s
    # note that $args is parsed remotely by /bin/sh, not by bash!
    sshpass -p 'ubnt' ssh -q ubnt@192.168.1.1 "vbash -s -- $args" < "$script"
}