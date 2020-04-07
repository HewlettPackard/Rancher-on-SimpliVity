# Rancher user cluster configuration

<!-- TODO Rancher user cluster config -->


## General config for user cluster

|Variable|File|Description|
|:-------|:---|:----------|
|`user_cluster.name`|group_vars/all/vars.yml|The name of the user cluster|
|`user_cluster.vcenter_credsname`|group_vars/all/vars.yml|The name given to the generated Cloud Credentials|



The following figure shows how to see the generated cloud credentials in the UI, accessed via your profile:

!["Cloud credentials"][cloud-credentials-png] 

**Figure. Cloud credentials**


## Configuration of pools

`user_cluster.pools` is an array of pool configurations, with typically one pool specified for master nodes,
and one pool for worker nodes. The configuration variables used within each pool definition is specified below.


|Variable|File|Description|
|:-------|:---|:----------|
|`name`|group_vars/all/vars.yml|The name of the pool, for example `master-pool` or `worker-pool`|
|`etcd`|group_vars/all/vars.yml|Boolean.`true` if you want `etcd` to run on nodes in this pool|
|`master`|group_vars/all/vars.yml|Boolean.`true` if you want the nodes in this pool to be `master` nodes|
|`worker`|group_vars/all/vars.yml|Boolean.`true` if you want the nodes in this pool to be `worker` nodes<br>Note that a node can act as both a master and a worker node|
|`count`|group_vars/all/vars.yml|Number of nodes of this type to create.|
|`hostPrefix`|group_vars/all/vars.yml|The prefix used to identify these nodes as belonging to this pool<br>Typically, you will specify a different prefix for master and worker nodes|


## Node templates

For each pool, a node template can be specified, with specific resource configuration appropriate to the node type
of the pool.

|Variable|File|Description|
|:-------|:---|:----------|
|`node_template.name`|group_vars/all/vars.yml|The name of the generated node template|
|`node_template.cpu_count`|group_vars/all/vars.yml|The number of virtual CPUs for the node|
|`node_template.disk_size`|group_vars/all/vars.yml|The size of disk in MB to create for the node|
|`node_template.disk_size`|group_vars/all/vars.yml|The size of RAM in MB|

The following figure shows how to see the generated node templates in the UI, accessed via your profile:

!["Node templates"][node-templates-png] 

**Figure. Node templates**


## Sample user cluster definition
```
user_cluster:
# vm_template: hpe-ubuntu-tpl     # an existing VM template, the admin template by default
  name: api                       # name of the user cluster
  csi: false                      # true to be done
  vcenter_credsname: mycreds2     # only one vCenter cluster supported at this time
  pools:
   - name: master-pool
     etcd: true
     master: true
     worker: false
     count: 1
     hostPrefix: hpe-mas
     node_template:
       name: master-node
       cpu_count: 2
       disk_size: 20000
       memory_size: 8192
   - name: worker-pool
     etcd: false
     master: false
     worker: true
     count: 2
     hostPrefix: hpe-wrk
     node_template:
       name: worker-node
       cpu_count: 2
       disk_size: 40000
       memory_size: 4096
```



[cloud-credentials-png]:<../images/cloud-credentials.png> "Figure. Cloud credentials"
[node-templates-png]:<../images/node-templates.png> "Figure. Node templates"

