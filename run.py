#!/usr/bin/python3
import netmiko
import sys
import traceback
import yaml
from jinja2 import Environment, FileSystemLoader, Template

ENV = Environment(loader=FileSystemLoader('./config'))

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
  '#ip':           variables.get('lan_ip'),
  'username':     variables.get('admin_username'),
  'allow_agent':  "True",
  'keepalive':    2,
  'timeout':      2.0
}


base = ENV.get_template("base.j2")

print (type(base))

# try:
#   net_connect = netmiko.ConnectHandler(**er)
#   base.configure(net_connect)
#   net_connect.disconnect()
#   net_connect = netmiko.ConnectHandler(**er)
#   base.firewall(net_connect)
#   net_connect.disconnect()
  
#   print("Finished, saving configuration to boot...")
#   #net_connect.send_command("save")

# # Connecting with **er will fail on first run, except clause will bootstrap 
# except (netmiko.ssh_exception.NetMikoTimeoutException, 
#   netmiko.ssh_exception.NetMikoAuthenticationException):

#   try:
#     # TODO: figure out why disconnect() is needed
#     print("Default configuration detected. Bootstrapping...")

#     with open('config/bootstrap.j2') as file_:
#       template = Template(file_.read())
#     template.render(name='John')
  
#     print("Bootstrap completed succesfully, update your NIC settings now if " + 
#       "needed and re-run script.")

  
#   except (netmiko.ssh_exception.NetMikoTimeoutException, 
#     netmiko.ssh_exception.NetMikoAuthenticationException)
#     print("Unable to boostrap, make sure it's pingable at 192.168.1.1 and in " +
#       "the factory default state.")

#   except KeyboardInterrupt:
#     print("Exiting")

#   except:
#     print("Unexpected error:", sys.exc_info()[0])
#     traceback.print_exc()

# except KeyboardInterrupt:
#   print("Exiting")

# except:
#   print("Unexpected error:", sys.exc_info()[0])
#   traceback.print_exc()

