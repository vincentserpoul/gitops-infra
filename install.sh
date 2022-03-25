#!/bin/bash

set -eou pipefail

cd local-cluster-init/k3d
make init
cd ../../runtime

sleep 10

make init
cd env/overlays/dev
make init
cd ../../..
make apply-all || echo 'expected error as the jaeger CRD is not yet created'
sleep 10

make apply-all
