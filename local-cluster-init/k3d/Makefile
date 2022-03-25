.PHONY: init

init:
	@read -p "Enter Project Name: " PROJECT_NAME; \
	sed \
	-e "s/PROJECT_NAME/$$PROJECT_NAME/g" \
	./k3d.yaml > ./.k3d_$$PROJECT_NAME.yaml &&\
	k3d cluster create -c ./.k3d_$$PROJECT_NAME.yaml &&\
	sleep 60
