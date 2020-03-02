script_dir=$(dirname $0)
. ${script_dir}/vars.rc

rancher kubectl apply -f sc.yaml
