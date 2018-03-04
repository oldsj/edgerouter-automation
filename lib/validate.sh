#!/bin/bash
vars=./vars.sh

command -v sshpass >/dev/null 2>&1 || { 
    echo >&2 "sshpass required but not installed"; 
    exit 1;
}
command -v sshpass >/dev/null 2>&1 || { 
    echo >&2 "mkpasswd required but not installed"; 
    exit 1;
}

if [ ! -f "$vars" ]; then
   echo Variables file \"vars\" missing;
   exit 1;
fi

source $vars

if [ -z ${username+x} ]; then 
    echo "var username is unset";
    exit 1;
elif [ -z ${ssh_public_key+x} ]; then 
    echo "var ssh_public_key is unset";
    exit 1;
elif [ -z ${ssh_private_key+x} ]; then 
    echo "var ssh_private_key is unset";
    exit 1;
elif [ -z ${hostname+x} ]; then 
    echo "var hostname is unset";
    exit 1;
elif [ -z ${firmware_file+x} ]; then 
    echo "var firmware_file is unset";
    exit 1;
elif [ -z ${mgmt_ip+x} ]; then 
    echo "var mgmt is unset";
    exit 1;
fi