# Quick Startup

Install Ansible on your Workstation: tested with Fedora 31 and Ansible 2.9.5

1. clone the repo

   ```
   # git clone git@github.com:HewlettPackard/Rancher-on-SimpliVity.git
   # cd ./Rancher-on-SimpliVity
   ```

2. copy the file `group_vars/all/vars.yml.sample` to `group_vars/all/vars.yml` and configure it to match your environment. The file contains comments that should help you understand how to populate this file. (and more documentation will come)

   Anyway a few variables deserves a special treatment. 

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

   The last variable you need to populate (for now) is the variable `rancher`. The only change you should have to do is the `url`. This is the url which will be used to access the Rancher Server. **You must configure your DNS environment **(the DNS servers designated by the variable `dns_servers`) so that the FQDN in this url (lb1.hpe.org in the example below) resolves to the IP address of the load balancer you configure in the Ansible inventory (see below)

   ```
   rancher:
     url: https://lb1.hpe.org   # this name must resolv to the IP address of your LB
     validate_certs: False      #
     apiversion: v3             # Playbooks designed for v3 of the API
     engineInstallURL: 'https://releases.rancher.com/install-docker/19.03.sh'    # ALl node templates use the same version of Docke
   ```

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

7. Deploy

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
   - deploys and configures the one LB (with NGINX)
   - deploys and configure the rancher VMs (installs docker and configures the firewall with the required ports)
   - deploys the Rancher Cluster
# Deployment of Rancher Server

Everything in this section is temporary and WILL change including this documentation. For now the repo provides a temporary script (`scripts/rancher.sh`). This script includesi the file proxy.rc which is expected to be in your $HOME directory.  Create this file. If you are behind a proxy configure the proxy environment variables as shown in the example below: (replace with your proxy settings)

```
export https_proxy=http://10.12.7.21:8080
export http_proxy=http://10.12.7.21:8080
export NO_PROXY="localhost,.am2.cloudra.local,.hpe.org,10.15.152.0/24"
```

If you are not behind a proxy, leave this file empty (but the file must exists). If behind a proxy, make sure you specify the `rancher_subnet` in the NO_PROXY specification (here 10.15.152.0/24).

To deploy Rancher server:

1. make sure you have created the file `$HOME/proxy.rc`  per the recommendations above

2. run the following commands

```
# cd scripts
# ./rancher.sh
```

**WARNING**: DO NOT TRY TO CONNECT TO THE RANCHER GUI NOW. The next playbook `1stlogin.yml` will change the password of the Rancher Server with the value you configured in the vault file. And for this to succeed, it uses the default credentials. 

# First time Login

The playbook `playbook/1stlogin.yml` configures the password for the local admin account and creates a token for use by subsequent playbooks when they use the Rancher API. This token is stored in `$HOME/.svtrancher/rancher-token`.

For this playbook to succeed you MUST NOT have connected to the Rancher GUI before running it. If you did, you will have to create a bearer token manually and store it in `$HOME/.svtrancher/rancher-token`

This playbook will be integrated in `site.yml` when we have the Rancher Server installation done. In the meantime you have to run it manually:

```

# ansible-playbook -i hosts playbooks/1stlogin.yml
```

   # Deploy the user cluster

 **WARNING**: You must have successfully run the playbook `playbooks/1stlogin.yml` before attempting to deploy the user cluster.
 **WARNING**: For now you must a DHCP server configured on your Rancher VLAN.

To some extent, you can configure the user cluster that the playbook `playbooks/ucluster.yml` will deploy. This is achieved by configuring the variable `user_cluster` in `group_vars/all/vars.yml`.

You may create as many pools as you want, but at least you will need 1 master node, one etcd node and one worker node (no checking done). In the example below, we have two pools, the `master-pool`  contains one node (`count: 1`) which is running etcd as well as the Kubernetes "master" pieces. The second pool (`worker-pool`)  deploys two nodes (`counts: 2`) which are only worker nodes. Each pool leverages a Rancher node template (`node_template`).  All Rancher node templates are based on the same VMWare VM template which by default is the VM template which was used to deploy the Rancher Cluster. 

**note:** It is possible to specify a different template but this template will have to be prepared in vCenter manually.

 Each node template specifies the amount of RAM (in GBs), CPUs and disk (in GBs) wanted.

 The `hostPrefix` within each pool specifies how the VMs should be named in the pool (host prefix + sequence number)

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

 

You are now ready to deploy the user cluster:  

```
# ansible-playbook -i hosts playbooks/ucluster.yml
```



# Access Rancher Server

You access your rancher server by browsing to the url which is specified by the variable `rancher.url`  (see in `group_vars/all/vars.yml` the `rancher` variable). This is https://lb1.hpe.org in the example below.

```
rancher:
     url: https://lb1.hpe.org  
     validate_certs: False    
     apiversion: v3  
         :   :

```
   # Other Features (not ready for prime-time)

   - Deployment of a user cluster with CPI / CSI (VMware drivers) is in progress
     - final steps manual for now (deploy cloud provider driver and CSI driver)
     - need to address the issue with the name of the network interface (see Known Issues)

  

   # Known issues / Work in progress

By default, `getkits.yml` will pull the Ubuntu 18.04 cloud image (OVF format) but this file deploys a VM at h/w revision 10 and CPI/CSI requires a rev 15 VM

Deployment of the Rancher Cluster fails occasionally also the cluster seems to be operational after the playbook is finished (according to `kubectl get nodes`)




