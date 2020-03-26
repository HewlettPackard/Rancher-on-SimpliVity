# Editing the hosts file

The `hosts` file consists of definitions for:

- `Cluster` nodes for the Rancher admin cluster
- `Support` node(s) for DHCP
- `Load balancer` node(s)


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



## General recommendations

- The recommended naming convention for cluster nodes is  ``<<cluster_name>>``-``<<node-type>><<node-number>>``, with
node numbering typically starting at 1. 

- Underscores (`_`) are not valid characters in hostnames.

- Make sure you change all the IP addresses in the sample files to match your environment.
