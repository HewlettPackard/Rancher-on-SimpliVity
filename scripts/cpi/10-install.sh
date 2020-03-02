cat >/tmp/vsphere.conf <<EOF
[Global]
insecure-flag = "true"

[VirtualCenter "vcentergen10.am2.cloudra.local"]
user = "Administrator@vsphere.local"
password = "Just4m\$hpe20!8"
port = "443"
datacenters = "DEVOPS"

[Network]
public-network = "clh2964"
EOF

rancher kubectl delete configmap cloud-config -n kube-system 
rancher kubectl create configmap cloud-config --from-file=/tmp/vsphere.conf -n kube-system
rancher kubectl apply -f cpi/cloud-controller-manager-roles.yaml
rancher kubectl apply -f cpi/cloud-controller-manager-role-bindings.yaml
rancher kubectl apply -f cpi/vsphere-cloud-controller-manager-ds.rancher.yaml


cat >/tmp/csi-vsphere.conf <<EOF
[Global]
cluster-id = "ClusterClh2964"
[VirtualCenter "vcentergen10.am2.cloudra.local"]
insecure-flag = "true"
user = "Administrator@vsphere.local"
password = "Just4m\$hpe20!8"
port = "443"
datacenters = "DEVOPS"
EOF


rancher kubectl delete secret vsphere-config-secret -n kube-system
rancher kubectl create secret generic vsphere-config-secret --from-file=/tmp/csi-vsphere.conf --namespace=kube-system


rancher kubectl apply -f csi/csi-driver-rbac.yaml
rancher kubectl apply -f csi/vsphere-csi-controller-ss.yaml
rancher kubectl apply -f csi/vsphere-csi-node-ds.yaml



rancher kubectl describe csinode
