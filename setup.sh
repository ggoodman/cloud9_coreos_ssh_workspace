#!/bin/bash

echo "Setting up Cloud9IDE ssh workspace in CoreOS"

if [ ! -f ~/.ssh/id_rsa.pub ]; then
	echo -n "Enter the email address to use in generating your ssh key and press [ENTER]"
	read email
	
	mkdir -p ./.ssh
	ssh-keygen -t rsa -b 4096 -C "$email" -f ./.ssh/id_rsa -N ''
fi

if [ ! -f ./.ssh/authorized_keys ]; then
	echo -n "Copy and paste the public key provided by Cloud9IDE's ssh workspace setup modal and press [ENTER] "
	read authkey

	echo "# Cloud9IDE public key" >> ./.ssh/authorized_keys
	echo $authkey >> ./.ssh/authorized_keys

	echo -n "Paste your own public key (~/.ssh/id_rsa.pub) and press [ENTER] "
	read pubkey

	echo "# User's public key" >> ./.ssh/authorized_keys
	echo $pubkey >> ./.ssh/authorized_keys
fi

mkdir -p ~/workspace

docker build --rm -t c9 .
