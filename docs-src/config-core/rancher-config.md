# Admin cluster and Rancher server configuration

The playbooks deploy an admin cluster and a separate user cluster. The user cluster
is deployed from the Rancher server installed on the admin cluster and the configuration for the user cluster is
documented [here](rancher-user-config).


The nodes in the admin cluster are determined by the
entries in the `hosts` file and are provisioned by the playbooks based on the configuration in this section.


General configuration variables are shown in the table below:

|Variable|File|Description|
|:-------|:---|:----------|
|`cluster_name`|group_vars/all/vars.yml|Name of the K8S admin cluster|
|`admin_folder`|group_vars/all/vars.yml|Folder and pool name for Rancher admin cluster VMs and templates|
|`admin_template`|group_vars/all/vars.yml|Name for the admin template|


If the `admin_template` already exists, it is used when provisioning the VMs for the admin cluster and
the load balancers. Otherwise, this template is created from the default Ubuntu OVA
specified in the file `playbooks/roles/kits/tasks/main.yml` and then used when provisioning the VMs.


## Rancher configuration

Rancher configuration is specified using the `rancher` dictionary element in the `group_vars/all/vars.yml` file:


|Variable|File|Description|
|:-------|:---|:----------|
|`rancher.url`|group_vars/all/vars.yml|FQDN at which Rancher Server can be reached|
|`rancher.hostname`|group_vars/all/vars.yml|Usually the same FQDN as the one in `rancher.url` but not necessarily|
|`rancher.validate_certs`|group_vars/all/vars.yml|`False`|
|`rancher.apiversion`|group_vars/all/vars.yml|Playbooks designed for v3 of the API|
|`rancher.engineInstallURL`|group_vars/all/vars.yml|Location of script for installing Docker on all node templates|


An example `rancher` structure is shown below:

```
rancher:
  url: https://lb1.hpe.org
  hostname: lb1.hpe.org
  validate_certs: False
  apiversion: v3
  engineInstallURL: 'https://releases.rancher.com/install-docker/19.03.sh'
```

## SSL/TLS configuration

Rancher Server is designed to be secure by default and requires SSL/TLS configuration. There are three options for the source of the certificates:

1. Rancher Generated Certificates
2. Let's Encrypt
3. Certificates from Files

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

If you want to supply your own certificates, you need to set `rancher.tls_source` to `secret` and let the playbooks know where to find your certificates as shown in the example below:

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

The `rancher.tls_privateCA` variable is set to `true` if the certificates are signed by a private root Certificate Authority (root CA). In this case, you need to supply the certificate of the root CA using `rancher.tls_cacert_file`. In the example above, the root CA certificate was stored in `/home/core/certs/cacerts.pem`. Note that all certificates use the PEM format.

The certificate and key that the Rancher Server should used is specified with the variables `rancher.tls_certchain_file` and `rancher.tls_certkey_file`. These variables should be configured with the names of the files that contain the SSL certificate and key that the Rancher Server should use. Note that the file designated by `rancher.tls_certchain_file` contains the certificate of the Rancher Server itself, followed by the certificates of intermediate CAs if any.