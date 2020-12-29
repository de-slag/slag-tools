#!/bin/bash
function log {
  echo $1
}

cd ~
log "pull slag-configurations..."
cd slag-configurations
git pull
log "pull slag-configurations. done."
cd ..

log "pull slag-tools..."
cd slag-tools
git pull
log "pull slag-tools. done."
