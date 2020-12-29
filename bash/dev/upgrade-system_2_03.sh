#!/bin/bash
apt-get update -y && apt-get -y autoremove && apt-get clean && apt-get dist-upgrade -y && apt-get autoremove -y && apt-get clean
