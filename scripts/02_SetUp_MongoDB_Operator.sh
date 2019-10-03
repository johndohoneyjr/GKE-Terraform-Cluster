#! /bin/bash

git clone https://github.com/mongodb/mongodb-enterprise-kubernetes.git
#
kubectl create namespace mongodb

# So to make Helm compatible with any existing chart, binding the cluster-admin to the tiller 
# Service Account is the best option.  

Deploy=tiller-clusterrolebinding.yaml
(
cat <<'ADDTEXT4'
apiVersion: v1
kind: ServiceAccount
metadata:
  name: helm
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: helm
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: helm
    namespace: kube-system
ADDTEXT4
) > $Deploy

kubectl apply -f tiller-clusterrolebinding.yaml

# Update the existing tiller-deploy deployment with the Service Account created earlier

helm init --service-account helm

sleep 3

# Did RBAC work>
helm ls


helm template ./mongodb-enterprise-kubernetes/helm_chart > operator.yaml
