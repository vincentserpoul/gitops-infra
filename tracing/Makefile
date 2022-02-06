.PHONY: init install-linkerd install-linkerd-jaeger install-linkerd-viz

init: install-linkerd install-linkerd-jaeger patch-postgres-cronjob
	
install-linkerd:
	linkerd install | kubectl apply -f - &&\
	linkerd check

install-linkerd-jaeger:
	linkerd jaeger install | kubectl apply -f - &&\
	linkerd check

install-linkerd-viz:
	linkerd viz install | kubectl apply -f - &&\
	linkerd check

patch-postgres-cronjob:
	kubectl -n postgres patch cronjob backup-mypostgres -p '{"spec":{"jobTemplate":{"spec":{"template":{"metadata":{"annotations":{"linkerd.io/inject": "disabled"}}}}}}}'
