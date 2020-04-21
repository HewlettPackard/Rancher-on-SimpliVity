# Editing the hosts file

The `hosts` file consists of definitions for:

- `Cluster` nodes for the Rancher admin cluster
- `Support` node(s) for DHCP
- `Load balancer` node(s)
- `template` for the Ubuntu template


## Rancher admin cluster nodes

It is recommended that a minimum of three nodes are provisioned for the admin cluster.

```
[ranchernodes]
hpe-rke1      ansible_host=10.15.152.21
hpe-rke2      ansible_host=10.15.152.22
hpe-rke3      ansible_host=10.15.152.23
```

## Support nodes

```
[support]
hpe-support1  ansible_host=10.15.152.5
```

## Load balancers

The playbooks can be used to deploy load balancers using the
information in the `loadbalancer` group.

```
[loadbalancer]
hpe-lb1       ansible_host=10.15.152.11
```

## Template

The playbooks download the latest Ubuntu 18.04 cloud image OVA as the VM template used when provisioning the various
nodes in this solution. The default Ubuntu 18.04 cloud image OVA uses VM Hardware Compatibility version 10, which
makes them incompatible with the CSI storage driver as it requires version 15. To work around this limitation, the
playbooks automatically deploy an initial VM template from the 18.04 cloud image OVA and then upgrade the hardware
compatibility to version 15, making the template compatible with CSI storage.

The template section of the Ansible inventory file lists the hostname and IP address that will be assigned to this initial
VM template. This single upgraded VM template will be used by default for any type of node in the solution, including:
support (DHCP), load balancer, RKE admin cluster and user cluster nodes. If you still wish to use a different template for
the user cluster and enable CSI support, be sure to set the `user_cluster.vm_template` variable to an appropriate VM
template that is available in the vSphere instance and is using hardware compatibility version 15.

## General recommendations

- The recommended naming convention for cluster nodes is  ``<<cluster_name>>``-``<<node-type>><<node-number>>``, with
node numbering typically starting at 1. 

- Underscores (`_`) are not valid characters in hostnames.

- Make sure you change all the IP addresses in the sample files to match your environment.
