#requires proxy
. ~/proxy.rc
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
kubectl create namespace cattle-system

# Install the CustomResourceDefinition resources separately
kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.12/deploy/manifests/00-crds.yaml

# **Important:**
# If you are running Kubernetes v1.15 or below, you will need to add the `--validate=false flag to your kubectl apply command above else you will receive a validation error relating to the x-kubernetes-preserve-unknown-fields field in cert-manager’s CustomResourceDefinition resources. This is a benign error and occurs due to the way kubectl performs resource validation.

# Create the namespace for cert-manager
kubectl create namespace cert-manager

# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v0.12.0

kubectl -n cert-manager rollout status deploy/cert-manager
kubectl -n cert-manager rollout status deploy/cert-manager-cainjector
kubectl -n cert-manager rollout status deploy/cert-manager-webhook

setfile=$(mktemp)
cat <<EOF >${setfile}
hostname: lb1.hpe.org
proxy: http://10.12.7.21:8080
noProxy: 127.0.0.0/8,10.0.0.0/8,.am2.cloudra.local,.hpe.org
EOF

helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --values=${setfile} 

kubectl -n cattle-system rollout status deploy/rancher
