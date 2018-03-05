
Go to https://www.ubnt.com/download/edgemax to get the latest firmware

Use mkpasswd to hash your password as sha-512 to store in vars.sh password_hash variable.
If you do not, the script will ask for the password on STDIN and use mkpasswd to hash.
mkpasswd -m sha-512
ssh keygen
- load the new key in ssh-agent. If you do not, you will be asked for the admin's password multiple times throughout the script
 ssh-agent bash
  ssh-add $ssh_private_key

To use the letsencrypt role, be sure to have a DNS entry to the EdgeRouter's public IP. The dynamic DNS role is configured to run before letsencrypt to be sure DNS works for those with a dynamic WAN IP

