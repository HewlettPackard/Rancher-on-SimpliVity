# Sample hosts file

```
[local]
localhost            ansible_connection=local ansible_python_interpreter=/usr/bin/python3

[support]
hpe-support1         ansible_host=10.15.152.5

[loadbalancer]
hpe-lb1              ansible_host=10.15.152.11 api_int_preferred=true
hpe-lb2              ansible_host=10.15.152.12

#machines hosting Rancher Cluster
[ranchernodes]
hpe-rke1             ansible_host=10.15.152.21
hpe-rke2             ansible_host=10.15.152.22
hpe-rke3             ansible_host=10.15.152.23

[template]
hpe-ubuntu-tpl       ansible_host=10.15.152.30
```