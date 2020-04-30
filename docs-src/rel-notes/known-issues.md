# Known issues

Known issues in this release of Rancher on HPE SimpliVity:

- On rare occasions, the `playbooks/csi.yml` playbook encounters a timing issue when attempting to deploy the CSI storage driver for the user cluster. The error is most often seen at the step where the CSI Secret is being created. This timing issue only affects user clusters where the `user_cluster.csi` variable has been set to `true` as the `csi.yml` playbook makes no changes when this variable is set to `false`. In the event that the CSI playbook fails when attempting to create the CSI Secret, the recommendation is to run the playbook again manually via the command:

  `ansible-playbook -i hosts playbooks/csi.yml`

<!-- TODO Known issues -->

<!-- TODO https://github.com/rancher/rancher/issues/16213  
     Sometimes local cluster in HA setup takes about 10 mts to get to "Active" state. -->