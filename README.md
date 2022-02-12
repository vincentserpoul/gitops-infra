## Requirements

- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [helm](https://helm.sh/docs/intro/install/)
- [flux](https://fluxcd.io/docs/installation/)
- [mkcert](https://github.com/FiloSottile/mkcert)
- [sops](https://github.com/mozilla/sops)
- [age](https://github.com/FiloSottile/age)

## Setup a local cluster

[README](./local-cluster-init/)

## Set runtime components

[README](./runtime/)

## Add tracing

[README](./tracing/)

## TO DO

- [x] nats jetstream
- [ ] simple app example
- [ ] run Kube-score, regula, popeye, polaris on the configs/cluster
- [ ] realtime from supabase for pg updates
- [ ] pgcat in front of the cluster?
- [ ] gitcliff changelog
- [ ] pixie?