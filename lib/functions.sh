#!/bin/bash
source ./vars.sh

letsEncrypt() {
    echo Copying letsencrypt-edgemax to device
    scp -qpr ./lib/letsencrypt-edgemax/ $username@$mgmt_ip:/config
    echo "Configuring Let's Encrypt..."
    runRemote ./lib/letsencrypt.sh $fqdn
}
runAdminUserRole() {
    # Check if user is already created
    if ! $(runRemoteBootstrap ./lib/getuser.sh | grep -q $username); then
        # Copy SSH public key
        echo Copying SSH public key $ssh_public_key
        sshpass -p 'ubnt' scp -q ./$ssh_public_key ubnt@192.168.1.1:/tmp/
        runRemoteBootstrap ./lib/bootstrap.sh $username $password_hash $ssh_public_key
    else
        echo User $username already configured. Skipping...
    fi
}

runBootstrapRole() {
    # If 'show system login users' does not display the user
    # in $username then configure user
    if [ -z ${password_hash+x} ]; then 
        echo "var password_hash is unset";
        # Get admin password and store as hash
        echo "Enter password for user $username:" 
        password_hash=`mkpasswd -m sha-512`
    fi

    # Check if firmware needs upgrade
    echo Current Firmware $(runRemoteBootstrap ./lib/getver.sh | grep Version)
    # If 'show version' does not display the version in $firmware_file then upgrade
    _firmware_version=$(echo $firmware_file | grep -oP "v[0-9]+\.[0-9]+\.[0-9]+")
    if ! $(runRemoteBootstrap ./lib/getver.sh | grep -q $_firmware_version); then
        echo Uploading firmware file $firmware_file
        sshpass -p 'ubnt' scp -q ./$firmware_file ubnt@192.168.1.1:/tmp/
        echo Upgrading
        runRemoteBootstrap upgrade.sh $firmware_file
        # Sleep 120 seconds while device upgrades and reboots
        echo "Wait 120 seconds for reboot"
        sleep 120s
        echo Upgrade Complete
        echo New Firmware $(runRemoteBootstrap ./lib/getver.sh | grep Version)
    else
        echo Already on $(runRemoteBootstrap ./lib/getver.sh | grep Version) Skipping...
    fi

    runAdminUserRole
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