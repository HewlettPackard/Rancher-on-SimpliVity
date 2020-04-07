# Prerequisites

Before you attempt to run the playbooks to deploy the solution, make sure that you have fulfil the requirements:

- Configure variables in `group_vars/all/vars.yml`
- Configure sensitive variables in `group_vars/all/vault.yml`
- Configure `hosts`
- Make sure the Rancher URL (specified using the `rancher.url` variable) resolves to the IP address of the load balancer you configured in the hosts inventory. Instructions for configuring the DNS are specific to your DNS implementation and are not provided here.

To assist in setting up the configuration, the solution provides a playbook `playbooks/pre-checks.yml`
to perform a pre-deployment validation. This optional playbook is described in the following section.