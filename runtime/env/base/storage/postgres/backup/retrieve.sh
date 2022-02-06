#!/bin/bash

set -euo pipefail

kubectl apply -f ./retriever.yaml
kubectl wait pod/retriever -n postgres --for condition=ready

kubectl -n postgres cp retriever:/backup/ ./

# kubectl -n postgres exec -it retriever tar -C /backup/ --create --listed-incremental=./ -vv --file=- . | tar -xvf - /backup

kubectl delete -f ./retriever.yaml
