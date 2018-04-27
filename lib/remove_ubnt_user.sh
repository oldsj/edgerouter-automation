#!/bin/vbash
source /opt/vyatta/etc/functions/script-template

configure
delete system login user ubnt
commit