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

if [ -z ${hostname+x} ]; then 
    echo "var hostname is unset";
    exit 1;
elif [ -z ${mgmt_ip+x} ]; then 
    echo "var mgmt is unset";
    exit 1;
elif [ -z ${wan_port+x} ]; then 
    echo "var wan_port is unset";
    exit 1;
elif [ -z ${username+x} ]; then 
    echo "var username is unset";
    exit 1;
elif [ -z ${fqdn+x} ]; then 
    echo "var fqdn is unset";
    exit 1;
fi

if ! [ -z ${bootstrap_role+x} ]; then 
    if [ -z ${firmware_file+x} ]; then 
        echo "var firmware_file is unset";
        exit 1;
    elif [ -z ${ssh_private_key+x} ]; then 
        echo "var ssh_private_key is unset";
        exit 1;
    elif [ -z ${ssh_public_key+x} ]; then 
        echo "var ssh_public_key is unset";
        exit 1;
    fi
fi

if ! [ -z ${ddns_role+x} ]; then
    if [ -z ${ddns_service+x} ]; then 
        echo "var ddns_service is unset";
        exit 1;
    elif [ -z ${ddns_host+x} ]; then 
        echo "var ddns_host is unset";
        exit 1;
    elif [ -z ${ddns_username+x} ]; then 
        echo "var ddns_username is unset";
        exit 1;
    elif [ -z ${ddns_password+x} ]; then 
        echo "var ddns_password is unset";
        exit 1;
    fi
fi

if ! [ -z ${letsencrypt_role+x} ]; then
    echo lets enc
fi