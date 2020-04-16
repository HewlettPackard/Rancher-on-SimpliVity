# High availability

Anti-affinity rules are created to ensure VMs ruuning similar loads are deployed on different ESXi hosts.

## Admin cluster

The default configuration for the solution is an admin cluster with three master nodes,
running on three separate ESXi hosts. These VMs are guaranteed to run on different ESXi hosts
through the use of an anti-affinity rule named

```
{{ cluster_name }}-ranchernodes-anti-affinity-rule-001
```

where cluster_name is the name of your cluster, as defined in the group_vars/all/vars.yml file.


## Deploying two load balancers

You can configure the playbooks to deploy two load balancers in an active-active configuration to provide high
availability access. These nodes run `keepalived` and `HAproxy`. The load balancers are hosted on two VMs that
are guaranteed to run on two different ESXi host through using an anti-affinity rule named

```
{{cluster_name}}-loadbalancer-anti-affinity-rule-001
```

where `cluster_name` is the name of your cluster, as defined in the `group_vars/all/vars.yml` file.