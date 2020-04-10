# Initial deployment

## Run site.yml

Run the
playbook `site.yml` to perform the initial admin and user cluster deployment:

```
$ cd ~/Rancher-on-SimpliVity
$ ansible-playbook -i hosts site.yml --vault-password-file .vault_pass
```

The playbook should take approximately twenty minutes, depending on your exact configuration.


Artifacts
generated during the installation are stored in the folder determined by the `install_dir` variable, specified in the
file `group_vars/all/private.yml`. The default location is the `.svtrancher` folder in your home directory.

Files generated include:

- `kube_config_rancher-cluster.yml` - the `kubeconfig` file that provides access to the admin cluster
- `rke-up.log` - the log file from the installation of the admin cluster
- `rancher-cluster.yml` - the admin cluster definition file




## Playbooks overview

The following section
provides an summary of the tasks carried out when running the `site.yml` playbook.


The main entry point `site.yml` is a wraper for a number of playbooks that perform the deployment in stages:

- playbooks/prepare.yml
- playbooks/provision.yml
- playbooks/configure.yml
- playbooks/ranchercluster.yml
- playbooks/rancherserver.yml
- playbooks/1stlogin.yml
- playbooks/ucluster.yml
- playbooks/csi.yml

### Prepare

The `prepare` stage performs some initial setup on the Ansible controller:

- Configures proxy if required and installs the required packages on the Ansible box
- Verifies that required files have been downloaded to staging area
- Installs client tools such as Helm, and CLIs for Rancher, RKE, `kubectl`
- Creates required artifacts in vCenter including VM folders, resource pools
- Populates `/etc/hosts`

It also performs datastore configuration:

- Connect to HPE SimpliVity 
- Create datastore if it does not already exist

### Provision

The `provision` stage performs the following tasks:

- Provision Support (DHCP) VM
- Provision Loadbalancer VMs
- Provision Rancher admin server VMs
- Update package manager on all provisioned VMs

### Configure

The `configure` stage configures the admin server VMs, DHCP VM and loadbalancer VMs. 

- Create DRS anti-affinity rules for Rancher admin server VMs and load balancer VMs
- Configure the Rancher admin server VMs
  - Install required packages, configure firewall and open ports
  - Install and configure Docker
- Configure support node (DHCP)
  - Install required packages, configure firewall and open ports
  - Install and configure DHCP
- Configure load balancer
  - Install required packages, configure firewall and open ports
  - Install and configure `nginx`


### Rancher admin cluster

The Rancher admin cluster is a Kubernetes cluster, deployed using RKE. The cluster configuration is stored in the file
`rancher-cluster.yml` in the installation directory.


### Rancher server

The Rancher server software is installed using Helm on top of the Rancher admin cluster.

For self-signed certs, `cert-manager` software is installed.  `cert-manager` is a Kubernetes add-on to automate the
management and issuance of TLS certificates from various issuing sources. It ensures certificates are valid and
up to date periodically, and attempt to renew certificates at an appropriate time before expiry.
For more information, see
[https://github.com/jetstack/cert-manager](https://github.com/jetstack/cert-manager).

For user-supplied certs, a Kubernetes secret is created from the supplied certs.

### First login

In this stage, a number of first-time log in operations are performed, including changing the admin password of the Rancher server and creating an API token.


### User cluster

- Create cloud credentials
- Create node template, from user (or the default admin) template using configuration specified in `user-template` variable in the `group_vars/all/vars.yml` file
- Deploy the user cluster with the Rancher API, using the node template and the configuration in the `cluster.yml.j2` Jinga template file.

In the current release, the user cluster deploys with a `kubernetesVersion` of  `v1.17.2-rancher1-2`.


### Enable CSI for user cluster

- Create a datastore named `csi_datastore_name` of size `csi_datastore_size`
- Retrieve the `kubeconfig` for user cluster and store it in installation directory
- Configure vSphere CSI driver
- Create storage class named `csi_storageclass_name`

