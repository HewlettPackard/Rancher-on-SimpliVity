# Protecting sensitive information

The Ansible `vault` file is used to protect any sensitive variables that should not appear in clear text in your
`group_vars/all/vars.yml` file. The vault file should be encrypted, requiring a password to be entered
before it can be read or updated.

A sample vault file is provided named `group_vars/all/vault.sample`. You can use this sample as a model for your own vault file. All variables in the vault are defined as keys inside a `vault` dictionary.


|Variable|File|Description|
|:-------|:---|:----------|
|`vault_vcenter_password`|**group_vars/all/vault.yml**|The password for the `vcenter_username` user|
|`vault_rancher_password`|**group_vars/all/vault.yml**|The password for the Rancher admin cluster|