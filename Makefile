NAMESPACE=kube-system
IMAGE_TAG ?= v0.0.2
IMAGE=027081542926.dkr.ecr.us-east-1.amazonaws.com/ansible-aws-operator:$(IMAGE_TAG)

ENVIRONMENT=sandbox
OIDC_PROVIDER=$$(aws eks describe-cluster --name ${ENVIRONMENT}-eks-cluster --query "cluster.identity.oidc.issuer" --output text | sed -e "s/^https:\/\///")

oidc :
	echo $(OIDC_PROVIDER)

docker-build :
	operator-sdk build $(IMAGE)

docker-push :
	$$(aws ecr get-login --no-include-email)
	docker push $(IMAGE)

set-namespace :
	kubectl config set-context --current --namespace=$(NAMESPACE)

deploy : set-namespace
	# kubectl apply -f deploy/crds/dynamodb_crd.yaml --validate=false
	# kubectl apply -f deploy/crds/s3bucket_crd.yaml --validate=false
	kubectl apply -f deploy/crds/iam_role_crd.yaml --validate=false
	kubectl apply -f deploy/role.yaml
	kubectl apply -f deploy/role_binding.yaml
	kubectl apply -f deploy/service_account.yaml
	kubectl apply -f deploy/operator.yaml

delete : set-namespace
	# kubectl delete -f deploy/crds/dynamodb_crd.yaml
	# kubectl delete -f deploy/crds/s3bucket_crd.yaml
	kubectl delete -f deploy/crds/iam_role_crd.yaml
	kubectl delete -f deploy/role.yaml
	kubectl delete -f deploy/role_binding.yaml
	kubectl delete -f deploy/service_account.yaml
	kubectl delete -f deploy/operator.yaml

dynamodb : set-namespace
	kubectl apply -f deploy/crs/dynamodb_cr.yaml

del-dynamodb : set-namespace
	kubectl delete -f deploy/crs/dynamodb_cr.yaml

s3bucket : set-namespace
	kubectl apply -f deploy/crs/s3bucket_cr.yaml

del-s3bucket : set-namespace
	kubectl delete -f deploy/crs/s3bucket_cr.yaml

iam-role : set-namespace
	kubectl apply -f deploy/crs/iam_role_cr.yaml

del-iam-role : set-namespace
	kubectl delete -f deploy/crs/iam_role_cr.yaml

iam-role-local :
	ansible-playbook iam_role.yml
