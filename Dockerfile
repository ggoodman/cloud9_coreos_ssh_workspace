FROM node

ENV GID=500
ENV UID=500
ENV NODE_VERSION=0.12

# Needed to run sshd and to build cloud9ide runtime
RUN \
  apt-get update && \
  apt-get install -y build-essential openssh-server && \
  mkdir -p /var/run/sshd

# Create the core user with same uid:gid as host user
RUN \
    groupadd -g $GID core && \
    useradd -g $GID -u $UID -d /home/core -m -G sudo -s /bin/bash core

# Install etcd so that we can interact with etcd in host environment
ENV ETCD_VERSION=v2.0.13
ADD https://github.com/coreos/etcd/releases/download/${ETCD_VERSION}/etcd-${ETCD_VERSION}-linux-amd64.tar.gz /tmp/etcdctl.tar.gz
RUN \
    tar -xvzf /tmp/etcdctl.tar.gz -C /usr/local/bin --strip-components=1 etcd-${ETCD_VERSION}-linux-amd64/etcdctl && \
    rm -rf /tmp/etcdctl.tar.gz

ENV FLEET_VERSION=v0.10.2
ADD https://github.com/coreos/fleet/releases/download/${FLEET_VERSION}/fleet-${FLEET_VERSION}-linux-amd64.tar.gz /tmp/fleetctl.tar.gz
RUN \
    tar -xvzf /tmp/fleetctl.tar.gz -C /usr/local/bin --strip-components=1 fleet-${FLEET_VERSION}-linux-amd64/fleetctl && \
    rm -rf /tmp/fleetctl.tar.gz

USER core

WORKDIR /home/core

# Install nodejs using nvm
RUN \
    wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.26.0/install.sh | bash

RUN \
    bash -c '. ~/.nvm/nvm.sh && nvm install $NODE_VERSION && nvm use $NODE_VERSION && nvm alias default $(nvm version $NODE_VERSION)'

# Install cloud9ide runtime
RUN \
    wget -O- https://raw.githubusercontent.com/c9/install/master/install.sh | bash

EXPOSE 2222
VOLUME /home/core/workspace

USER root

# Run the sshd server
CMD /usr/sbin/sshd -p 2222 -D

