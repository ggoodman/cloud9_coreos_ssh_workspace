#!/bin/bash

set -ux

echo "Setting up Cloud9IDE ssh workspace in CoreOS"

mkdir -p ./add/.ssh

if [ ! -f ./add/.ssh/id_rsa.pub ]; then
	read -e -p "Enter the email address to use in generating your ssh key and press [ENTER]: " EMAIL
	
	ssh-keygen -t rsa -b 4096 -C "$EMAIL" -f ./add/.ssh/id_rsa -N ''
	
	echo
	echo "Adding the public key just generated to your Github profile..."
	
	read -e -p "Enter the name that will identify this public key on Github and press [ENTER]: " -i "Cloud9@$(hostname)" GH_KEY_TITLE
	read -e -p "Enter your github username and press [ENTER]: " GH_USER
	read -e -s -p "Enter your github password and press [ENTER]: " GH_PASS
	
	curl -XPOST -u $GH_USER:$GH_PASS -H "Content-Type: application/json" --data-binary @- https://api.github.com/user/keys <<EOF
{
	"title": "$GH_KEY_TITLE",
	"key":"$(cat ./add/.ssh/id_rsa.pub)"
}
EOF

fi

if [ ! -f ./add/.ssh/authorized_keys ]; then
	read -e -p "Copy and paste the public key provided by Cloud9IDE's ssh workspace setup modal and press [ENTER]: " C9_PUB_KEY

	echo "# Cloud9IDE public key" >> ./add/.ssh/authorized_keys
	echo $C9_PUB_KEY >> ./add/.ssh/authorized_keys

	read -e -p "Paste your own public key (~/.ssh/id_rsa.pub) and press [ENTER]: " USER_PUB_KEY

	echo "# User's public key" >> ./add/.ssh/authorized_keys
	echo $USER_PUB_KEY >> ./add/.ssh/authorized_keys
fi

if [ ! -f ./add/.gitconfig ]; then
	read -e -p "Enter your git email address and press [ENTER] " GIT_EMAIL
	read -e -p "Enter your git name and press [ENTER] " GIT_NAME
	
	tee ./add/.gitconfig <<EOF
[user]
	email = $GIT_EMAIL
	name = $GIT_NAME
EOF

mkdir -p ~/workspace

docker build --rm -t c9 $@ .
