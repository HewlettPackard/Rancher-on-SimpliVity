# Solution sizing

By default, the Ansible playbooks create VMs according to the following recommended specifications. You can override
these recommended values in the configuration files, as detailed in the section
[Configuring the solution](../config-core/group-vars).



## Admin cluster nodes
For high resiliency requirements, we recommend deploying HPE SimpliVity clusters with three (or more) nodes with
admin and user cluster components spread across the three nodes.

|VM|Number|OS|Sizing|Comments|
|:-------|:---:|:---|:----------|:----------|
|Rancher nodes|3|Ubuntu 18.04|2x&nbsp;vCPU<br>8GB RAM<br>60GB disk space|Three nodes are deployed by default.|


## Load balancers

Two load balancer VMs are configured by default.

|VM|Number|OS|Sizing|Comments|
|:-------|:---:|:---|:----------|:----------|
|Load balancers|2|Ubuntu 18.04|2x&nbsp;vCPU<br>8GB RAM<br>60GB disk space|Two load balancers are deployed by default. You can configure one (no HA) or 0 where you use your own existing load balancers|

## Support node

A single VM is configured to provide DHCP services

|VM|Number|OS|Sizing|Comments|
|:-------|:---:|:---|:----------|:----------|
|Support|1|Ubuntu 18.04|2x&nbsp;vCPU<br>8GB RAM<br>60GB disk space|Single node for DHCP|


## User cluster

By default, one master and two worker nodes are deployed.

|VM|Number|OS|Sizing|Comments|
|:-------|:---:|:---|:----------|:----------|
|Master|1|Ubuntu 18.04|2x&nbsp;vCPU<br>8GB RAM<br>60GB disk space||
|Worker|2|Ubuntu 18.04|2x&nbsp;vCPU<br>8GB RAM<br>60GB disk space||