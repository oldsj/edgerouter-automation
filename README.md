
Go to https://www.ubnt.com/download/edgemax to get the latest firmware

Use mkpasswd to hash your password as sha-512 to store in vars.sh password_hash variable.
If you do not, the script will ask for the password on STDIN and use mkpasswd to hash.
mkpasswd -m sha-512
ssh keygen
- load the new key in ssh-agent. If you do not, you will be asked for the admin's password multiple times throughout the script
 ssh-agent bash
  ssh-add $ssh_private_key

To use the letsencrypt role, be sure to have a DNS entry to the EdgeRouter's public IP. The dynamic DNS role is configured to run before letsencrypt to be sure DNS works for those with a dynamic WAN IP.
Make sure dynamic DNS is configured with your domain provider first.

If you get a ":Verify error:DNS problem: NXDOMAIN..." error your DNS might still be propogating throughout DNS. See if you can ping your ddns domain.

Upgrade firmware role can also be used to downgrade, however this script isn't guaranteed to work with any version other than v1.10.0.5056246

# Getting started
Copy examples/vars.sh to the root of the folder along side run.sh. Vars.sh is organized by "roles" like Ansible, so for example if you do not wish to configure dynamic DNS (ddns) at all, just comment out the non-indented line of ddns_role and none of the steps will run.

Modify vars.sh with you information and then run ./run.sh