# Download required software

Once you have satisfied the prerequisites and configured all of the variables to match your environment,
you need to download the required software by running the `playbooks/getkits.yml`:

```
$ cd ~/Rancher-on-SimpliVity
# ansible-playbook -i hosts playbooks/getkits.yml
```


The following software is downloaded:

- The `rke` command line tool
- The `rancher` command line tool
- The Ubuntu 18.04 cloud image from Ubuntu (OVA)
- The `kubectl` command line tool
- The `helm` command line tool

## Software versions

The version of software downloaded is determined by the settings in the file `playbooks/roles/kits/defaults/main.yml`.
The versions at the time of writing are as follows:

```
kits_rke_version: v1.0.4
kits_rancher_cli_version: v2.3.2
kits_kubectl_cli_version: v1.17.2
kits_helm_cli_version: v3.1.2
```

If you need to override the default values you can configuring variables with the same names in `group_vars/all/vars.yml`. For example, if the following is specified in group_vars/all/vars.yml, the playbook will download rke version 1.0.6 and rancher version 2.4.0.

```
kits_rke_version: v1.0.6
kits_rancher_cli_version: v2.4.0
```


The software is downloaded to the folder determined by the `kits_folder` variable, specified in the
file `group_vars/all/private.yml`. The default location is the `kits` folder in your home directory (`~/kits`).

## Ubuntu OVA

The Ubuntu OVA is downloaded from `https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.ova`.
This URL is specified in the file `playbooks/roles/kits/tasks/main.yml`.


