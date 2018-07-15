from lib.functions import template_config, createSSHClient

from scp import SCPClient
import re
import time

def upgrade_firmware(net_connect, variables):
  firmware_file = variables['firmware_file']

  current_ver = re.search(r"v[0-9]+\.[0-9]+\.[0-9]+", 
                net_connect.send_command('show version')).group(0)
  
  new_ver = re.search(r"v[0-9]+\.[0-9]+\.[0-9]+", 
            firmware_file).group(0)

  if(current_ver == new_ver):
    print(f'Router already running version {new_ver}')
    print("Skipping.")

  else:
    dest = f'/tmp/{firmware_file}'
    ip = net_connect.ip
    port = net_connect.port
    user = net_connect.username
    password = net_connect.password

    ssh = createSSHClient(ip, port, user, password)
    scp = SCPClient(ssh.get_transport())

    print(f'Transferring firmware {firmware_file}...')
    scp.put(f'firmware/{firmware_file}', dest)

    #TODO this doesn't work yet
    print(f'Installing firmware...')
    net_connect.send_command(f'add system image /tmp/{firmware_file}\n',
                                    delay_factor=10)

    net_connect.send_command("reboot\n")

    print("Firmware loaded succesfully, reload router now.")