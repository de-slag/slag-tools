#!/bin/bash

set -euo pipefail

readonly TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
readonly CRONTAB_BACKUP_NAME="/etc/crontab.bak-$TIMESTAMP"

cp /etc/crontab $CRONTAB_BACKUP_NAME

mkdir /etc/cron.rebootly
mkdir /etc/cron.minutely

echo '@reboot         root    cd / && run-parts --report /etc/cron.rebootly' >> /etc/crontab
echo '* * * * *       root    cd / && run-parts --report /etc/cron.minutely' >> /etc/crontab

