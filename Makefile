
IMAGE_NAME = s2i-apb-builder

SHELL = bash

.PHONY: build
build:
	@echo  " ---> wget 'config', 'oc-login.sh', 'entrypoint.sh' from apb-examples/apb-base repo"
	@wget -q -N https://raw.githubusercontent.com/fusor/apb-examples/master/apb-base/config 
	@wget -q -N https://raw.githubusercontent.com/fusor/apb-examples/master/apb-base/entrypoint.sh 
	@wget -q -N https://raw.githubusercontent.com/fusor/apb-examples/master/apb-base/oc-login.sh 
	@chmod +x *.sh
	docker build -t $(IMAGE_NAME) .
	@rm -f config entrypoint.sh oc-login.sh

.PHONY: test
test:
	docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run
