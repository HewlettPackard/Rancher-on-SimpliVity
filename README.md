# Quick Startup

Install Ansible on your Workstation: tested with Fedora 31 and Ansible 2.9.5

1. clone the repo
   ```
   # git clone git@github.com:HewlettPackard/Rancher-on-SimpliVity.git
   # cd ./Rancher-on-SimpliVity
   ```
   
2. copy the file `group_vars/all/vars.yml.sample` to `group_vars/all/vars.yml` and configure it to match your environment. The file contains comments that should help you understand how to populate this file. (and more documentation will come)

   Anyway a few variables deserve a special treatment. 
   ```
   rancher_subnet: 10.15.xxx.0/24
   gateway: '10.15.xxx.1'
   ssh_key: < your public key>  # no a public key is not a secret
   ntp_servers: ['10.12.2.1']                                # List of NTP servers
   dns_servers: ['10.10.173.1','10.10.173.31']               # list of DNS servers
   dns_suffixes: ['am2.cloudra.local','hpe.org']             # list of DNS suffixes
   ```
   The `rancher_subnet` variable is the scope of IP addresses which you can use on the Rancher VLAN. The Rancher VLAN is a vCenter portgroup in your virtual infrastructure which connects all the virtual machines that this solution deploys. **This portgroup must exists** (see below `vm_portgroup`) before you attempt to run the playbooks and you must have been assigned a scope (subnet) of IP addresses on which you have complete control.

   The `gateway` variable is the gateway to use for the Rancher VLAN. 

   the `ssh_key` is an SSH public key for which you have the corresponding SSH private key. Currently the playbooks use the default ID of the user who is running the playbook hence the SSH public key to specify here is the one you find in `~/.ssh/id_rsa.pub`.

   The `ntp_servers` and `dns_servers` variables should be configured with addresses which apply in your environment. The machines which will be deployed on the Rancher VLAN will need connectivity with these services.  

   **Note: Time services are crucial**. You must have time services available in your environment

   The variables used to configure the DHCP service on a support VM include:

   ```
   #
   # DHCP related settings
   #
   dhcp_subnet: 10.15.152.0/24                               # subnet to use on the above VLAN (see your net admin)
   dhcp_range: '10.15.152.100 10.15.152.150'                 # DHCP range to use on the above VLAN (see your net admin)
   dhcp_default_lease_time: 86400                            # DHCP default lease time (24 hours)
   dhcp_max_lease_time: 2592000                              # DHCP maximum lease time (30 days)
   domain_name: hpe.org                                      # DNS domain name
   support_template: hpe-ubuntu-tpl                          # Name of VM template used for Support Node running DHCP
   ```

   The `dhcp_subnet` variable denotes the subnet where DHCP leases will be provided.  This is normally the same subnet as `rancher_subnet`.

   The `dhcp_range` variable configures the range of IP addresses that will be given out by the DHCP server. This range needs to include sufficient addresses to satisfy any nodes created using node templates, such as user clusters.

   The `dhcp_default_lease_time` and `dhcp_max_lease_time` variables specify the minimum and maximum times in seconds for DHCP leases to remain valid. In the provided sample file the default lease time is 86400 seconds or 24 hours. The maximum lease time is 2592000 seconds, or 30 days. You should use values that will ensure your K8s cluster nodes are not changing IP addresses. You could specify an indefinite lease time but that would likely result in exhausting your `dhcp_range` addresses.

   The `domain_name` variable denotes the DNS domain name used for the rancher/DHCP subnet.

   The `support_template` variable defines the name of the VM template used when deploying the support VM. By default this is set to the same value as the `admin_template` variable, which is the template used when creating the VMs in the admin cluster.

   ```
   #
   # vcenter related settings
   #
   vcenter_hostname: vcentergen10.am2.cloudra.local # FQDN of your vCenter Server
   vcenter_username: Administrator@vsphere.local    # Admin creds
   vcenter_password: "{{ vault_vcenter_password }}" # Admin creds
   vcenter_cluster: OCP           # Name of your SimpliVity Cluster (must exist)
   vm_portgroup: hpe2964          # portgroup that the VMS connect to (must exist)
   datacenter: DEVOPS             # Name of your DATACENTER (must exist)
   datastore: hpeRancher          # Datastore where the VMs are landed
   datastore_size: 1024           # size in GiB of the datastore above
   cluster_name: hpe              # may not be needed
   user_folder: hpe               # folder and pool name for the user cluster VMs
   admin_folder: hpeRancher       # Folder and pool name for Rancher Cluster VMs and  Templates
   admin_template: hpe-ubuntu-tpl # name to give to the admin template
   ```

   The vCenter related variables are pretty self-explanatory.  The vCenter credentials must be valid . Some objects must exists before running the playbooks and some will be created by the playbooks.

   **note**: `vcenter_password` is configured using an indirection. the vCenter password is stored in a separate file (an Ansible vault) using the variable `vault_vcenter_password`. The vault file can be encrypted

   ```
   proxy:
     http:  "http://10.12.7.21:8080/"
     https:  "http://10.12.7.21:8080/"
     except: "localhost,.am2.cloudra.local,.hpe.org"
   ```

   If your installation is behind a corporate proxy, you will need to configure the `proxy` variable as indicated above. if you are not behind a proxy just rename the variable `proxy` to something else (eg `fooproxy`)

   The next variable you need to configure is the variable `rancher`. The only change you should have to do are the `url` and the `hostname`. The url is the one used to access the Rancher Server.  The hostname is the FQDN of the Rancher Server. You must configure your DNS environment so that these names resolves to the IP address of the load balancer you configure in the Ansible inventory (see below) (these two names may not necessarily be the same). Note that you can also specify the version of Rancher Server using `rancher.version`. These playbooks were last tested using version 2.3.x.

   ```
   rancher:
     url: https://rancher.hpe.org
     hostname: rancher.hpe.org
     validate_certs: False
     version: 2.3.6
     apiversion: v3
     engineInstallURL: 'https://releases.rancher.com/install-docker/19.03.sh'
   ```

   Rancher Server is designed to be secure by default and requires SSL/TLS configuration. There are three options for the source of the certificate: Rancher Generated Certificates, Let's Encrypt and Certificates from Files.
   These playbooks support option 1 and option 3. You specify which one to use by configuring the variable `rancher.tls_source` in `group_vars/all/vars.yml`. The accepted values are `rancher` for option 1, and `secret` for option 3. The default is `rancher` which means that the example above is equivalent to what is shown below:

   ```
   rancher:
     url: https://rancher.hpe.org
     hostname: rancher.hpe.org
     version: 2.3.6
     validate_certs: False
     apiversion: v3
     engineInstallURL: 'https://releases.rancher.com/install-docker/19.03.sh'
     tls_source: rancher
   ```
   If you want to supply your own certificates you will have to set `rancher.tls_source` to `secret` and let the playbooks know where to find your certificates as shown in the example below:
   ```
   rancher:
     url: https://rancher.hpe.org
     hostname: rancher.hpe.org
     validate_certs: False
     apiversion: v3
     engineInstallURL: 'https://releases.rancher.com/install-docker/19.03.sh'
     tls_source: secret
     tls_privateCA: true
     tls_cacert_file: /home/core/certs/cacerts.pem
     tls_certchain_file: /home/core/certs/cachain.pem
     tls_certkey_file: /home/core/certs/tlskey.pem    
   ```
   The `rancher.tls_privateCA` variable should be set to `true` if the certificates are signed by a private root Certificate Authority (root CA), in which case you need to supply the certificate of the root CA using `rancher.tls_cacert_file`. In the example above, the root CA certificate was stored in /home/core/certs/cacerts.pem. Note that all certificates use the PEM format.
   The certificate and key that the Rancher Server should used is specified with the variables `rancher.tls_certchain_file` and `rancher.tls_certkey_file`. These variables should be configured with the names of the files that contain the SSL certificate and key that the Rancher Server should use. Note that the file designated by `rancher.tls_certchain_file` contains the certificate of the Rancher Server itself followed by the certificates of intermediate CAs if any.

   You can configure **one or two load balancers** depending on if you want HA for this service or not.  When deploying two load balancers, a floating IP is deployed and managed by keepalived.  Your settings for `rancher.hostname` and the name in the `rancher.url` variable should resolve to the address you chose for this floating IP. If you configure a single load balancer, you don't need a floating IP and the `rancher.hostname` should resolve to the IP of the standalone load balancer.

   The first example below is for an HA setup. The Ansible inventory specifies two load balancers. The `loadbalancers` variable in `group_vars/all/vars.yml` specifies the VIP to use (`loadbalancers.backend.vip`) and a VRRP router ID (51) which must be unique on the rancher subnet/VLAN . The DNS is configured to resolve`rancher.hostname` to 10.15.152.9. Note that this VIP MUST be in the rancher subnet **and** outside the DHCP scope like any other IP address from the hosts inventory.

   ```
   rancher_subnet: 10.15.152.0/24 
        :    :
   rancher:
     url: https://rancher.hpe.org
     hostname: rancher.hpe.org
         :   :
   loadbalancers:
     backend:
       vip: 10.15.152.9/24
       vrrp_router_id: 51
       nginx_max_fails: 1
       nginx_fail_timeout: 10s
       nginx_proxy_timeout: 10m
       nginx_proxy_connect_timeout: 60s
   ```

   ```
   [local]
   localhost     ansible_connection=local ansible_python_interpreter=/usr/bin/python3
    
   [support]
   hpe-support1  ansible_host=10.15.152.5
    
   [loadbalancer]
   hpe-lb1       ansible_host=10.15.152.11 api_int_preferred=true
   hpe-lb2       ansible_host=10.15.152.12
    
   #machines hosting Rancher Cluster
   [ranchernodes]
   hpe-rke1      ansible_host=10.15.152.21
   hpe-rke2      ansible_host=10.15.152.22
   hpe-rke3      ansible_host=10.15.152.23
   ```

   **note:** The first load balancer is tagged with the variable `api_int_preferred` which means when the two load balancers are up and running, this VM will host the configured VIP.

   The second example below shows how to configure a single load balancer.  HA is provided by VMWare HA. The VIP and the VRRP router ID are commented out. This disables keepalived. In this case, `rancher.hostname` (rancher.hpe.org)  must resolve to the IP address of the VM in the `loadbalancer` group.

   ```
   rancher_subnet: 10.15.152.0/24
       :         : 
   rancher:
     url: https://rancher.hpe.org 
     hostname: rancher.hpe.org
       :          :
   loadbalancers:
     backend:
   #    vip: 10.15.152.9/24
   #    vrrp_router_id: 51
       nginx_max_fails: 1
       nginx_fail_timeout: 10s
       nginx_proxy_timeout: 10m
       nginx_proxy_connect_timeout: 60s
   ```
   
   ```
   [local]
   localhost     ansible_connection=local ansible_python_interpreter=/usr/bin/python3
    
   [support]
   hpe-support1  ansible_host=10.15.152.5
    
   [loadbalancer]
   hpe-lb1       ansible_host=10.15.152.9
    
   #machines hosting Rancher Cluster
   [ranchernodes]
   hpe-rke1      ansible_host=10.15.152.21
   hpe-rke2      ansible_host=10.15.152.22
   hpe-rke3      ansible_host=10.15.152.23
   ```

   Finally, configure the `user_cluster` variable. To some extent, you can configure the user cluster that the playbooks will deploy. This is achieved by configuring the variable `user_cluster` in `group_vars/all/vars.yml`.  An example is provided below:

   ```
   user_cluster:
   # vm_template: hpe-ubuntu-tpl     # an existing VM template, admin template by default
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

   You may create as many `pools` as you want, but at least you will need 1 master node, one etcd node and one worker node (no checking done). In the example above, we have two pools, the `master-pool`  contains one node (`count: 1`) which is running etcd as well as the Kubernetes "master" pieces. The second pool (`worker-pool`)  deploys two nodes (`counts: 2`) which are only worker nodes. Each pool leverages a Rancher node template (`node_template`).  All Rancher node templates inside the user cluster are based on the same VMWare VM template which by default is the VM template which was used to deploy the Rancher Cluster. It is possible to specify a different template but this template will have to be prepared in vCenter manually. Each node template specifies the amount of RAM (in GBs), CPUs and disk (in GBs) wanted.

   The `hostPrefix` within each pool specifies how the VMs in a pool should be named. (host prefix + sequence number)

   ### vSphere storage Container Storage Interface (CSI) support

   The `user_cluster.csi` variable controls whether the provisioned user cluster will include support for a CSI storage plugin. When set to `true` the cluster will deploy with CSI storage support enabled. At this time only the vSphere CSI driver is supported. Future versions of this solution will include support for other CSI plugins.

   **Note:** CSI storage drivers require that the VM template used to create the user cluster be configured with **VM Hardware Compatibility version 15**. The playbooks have been designed to download the latest Ubuntu 18.04 cloud image OVA as the VM template used when provisioning the various nodes in this solution. The default Ubuntu 18.04 cloud image OVA use **hardware compatibility version 10**, which makes them incompatible with the CSI storage driver. To work around this limitation, the playbooks automatically deploy an initial VM template from the 18.04 cloud image OVA and then upgrade the hardware compatibility to version 15, making the template compatible with CSI storage. This single upgraded VM template can therefore be used for any type of node in the solution: support (DHCP), load balancer, RKE cluster and user cluster nodes. If you still wish to use a different template for the user cluster and enable CSI support, be sure to set the `user_cluster.vm_template` variable to an appropriate VM template that uses hardware compatibility version 15.

   The following variables control the CSI storage deployment:

   ```
   csi_datastore_name: hpecsi
   csi_storageclass_name: csivols
   csi_datastore_size: 512
   csi_driver: vsphere
   ```

   The `csi_datastore_name` variable defines the name of the vSphere datastore where CSI volumes will be created by the CSI driver. If this datastore does not exist it will be created by the playbooks. The `csi_storageclass_name` variable defines the name of the Kubernetes storage class that will be created in the user cluster associated with the vSphere CSI driver. PVCs and PVs using this storage class will trigger vSphere to create the underlying volumes. The `csi_datastore_size` variable determines the size of the datastore in GiB that will hold the CSI volumes. The `csi_driver` variable determines which CSI driver will be deployed. At this time the only supported value is `vsphere`, though this will change in future releases as other CSI drivers are supported.

3. copy the file `group_vars/all/vault.sample` to `group_vars/all/vault.yml` and edit this new file. Specify the password for the vCenter admin account and the password you want to configure for the Rancher Server admin account.

   ```
   vault_vcenter_password: 'PasswordForYourVcenter'
   vault_rancher_password: 'PasswordForRancher'
   ```

4. copy the `hosts.sample` file to `hosts`. Edit the file`hosts` and assign IP addresses to the machines in this inventory with IP addresses taken from the `rancher_subnet` scope (see above) .  The `rancher_subnet` scope provided with the file `group_vars/all/vars.yml.sample` specifies 10.15.152.0/24 and hence the IP addresses configured in `hosts.sample` file are taken from this pool. If you need to change the `rancher_subnet` scope, make sure you change the IP addresses in the `hosts` inventory file as well.

5. make sure the Rancher url (`rancher.url`) resolves to the IP address of the load balancer you configured in the `hosts` inventory. Instructions for configuring the DNS are specific to your DNS implementation and are not provided here.

6. Prepare the staging area (download the kits)

   ```
   # ansible-playbook -i hosts playbooks/getkits.yml
   ```

7. (Optional) Validate configuration parameters via the `pre-checks.yml` playbook. The playbook attempts to verify that the configuration parameters defined in the `group_vars/all/vars.yml` and `group_vars/all/vault.yml` files contain appropriate values. It validates access to the `vCenter` instance hosting the SimpliVity cluster and verifies the requested `datacenter` and `vm_portgroup` exist. It ensures the configured `DNS` and `NTP` servers are valid. It also attempts to ensure the hostnames and IP addresses that will be used when creating the RKE admin cluster (defined in the `hosts.yml` file) are not already being used elsewhere in the environment.

   ```
   # ansible-playbook -i hosts playbooks/pre-checks.yml
   ```

8. Deploy

   ```
   # ansible-playbook -i hosts site.yml
   ```

   **Note**: You don't have to create a VM template! (for now)

# What is deployed

The playbook `site.yml` does the following:

   - installs the required packages on the Ansible box
   - verifies that the required files are found in the staging area
   - Installs client tools (rancher cli and rke cli) on the Ansible box
   - Creates required artifacts in vCenter including VM folders,  resource pools BUT NOT the VM Portgroup (`group_vars/all/vars.yml:vm_portgroup)` which you need to create manually (if not already existing)
   - loads the Ubuntu 18.04 cloud image OVA in vCenter
   - Creates an initial VM template from the Ubuntu 18.04 OVA
   - Updates the open-vm-tools and other packages in the VM template to the latest version
   - Upgrades the Hardware Compatibility of the VM template to version 15, which is needed for CSI support
   - Deploys and configures the support node with a DHCP server used when deploying Rancher user clusters
   - Deploys and configures the loadbalancers (with NGINX)
   - Deploys and configure the Rancher VMs (installs docker and configures the firewall with the required ports)
   - Deploys the Rancher Cluster (a Kubernetes cluster)
   - Deploys the Rancher Server on top of the Rancher Cluster
   - Performs a number of first time login operations including changing the admin password of the Rancher server and creating an API token
   - Deploys the user cluster

# Access Rancher Server

You access your rancher server by browsing to the url which is specified by the variable `rancher.url`  (see in `group_vars/all/vars.yml` the `rancher` variable). This is https://rancher.hpe.org in the example below. 

```
rancher:
  url: https://rancher.hpe.org
  validate_certs: False
  apiversion: v3
         :   :
