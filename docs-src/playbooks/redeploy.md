# Redeployment


The playbook `playbooks/clean.yml` is a convenience playbook for stripping down a cluster. This can be very useful
in a proof-of-concept environment, where you may want to regularly tear down and re-deploy your test cluster.

- Set the value of the variable `delete_templates` to `false` if you don't want your templates to be deleted
- Run the playbook `playbooks/clean.yml`:

    ```
    $ cd ~/Rancher-on-SimpliVity
    
    $ ansible-playbook -i hosts playbooks/clean.yml --vault-password-file .vault_pass
    ```

The playbook will delete VMs and templates.
