#!/bin/bash

function user_request {
  echo
  printf "### $1\n"
  echo "hit ENTER to continue"
  read
}

echo "this script installs docker on a ubuntu machine"
echo "tested on ubuntu:"
echo " * 20.04"


echo
echo "I. make sure you meet the prerequisites"
user_request "Uninstall old versions, if any"
sudo apt-get remove docker docker-engine docker.io containerd runc

echo
echo "II. Install using the repository"
echo "II a. Set up the repository"

user_request "1. Update the apt package index and install packages to allow apt to use a repository over HTTPS"
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

user_request "2. Add Docker’s official GPG key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88
user_request "Verify that you now have the key with the fingerprint\n'9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88'"

user_request "3. set up the stable repository"
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

echo
echo "II b. Install Docker Engine"

user_request "1. Update the apt package index, and install the latest version of Docker Engine"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

echo "2. List the versions available in your repo"
apt-cache madison docker-ce
