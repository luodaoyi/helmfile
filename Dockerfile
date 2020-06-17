FROM golang:1.13-buster
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y locales \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# SOPS
ENV SOPS_VERSION 3.5.0
RUN DPKG_ARCH=$(dpkg --print-architecture); \
    wget -q https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops_${SOPS_VERSION}_amd64.deb; \
    apt install ./sops_${SOPS_VERSION}_amd64.deb; \
    rm sops_${SOPS_VERSION}_amd64.deb

# HELM
ENV HELM_VERSION v3.2.3
RUN wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz; \
    tar -zxvf helm-${HELM_VERSION}-linux-amd64.tar.gz; \
    rm helm-${HELM_VERSION}-linux-amd64.tar.gz; \
    chmod +x linux-amd64/helm; \
    mv linux-amd64/helm /usr/bin/helm

# HELMFILE
ENV HELMFILE_VERSION v0.119.0
RUN wget -q https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64 -O /usr/bin/helmfile; \
    chmod +x /usr/bin/helmfile

# HELM PLUGINS
RUN helm plugin install https://github.com/aslafy-z/helm-git
RUN helm plugin install https://github.com/databus23/helm-diff
RUN helm plugin install https://github.com/futuresimple/helm-secrets

# kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl; \
    chmod +x ./kubectl; \
    mv ./kubectl /usr/local/bin/kubectl
