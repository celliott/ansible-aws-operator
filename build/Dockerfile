FROM quay.io/operator-framework/ansible-operator:v0.13.0

COPY build/requirements.txt requirements.txt

RUN pip3 install --user -r requirements.txt

COPY watches.yaml ${HOME}/watches.yaml

COPY roles/ ${HOME}/roles/
