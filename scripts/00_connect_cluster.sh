#! /bin/bash

#
# Configure KubeCtl
#
gcloud container clusters get-credentials k8s-cluster --zone us-west1-b --project dohoneydemos
#
# Set Up dashboard UI
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta4/aio/deploy/recommended.yaml

#
# Cluster Nodes Status
#
kubectl get nodes
