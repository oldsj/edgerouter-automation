#!/usr/bin/python3
import netmiko
from variables import *
import lib.base as base
import lib.bootstrap as bootstrap
import sys
import traceback

er_bootstrap = {
  'device_type':  'vyos',
  'ip':           '192.168.1.1',
  'username':     'ubnt',
  'password':     'ubnt',
  'keepalive':    2,
  'timeout':      2.0
}

er = {
  'device_type':  'vyos',
  'ip':           lan_ip,
  'username':     admin_username,
  'allow_agent':  "True",
  'keepalive':    2,
  'timeout':      2.0
}

try:
  net_connect = netmiko.ConnectHandler(**er)
  base.configure(net_connect)
  net_connect.disconnect()
  net_connect = netmiko.ConnectHandler(**er)
  base.firewall(net_connect)
  net_connect.disconnect()
  
  print("Finished, saving configuration to boot...")
  #net_connect.send_command("save")
except (netmiko.ssh_exception.NetMikoTimeoutException, 
  netmiko.ssh_exception.NetMikoAuthenticationException):

  try:
    # TODO: figure out why disconnect() is needed
    print("Default configuration detected. Bootstrapping...")

    net_connect = netmiko.ConnectHandler(**er_bootstrap)
    bootstrap.load_key(net_connect)
    net_connect.disconnect()

    net_connect = netmiko.ConnectHandler(**er_bootstrap)
    bootstrap.configure(net_connect)
    net_connect.disconnect()
    print("Bootstrap completed succesfully, update your NIC settings now if " + 
      "needed and re-run script.")

  except (netmiko.ssh_exception.NetMikoTimeoutException):
    print("Unable to boostrap, make sure it's pingable at 192.168.1.1 and in " +
      "the factory default state.")

  except KeyboardInterrupt:
    print("Exiting")

  except:
    print("Unexpected error:", sys.exc_info()[0])
    traceback.print_exc()

except KeyboardInterrupt:
  print("Exiting")

except:
  print("Unexpected error:", sys.exc_info()[0])
  traceback.print_exc()

