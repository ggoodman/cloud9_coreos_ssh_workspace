#!/bin/bash

echo "Setting up Cloud9IDE ssh workspace in CoreOS"

if [ ! -f id_rsa.pub ]; then
	echo -n "Enter the email address to use in generating your ssh key and press [ENTER]"
	read email

	ssh-keygen -t rsa -b 4096 -C "$email" -f ./id_rsa -N ''
fi

if [ ! -f c9_rsa.pub ]; then
	echo -n "Copy and paste the public key provided by Cloud9IDE's ssh workspace setup modal and press [ENTER] "
	read authkey

	echo $authkey >> ./authorized_keys
fi

mkdir -p ~/workspace

docker build -t cloud9ide .
