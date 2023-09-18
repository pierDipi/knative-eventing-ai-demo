#!/usr/bin/env bash

current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
manifests_dir="${current_dir}/../kind-manifests"

while ! kubectl apply -k ${current_dir}
do
  echo "waiting for resource apply to succeed"
  sleep 10
done
