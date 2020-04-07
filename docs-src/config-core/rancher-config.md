# Admin cluster and Rancher server configuration

The playbooks deploy an admin cluster and a separate user cluster. The user cluster
is deployed from the Rancher server installed on the admin cluster and the configuration for the user cluster is
documented [here](rancher-user-config).


The nodes in the admin cluster are determined by the
entries in the `hosts` file and are provisioned by the playbooks based on the configuration in this section.

Rancher configuration is specified using the `rancher` dictionary element in the `group_vars/all/vars.yml` file:


|Variable|File|Description|
|:-------|:---|:----------|
|`rancher.url`|group_vars/all/vars.yml|FQDN at which Rancher Server can be reached|
|`rancher.hostname`|group_vars/all/vars.yml|Usually the same FQDN as the one in `rancher.url` but not necessarily|
|`rancher.validate_certs`|group_vars/all/vars.yml|`False`|
|`rancher.apiversion`|group_vars/all/vars.yml|Playbooks designed for v3 of the API|
|`rancher.engineInstallURL`|group_vars/all/vars.yml|Location of script for installing Docker on all node templates|


An example `rancher` structure is shown below:

```
rancher:
  url: https://lb1.hpe.org
  hostname: lb1.hpe.org
  validate_certs: False
  apiversion: v3
  engineInstallURL: 'https://releases.rancher.com/install-docker/19.03.sh'
```

General configuration variables are shown in the table below:

|Variable|File|Description|
|:-------|:---|:----------|
|`cluster_name`|group_vars/all/vars.yml|Name of the K8S admin cluster|
|`user_folder`|group_vars/all/vars.yml|Folder and pool name for the user cluster VMs|
|`admin_folder`|group_vars/all/vars.yml|Folder and pool name for Rancher admin cluster VMs and templates|
|`admin_template`|group_vars/all/vars.yml|Name for the admin template|


