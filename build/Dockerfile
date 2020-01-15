FROM quay.io/operator-framework/ansible-operator:v0.13.0

RUN pip3 install --user \
  boto \
  boto3

COPY watches.yaml /opt/ansible/watches.yaml

COPY roles/ ${HOME}/roles/
