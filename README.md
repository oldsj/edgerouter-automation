An ansible playbook and supporting Terraform code to create an AWS VPC with a VPN Gateway to a Ubiquity Edgerouter.

# Terraform
Run terraform first to build the AWS infrastructure, and to get outputs of the tunnel configuration to use as inputs to Ansible to configure the edgerouter side.

## Set variables
Configuration of terraform can be provided either on standard input (terraform will ask you to input the variables on the cli) or by setting environment variables.

```
export TF_VAR_customer_gateway_ip=75.55.241.162
export TF_VAR_customer_gateway_lan=192.168.2.0/24
export TF_VAR_customer_gateway_asn=65000
```

## VPC

```
cd terraform/dev/vpc
terraform init
terraform plan
terraform apply
```

## EC2

```
cd terraform/dev/ec2
terraform init
terraform plan
terraform apply
```

Take the outputs printed to screen from the above commands or run `terraform output` to get the tunnel configuration and ec2 private IP address and add it to ansible/hosts.yml.

# Ansible
All configuration happens in ansible/hosts.yml. I am using ansible-vault to encrypt this file since it has some sensitive data in it. If you'd like to do so as well, simply `ansible-vault encrypt ansible/hosts.yml` An example hosts.yml is provided in ansible/examples/hosts.yml.

All tunnel configuration was taken from `terraform output` of terraform/dev/vpc

hosts.yml
```yaml
all:
  hosts:
    er01:
      ansible_connection: network_cli
      ansible_host: 192.168.1.1
      ansible_network_os: edgeos
      wan_interface: "eth0"
      wan_ip: "75.55.241.162"

      tunnel1_address: "34.202.178.183"
      tunnel1_bgp_asn: "64512"
      tunnel1_bgp_holdtime: "30"
      tunnel1_cgw_inside_address: "169.254.45.202"
      tunnel1_preshared_key: "NQ..oqmc14mykx63bRp0p079jTnvKrH."
      tunnel1_vgw_inside_address: "169.254.45.201"
      tunnel2_address: "54.174.66.142"
      tunnel2_bgp_asn: "64512"
      tunnel2_bgp_holdtime: "30"
      tunnel2_cgw_inside_address: "169.254.45.134"
      tunnel2_preshared_key: "YsZA_l74zY6Z5cY9vC14wBQlzI2LFlPx"
      tunnel2_vgw_inside_address: "169.254.45.133"
```

## Run playbook
Comitting configurations can take extra time on certain edgerouter models so ANSIBLE_PERSISTENT_COMMAND_TIMEOUT needs to be set to 30 seconds to not timeout while configuring the aws tunnels. I'm using ansible-vault to encrypt hosts.yml, so I keep the decrypt password in a file at ~/.vault_pw and run ansible-playbook with --vault-password-file.

```
ANSIBLE_PERSISTENT_COMMAND_TIMEOUT=30 ansible-playbook playbook.yml -i hosts.yml --vault-password-file ~/.vault_pw
```

# See if it works
It may take a while but your tunnels and bgp adjacency should be up! Verify with

```
show vpn ipsec sa
show ip bgp
```