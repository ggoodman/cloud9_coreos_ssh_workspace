#!/bin/sh

docker run -d --net=host -v /home/core/workspace:/root/workspace -e PROXY_IMAGE=$(etcdctl get /config/proxy_image) -e HOST=$(hostname) --name=cloud9ide cloud9ide