```

The password for the admin account is the password you configured in `group_vars/all/vault.yml`.

# Optional Post-Installation Features

## Active Directory Integration

Rancher supports multiple methods of authentication, one of which is integrating with Microsoft Active Directory services.

### Configuring Active Directory Variables

All variables relating to Active Directory integration are described in the table below.

| Variable Name                            | File                         | Description                                    |
| :--------------------------------------- | :--------------------------- | :--------------------------------------------- |
| ad_ca_file                               | group_vars/all/vars.yml      | The path to you Active Directory CA certificate stored in .pem format. A default ca.pem file is provided in `playbooks/roles/ad-auth/files/ca.pem`, but this certificate will not work in your environment. |
| ad_login_domain                          | group_vars/all/vars.yml      | The Domain name served by your Active Directory service. |
| ad_server_name                           | group_vars/all/vars.yml      | The name of your Active Directory server. |
| ad_service_account_username              | group_vars/all/vars.yml      | The username used to authenticate to your Active Directory service account. |
| ad_service_account_password              | group_vars/all/vault.yml     | The password used to authenticate to your Active Directory service account. |
| ad_tls                                   | group_vars/all/vars.yml      | A value of 'true' indicates your Active Directory service requires the use of TLS. A value of 'false' indicates your Active Directory service does not require TLS.     |
| ad_port                                  | group_vars/all/vars.yml      | The port number used to access your Active Directory service. |
| ad_group_search_base                     | group_vars/all/vars.yml      | String defining the AD search parameters for Group lookups.   |
| ad_group_search_filter                   | group_vars/all/vars.yml      | String defining the AD search filter used for Group lookups.  |
| ad_user_search_base                      | group_vars/all/vars.yml      | String defining the AD search parameters for User lookups.    |
| ad_user_search_filter                    | group_vars/all/vars.yml      | String defining the AD search filter used for User lookups.   |

Once these variables are set to the appropriate value, run the `playbooks/ad-auth.yml` playbook:

```
# ansible-playbook -i hosts playbooks/ad-auth.yml --vault-password-file .vault_pass
```

### Active Directory Verification

Access the Rancher GUI and access the `Security -> Authentication` menu option to verify the `Active Directory` Authentication method is enabled.

# Other Features (not ready for prime-time)

     - need to address the issue with the name of the network interface (see Known Issues)

  

   # Known issues / Work in progress

Deployment of the Rancher Cluster fails occasionally also the cluster seems to be operational after the playbook is finished (according to `kubectl get nodes`)
