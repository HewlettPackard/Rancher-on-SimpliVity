setfile=$(mktemp)
cat <<EOF >${setfile}
hostname: lb1.clh.org
proxy: http://10.12.7.21:8080
noProxy: 127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.am2.cloudra.local,.clh.org,10.15.152.0/24
EOF

helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --values=${setfile} 

kubectl -n cattle-system rollout status deploy/rancher
