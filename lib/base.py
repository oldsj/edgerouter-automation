from variables import *

def configure(net_connect):

  config_commands = [
    # delete the default ubnt user now that we're bootstrapped
    f'delete system login user ubnt',

    f'set interfaces ethernet {wan_port} address dhcp',
    f'set interfaces ethernet {wan_port} description "WAN1"',


    f'set system host-name {hostname}',
    f'set system domain-name {domain}',

    f'set system name-server 127.0.0.1',
    f'set service dns forwarding name-server {ext_dns1}',
    f'set service dns forwarding name-server {ext_dns2}',
    f'set service dns forwarding listen-on switch0',
    f'set service dns forwarding cache-size 400',
    f'set service dns forwarding system',

    f'set system static-host-mapping host-name {hostname} inet {lan_ip}',

    f'set system offload hwnat enable',
    f'set system offload ipsec enable'
  ]

  config_commands.append('commit')
  print("Configuring base settings...")
  print(net_connect.send_config_set(config_commands))

def firewall(net_connect):
  config_commands = [
    f'set firewall name WAN_IN default-action drop',
    f'set firewall name WAN_IN description "WAN to internal"',
    f'set firewall name WAN_IN rule 10 action accept',
    f'set firewall name WAN_IN rule 10 description "Allow established/related"',
    f'set firewall name WAN_IN rule 10 state established enable',
    f'set firewall name WAN_IN rule 10 state related enable',
    f'set firewall name WAN_IN rule 20 action drop',
    f'set firewall name WAN_IN rule 20 description "Drop invalid state"',
    f'set firewall name WAN_IN rule 20 state invalid enable',

    f'set firewall name WAN_LOCAL default-action drop',
    f'set firewall name WAN_LOCAL description "WAN to router"',
    f'set firewall name WAN_LOCAL rule 10 action accept',
    f'set firewall name WAN_LOCAL rule 10 description "Allow established/related"',
    f'set firewall name WAN_LOCAL rule 10 state established enable',
    f'set firewall name WAN_LOCAL rule 10 state related enable',
    f'set firewall name WAN_LOCAL rule 20 action drop',
    f'set firewall name WAN_LOCAL rule 20 description "Drop invalid state"',
    f'set firewall name WAN_LOCAL rule 20 state invalid enable',

    f'set interfaces ethernet {wan_port} firewall in name WAN_IN',
    f'set interfaces ethernet {wan_port} firewall local name WAN_LOCAL',

    f'set service nat rule 5000 outbound-interface {wan_port}',
    f'set service nat rule 5000 type masquerade'
  ]
  
  config_commands.append('commit')
  
  print("Configuring firewall...")
  print(net_connect.send_config_set(config_commands))
  
