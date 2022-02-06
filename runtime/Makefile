.PHONY: init release-commit context-select manifest-apply encrypted-manifests-apply manifest-kustomize-build create-password create-yaml-from-file encrypt-yaml

ENV?=dev

include env/base/base.env
include env/overlays/$(ENV)/$(ENV).env

export

apply-all: context-select encrypted-manifests-apply manifest-kustomize-build manifest-apply 

########
# INIT #
########

init: context-select install-crds init-db-password age-keygen
	
install-crds: install-crds-cert-manager install-crds-kubegres install-crds-nats install-flux
	
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
	kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.7.0/cert-manager.crds.yaml

######
# DB #
######

install-crds-kubegres:
	kubectl apply -f https://raw.githubusercontent.com/reactive-tech/kubegres/v1.15/kubegres.yaml

init-db-password: create-password create-yaml-from-file encrypt-yaml

create-password:
	@read -p "Enter pass for db: " DB_PASSWORD &&\
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

##############
# encryption #
##############

age-keygen:
	@test -f ./env/overlays/$(ENV)/key.age || \
	( \
	age-keygen > ./env/overlays/$(ENV)/key.age && \
	cat ./env/overlays/$(ENV)/key.age | sed -n -e 's/^.*# public key: //p' > ./env/overlays/$(ENV)/key.pub && \
	echo "please add this key to your AGE_RECIPIENTS in ./env/overlays/$(ENV)/$(ENV).env" \
	)


########
# nats #
########

install-crds-nats:
	kubectl apply -f https://raw.githubusercontent.com/nats-io/nack/v0.6.0/deploy/crds.yml