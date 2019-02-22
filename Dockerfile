FROM alpine:3.8

RUN apk update && \
    apk add python2 py3-setuptools python3-dev gcc make libc-dev \
            linux-headers libffi-dev openssl-dev openssh-client && \
    pip3 install -U pip && \
    pip3 install ansible

COPY ansible/inventory              /etc/ansible/hosts
COPY ansible/ansible.cfg            /etc/ansible/ansible.cfg
COPY ansible/ssh_config             /etc/ssh/ssh_config
COPY ansible/roles                  /etc/ansible/roles
COPY ansible/asa-password-reset.yml /asa-password-reset.yml

VOLUME /output
VOLUME /extra-vars.yml

CMD ["/usr/bin/ansible-playbook", "/asa-password-reset.yml", "-v"]
