rancher kubectl describe CSINode
rancher kubectl get pods --namespace=kube-system -o wide
rancher kubectl describe nodes | grep ProviderID
rancher kubectl describe nodes | egrep "Taints:|Name:"
