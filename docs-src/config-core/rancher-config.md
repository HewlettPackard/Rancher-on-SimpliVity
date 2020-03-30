# Rancher configuration

Rancher-specific configuration is performed using the `rancher` dictionary element in the `group_vars/all/vars.yml` file:


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
|`cluster_name`|group_vars/all/vars.yml|Name of the K8S Cluster|
|`user_folder`|group_vars/all/vars.yml|Folder and pool name for the user cluster VMs|
|`admin_folder`|group_vars/all/vars.yml|Folder and pool name for Rancher Cluster VMs and  Templates|
|`admin_template`|group_vars/all/vars.yml|Name for the admin template|


## User cluster

<!-- TODO Rancher user cluster config -->

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


