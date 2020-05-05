#!/bin/bash
readonly TRIGGER_FILE=/tmp/upgrade-system.trigger

if [ -e $TRIGGER_FILE ] ; then
  exit 0
fi
rm $TRIGGER_FILE


