#!/usr/bin/env bash

set -xe

current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
manifests_dir="${current_dir}/kind-manifests"

export ISTIO_VERSION=1.17.2

kind delete cluster --name knative-ai-demo
kind create cluster --name knative-ai-demo --config "${manifests_dir}/kind/cluster.yaml"

kubectl cluster-info --context kind-knative-ai-demo

# Install Istio
curl -L https://istio.io/downloadIstio | sh -
kubectl apply -f "${manifests_dir}/istio/100-namespace.yaml"
./istio-${ISTIO_VERSION}/bin/istioctl manifest apply -f "${manifests_dir}/istio/200-istio-minimal-operator.yaml" -y

rm -rf ./istio-${ISTIO_VERSION}

# Install cert-manager
kubectl apply -f "${manifests_dir}/certmanager"

# Install Knative
# Retry 2 times since it fails since apply is async
kubectl apply -f "${manifests_dir}/knative" || kubectl apply -f "${manifests_dir}/knative"

kubectl patch configmap/config-domain \
  --namespace knative-serving \
  --type merge \
  --patch '{"data":{"127.0.0.1.sslip.io":""}}'

kubectl wait --for=condition=ready --timeout=10m -n cert-manager pod -l=app.kubernetes.io/instance=cert-manager

# Install Kserve
kubectl apply -f "${manifests_dir}/kserve"

# Install postgres, documentation at https://github.com/bitnami/charts/tree/main/bitnami/postgresql/
kubectl apply -f "${manifests_dir}/postgresql/100-namespace.yaml"
helm install postgresql oci://registry-1.docker.io/bitnamicharts/postgresql --namespace postgresql

# Install superset, documentation at https://superset.apache.org/docs/installation/running-on-kubernetes/
kubectl apply -f "${manifests_dir}/superset/100-namespace.yaml"
helm repo add superset https://apache.github.io/superset
helm install superset superset/superset --namespace superset

# Install Ceph
helm repo add rook https://charts.rook.io/release
helm install --create-namespace --namespace rook-ceph rook-ceph rook/rook-ceph
kubectl wait --for=condition=ready --timeout=10m -n rook-ceph pod -l=app=rook-ceph-operator
kubectl apply -f "${manifests_dir}/ceph/"

sleep 30 # Wait to avoid getting "no resources found"

# Wait for components to become ready
kubectl wait --for=condition=ready --timeout=10m -n knative-serving pod -l=app.kubernetes.io/name=knative-serving
kubectl wait --for=condition=ready --timeout=10m -n knative-eventing pod -l=app.kubernetes.io/name=knative-eventing
kubectl wait --for=condition=ready --timeout=10m -n kserve pod -l=control-plane=kserve-controller-manager
kubectl wait --for=condition=Ready --timeout=10m cephcluster -n rook-ceph my-cluster

postgres_password=$(kubectl get secret --namespace postgresql postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)
echo "Connection string"
echo "postgresql://postgres:${postgres_password}@postgresql.postgresql.svc.cluster.local:5432/postgres"
