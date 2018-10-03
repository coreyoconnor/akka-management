#!/bin/bash

set -exu

sbt bootstrap-demo-kubernetes-api/docker:publishLocal

kubectl apply -f bootstrap-demo/kubernetes-api/kubernetes/akka-cluster.yml

sleep 20

kubectl get pods

POD=$(kubectl get pods | grep appka | grep Running | head -n1 | awk '{ print $1 }')

TRY=0

until [ $TRY -ge 10 ]
do
  echo "Checking for MemberUp logging..."
  kubectl logs $POD | grep MemberUp
  [ `kubectl logs $POD | grep MemberUp | wc -l` -eq 2 ] && break
  sleep 3
done

if [ $TRY -eq 10 ]
then
  exit -1
fi
