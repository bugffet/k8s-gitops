#!/bin/sh

rm -rf lke-cluster-config.yaml

sleep 30

export KUBE_VAR=$(cat terraform.tfstate | jq -r .outputs.kubeconfig.value) && echo $KUBE_VAR | base64 -d > lke-cluster-config.yaml
export KUBECONFIG=$(pwd)/lke-cluster-config.yaml
chmod 400 lke-cluster-config.yaml