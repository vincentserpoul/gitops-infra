.PHONY: init

init:
	@read -p "Enter Project Name: " PROJECT_NAME; \
	doctl kubernetes cluster create do-$$PROJECT_NAME \
	--count=5 --size=s-2vcpu-4gb --region=sgp1 --ha \
	--auto-upgrade --wait --set-current-context 

registry/create:
	@read -p "Enter Project Name: " PROJECT_NAME; \
	doctl registry create --region=sgp1 --subscription-tier=starter $$PROJECT_NAME && \
	doctl registry login $$PROJECT_NAME && \
	doctl kubernetes cluster registry add do-$$PROJECT_NAME


	