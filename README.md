# Quick Startup

Install Ansible on your Workstation

- I use Fedora 31

- Here is the Ansible setup I have

  ```
  ansible 2.9.3
    config file = /etc/ansible/ansible.cfg
    configured module search path = ['/home/core/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
    ansible python module location = /usr/lib/python3.7/site-packages/ansible
    executable location = /usr/bin/ansible
    python version = 3.7.6 (default, Dec 19 2019, 22:52:49) [GCC 9.2.1 20190827 (Red Hat 9.2.1-1)]
  
  ```

**note**: I would recommend we use Ubuntu for the Ansible box for the solution to consolidate with a single OS, but I never tried it myself and this is open to discussion.



1.  clone the repo

   ```
   # git clone https://github.com/chris7444/Rancher-on-SimpliVity.git
   ```

2. chose yourself a 3 letters tag. Will be denoted as <tag> in the remaining of this document. Anything is fine as long as it is unique in the SVT cluster and not equal to `hpe` (which I am already using)

   copy the `hosts.sample` file to `hosts`. Edit the file`hosts` and replace all occurrences of `hpe` with your 3 letters tag.

   **tip**: if using vi you can use **:%s/hpe/xxx/g**

   copy the `group_vars/all/vars.yml.sample` to `group_vars/all/vars.yml`. In this file, replace **all** occurrences of `hpe` with your 3 letter tag (using the vi tip above if you want)

   Always in `group_vars/all/vars.yml`, verify these other settings and use your own values. Most of the vcenter_* variables are configured for the gen10 equipment. if you use the gen9 equipement you will have to change them

   ```
   rancher_subnet: 10.15.xxx.0/24 
   gateway: '10.15.xxx.1'
   ssh_key: < your public key>  # no a public key is not a secret 
   
   ```

   Edit `group_vars/all/vault.yml` (copy vault.yml.sample) and specify the password for the vcenter environment you chose

   ```
   ---
   vault_vcenter_password: 'passwordForvCenterAdminAccount'
   vault_rancher_token: ignoreThisforNow
   ```

   

3. Create a DNS zone in our DNS (10.10.173.1) with the name `xxx.org`. Where `xxx` is your tag.

   In this zone, add an A Record for lb1.xxx.org where the IP address should be the IP address of your unique load balancer as found in YOUR hosts file. If your load balancer is described like the following, then lb1.xxx.org should revolve to 10.15.yyy.11

   ```
   [local]
   localhost ansible_connection=local ansible_python_interpreter=/usr/bin/python3
   
   [loadbalancer]
   <tag>-lb1 ansible_host=10.15.yyy.11
   
   #machines hosting Rancher Cluster
   [ranchernodes]
   <tag>-rke1   ansible_host=10.15.yyy.21
   <tag>-rke2   ansible_host=10.15.yyy.22
   <tag>-rke3   ansible_host=10.15.yyy.23
   ```

4. Prepare the staging area (download the kits)

   ```
   # ansible-playbook -i hosts playbooks/getkits.yml
   ```

   **Note**: You don't really need to know where the kits are downloaded (but you will find them in  $HOME/kits)

   **Note:** This is a separate playbook because we may have to support air-gapped/offline environments in the future

