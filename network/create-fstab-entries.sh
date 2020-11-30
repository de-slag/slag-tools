#!/bin/bash

if [ "DEBUG" = "$1" ] ; then
  set -x
  shift
fi


# PARAMETERS
DOMAIN=$1

# BASE FUNCTIONS
function log {
  echo $1
}

function log_error {
  log "ERROR: $1"
}

# SPECIAL FUNCTIONS
function generate_entry {
  local host=$1
  local host_domain="$host.$DOMAIN"
  local ip_adress=$(dig +short $host_domain)
  if [ -z $ip_adress ] ; then
    return
  fi
  echo "$ip_adress $host"
}


# MAIN
## validation
if [ -z $DOMAIN ] ; then
  log_error "domain not setted"
  exit 1
fi

## run
while [ ! -z $2 ] ; do
  generate_entry $2
  shift
done

log "all done!"
