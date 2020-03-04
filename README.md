# Quick Startup

Install Ansible on your Workstation

- tested with Fedora 31 and Ansible 2.9.5

  


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

3. copy the file `group_vars/all/vault.sample` to `group_vars/all/vault.yml` and edit this new file. Specify the password for the vCenter admin account using the variable `vault_vcenter_password`.

   ```
   vault_vcenter_password: 'PasswordForYourVcenter'
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

   The playbook site.yml does the following:

   - installs the required packages on the Ansible box (I may have installed a number of packages manually on my ansible box and you may hit issue in subsequent playbooks if this is the case)
   - verifies that the required files are found in the staging area (getkits.yml)
   - Installs client tools (rancher cli and rke cli) on the Ansible box
   - Creates required artifacts in vCenter including VM folders,  resource pools BUT NOT the VM Portgroup (`group_vars/all/vars.yml:vm_portgroup)` which you need to create manually (if not already existing)
   - loads the Ubuntu 18.04 cloud image OVA in vCenter
   - deploys and configure the one LB (with NGINX)
   - deploys and configure the rancher VMs (installs docker and configure the firewall with required ports)
   - deploy the Rancher Cluster

   # Missing today

   Deployment of Rancher server.

   in the <repo>/scripts folder, there are a number of TEMPORARY shell script with can be used to deploy Rancher but you will have to modify them to match your environment) (Ansible dev work here )

   To deploy Rancher server

   1. make sure you have your proxy env defined (http_proxy, https_proxy, no_proxy)

   2. edit  the file scripts/30-rancher.sh and populate it with your settings (replace xxx by your tag and 10.15.yyy.0/24 by your subnet, the supposedly proxy-free VLAN)

      ```
      setfile=$(mktemp)
      cat <<EOF >${setfile}
      hostname: lb1.xxx.org
      proxy: http://10.12.7.21:8080
      noProxy: 127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.am2.cloudra.local,.xxx.org,10.15.yyy.0/24
      EOF

      helm install rancher rancher-stable/rancher \
        --namespace cattle-system \
        --values=${setfile}

      kubectl -n cattle-system rollout status deploy/rancher
      ```

   3. execute in sequence the scripts numbers 10-*, 20-* and 30-* (the script 10-* has been integrated in site.yml)

   # Other Features (not ready for prime-time)

   Other features in this playbook

   - Automation of the user cluster is working but not integrated in site.yml for now. Try to digest the deployment of the Rancher Cluster for now

   - Deployment of a user cluster with CPI / CSI (VMware drivers) is in progress

     - final steps manual for now (deploy cloud provider driver and CSI driver)

     - need to address the issue with the name of the network interface (see Known Issues)

   # Access Rancher Server

   You access your rancher server by browsing to https://lb1.xxx.org

   # Known issues / Work in progress

   By default, `getkits.yml` will pull the Ubuntu 18.04 cloud image (OVF format) but this file deploys a VM at h/w revision 10 and CPI/CSI requires a rev 15 VM

   Deployment of the Rancher Cluster fails occasionally also the cluster seems to be operational after the playbook is finished (according to `kubectl get nodes`)

   Deployment of the user cluster is ready doc coming soon

   
