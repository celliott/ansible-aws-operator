.DEFAULT_GOAL:=help
SHELL:=/bin/bash
NAMESPACE=demo
IMAGE_TAG ?= v0.0.1
IMAGE=923133779345.dkr.ecr.us-east-1.amazonaws.com/ansible-aws-operator:$(IMAGE_TAG)

docker-build :
	operator-sdk build $(IMAGE)

docker-push :
	$$(aws ecr get-login --no-include-email)
	docker push $(IMAGE)

install-operator :
	@echo ....... Creating namespace .......
	- kubectl create namespace ${NAMESPACE}
	@echo ....... Applying CRDs .......
	- kubectl apply -f deploy/crds/ansible-aws.modaoperandi.com_dynamodb_crd.yaml -n ${NAMESPACE} --validate=false
	@echo ....... Applying Rules and Service Account .......
	- kubectl apply -f deploy/role.yaml -n ${NAMESPACE}
	- kubectl apply -f deploy/role_binding.yaml  -n ${NAMESPACE}
	- kubectl apply -f deploy/service_account.yaml  -n ${NAMESPACE}
	@echo ....... Applying Operator .......
	- kubectl apply -f deploy/operator.yaml -n ${NAMESPACE}

uninstall-operator :
	@echo ....... Uninstalling .......
	@echo ....... Deleting CRDs.......
	- kubectl delete -f deploy/crds/ansible-aws.modaoperandi.com_dynamodb_crd.yaml -n ${NAMESPACE}
	@echo ....... Deleting Rules and Service Account .......
	- kubectl delete -f deploy/role.yaml -n ${NAMESPACE}
	- kubectl delete -f deploy/role_binding.yaml -n ${NAMESPACE}
	- kubectl delete -f deploy/service_account.yaml -n ${NAMESPACE}
	@echo ....... Deleting Operator .......
	- kubectl delete -f deploy/operator.yaml -n ${NAMESPACE}

dynamodb :
	@echo ....... Creating the Database .......
	- kubectl apply -f deploy/crs/ansible-aws.modaoperandi.com_v1alpha1_dynamodb_cr.yaml -n ${NAMESPACE}

del-dynamodb :
	@echo ....... Deleting the Database .......
	- kubectl delete -f deploy/crs/ansible-aws.modaoperandi.com_v1alpha1_dynamodb_cr.yaml -n ${NAMESPACE}

.PHONY: help
help :
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
