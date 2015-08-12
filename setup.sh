#!/bin/bash

echo "Setting up Cloud9IDE ssh workspace in CoreOS"

if [ ! -f id_rsa.pub ]; then
	echo -n "Enter the email address to use in generating your ssh key and press [ENTER]"
	read email

	ssh-keygen -t rsa -b 4096 -C "$email" -f ./id_rsa -N ''
fi

if [ ! -f ssh_host_dsa_key ]; then
	ssh-keygen -t dsa -f ./ssh_host_dsa_key -N ''
fi

if [ ! -f ssh_host_dsa_key ]; then
	ssh-keygen -t dsa -f ./ssh_host_dsa_key -N ''
fi

if [ ! -f authorized_keys ]; then
	echo -n "Copy and paste the public key provided by Cloud9IDE's ssh workspace setup modal and press [ENTER] "
	read authkey

	echo $authkey >> ./authorized_keys

	echo -n "Paste your own public key (~/.ssh/id_rsa.pub) and press [ENTER] "
	read pubkey

	echo $pubkey >> ./authorized_keys
fi

mkdir -p ~/workspace

docker build --rm -t cloud9ide .
