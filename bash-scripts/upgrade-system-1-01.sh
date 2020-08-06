#!/bin/bash

function run_upgrade {
  apt-get update && apt-get dist-upgrade -y && apt-get autoremove -y && apt-get clean
}

run_upgrade
