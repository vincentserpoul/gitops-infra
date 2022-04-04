.PHONY: init

init:
	@read -p "Enter Project Name: " PROJECT_NAME; \
	doctl kubernetes cluster create do-$$PROJECT_NAME \
	--count=5 --size=s-2vcpu-4gb --region=sgp1 --ha \
	--auto-upgrade --wait --set-current-context 

registry-create:
	doctl registry create --region=sgp1 --subscription-tier=starter gitops && \
	doctl registry login gitops