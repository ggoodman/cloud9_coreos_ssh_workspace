#!/bin/sh


docker run -d --net=host -v $HOME:/home/core/workspace -v $(pwd)/.ssh:/home/core/.ssh -e GID=$(id -g) -e UID=$(id -u) --name=c9 c9
