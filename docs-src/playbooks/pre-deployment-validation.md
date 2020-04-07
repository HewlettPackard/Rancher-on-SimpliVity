# Pre-deployment validation

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


The playbook performs the following checks:

- Test reachability to vCenter host
- Verify vCenter credentials
- Verify existence of datacenter
- Verify existence of portgroup
- Verify IP addresses for RKE admin cluster are not in use
- Verify DNS server(s)
- Verify NTP server(s)