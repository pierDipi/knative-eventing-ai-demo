#!/usr/bin/env bash

current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
manifests_dir="${current_dir}/../kind-manifests"

while ! kubectl apply -k ${current_dir}
do
  echo "waiting for resource apply to succeed"
  sleep 10
done

# kubectl port-forward -n minio-operator svc/minio 9445:443 # port-forward minio store
# mc alias set ai-demo https://localhost:9445 minio minio1234 --insecure # set a minio host alias
# kubectl port-forward -n minio-operator svc/minio-tenant-console 9444:9443 # port-forward tenant console (login with credentials in minio-storage-configuration.yaml)
# mc mb ai-demo/ai-demo --insecure # Create bucket 'ai-demo'
# mc event add ai-demo/ai-demo arn:minio:sqs::PRIMARY:webhook --event put --insecure #
# mc admin config set ai-demo/ notify_webhook:PRIMARY endpoint="http://event-display.ai-demo.svc.cluster.local:80" --insecure