# ansible-aws-operator

Ansible Operator to provision AWS resources

## Usage

```
$ export IMAGE_TAG=v0.0.1
$ export IMAGE=923133779345.dkr.ecr.us-east-1.amazonaws.com/ansible-aws-operator:${IMAGE_TAG}
$ operator-sdk build ${IMAGE}
$ $(aws ecr get-login --no-include-email)
$ docker push ${IMAGE}
```
