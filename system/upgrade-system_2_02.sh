#!/bin/bash
apt-get update -y && apt-get dist-upgrade -y && apt-get autoremove -y && apt-get clean
