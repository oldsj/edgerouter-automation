from lib.functions import createSSHClient
from scp import SCPClient

def install_wireguard(net_connect, variables):
  wireguard_deb = variables['wireguard_deb']

  dest = f"/tmp/{wireguard_deb}"

  ssh = createSSHClient(variables['device_ip'])
  scp = SCPClient(ssh.get_transport())

  print(f'Transferring Wireguard deb pkg {wireguard_deb}...')
  scp.put(f'files/{wireguard_deb}', dest)

  config_commands = [
    f"sudo dpkg -i /tmp/{wireguard_deb}"
  ]

  print("Installing Wireguard...")
  print(net_connect.send_config_set(config_commands))

def configure(net_connect, variables):
    config_commands = [

  ]