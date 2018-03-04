#!/bin/bash
source ./vars.sh

runRemote() {
    
    local args script host

    script=$1; shift

    # generate eval-safe quoted version of current argument list
    printf -v args '%q ' "$@"

    # pass that through on the command line to bash -s
    # note that $args is parsed remotely by /bin/sh, not by bash!
    ssh -q $username@$mgmt_ip "vbash -s -- $args" < "$script"
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