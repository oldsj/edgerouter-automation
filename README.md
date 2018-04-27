EdgeRouter Automation is a set of bash scripts to automate provisioning and the deployment of common features of Ubiquity's EdgeRouter X routers.

I chose write it in pure bash vs using a proper configuration management tool like Ansible or SaltStack because I didn't want to require any third party tool setup, and also wanted to learn a bit more bash.

Being pure bash, all it takes to run it is to ./run.sh on any platform that has bash installed (that includes you too now Windows10).
It aims to be idempotent, being able to be ran more than once against the same router without error or misconfiguration. 

This project is targeted at advanced home users who want to automate their home network configuration and be able to store it's state in a git repository.
As such, speed is not a primary goal of the project. It's not meant to configure 1000's or even 100's of devices. For that I would check out SaltStack, napalm-salt and [napalm-vyos](https://github.com/napalm-automation-community/napalm-vyos) to manage a fleet of EdgeRouters.

# Getting started
* Fork and clone the repository locally.
* Go to https://www.ubnt.com/download/edgemax to get the latest firmware and place it in
the files folder.
* Copy examples/vars.sh to the root of the folder along side run.sh. The .gitignore ignores /vars.sh so that you can place private information there without it getting stored in git.

## Configuration
All configuration is located centrally in vars.sh. It is organized by roles like Ansible, so if you do not wish to configure a top level role like dynamic DNS (ddns), just comment out ddns_role=.

The example vars.sh as written will configure an administrator with a name of 'oldsj', a password of 'test' (hashed as SHA-512), configure SSH login with the provided public key, and set the hostname to er01, domain to example.com. Eth4 is configured as the WAN port as a DHCP client, eth0 is a single LAN port configured as a DHCP server. Static  DHCP reservations are resolvable in DNS as well as the router's hostname, all under the configured domain variable. 
NAT is configured to masquerade to $wan_port.
Hardware offloading is enabled for NAT and IPsec.
The firmware will be upgraded to ER-e50.v1.10.1.5067582.
Dynamic DNS will be configured to update DNS-O-Matic with you WAN IP.
LetsEncrypt will issue a valid certificate for your routers admin page.
IPSec will not run because it is commented out, but is configured to run correctly if ipsec_server_role= is uncommented.

### base_role 
Use mkpasswd to hash your password as SHA-512 to store in the vars.sh password_hash=.
If you do not want to store your hashed password in vars.sh, comment out #password_hash and the script will ask for the password on STDIN.
```bash
mkpasswd -m sha-512
```

Generate an ssh key using

``` bash
ssh keygen
```

Load the newly generated key in ssh-agent. If you do not, you will be asked for the admin's password multiple times throughout the script.
Replace $ssh_private_key with the name of the key you want to use (id_rsa) by default.
```bash
ssh-agent bash
ssh-add $ssh_private_key
```

Configure the management IP wan/lan ports, hostname and domain name. The hostname and domain name set here are also referenced from other roles like letsencrypt to issue certificates.

If you change the lan variables from the default of 192.168.1.1/24, you will break your connection to the router and need to update the interface on the PC with the new network address.
Just update your settings and re-run ./run.sh

### upgrade_firmware_role
Place the firmware you'd like to run in /files and configure the firmware_files variable with the firmware file's full name.

This role can also be used to downgrade the firmware, however this script hasn't been tested work with any version other than v1.10.0.5056246.

### admin_user_role


### ddns_role
Make sure dynamic DNS is configured with your domain provider first.

Compatible services are:

dnspark, dyndns, namecheap, zoneedit, dslreports, easydns, sitelutions, afraid (as of OS Version 1.3)

Configure your ddns provider's credentials. For Namecheap, ddns_host is your subdomain, ddns_username is the root domain, and ddns_password is generated in your ddns settings at Namecheap, it is not your Namecheap login credentials.

### lets_encrypt_role
This role uses https://github.com/j-c-m/ubnt-letsencrypt to 
To use the letsencrypt role, be sure to have a DNS entry to the EdgeRouter's public IP. The dynamic DNS role is configured to run before letsencrypt to be sure DNS works for those with a dynamic WAN IP.

If you get a ":Verify error:DNS problem: NXDOMAIN..." error your DNS might still be propagating throughout DNS. See if when you ping your configured FQDN, it resolves to a public IP. If not you'll need to wait.

### ipsec_server_role
This role configures the router as an IPsec VPN server so that you can connect back to your home network from anywhere. Most devices have built in IPsec clients so you won't even have to download an app.
The VPN server will be available publicly at the routers FQDN configured in base_role.

Configure the IPsec credentials you would like for clients to use to authenticate to the server. Be sure to use a strong ipsec_psk and ipsec_user_pass as it's the only thing stopping someone on the internet from gaining access to your LAN and is brute-forcible.

client_ip_pool_start and stop covers the range of IP addresses that will be handed out to clients.

## Running
Connect the EdgeRouter port eth0 to a port on your PC statically configured with an IP like 192.168.1.10/24

Make sure your PC isn't connected to any other 192.168.1.0/24 network.

If you run base_role and chose to configure a subnet and management IP other than default, you will need to update your PC's network adapter settings.

Once the script has run, be sure to reboot the router if this is the first run to load the new firmware and enable hardware offloading.

### Linux / macOS / WSL
```bash
cd edgerouter-automation
chmod +x run.sh
./run.sh
```
