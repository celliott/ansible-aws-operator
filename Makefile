NAMESPACE=demo
IMAGE_TAG ?= v0.0.1
IMAGE=923133779345.dkr.ecr.us-east-1.amazonaws.com/ansible-aws-operator:$(IMAGE_TAG)

docker-build :
	operator-sdk build $(IMAGE)

docker-push :
	$$(aws ecr get-login --no-include-email)
	docker push $(IMAGE)

set-namespace :
	kubectl config set-context --current --namespace=$(NAMESPACE)

deploy : set-namespace
	kubectl apply -f deploy/crds/ansible-aws.modaoperandi.com_dynamodb_crd.yaml --validate=false
	kubectl apply -f deploy/crds/ansible-aws.modaoperandi.com_s3bucket_crd.yaml --validate=false
	kubectl apply -f deploy/role.yaml
	kubectl apply -f deploy/role_binding.yaml
	kubectl apply -f deploy/service_account.yaml
	kubectl apply -f deploy/operator.yaml

delete : set-namespace
	kubectl delete -f deploy/crds/ansible-aws.modaoperandi.com_dynamodb_crd.yaml
	kubectl delete -f deploy/crds/ansible-aws.modaoperandi.com_s3bucket_crd.yaml
	kubectl delete -f deploy/role.yaml
	kubectl delete -f deploy/role_binding.yaml
	kubectl delete -f deploy/service_account.yaml
	kubectl delete -f deploy/operator.yaml

dynamodb : set-namespace
	kubectl apply -f deploy/crs/ansible-aws.modaoperandi.com_v1alpha1_dynamodb_cr.yaml

del-dynamodb : set-namespace
	kubectl delete -f deploy/crs/ansible-aws.modaoperandi.com_v1alpha1_dynamodb_cr.yaml

s3bucket : set-namespace
	kubectl apply -f deploy/crs/ansible-aws.modaoperandi.com_v1alpha1_s3bucket_cr.yaml

del-s3bucket : set-namespace
	kubectl delete -f deploy/crs/ansible-aws.modaoperandi.com_v1alpha1_s3bucket_cr.yaml
