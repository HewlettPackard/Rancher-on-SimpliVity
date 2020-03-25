# VMware configuration

All variables related to VMware configuration are described in the table below.

|Variable|File|Description|
|:-------|:---|:----------|
|`vcenter_hostname`|group_vars/all/vars.yml|IP or hostname of the vCenter appliance. For example, `vcentergen10.am2.cloudra.local`|
|`vcenter_username`|group_vars/all/vars.yml|Username to log in to the vCenter appliance. It might include a domain, for example, '`Administrator@vsphere.local`'|
|`vault_vcenter_password`|**group_vars/all/vault.yml**|The password for the `vcenter_username` user, stored in the vault|
|`vcenter_password`|group_vars/all/vars.yml|Use the value of the `{{ vault_vcenter_password }}` variable from the vault|
|`vcenter_cluster`|group_vars/all/vars.yml|Name of your SimpliVity Cluster. For example `Rancher`|
|`vm_dvswitch`|group_vars/all/vars.yml|Distributed Virtual Switch containing `vm_portgroup`|
|`vm_portgroup`|group_vars/all/vars.yml|Portgroup that the VMs connect to|
|`datacenter`|group_vars/all/vars.yml|Name of the datacenter where the environment will be provisioned. For example, `DEVOPS`|
|`datastore`|group_vars/all/vars.yml|The datastore for storing VMs. For example, 'Rancher_HPE'|
|`datastore_size`|group_vars/all/vars.yml|Size in GiB of the above datastore|



**Note:** The `vcenter_password` variable de-references the `vault_vcenter_password` which is stored in the vault.

For more information on datastore configuration, see the section [SimpliVity Configuration](simplivity-config).