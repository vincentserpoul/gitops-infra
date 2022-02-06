.PHONY: init create-ca-key-pair create-namespace encrypt-yaml

include dev.env

export

CAROOT = $(shell mkcert -CAROOT)

init: create-ca-key-pair encrypt-yaml

create-ca-key-pair: create-namespace
	mkcert --install &&\
	kubectl -n cert-manager create secret tls ca-key-pair \
		--key="$(CAROOT)/rootCA-key.pem" \
		--cert="$(CAROOT)/rootCA.pem" \
		--dry-run=client -o yaml >> certs/tls.yaml

create-namespace:
	kubectl create namespace cert-manager --dry-run=client -o yaml > certs/tls.yaml &&\
	echo "---" >> certs/tls.yaml

encrypt-yaml:
	sops --encrypt --encrypted-regex '^(data|stringData)$$' \
		--age $(AGE_RECIPIENTS) certs/tls.yaml \
		> ../../../manifests/dev/tls.enc.yaml