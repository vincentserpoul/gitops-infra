.PHONY: init init-ingress dns-update config-update

include prod.env

export

# Public IP address
IP = $(shell kubectl get svc ingress-nginx-controller -n ingress-nginx --output jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Get the resource-id of the public ip
PUBLICIPID=$(shell az network public-ip list --query "[?ipAddress!=null]|[?contains(ipAddress, '$(IP)')].[id]" --output tsv)
# 


init: az network public-ip update --ids $(PUBLICIPID) --dns-name $(DNSNAME)
