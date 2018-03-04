#!/bin/vbash
firmware_file=$1

PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
source /opt/vyatta/etc/functions/script-template
source /etc/bash_completion.d/vyatta-cfg
source /etc/bash_completion.d/vyatta-op

add system image /tmp/$firmware_file
sudo /sbin/shutdown -r now