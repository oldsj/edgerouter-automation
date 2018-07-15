import lib.functions as functions
import lib.bootstrap as bootstrap
import lib.upgrade_firmware as upgrade_firmware

import yaml
import netmiko
import sys
import traceback

with open("variables.yml") as variables:
    variables =  yaml.load(variables)

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
  'ip':           variables['lan_ip'],
  'username':     variables['admin_username'],
  'allow_agent':  "True",
  'keepalive':    2,
  'timeout':      2.0
}

try:
  net_connect = netmiko.ConnectHandler(**er)

  net_connect.send_command(functions.template_config('base.j2', variables))
    
  print("Finished, saving configuration to boot...")
  #net_connect.send_command("save")

# Connecting with **er will fail on first run, except clause will bootstrap 
except (netmiko.ssh_exception.NetMikoTimeoutException, 
  netmiko.ssh_exception.NetMikoAuthenticationException):

  # Try again with default user/pass and IP
  try:
    net_connect = netmiko.ConnectHandler(**er_bootstrap)

    print("Default configuration detected. Bootstrapping...")
    
    print("Upgrading firmware.")
    upgrade_firmware.upgrade_firmware(net_connect, variables)

    # print("Loading SSH Key.")
    # bootstrap.load_key(net_connect, variables)
    # print("Loading base LAN config")
    # bootstrap.configure(net_connect, variables)

    print("Bootstrap completed succesfully, update your NIC settings now if " + 
      "needed and re-run script.")

  
  except (netmiko.ssh_exception.NetMikoTimeoutException, 
    netmiko.ssh_exception.NetMikoAuthenticationException):
    print("Unable to boostrap, make sure the router is pingable at 192.168.1.1 and in " +
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
