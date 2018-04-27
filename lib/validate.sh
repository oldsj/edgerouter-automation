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
if ! [ -z $base_role+x} ]; then 
    if [ -z ${admin_username+x} ]; then 
        echo "var admin_username is unset";
        exit 1;
    elif [ -z ${ssh_private_key+x} ]; then 
        echo "var ssh_private_key is unset";
        exit 1;
    elif [ -z ${ssh_public_key+x} ]; then 
        echo "var ssh_public_key is unset";
        exit 1;
    elif [ -z ${hostname+x} ]; then
        echo "var hostname is unset";
        exit 1;
    elif [ -z ${domain+x} ]; then 
        echo "var domain is unset";
        exit 1;
    elif [ -z ${wan_port+x} ]; then 
        echo "var wan_port is unset";
        exit 1;
    elif [ -z ${lan_port+x} ]; then 
        echo "var lan_port is unset";
        exit 1;
    elif [ -z ${lan_ip+x} ]; then 
        echo "var lan_ip is unset";
        exit 1;
    elif [ -z ${lan_net+x} ]; then 
        echo "var lan_net is unset";
        exit 1;
    elif [ -z ${lan_mask+x} ]; then 
        echo "var lan_mask is unset";
        exit 1;
    elif [ -z ${lan_dhcp_start+x} ]; then 
        echo "var lan_dhcp_start is unset";
        exit 1;
    elif [ -z ${lan_dhcp_stop+x} ]; then 
        echo "var lan_dhcp_stop is unset";
        exit 1;
    elif [ -z ${ext_dns1+x} ]; then 
        echo "var ext_dns1 is unset";
        exit 1;
    elif [ -z ${ext_dns2+x} ]; then 
        echo "var ext_dns2 is unset";
        exit 1;
    fi
fi

if ! [ -z ${upgrade_firmware_role+x} ]; then 
    if [ -z ${firmware_file+x} ]; then 
        echo "var firmware_file is unset";
        exit 1;

    fi
fi

if ! [ -z ${ddns_role+x} ]; then
    if [ -z ${ddns_service+x} ]; then 
        echo "var ddns_service is unset";
        exit 1;
    else
        if [ "$ddns_service" = "dyndns" ]; then 
            if [ -z ${ddns_username+x} ]; then 
                echo "var ddns_username is unset";
                exit 1;
            elif [ -z ${ddns_password+x} ]; then 
                echo "var ddns_password is unset";
                exit 1;
            fi
        else 
            if [ -z ${ddns_host+x} ]; then 
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
    fi

fi