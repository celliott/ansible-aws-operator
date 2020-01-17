# ansible-aws-operator

Ansible Operator to provision AWS resources. See `deploy/crs` for examples of infra definitions.

>NOTES
>- Currently this is setup to run in the `demo` namespace in POC cluster in `prod-rds` account
>- Currently pinned to `IMAGE_TAG=v0.0.1`

# TODO
- Add more AWS resources
- Improve ansible roles; idempotent
- Add helm chart to deploy operator
- Sort Molecule tests

## Usage

Build and push operator docker image

```
$ make docker-build
$ make docker-push
```

* Deploy operator

```
$ make deploy
```

* provision `dynamodb` using operator

```
$ make dynamodb
```

* provision `s3bucket` using operator

```
$ make s3bucket
```
