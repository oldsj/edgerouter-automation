from lib.functions import *
import lib.base as base
import lib.wireguard_client as wireguard_client
import lib.ipsec_server as ipsec_server

import yaml
import netmiko
import sys
import traceback

with open("variables.yml") as variables:
    variables =  yaml.load(variables)

er = {
  'device_type':  'vyos',
  'ip':           variables['device_ip'],
  'username':     variables['admin_username'],
  'allow_agent':  "True",
  'keepalive':    2,
  'timeout':      2.0,
  'verbose':      "True",
}

try:
  net_connect = netmiko.ConnectHandler(**er)

  #base.configure(net_connect, variables)
  #wireguard_client.install_wireguard(net_connect, variables)
  #wireguard_client.configure(net_connect, variables)
  ipsec_server.configure(net_connect, variables)

  print("Finished, saving configuration to boot...")
  #print(net_connect.send_config_set(["save"]))

except (netmiko.ssh_exception.NetMikoTimeoutException, 
  netmiko.ssh_exception.NetMikoAuthenticationException):
  print(f"Unable to connect to EdgeRouter at {variables['admin_username']}@{variables['device_ip']}")
except KeyboardInterrupt:
  print("Exiting")
except:
  print("Unexpected error:", sys.exc_info()[0])
  traceback.print_exc()
