# Sample vars file

A sample `vars.yml` file is provided named `group_vars/all/vars.yml.sample` that you can use as a model for your own
vars file. To create a `vars.yml` file, you create a new file called `group_vars/all/vars.yml` and add entries based on
the descriptions in the preceding sections. A sample `vars.yml` file is shown below for convenience.

<!-- TODO Update sample vars file before release -->

```
---

rancher_subnet: 10.15.152.0/24                            # subnet to use on the 'vm_portgroup' VLAN
gateway: '10.15.152.1'                                    # gateway for the above subnet (see your net admin)
ntp_servers: ['10.12.2.1']                                # List of NTP servers
dns_servers: ['10.10.173.1','10.10.173.31']               # list of DNS servers
dns_suffixes: ['am2.cloudra.local','hpe.org']             # list of DNS suffixes

#
# DHCP related settings
#
dhcp_subnet: 10.15.152.0/24                               # subnet to use on the above VLAN (see your net admin)
dhcp_range: '10.15.152.100 10.15.152.150'                 # DHCP range to use on the above VLAN (see your net admin)
dhcp_default_lease_time: 86400                            # DHCP default lease time (24 hours)
dhcp_max_lease_time: 2592000                              # DHCP maximum lease time (30 days)
domain_name: hpe.org                                      # DNS domain name
support_template: hpe-ubuntu-tpl                          # Name of VM template used for Support Node running DHCP

#
# vcenter related settings
#
vcenter_hostname: vcentergen10.am2.cloudra.local          # name of your vCenter server
vcenter_username: Administrator@vsphere.local             # Admin user for your vCenter environment
vcenter_password: "{{ vault_vcenter_password }}"          # Encrypted in group_vars/all/vault.yml
vcenter_validate_certs: false                             # true not implemented/tested
vcenter_cluster: Rancher                                  # Name of your SimpliVity Cluster (must exist)
vm_dvswitch: dvsMgmt2960                                  # Distributed Virtual Switch containing vm_portgroup (must exist)
vm_portgroup: hpe2964                                     # portgroup that the VMS connect to (must exist)
datacenter: DEVOPS                                        # Name of your DATACENTER (must exist)
datastore: hpeRancher                                     # Datastore where the VMs are landed
datastore_size: 1024                                      # size in GiB of the VM datastore, only applies if the playbook creates the datastore
cluster_name: hpe                                         # Name of the K8S Cluster. A VM folder with the same name is created if needed

#
# folders, templates and OVAs, templates are created using the corresponding OVA if they cannot be found (and only if they cannot be found)
#
user_folder: hpe                                          # folder and pool name for the user cluster VMs, created if they are not found
admin_folder: hpeRancher                                  # Folder and pool name for Rancher Cluster VMs and  Templates
admin_template: hpe-ubuntu-tpl
#admin_template: hpe-centos-tpl

#
# Public key to use for login in the rancher nodes (the VM hosting the Rancher Cluster)
#
ssh_key: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDUAPiKRsniRNFeAsbwxY1/dfAG6Bhhsc+Z45j3Cn+K6rQ06L8sVvCCVglzL0uXjhAoVwaapMDSpYNTUOy4ukvSq99Cil97UdKQxV9nPkhghjFGMt3XIHeddX994F0Ma5W/6Y/fKWOuPRsoV+3bj4LmAK634ISmEAEYdh4mbczSsLTDTQcafREnzTJGAlx4GqFiHr1isK+CWLEFcJGbjbULgtJGGkprfMX/UZS0LNV5QYGiiw5/jkQQZ6jl7aKJwaRT/4jlW8Jbg4YbPddUnicxOeVDmU2lpi42S4lBxJC5f9VH8S9NzdcX43R5dleRjKdtEbMRFhsBlx7vkvRJ2upx core@hpe-ansible'

#
# CSI Storage plugin
#
csi_datastore_name: hpecsi
csi_storageclass_name: csivols
csi_datastore_size: 20


#
# SimpliVity
#
simplivity_validate_certs: false
simplivity_appliances:
- 10.10.173.116
- 10.10.173.117
- 10.10.173.118


proxy:
  http:  "http://10.12.7.21:8080/"     #  http:  "http://user:password@10.12.7.21:8080/"
  https:  "http://10.12.7.21:8080/"
  except: "localhost,.am2.cloudra.local,.hpe.org"


rancher:
  url: https://lb1.hpe.org        # this the FQDN at which Rancher Server can be reached
  hostname: lb1.hpe.org           # generally same fqdn as the one in the url above but not necessarily
  validate_certs: False           #
  apiversion: v3                  # Playbooks designed for v3 of the API
  engineInstallURL: 'https://releases.rancher.com/install-docker/19.03.sh'    # All node templates use the same version of Docker

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