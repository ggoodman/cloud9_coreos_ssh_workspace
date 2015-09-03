#!/bin/sh


docker run -d --net=host -v /var/run/fleet.sock:/var/run/fleet.sock -v $HOME/workspace:/home/core/workspace -v $(pwd)/add/.ssh:/home/core/.ssh -e GID=$(id -g) -e UID=$(id -u) --name=c9 c9
