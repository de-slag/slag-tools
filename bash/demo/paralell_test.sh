#!/bin/bash



# so auf jeden fall nicht

do_it() (
  echo "start $1 $BASHPID" >&2
  sleep "$2"
  echo "end $1">&2
)

do_it a 5
do_it b 5
