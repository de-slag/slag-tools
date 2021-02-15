#!/bin/bash

set -euo pipefail

function assert_not_ran_before {
  if grep -q /etc/cron.minutely /etc/crontab ; then
    echo "it seems, that this script ran before. Please check '/etc/crontab'"
    exit 1
  fi

  if [ -e /etc/cron.minutely ] ; then
    echo "it seems, that this script ran before. Please check dir '/etc/cron.minutely'"
    exit 1
  fi

  echo "assert_not_ran_before: ok"
}

assert_not_ran_before

TS=$(date +%s)

echo "create dir..."
mkdir /etc/cron.minutely
if [ ! -e /etc/cron.minutely ] ; then echo "NOT successful" ; exit 1 ; fi
echo "create dir, ok."

echo "backup crontab file..."
cp /etc/crontab /etc/crontab.bak-$TS

echo "extend crontab file..."
echo "* * * * *	root    cd / && run-parts --report /etc/cron.minutely" >> /etc/crontab

echo "all done: ok"





