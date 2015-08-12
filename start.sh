#!/bin/sh

docker run -d --net=host -v /home/core/workspace:/home/cloud9/workspace -e GID=$(id -g) -e UID=$(id -u) --name=cloud9ide cloud9ide
