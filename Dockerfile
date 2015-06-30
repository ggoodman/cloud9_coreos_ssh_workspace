FROM node:0.12.2

# Needed to run sshd and to build cloud9ide runtime
RUN \
  apt-get update && \
  apt-get install -y build-essential openssh-server

RUN mkdir /var/run/sshd

# Install cloud9ide runtime
RUN wget -O - https://raw.githubusercontent.com/c9/install/master/install.sh | bash

# Create our working directory
RUN mkdir /root/workspace

# Install etcd so that we can interact with etcd in host environment
RUN curl -sL https://github.com/coreos/etcd/releases/download/v2.0.11/etcd-v2.0.11-linux-amd64.tar.gz -o /tmp/etcd-v2.0.11-linux-amd64.tar.gz
RUN cd /tmp && gzip -dc etcd-v2.0.11-linux-amd64.tar.gz | tar -xof -
RUN cp -f /tmp/etcd-v2.0.11-linux-amd64/etcdctl /usr/local/bin
RUN rm -rf /tmp/etcd-v2.0.11-linux-amd64.tar.gz

# Add in ssh keys and c9 public key
RUN mkdir ~/.ssh
ADD authorized_keys /root/.ssh/authorized_keys
ADD id_rsa /root/.ssh/id_rsa
ADD id_rsa.pub /root/.ssh/id_rsa.pub

EXPOSE 2222

# Expose some environment variables from the host in the container
CMD env | grep HOST >> /etc/environment && env | grep PROXY_IMAGE >> /etc/environment && echo PORT=8721 >> /etc/environment && /usr/sbin/sshd -D -p 2222

