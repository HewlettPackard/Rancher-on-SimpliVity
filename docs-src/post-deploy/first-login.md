# Log in to the Rancher server

Once the `site.yml` playbook has run successfully to completion, you can log in to the Rancher server using the URL you
specified in the file `group_vars/all/vars.yml`


```
rancher:
  url: https://rancher.gmcg-rancher.org
```

The username is `admin` and the password is the value of the variable `vault_rancher_password` from your `vault` file. 
The following image shows the initial login screen:



!["Rancher login"][rancher-login-png]

**Figure. Rancher login**

<br><br>


A list of all the managed clusters is displayed, including the admin cluster (in this case, named `local`) and the user cluster (`api`).



!["Initial clusters"][initial-clusters-png]

**Figure. Initial clusters**

<br><br>

Select the admin cluster and choose to display the nodes:



!["Admin cluster nodes"][admin-nodes-png]

**Figure. Admin cluster nodes**



[rancher-login-png]:<../images/rancher-login.png> "Figure. Rancher login"
[initial-clusters-png]:<../images/initial-clusters.png> "Figure. Initial clusters"
[admin-nodes-png]:<../images/admin-nodes.png> "Figure. Admin cluster nodes"