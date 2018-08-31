def configure(net_connect, variables):

  config_commands = [

  ]

  config_commands.append("commit")
  print("Configuring wireguard client...")
  print(net_connect.send_config_set(config_commands))
