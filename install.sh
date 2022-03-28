#!/bin/bash

set -eou pipefail

cd local-cluster-init/k3d
make init
cd ../../runtime

sleep 15

make init
cd env/overlays/dev
make init
cd ../../..
make apply-all

sleep 30

# we need to run that later on, as we need jaeger-operator to be avail
kubectl apply -f runtime/env/base/observability/jaeger/jaegertracing.yaml

# we need to run that later on, as we need cert-manager to be avail
kubectl apply -f runtime/env/base/storage/cockroachdb/helm-release.yaml