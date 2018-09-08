from paramiko import SSHClient, AutoAddPolicy

def createSSHClient(server):
    client = SSHClient()
    client.load_system_host_keys()
    client.set_missing_host_key_policy(AutoAddPolicy())
    client.connect(server)
    return client
