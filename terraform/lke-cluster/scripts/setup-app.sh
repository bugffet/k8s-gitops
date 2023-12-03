#!/bin/sh

#sleep 300

EXPECT_NODES=2
NODES=$(kubectl get nodes | grep "Ready" -c)

RETRY=0
MAX_RETRY=10

while [ $NODES != $EXPECT_NODES ]
do
  RETRY=$(( $RETRY + 1 ))

  if [ $RETRY = $MAX_RETRY ]
  then
    exit 1
  fi

  echo "Nodes Expect: $EXPECT_NODES, Nodes Result: $NODES , Retry Times: $RETRY"
  sleep 3
done

cd ../../
kubectl apply -k argocd
kubectl apply -k apps/overlays/production

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx

#argocd login localhost:8080
