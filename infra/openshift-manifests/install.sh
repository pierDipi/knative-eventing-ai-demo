#!/usr/bin/env bash

current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
manifests_dir="${current_dir}/../kind-manifests"

kubectl apply -k "${current_dir}"
