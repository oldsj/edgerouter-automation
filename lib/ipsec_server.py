def configure(net_connect, variables):
  config_commands = [
    f"set firewall name WAN_LOCAL rule 30 action accept",
    f"set firewall name WAN_LOCAL rule 30 description ike",
    f"set firewall name WAN_LOCAL rule 30 destination port 500",
    f"set firewall name WAN_LOCAL rule 30 log disable",
    f"set firewall name WAN_LOCAL rule 30 protocol udp",
    f"set firewall name WAN_LOCAL rule 40 action accept",
    f"set firewall name WAN_LOCAL rule 40 description esp",
    f"set firewall name WAN_LOCAL rule 40 log disable",
    f"set firewall name WAN_LOCAL rule 40 protocol esp",
    f"set firewall name WAN_LOCAL rule 50 action accept",
    f"set firewall name WAN_LOCAL rule 50 description nat-t",
    f"set firewall name WAN_LOCAL rule 50 destination port 4500",
    f"set firewall name WAN_LOCAL rule 50 log disable",
    f"set firewall name WAN_LOCAL rule 50 protocol udp",
    f"set firewall name WAN_LOCAL rule 60 action accept",
    f"set firewall name WAN_LOCAL rule 60 description l2tp",
    f"set firewall name WAN_LOCAL rule 60 destination port 1701",
    f"set firewall name WAN_LOCAL rule 60 ipsec match-ipsec",
    f"set firewall name WAN_LOCAL rule 60 log disable",
    f"set firewall name WAN_LOCAL rule 60 protocol udp",
    f"set vpn l2tp remote-access ipsec-settings authentication mode pre-shared-secret",
    f"set vpn l2tp remote-access ipsec-settings authentication pre-shared-secret {variables['ipsec_psk']}",
    f"set vpn l2tp remote-access authentication mode local",
    f"set vpn l2tp remote-access authentication local-users username {variables['ipsec_username']} password {variables['ipsec_user_pass']}",
    f"set vpn l2tp remote-access client-ip-pool start {variables['client_ip_pool_start']}",
    f"set vpn l2tp remote-access client-ip-pool stop {variables['client_ip_pool_stop']}",
    f"set vpn l2tp remote-access dns-servers server-1 {variables['ext_dns1']}",
    f"set vpn l2tp remote-access dns-servers server-2 {variables['ext_dns2']}",
    f"set vpn l2tp remote-access mtu 1400",
    f"set vpn l2tp remote-access dhcp-interface {variables['wan_port']}",
    f"set vpn ipsec ipsec-interfaces interface {variables['wan_port']}",
  ]

  config_commands.append("commit")
  print("Configuring IPSec server settings...")
  print(net_connect.send_config_set(config_commands))
