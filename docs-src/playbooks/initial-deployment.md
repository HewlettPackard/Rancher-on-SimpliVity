# Initial cluster deployment

## Prerequisites

Before you attempt to run the playbooks to deploy the solution, make sure that you have fulfil the requirements:

- Configure variables in `group_vars/all/vars`
- Configure sensitive variables in `group_vars/all/vault`
- Configure `hosts`
- Make sure the Rancher URL (specified using the `rancher.url` variable) resolves to the IP address of the load balancer you configured in the hosts inventory. Instructions for configuring the DNS are specific to your DNS implementation and are not provided here.


## Pre-deployment validation

You can validate configuration parameters via the `playbooks/pre-checks.yml` playbook.
The playbook attempts to verify that the configuration parameters defined in the `group_vars/all/vars.yml` and
`group_vars/all/vault.yml` files contain appropriate values. It validates access to the vCenter instance hosting the
HPE SimpliVity cluster and verifies the requested `datacenter` and `vm_portgroup` exist. It checks that the
configured DNS and NTP servers are valid. It also attempts to ensure the hostnames and IP addresses that will be used
when creating the RKE admin cluster (defined in the `hosts.yml` file) are not already being used
elsewhere in the environment.

```
$ cd ~/Rancher-on-SimpliVity
$ ansible-playbook -i hosts playbooks/pre-checks.yml
```

## Download required software

Once you have satisfied the prerequisites and configured all of the variables to match your environment,
prepare the staging area by running the `playbooks/getkits.yml` to download the kits:

```
$ cd ~/Rancher-on-SimpliVity
# ansible-playbook -i hosts playbooks/getkits.yml
```

## Deploy Rancher

Run the
playbook `site.yml` to perform the initial cluster deployment:

```
$ cd ~/Rancher-on-SimpliVity
$ ansible-playbook -i hosts site.yml --vault-password-file .vault_pass
```


