#!/usr/bin/env bash

set -Eeuo pipefail

ENV="${ENV:-"dev"}"

case "$ENV" in
 prod) PROVIDER="digitalocean" ;;
    *) PROVIDER="k3d" ;;
esac

cd cluster-init/"${PROVIDER}"

make init

sleep 15

cd ../../runtime

make init

make apply-all

cd ..

sleep 30

# we need to run that later on, as we need jaeger-operator to be avail
kubectl apply -f ./runtime/env/base/observability/jaeger/jaegertracing.yaml

# we need to run that later on, as we need cert-manager to be avail
kubectl apply -f ./runtime/env/base/storage/cockroachdb/helm-release.yaml