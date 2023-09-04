#!/usr/bin/env bash

serving_version="knative-v1.11.0"
eventing_version="knative-v1.11.1"
serving_net_istio_version="knative-v1.11.0"
cert_manager_version="v1.3.0"
kserve_version="v0.11.0"

output_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
knative_output_dir="${output_dir}/knative"
cert_manager_output_dir="${output_dir}/certmanager"
kserve_output_dir="${output_dir}/kserve"

rm -rf "${knative_output_dir}" "${cert_manager_output_dir}" "${kserve_output_dir}"
mkdir -p "${knative_output_dir}"
mkdir -p "${cert_manager_output_dir}"
mkdir -p "${kserve_output_dir}"

wget "https://github.com/knative/serving/releases/download/${serving_version}/serving-crds.yaml" -O "${knative_output_dir}/100-serving-crds.yaml"
wget "https://github.com/knative/serving/releases/download/${serving_version}/serving-core.yaml" -O "${knative_output_dir}/200-serving-core.yaml"
wget "https://github.com/knative-extensions/net-istio/releases/download/${serving_net_istio_version}/net-istio.yaml" -O "${knative_output_dir}/300-net-istio.yaml"

wget "https://github.com/knative/eventing/releases/download/${eventing_version}/eventing-crds.yaml" -O "${knative_output_dir}/100-eventing-crds.yaml"
wget "https://github.com/knative/eventing/releases/download/${eventing_version}/eventing-core.yaml" -O "${knative_output_dir}/200-eventing-core.yaml"
wget "https://github.com/knative/eventing/releases/download/${eventing_version}/mt-channel-broker.yaml" -O "${knative_output_dir}/200-mt-channel-broker.yaml"
wget "https://github.com/knative/eventing/releases/download/${eventing_version}/in-memory-channel.yaml" -O "${knative_output_dir}/200-in-memory-channel.yaml"

wget "https://github.com/jetstack/cert-manager/releases/download/${cert_manager_version}/cert-manager.yaml" -O "${cert_manager_output_dir}/100-cert-manager.yaml"

wget "https://github.com/kserve/kserve/releases/download/${kserve_version}/kserve.yaml" -O "${kserve_output_dir}/100-kserve.yaml"
