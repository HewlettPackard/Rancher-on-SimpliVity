# Networking configuration

The variables used for network configuration include:

|Variable|File|Description|
|:-------|:---|:----------|
|`rancher_subnet`|group_vars/all/vars.yml|The scope of IP addresses which you can use on the Rancher VLAN|
|`vm_portgroup`|group_vars/all/vars.yml|The Rancher VLAN is a vCenter portgroup in your virtual infrastructure which connects all the virtual machines that this solution deploys|
|`gateway`|group_vars/all/vars.yml|Gateway for the Rancher VLAN. For example, `'10.15.155.1'`|
|`ntp_servers`|group_vars/all/vars.yml|List of NTP servers to be used, in list format. For example, `['1.2.3.4','0.us.pool.net.org'...]`|
|`dns_servers`|group_vars/all/vars.yml|List of DNS servers to be used, in list format. For example, `['10.10.173.1','10.10.173.2'...]`<br><br>The DNS services deployed by the solution forwards unresolved requests to these DNS servers.|
|`dns_suffixes`|group_vars/all/vars.yml|List of DNS suffixes|




## DHCP related settings

The variables used to configure the DHCP service on a support VM include:

|Variable|File|Description|
|:-------|:---|:----------|
|`dhcp_subnet`|group_vars/all/vars.yml|Subnet used by the playbooks to create a DHCP range on the above VLAN. For example, `10.15.155.0/24`|
|`dhcp_range`|group_vars/all/vars.yml|DHCP range to use on the above VLAN|
|`dhcp_default_lease_time`|group_vars/all/vars.yml|DHCP default lease time. Default is 86400 (24 hours)|
|`dhcp_max_lease_time`|group_vars/all/vars.yml|DHCP maximum lease time. Default is 2592000 (30 days)|
|`domain_name`|group_vars/all/vars.yml|DNS domain name for cluster. For example, `rancher-demo.org`|
|`support_template`|group_vars/all/vars.yml|Name of VM template used for the support node running DHCP. For example, `hpe-ubuntu-tpl`|


The `dhcp_subnet` variable denotes the subnet where DHCP leases will be provided. This is normally the same subnet as `rancher_subnet`.

The `dhcp_range` variable configures the range of IP addresses that will be given out by the DHCP server. This range needs to include sufficient addresses to satisfy any nodes created using node templates, such as user clusters.

The `dhcp_default_lease_time` and `dhcp_max_lease_time` variables specify the minimum and maximum times in seconds for DHCP leases to remain valid. In the provided sample file, the default lease time is 86400 seconds or 24 hours. The maximum lease time is 2592000 seconds, or 30 days. You should use values that will ensure your Kubernetes cluster nodes are not changing IP addresses. You could specify an indefinite lease time but that would likely result in exhausting your `dhcp_range` addresses.

The `domain_name` variable denotes the DNS domain name used for the rancher/DHCP subnet.

The `support_template` variable defines the name of the VM template used when deploying the support VM. By default this is set to the same value as the `admin_template` variable, which is the template used when creating the VMs in the admin cluster.




## SSH configuration

|Variable|File|Description|
|:-------|:---|:----------|
|`ssh_key`|group_vars/all/vars.yml|SSH public key for which you have the corresponding SSH private key. Currently the playbooks use the default ID of the user who is running the playbook.  So, the SSH public key to specify here is the one in the file `~/.ssh/id_rsa.pub`|


