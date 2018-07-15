from jinja2 import Environment, FileSystemLoader, Template
from paramiko import SSHClient, AutoAddPolicy

def createSSHClient(server, port, user, password):
    client = SSHClient()
    client.load_system_host_keys()
    client.set_missing_host_key_policy(AutoAddPolicy())
    client.connect(server, port, user, password)
    return client

def template_config(template_file, variables):
    ENV = Environment(loader=FileSystemLoader('./lib/config'))
    template = ENV.get_template(template_file)

    return template.stream(variables=variables)
