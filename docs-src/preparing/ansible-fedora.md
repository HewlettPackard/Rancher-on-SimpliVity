# Create the Ansible node on Fedora


It is recommended that you deploy the Ansible controller on Fedora, to take advantage of the built-in support for
Python 3. The solution requires Fedora 31 and Ansible 2.9.5. It may be possible to run the playbooks
on other operating systems including RHEL and CentOS but
the playbooks have only been tested on Fedora. In addition to Python 3 and Ansible 2.9.5, a number of other packages
must be also be installed, as outlined below.

The playbooks should be run from a non-privileged account - in the subsequent instructions, a user named `rancher` will be used.

## Create the Fedora VM

Create a Virtual Machine with the following characteristics:

- **Guest OS:** Red Hat Fedora Server 31 (64-bit)
- **Disk:** 50G (thin provisioning)
- **CPU:** 2
- **RAM:** 4 GB
- **Ethernet Adapter:** VMXNET3, connected to your Ansible or management network

Install Fedora Server 31 using the x64 64-bit ISO image.
In the `Software Selection` section, choose:

- **Base Environment:** Fedora Server Edition
- **Add-Ons for Selected Environment:** Guest Agent

Select your language, keyboard layout, and timezone settings and re-boot when the installation finishes. Configure your networking and check your connectivity before moving on to the next section.


## Password-less sudo

Configure password-less `sudo` for the `rancher` user on the Ansible controller node by logging in
as `root` and issuing the command:

```
$ usermod -a -G wheel rancher
```

The default `/etc/sudoers` file contains two lines for the group `wheel`. As the root user, run `visudo` to uncomment
the %wheel line containing the string `NOPASSWD:` and comment out the other %wheel line. When you are done,
it should look like this:

```
## Allows people in group wheel to run all commands
#%wheel ALL=(ALL)       ALL

## Same thing without a password
%wheel ALL=(ALL)       NOPASSWD: ALL
```

The advantage of using `visudo` is that it will validate the changes to the file.


## Install Ansible and required modules

Log in to the Ansible controller node as the `rancher` user and run the following commands to install `git`, `ansible`
and the required Python dependencies:

```
$ sudo dnf update -y --exclude=ansible
$ sudo dnf install -y git ansible python3-netaddr python3-requests python3-pyvmomi
```



