#!/bin/bash
echo "remove old packages, if any"
echo "hit ENTER"
read
sudo apt-get remove docker docker-engine docker.io containerd runc

echo
echo "Update the apt package index and install packages to allow apt to use a repository over HTTPS"
echo "hit ENTER"
read

sudo apt-get update

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

