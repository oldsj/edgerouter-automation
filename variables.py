from pathlib import Path

# Base
admin_username = 'jamesolds'
#password_hash is generated by mkpasswd -m sha-512
password_hash='$6$afWdFcagDiQI.$F9J2vdc7dzjFQrpSj32R6zt9LhsrHa.2S3aY0Qlp0un0WDRKEZI.PWH7Q5leuJnjA0BJMGuuoQaJQA/PndsyK0'
ssh_public_key = 'er01.pub'
hostname='er01'
domain = 'oldsmail.com'
wan_port = 'eth4' # DHCP client
lan_ports = ['eth0', 'eth1', 'eth2']
wlan_ports = ['eth3']
lan_ip = '192.168.3.1'
lan_net = '192.168.3.0'
lan_mask = '/24'
lan_dhcp_start = '192.168.3.21'
lan_dhcp_stop = '192.168.3.250'
ext_dns1 = '208.67.222.222'
ext_dns2 = '208.67.220.220'

# Upgrade firmware
firmware_file = 'ER-e50.v1.10.1.5067582.tar'