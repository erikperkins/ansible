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
