# Introduction

The following section covers some common post-deployment tasks and validation.

- Accessing the clusters
- Logging into the Rancher cluster for the first time
- Deploying a sample application


## Accessing the admin cluster

A `kubeconfig` file contains the credentials necessary to access your admin cluster with `kubectl`.

The installation should have created a `kubeconfig` file named `~/.svtrancher/kube_config_rancher-cluster.yml`. This file has the credentials for `kubectl` and `helm`.

```
$ export KUBECONFIG=~/.svtrancher/kube_config_rancher-cluster.yml
```

Test your connectivity with `kubectl` and see if all your nodes in the admin cluster are in Ready state:

```
$ kubectl get nodes

NAME           STATUS   ROLES                      AGE    VERSION
10.15.163.91   Ready    controlplane,etcd,worker   6d1h   v1.17.2
10.15.163.92   Ready    controlplane,etcd,worker   6d1h   v1.17.2
10.15.163.93   Ready    controlplane,etcd,worker   6d1h   v1.17.2
```


## Accessing the user cluster

A `kubeconfig` file will have been created for the user cluster in the installation folder. The filename starts with `kube_config.` and contains the user cluter name followed by a unique identifier:


```
$ export KUBECONFIG=~/.svtrancher/kube_config.gmcg-user.c-t2h6g
```

Test your connectivity to the user cluster  with kubectl and see if all your nodes in the use cluster are in Ready state:

```
kubectl get nodes

NAME        STATUS   ROLES               AGE   VERSION
gmcg-mas1   Ready    controlplane,etcd   6d    v1.17.2
gmcg-wrk1   Ready    worker              6d    v1.17.2
gmcg-wrk2   Ready    worker              6d    v1.17.2
```