5. Deploy. (You may have to use a password in the command line if you encrypted your vault file)

   ```
   # ansible-playbook -i hosts site.yml
   ```

   

   **Note**: You don't have to create a VM template! (for now). Not having end users build a template is a design goal, this does not mean that we will be able to avoid it in the final solution (see Known issues below). But if we can avoid it, we will.

   # What is deployed

   the playbook site.yml does the following:

   - installs the required packages on the Ansible box (I may have installed a number of packages manually on my ansible box and you may hit issue in subsequent playbooks if this is the case) (please report if this is the case)
   - verifies that the required files are found in the staging area (where they were downloaded earlier using `getkits.yml`)
   - Installs client tools (rancher cli and rke cli) on the Ansible box
   - Creates required artifacts in vCenter including VM folders,  resource pools BUT NOT the VM Portgroup (`group_vars/all/vars.yml:vm_portgroup)` which you need to create manually (if not already existing)
   - loads the Ubuntu 18.04 cloud image OVA in vCenter
   - deploys and configure the one LB (with NGINX) (no HA support yes)
   - deploys and configure the rancher VMs (installs docker and configure the firewall with the required rules)
   - deploys the Rancher Cluster

   

   # Missing today

   Deployment of Rancher server on the Rancher cluster is not done (ie no playbooks). However in the <repo>/scripts folder, there are a number of TEMPORARY shell scripts with can be used to deploy Rancher Server but you will have to modify them to match your environment) (Ansible dev work here ). Here are the scripts:

   ```
-rwxrwxr-x. 1 core core  162 Feb 14 09:22 00-rke.sh
   -rwxrwxr-x. 1 core core  133 Feb 19 12:53 10-helm.sh
-rwxrwxr-x. 1 core core 1139 Feb 14 09:22 20-certmgr.sh
   -rwxrwxr-x. 1 core core  356 Feb 26 16:11 30-rancher.sh
```
   
You don't need `00-rke.sh` as this is now done by the ansible playbooks (`site.yml`)
   
   To deploy Rancher Server proceed as indicated below:
   
   1. make sure you have your proxy environment defined  (http_proxy, https_proxy, no_proxy). Make sure you specify the DNS domain <tag>.org (hpe.org for me) and your proxy-free VLAN subnet (even if it is not proxy free). 10.15.152.0/24 for me. Here are my settings:
   
      ```
      export https_proxy=http://10.12.7.21:8080
      export http_proxy=http://10.12.7.21:8080
      export NO_PROXY="localhost,.am2.cloudra.local,.hpe.org,10.15.152.0/24"
      ```
   
      
   
   2. edit  the file `scripts/30-rancher.sh` and populate it with your settings (replace yyy are the digits in your 10.15.yyy.0/24 subnet)

      ```
   setfile=$(mktemp)
      cat <<EOF >${setfile}
   hostname: lb1.<tag>.org
      proxy: http://10.12.7.21:8080
   noProxy: 127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.am2.cloudra.local,.<tag>.org,10.15.yyy.0/24
      EOF
   
      helm install rancher rancher-stable/rancher \
     --namespace cattle-system \
        --values=${setfile}
   
      kubectl -n cattle-system rollout status deploy/rancher
   ```
   
   
   
3. Execute the following scripts in sequence
   
   ```
      ./10-helm.sh
   ./20-certmgr.sh
      ./30-rancher.sh
   ```
   
   
   
# Access Rancher Server
   
You access your rancher server by browsing to https://lb1.<tag>.org. Make sure your browser specifies .<tag>.org in proxy exceptions (do not use proxy for those names ending with .<tag>.org)
   
For this to work your workstation (typically your jumbox) needs to use our DNS server as ... DNS server
   
   # Known issues / work in Progress
   
   The name of the network interface as seen by Ubuntu  is changing depending on how the template/OVA was built. If using the cloud image built by Ubuntu (which is what this draft set of playbooks is doing), the name is ens192 but when using my own image, the name is ens160. Currently I use a variable to configure this name but this is sub-optimal. There is a way to address this issue with cloud-init but I need to re-org some of the tasks (integrate the cloud-init tasks in the vsphere role)
   
   We need to build our own Ubuntu image if we want CPI/CSI (requires a rev 15 VM)
   
   
   
   # Other Features (not ready for prime-time)
   
   Other features in this playbook 
   
   - Automation of the user cluster is working but not integrated in site.yml for now. I am working on it
   
   - Deployment of a user cluster with CPI / CSI (VMware drivers) is in progress (working on it)
   
     - final steps manual for now (deploy cloud provider driver and CSI driver)
   
     - need to address the issue with the name of the network interface (see Known Issues)
   
   
   
   