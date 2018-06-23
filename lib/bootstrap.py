from lib.functions import template_config

from paramiko import SSHClient, AutoAddPolicy
from scp import SCPClient
import os
import yaml

def createSSHClient(server, port, user, password):
    client = SSHClient()
    client.load_system_host_keys()
    client.set_missing_host_key_policy(AutoAddPolicy())
    client.connect(server, port, user, password)
    return client

def load_key(net_connect, variables):
  ssh_public_key = variables['ssh_public_key']
  admin_username = variables['admin_username']  

  home = os.path.expanduser("~")
  ssh_public_key_path = os.path.join(home, '.ssh', ssh_public_key)

  dest = f'/tmp/{ssh_public_key}'
  ssh = createSSHClient('192.168.1.1', '22', 'ubnt', 'ubnt')
  scp = SCPClient(ssh.get_transport())

  print('Transferring SSH public key...')
  scp.put(ssh_public_key_path, dest)

  print(f"Loading SSH key for {admin_username}...")
  net_connect.send_config_set(template_config('load_key.j2', variables))
  net_connect.send_config_set('commit')

def configure(net_connect, variables):
  print("Configuring LAN network...")
  net_connect.send_config_set(template_config('bootstrap.j2', variables))
  net_connect.send_config_set('commit')