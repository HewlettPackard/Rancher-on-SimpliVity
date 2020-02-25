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
