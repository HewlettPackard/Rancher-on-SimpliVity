script_dir=$(dirname $0)
. ${script_dir}/vars.rc

kubectl apply -f sc.yaml
