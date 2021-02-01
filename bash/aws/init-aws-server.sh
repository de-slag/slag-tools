#!/bin/bash

source ~/slag-tools/bash/core-script.sh

readonly PEM_FILE=~/.ssh/aws-003.pem

TS=$(date $TIMESTAMP_PATTERN)

HOST=$1
TAR_FILE=to-be-uploaded.tar.gz
USER=ubuntu

if [ ! -f $PEM_FILE ] ; then log_error "PEM_FILE not found: '$PEM_FILE'" ; exit 1 ; fi
if [ ! -f $TAR_FILE ] ; then log_error "TAR_FILE not found: '$TAR_FILE'" ; exit 1 ; fi

if [ ! -f $PEM_FILE ] ; then log_error "PEM_FILE not found: '$PEM_FILE'" ; exit 1 ; fi
if [ ! -f $TAR_FILE ] ; then log_error "TAR_FILE not found: '$TAR_FILE'" ; exit 1 ; fi

log_info "start update..."
ssh -i $PEM_FILE $USER@$HOST "sudo apt-get update > init-update-$TS.log"

log_info "start upgrades..."
ssh -i $PEM_FILE $USER@$HOST "sudo apt-get upgrade -y > init-upgrade-$TS.log"
ssh -i $PEM_FILE $USER@$HOST "sudo apt-get dist-upgrade -y > init-dist-upgrade-$TS.log"

log_info "start install packages..."
ssh -i $PEM_FILE $USER@$HOST "sudo apt-get install -y openjdk-11-jre-headless > init-install-jkd11-$TS.log"

log_info "upload file..."
scp -i $PEM_FILE $TAR_FILE $USER@$HOST:$TAR_FILE
  
log_info "unzip uploaded file..."
ssh -i $PEM_FILE $USER@$HOST "tar -xf $TAR_FILE > init-unzip-tar-file-$TS.log"

log_info "setting ownership..."
ssh -i $PEM_FILE $USER@$HOST "chown -R $USER:$USER * > init-set-ownership-$TS.log"



ssh -i $PEM_FILE $USER@$HOST 




