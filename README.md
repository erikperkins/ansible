# Ansible
## Setup
Docker requires some programs to be installed on the remote hosts in order to
run. At a minimum, a server must have Python - AWS Ubuntu 16.04 images do not
have Python installed by default. The `/setup.yml` playbook handles the
installation of Python and other required packages, and must be run on a fresh
AWS host before any other task is performed
```
$ ansible-playbook -i hosts setup.yml
```

## Proxy
Only `main.datapun.net` accepts incoming connections from the internet; other
hosts are confined to an Amazon Virtual Private Cloud. In order for Ansible
to access these hosts, `main.datapun.net` must be used as a proxy. The local
SSH daemon must be configured to do this; the necessary configuration can be
found in `ssh/config`. The ssh configuration contains aliases for the IP
addresses on the private network.

To access servers on the private network, use ssh local port forwarding. Ports
from each service running on each server are bound locally via `ssh/config`.
```
$ ssh -fN storage.datapun.net
```
The `-f` flag starts the ssh tunnel in the background; the sockets are stored
in `~/.ssh/sockets/` according to `ssh/config`. To stop the tunnel, do
```
$ ssh -S ~/.ssh/sockets/ubuntu@main.datapun.net -O exit main.datapun.net
```

## Inventory
The list of hosts is in `hosts/`. Additional parameters for each host are kept
in `host_vars`. Encrypted SSH keys are kept in the `ssh/keys/` directory.

## Tasks
Tasks are partitioned by service into roles. These roles are organized according
to which service is deployed on which server in `main.yml`. Each task has a set
of tags of the form `task-role`. To perform a particular task on a particular
service, e.g. deploying the Nginx configuration, do
```
$ ansible-playbook -i hosts -t configure-nginx main.yml
```

## Vault
Uncomment the following line to `/etc/ansible/ansible.cfg` to automatically load
the vault password from the plaintext file `.ansible_vault`
```
vault_password_file = ~/.ansible/vault
```
Edit encrypted vault files with
```
$ ansible-vault edit secrets.yml
```
If the location of the vault password file has not been specified in
`ansible.cfg`, use the `--vault-password-file=/path/to/password/file` flag with
`ansible-vault`.

Unencrypted `.pem` files for remote hosts must be manually added to the local
`ssh` configuration, ensuring that the keys have the proper permissions
```
$ chmod 600 keys/storage.datapun.net.pem
```
Copy the unencrypted `.pem` files to the local ~/.ssh, and for each remote host,
add the following to `~/.ssh/config`
```
Host main.datapun.net
  ForwardAgent yes
  User ubuntu
  IdentityFile ~/.ssh/main.datapun.net.pem
```
This will make the keys available to `ssh-agent` across local reboots. Once
this is done, the keys can be encrypted with `ansible-vault`
```
$ ansible-vault encrypt keys/main.datapun.net.pem
```
The keys can later be decrypted with `ansible-vault decrypt`.

## AWS CloudWatch Logging
The "Push AWS credentials" task in `setup.yml` will inject AWS credentials required for the AWS log driver into each host. Note that the credentials are kept encrypted with `ansible-vault`, and must be decrypted temporarily to push to each host.
