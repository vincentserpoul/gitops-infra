## Requirements

- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [helm](https://helm.sh/docs/intro/install/)
- [flux](https://fluxcd.io/docs/installation/)
- [mkcert](https://github.com/FiloSottile/mkcert)
- [sops](https://github.com/mozilla/sops)
- [age](https://github.com/FiloSottile/age)

## Setup a local cluster

[README](./cluster-init/)

## Set runtime components

[README](./runtime/)

## Add tracing

[README](./tracing/)

## TO DO

- [x] nats jetstream
- [x] run Kube-score ✅, regula ✅, popeye (bugged for latest k8s, to rerun), polaris ✅ on the configs/cluster
- [x] [app examples](https://github.com/vincentserpoul/gitops-example)
- [ ] realtime from supabase for pg updates
- [ ] test pgcat in front of the cluster?
- [ ] gitcliff changelog
- [ ] pixie

## Domains for cloud clusters

### Freenom

Get a .tk free domain name!