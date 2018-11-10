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

## Inventory
The list of hosts is in `/hosts`. This inventory file also lists the
individual SSH keys for each host. SSH keys should be placed in the `/keys` directory.

## Tasks
Tasks are partitioned by service into roles. These roles are organized according
to which service is deployed on which server in `/main.yml`. Each task has a set
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
`ssh` configuration with e.g.
```
$ ssh-add keys/storage.datapun.net.pem
```
Once this is done, the keys can be encrypted with `ansible-vault`
```
$ ansible-vault encrypt keys/main.datapun.net.pem
```
The keys can also be decrypted with `ansible-vault decrypt`.
