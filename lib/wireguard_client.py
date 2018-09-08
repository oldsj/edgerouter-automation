from lib.functions import createSSHClient
from scp import SCPClient

def install_wireguard(net_connect, variables):
  wireguard_deb = variables['wireguard_deb']

  ssh = createSSHClient(variables['device_ip'])
  scp = SCPClient(ssh.get_transport())

  print(f'Transferring Wireguard deb pkg {wireguard_deb}...')
  dest = f"/tmp/{wireguard_deb}"
  scp.put(f'files/{wireguard_deb}', dest)

  config_commands = [
    f"sudo dpkg -i /tmp/{wireguard_deb}"
  ]

  print("Installing Wireguard...")
  print(net_connect.send_config_set(config_commands))

def configure(net_connect, variables):
  key_commands = [
      "umask 077",
      "wg genkey | tee /config/auth/wg_privatekey | wg pubkey > /config/auth/wg_publickey",
      "cat /config/auth/wg_publickey"
  ]

  config_commands = [
      f"set interfaces wireguard wg0 address {variables['client_private_ip']}",
      f"set interfaces wireguard wg0 listen-port 51820",
      f"set interfaces wireguard wg0 peer {variables['server_publickey']} allowed-ips 0.0.0.0/0",
      f"set interfaces wireguard wg0 peer {variables['server_publickey']} endpoint {variables['server_endpoint']}:51820",
      f"set interfaces wireguard wg0 peer {variables['server_publickey']} persistent-keepalive 25",
      f"set interfaces wireguard wg0 private-key /config/auth/wg_privatekey",
      f"set interfaces wireguard wg0 route-allowed-ips false",
      f"set protocols static interface-route {variables['server_endpoint']}/32 next-hop-interface eth0",
      f"set protocols static interface-route 0.0.0.0/0 next-hop-interface wg0",
  ]

  print("Configuring Wireguard client...")
  config_commands.append("commit")
  print(net_connect.send_config_set(config_commands))