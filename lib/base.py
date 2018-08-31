def configure(net_connect, variables):

  config_commands = [
    f"set system host-name {variables['hostname']}",
    f"set system domain-name {variables['domain']}",
    f"set system name-server 127.0.0.1",
    f"set service dhcp-server shared-network-name LAN subnet {variables['lan_net']} domain-name {variables['domain']}",
    f"set service dhcp-server shared-network-name LAN subnet {variables['lan_net']} static-mapping {variables['hostname']} ip-address {variables['device_ip']}",
    f"set service dhcp-server shared-network-name LAN subnet {variables['lan_net']} static-mapping {variables['hostname']} mac-address 00:00:00:00:00:00",
    f"set service dhcp-server use-dnsmasq enable",
    f"set system offload hwnat enable"
  ]

  config_commands.append("commit")
  print("Configuring base settings...")
  print(net_connect.send_config_set(config_commands))
