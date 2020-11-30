#!/bin/bash

if [ "DEBUG" = $1 ] ; then
  set -x
  shift
fi

DOMAIN=$1

function generate_entry {
  local host=$1
  local host_domain="$host.$DOMAIN"
  local ip_adress=$(dig +short $host_domain)
  if [ -z $ip_adress ] ; then
    return
  fi
  echo "$ip_adress $host"
}

while [ ! -z $2 ] ; do
  generate_entry $2
  shift
done
