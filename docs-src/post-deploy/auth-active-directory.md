# Active Directory Integration

Rancher supports multiple methods of authentication, one of which is integrating with Microsoft Active Directory services.

## Configuring Active Directory Variables

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
$ cd ~/Rancher-on-SimpliVity
$ ansible-playbook -i hosts playbooks/ad-auth.yml --vault-password-file .vault_pass
```

### Active Directory Verification

Access the Rancher GUI and access the `Security -> Authentication` menu option to verify the `Active Directory` Authentication method is enabled.
