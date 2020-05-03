# Proxy configuration


The Reference Configuration for Rancher on HPE SimpliVity
supports deploying Rancher in environments that require the use of a proxy to access the internet.
Configuration variables for the playbooks must be specified, while the Ansible controller itself must also
be properly configured.



## Proxy configuration variables

Proxy configuration is specified in the `proxy` dictionary variable and are described in the table below.

|Variable|File|Description|
|:-------|:---|:----------|
|`proxy.http`|group_vars/all/vars.yml|Hostname or IP address of the HTTP proxy server and the proxy port number separated by a colon. For example: "http://web-proxy.hpecloud.org:8080".<br><br>Mandatory if proxy support is required.|
|`proxy.https`|group_vars/all/vars.yml|Hostname or IP address of the HTTP proxy server and the proxy port number separated by a colon. Typically, this is identical to the `http_proxy` value.<br><br>Mandatory if proxy support is required.|
|`proxy.except`|group_vars/all/vars.yml|A comma-separated list of hostnames, IP addresses, or network ranges that should bypass the proxy server. The list should include: localhost, the configured domain name used to deploy the Rancher cluster, the DHCP subnet CIDR, and the vCenter hostname. <br><br>Mandatory if proxy support is required.|


A sample proxy configuration is provided in the file `group_vars/all/vars.yml.sample`:

```
#
# Proxy Configuration
#
proxy:
  http:  "http://10.12.7.21:8080/"
  https:  "http://10.12.7.21:8080/"
  except: "localhost,.am2.cloudra.local,.rancher-demo.org,10.15.155.0/24"
```