.PHONY: reset-db user-confirm

reset-db: user-confirm
	kubectl delete -f ./postgres.yaml && \
	kubectl delete -f ./backup.yaml && \
	kubectl delete -f https://raw.githubusercontent.com/reactive-tech/kubegres/v1.15/kubegres.yaml && \
	kubectl delete -f namespace.yaml

user-confirm:
	@kubectl config current-context
	@echo "Are you sure? [y/N]" && read ans && [ $${ans:-N} == y ]