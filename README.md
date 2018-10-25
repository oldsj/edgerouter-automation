A set of Ansible roles to configure a Ubiquity EdgeRouter X series.

# Run the playbook
Comitting configurations can take extra time on certain edgerouter models so ANSIBLE_PERSISTENT_COMMAND_TIMEOUT needs to be set to 30 seconds to not timeout while configuring the aws tunnels. I'm using ansible-vault to encrypt hosts.yml, so I keep the decrypt password in a file at ~/.vault_pw and run ansible-playbook with --vault-password-file.

```
ANSIBLE_PERSISTENT_COMMAND_TIMEOUT=30 ansible-playbook playbook.yml -i hosts.yml --vault-password-file ~/.vault_pw
```