#!/bin/bash

source ~/slag-tools/bash/core-script.sh

readonly PEM_FILE=~/.ssh/aws-003.pem

TS=$(date $TIMESTAMP_PATTERN)

HOST=$1
UPLOAD_FILE=to-be-uploaded.tar.gz
USER=ubuntu

if [ -z $PEM_FILE ] ; then log_error "PEM_FILE not setted: '$PEM_FILE'" ; exit 1 ; fi
if [ -z $UPLOAD_FILE ] ; then log_error "UPLOAD_FILE not setted: '$UPLOAD_FILE'" ; exit 1 ; fi

if [ ! -f $PEM_FILE ] ; then log_error "PEM_FILE not found: '$PEM_FILE'" ; exit 1 ; fi
if [ ! -f $UPLOAD_FILE ] ; then log_error "UPLOAD_FILE not found: '$UPLOAD_FILE'" ; exit 1 ; fi




log_info "start update..."
ssh -i $PEM_FILE $USER@$HOST "sudo apt-get update > init-update-$TS.log"

log_info "start upgrades..."
ssh -i $PEM_FILE $USER@$HOST "sudo apt-get upgrade -y > init-upgrade-$TS.log"
ssh -i $PEM_FILE $USER@$HOST "sudo apt-get dist-upgrade -y > init-dist-upgrade-$TS.log"

log_info "start install packages..."
ssh -i $PEM_FILE $USER@$HOST "sudo apt-get install -y openjdk-11-jre-headless > init-install-jkd11-$TS.log"

log_info "upload file..."
scp -i $PEM_FILE $UPLOAD_FILE $USER@$HOST:$UPLOAD_FILE

if [[ "$UPLOAD_FILE" == *.tar.gz ]] ; then
  log_info "unzip uploaded file..."
  ssh -i $PEM_FILE $USER@$HOST "tar -xf $UPLOAD_FILE > init-unzip-tar-file-$TS.log"
else
  log_info "uploaded file seems not to be a gzipped archive. Unzip by your own if any"
fi



log_info "create crontab-file..."
CRON_FILE=/etc/cron.d/slag-start-server
CRON_TMP_FILE=slag-start-server
ssh -i $PEM_FILE $USER@$HOST "echo '# file created at: $TS' > $CRON_TMP_FILE"
ssh -i $PEM_FILE $USER@$HOST "echo 'SHELL=/bin/sh' >> $CRON_TMP_FILE"
ssh -i $PEM_FILE $USER@$HOST "echo 'PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin' >> $CRON_TMP_FILE"
ssh -i $PEM_FILE $USER@$HOST "echo '@reboot $USER /home/$USER/autostart.sh' >> $CRON_TMP_FILE"
ssh -i $PEM_FILE $USER@$HOST "echo '' >> $CRON_TMP_FILE"

log_info "copy crontab-file..."
ssh -i $PEM_FILE $USER@$HOST "sudo cp $CRON_TMP_FILE $CRON_FILE"

log_info "create autostart-file..."
AUTOSTART_FILE=autostart.sh
ssh -i $PEM_FILE $USER@$HOST "echo '# file created at: $TS' > $AUTOSTART_FILE"
ssh -i $PEM_FILE $USER@$HOST "echo 'if [ ! -f ~/start.sh ] ; then' >> $AUTOSTART_FILE"
ssh -i $PEM_FILE $USER@$HOST "echo '  echo \"autostart: start file not found. exit.\"' >> $AUTOSTART_FILE"
ssh -i $PEM_FILE $USER@$HOST "echo '  exit' >> $AUTOSTART_FILE"
ssh -i $PEM_FILE $USER@$HOST "echo 'fi' >> $AUTOSTART_FILE"
ssh -i $PEM_FILE $USER@$HOST "echo '  echo \"autostart: start file found. run it..\"' >> $AUTOSTART_FILE"
ssh -i $PEM_FILE $USER@$HOST "echo 'nohup ~/start.sh &' >> $AUTOSTART_FILE"

log_info "make autostart-file executable..."
ssh -i $PEM_FILE $USER@$HOST "chmod +x $AUTOSTART_FILE"

log_info "setting ownership of home dir of '$USER'..."
ssh -i $PEM_FILE $USER@$HOST "chown -R $USER:$USER * > init-set-ownership-$TS.log"

ssh -i $PEM_FILE $USER@$HOST





