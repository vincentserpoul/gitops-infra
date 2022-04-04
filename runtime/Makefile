.PHONY: init release-commit context-select manifest-apply encrypted-manifests-apply manifest-kustomize-build create-password create-yaml-from-file encrypt-yaml

ENV?=dev

include env/base/base.env
include env/overlays/$(ENV)/$(ENV).env

export

apply-all: context-select encrypted-manifests-apply manifest-kustomize-build manifest-apply 

########
# INIT #
########

# init: context-select install-crds age-keygen init-db-password

init: context-select install-crds age-keygen ca-init
	
install-crds: install-crds-cert-manager install-crds-kubegres install-crds-nats-nack install-flux
	
install-flux: 
	flux install
	
###########
# HELPERS #
###########

release-commit:
	git commit -m "manifest build and deploy $(IMAGE_NAME) to $(ENV)" ./manifests/*

context-select:
	kubectl config use-context $(K8S_CONTEXT)

############
# MANIFEST #
############

MANIFEST_FOLDER = ./manifests/$(ENV)
MANIFEST_FILE_PATH = $(MANIFEST_FOLDER)/cluster.yaml

manifest-apply:
	kubectl apply -f $(MANIFEST_FILE_PATH)

encrypted-manifests-apply: $(MANIFEST_FOLDER)/*.enc.yaml
	@for ENC_FILE in $^ ; do \
		SOPS_AGE_KEY_FILE="./env/overlays/$(ENV)/key.age" sops --decrypt $${ENC_FILE} | kubectl apply -f -; \
		echo "$${ENC_FILE} applied"; \
	done

manifest-kustomize-build:
	kubectl kustomize ./env/overlays/$(ENV) > $(MANIFEST_FILE_PATH)

################
# cert manager #
################

install-crds-cert-manager:
	kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.7.2/cert-manager.crds.yaml

############
# POSTGRES #
############

install-crds-kubegres:
	kubectl apply -f https://raw.githubusercontent.com/reactive-tech/kubegres/v1.15/kubegres.yaml

init-db-password: create-password create-yaml-from-file encrypt-yaml

create-password:
	@printf "Enter pass for postgres db: "; read -rs DB_PASSWORD && \
	printf $${DB_PASSWORD} > env/overlays/$(ENV)/storage/postgres/secrets/.db_password

create-yaml-from-file:
	sed \
		-e "s/DB_PASSWORD/$(shell cat env/overlays/$(ENV)/storage/postgres/secrets/.db_password)/g" \
		env/base/storage/postgres/secrets/secret-tmpl.yaml \
	> env/overlays/$(ENV)/storage/postgres/secrets/secret.yaml

encrypt-yaml:
	sops --encrypt --encrypted-regex '^(data|stringData)$$' \
		--age $(AGE_RECIPIENTS) env/overlays/$(ENV)/storage/postgres/secrets/secret.yaml \
		> ./manifests/$(ENV)/secret.enc.yaml

###############
# COCKROACHDB #
###############

# https://github.com/fluxcd/flux2/issues/2563
# https://github.com/cockroachdb/helm-charts/issues/234
tmp-install-cockroachdb:
	helm repo add cockroachdb https://charts.cockroachdb.com/ && \
	helm repo update && \
	helm install -f env/overlays/$(ENV)/storage/cockroachdb/values.yaml \
		cockroachdb cockroachdb/cockroachdb -n cockroachdb

create-crdb-password:
	@printf "Enter pass for cockroach db: "; read -rs DB_PASSWORD && \
	kubectl exec -it cockroachdb-0 \
		-- ./cockroach sql \
		--certs-dir=/cockroach-certs \
		--host=cockroachdb-cockroachdb-public \
	SELECT 1

##############
# encryption #
##############

age-keygen:
	@test -f ./env/overlays/$(ENV)/key.pub || \
	( \
	age-keygen > ./env/overlays/$(ENV)/key.age && \
	cat ./env/overlays/$(ENV)/key.age | sed -n -e 's/^.*# public key: //p' > ./env/overlays/$(ENV)/key.pub && \
	echo "please add this key to your AGE_RECIPIENTS in ./env/overlays/$(ENV)/$(ENV).env" \
	)

########
# nats #
########

install-crds-nats-nack:
	kubectl apply -f https://raw.githubusercontent.com/nats-io/nack/v0.6.0/deploy/crds.yml

######
# CA #
######

CAROOT = $(shell mkcert -CAROOT)

ca-init: ca-create-ca-key-pair ca-encrypt-yaml

ca-create-ca-key-pair: ca-create-namespace
	mkcert --install &&\
	kubectl -n cert-manager create secret tls ca-key-pair \
		--key="$(CAROOT)/rootCA-key.pem" \
		--cert="$(CAROOT)/rootCA.pem" \
		--dry-run=client -o yaml >> ./env/overlays/$(ENV)/certs/tls.yaml

ca-create-namespace:
	kubectl create namespace cert-manager --dry-run=client -o yaml > ./env/overlays/$(ENV)/certs/tls.yaml &&\
	echo "---" >> ./env/overlays/$(ENV)/certs/tls.yaml

ca-encrypt-yaml:
	sops --encrypt --encrypted-regex '^(data|stringData)$$' \
		--age $(AGE_RECIPIENTS) ./env/overlays/$(ENV)/certs/tls.yaml \
		> ./manifests/$(ENV)/tls.enc.yaml