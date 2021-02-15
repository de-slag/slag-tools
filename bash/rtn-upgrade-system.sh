#!/bin/bash
before=$(df -h /)
apt-get update -y && apt-get dist-upgrade -y && apt-get autoremove -y && apt-get clean
printf "\ndisk usage before:\n"
echo "$before"
printf "\ndisk usage after:\n"
df -h /
