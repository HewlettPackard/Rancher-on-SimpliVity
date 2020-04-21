# Load balancer configuration

The solution supports a number of load balancer configuration options:

- Use the playbooks to configure two load balancers, for highly available, production deployments.
- Use the playbooks to configure a single load balancer, useful for proof of concept deployments.

When deploying two load balancers, a floating IP is deployed and managed by `keepalived`. Your settings
for `rancher.hostname` and  `rancher.url` variables should resolve to the address you chose for this floating IP.
If you configure a single load balancer, you don't need a floating IP and the `rancher.hostname` should resolve
to the IP of the standalone load balancer.

The `admin-template` is used when provisioning the load balancer VMs.

## Deploying two load balancers

With this option, two load balancers are deployed in an active-active configuration to provide highly-available access.


Two virtual machines are configured in the `hosts` inventory file. You configure one of the VMs as the preferred VM
for hosting the internal VIP for the Rancher API, by adding `api_int_preferred=` to the definition.


A sample configuration for deploying two load balancers is shown below. This extract from an Ansible `hosts`
inventory file shows the entries defining the nodes used for the load balancers:

```
[loadbalancer]
gmcgr-lb1       ansible_host=10.15.163.96 api_int_preferred=true
gmcgr-lb2       ansible_host=10.15.163.97
```



This extract from the configuration file `group_vars/all/vars.yml` shows the configuration required for
the two load balancer scenario:

```
rancher_subnet: 10.15.163.0/24

rancher:
  url: https://rancher.gmcg-rancher.org
  hostname: rancher.gmcg-rancher.org

loadbalancers:
  backend:
    vip: 10.15.163.94/24
    vrrp_router_id: 54
    nginx_max_fails: 1
    nginx_fail_timeout: 5s
    nginx_proxy_timeout: 3s
    nginx_proxy_connect_timeout: 2s
```



The `vrrp_router_id` is used to differentiate between multiple deployments
on the same networking infrastructure, for example, in proof of concepts. If you have multiple deployments, ensure that
each deployment uses unique VRRP router IDs.

You must configure DNS to resolve the value of the `rancher.hostname` (in this case `rancher.gmcg-rancher.org`)
to the value of the `loadbalancers.backend.vip` variable (in this case, `10.15.163.94`). Note that this VIP
address **must** be in the Rancher subnet and outside the DHCP range, like any other IP address in the hosts inventory.


## Deploying one load balancer

If you do not require high availability, you can deploy a single load balancer to reduce complexity and resource
requirements. In this instance, you only specify a single entry in the `[loadbalancer]` group in your `hosts` file.

```
[loadbalancer]
gmcgr-lb1       ansible_host=10.15.163.96
```

Simply comment out the `vip` and `vrrp_router_id` variables in
the `loadbalancers.backend` structure. You must configure DNS to resolve the value of the `rancher.hostname`
(in this case `rancher.gmcg-rancher.org`) to the value of the IP addess of the single load balancer VM (in this case
`10.15.163.96`).

```
rancher_subnet: 10.15.163.0/24

rancher:
  url: https://rancher.gmcg-rancher.org
  hostname: rancher.gmcg-rancher.org

loadbalancers:
  backend:
#    vip: 10.15.163.94/24
#    vrrp_router_id: 54
    nginx_max_fails: 1
    nginx_fail_timeout: 5s
    nginx_proxy_timeout: 3s
    nginx_proxy_connect_timeout: 2s
```




