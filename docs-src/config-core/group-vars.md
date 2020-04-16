# Inventory group variables

## Group files

The following files, in the `group_vars` folder, contain variable definitions for each group of nodes.
These group files facilitate more sophisticated settings, such as additional network interfaces.


|File|Description|
|:---|:----------|
|`group_vars/ranchernodes.yml`|Variables defined for all nodes in the `[ranchernodes]` group|
|`group_vars/loadbalancer.yml`|Variables defined for all nodes in the `[loadbalancer]` group|
|`group_vars/support.yml`|Variables defined for all nodes in the `[support]` group|


## Overriding group variables

If you wish to configure individual nodes with different specifications to the ones defined by the group, it is possible to declare the same variables at the node level, overriding the group value. For exanple, if the default CPU and memory resource limits defined in for your Rancher nodes in the `group_vars/ranchernodes.yml` file are not sufficient, you can override these values in their respective `hosts` entries.  For example, if these are the CPU, RAM, and disk limits specified at the group level:

```   
cpus: '2'                           # Number of vCPUs
ram: '8192'                         # RAM size in MBs
disk1_size: '60'                    # Disk size in Gbs
```

you can override these values in the individual node entries in the `hosts` file:

```
[ranchernodes]
gmcgr-rke1      ansible_host=10.15.163.91 cpus=8 ram=32768
gmgcr-rke2      ansible_host=10.15.163.92 cpus=8 ram=32768
gmcgr-rke3      ansible_host=10.15.163.93 cpus=8 ram=32768
```



## Common variables across all groups

The following variables apply to all node groups:

|Variable|Scope|Description|
|:-------|:----|:----------|
|`ip_addr`|All nodes|IP address in CIDR format to be given to a node|
|`esxi_host`|All nodes|ESXi host where the node will be deployed. If the cluster is configured with DRS, this option will be overridden|
|`cpus`|All nodes/groups|Number of virtual CPU cores to assign to a VM or a group of VMs|
|`ram`|All nodes/groups|Amount of RAM in MB to assign to a VM or a group of VMs|
|`disk1_size`|All nodes/groups|Size of the disk in GB to attach to a VM or a group of VMs. |

<!-- TODO Additional common variables -->
