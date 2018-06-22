from paramiko import SSHClient, AutoAddPolicy
from scp import SCPClient
import os

with open("variables.yml") as variables:
    variables =  yaml.load(variables)

def createSSHClient(server, port, user, password):
    client = SSHClient()
    client.load_system_host_keys()
    client.set_missing_host_key_policy(AutoAddPolicy())
    client.connect(server, port, user, password)
    return client

def load_key(net_connect):
  home = os.path.expanduser("~")
  ssh_public_key_path = os.path.join(home, '.ssh', variables.get('ssh_public_key')

  dest = f'/tmp/{variables.get('ssh_public_key')}'
  ssh = createSSHClient('192.168.1.1', '22', 'ubnt', 'ubnt')
  scp = SCPClient(ssh.get_transport())

  print('Transferring SSH public key...')
  scp.put(ssh_public_key_path, dest)

  load_key_commands = [
    f'set system login user {variables.get('admin_username')} authentication encrypted-password {variables.get('password_hash')}',
    f'set system login user {variables.get('admin_username')} level admin',
    f'commit',
    f'loadkey {variables.get('admin_username')} /tmp/{variables.get('ssh_public_key')}'
  ]
  
  print(f"Loading SSH key for {variables.get('admin_username')}...")
  print(net_connect.send_config_set(load_key_commands))

def configure(net_connect):

  config_commands = [
    f'set interfaces switch switch0 address {variables.get('lan_ip')}{variables.get('lan_mask')}',
    f'set interfaces switch switch0 description "LAN1"',
    f'delete interfaces ethernet eth0 address',

    f'set service dhcp-server shared-network-name LAN subnet {variables.get('lan_net')}{variables.get('lan_mask')} domain-name {variables.get('domain'}',
    f'set service dhcp-server shared-network-name LAN subnet {variables.get('lan_net')}{variables.get('lan_mask')} default-router {variables.get('lan_ip')}',
    f'set service dhcp-server shared-network-name LAN subnet {variables.get('lan_net')}{variables.get('lan_mask')} dns-server {variables.get('lan_ip')}',
    f'set service dhcp-server shared-network-name LAN subnet {variables.get('lan_net')}{variables.get('lan_mask')} start {variables.get('lan_dhcp_start')} stop {variables.get('lan_dhcp_stop')}',
    f'set service dhcp-server dynamic-dns-update enable true'
  ]

  for interface in variables.get('lan_ports'):
    config_commands.append(f'set interfaces switch switch0 switch-port interface {interface}')
  
  config_commands.append('commit')
  print("Configuring LAN network...")
  print(net_connect.send_config_set(config_commands))
