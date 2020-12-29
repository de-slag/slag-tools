#!/bin/bash

# demo 1

function demo1 {
  firstString="I love Suzi and Marry"
  echo $firstString
  secondString="Sara"
  echo "${firstString/Suzi/$secondString}"
}

# demo 2

uranus="uranus.speedport.ip"
jupiter="jupiter.speedport.ip"
HOST_REPLACED=

function replace_host {
  source_string="$1"
  HOST_REPLACED=
  HOST_REPLACED="${source_string/uranus/$uranus}"
  HOST_REPLACED="${HOST_REPLACED/jupiter/$jupiter}"
}

function replace_mnt {
  source_string="$1"
  MNT_REPLACED=
  MNT_REPLACED="${source_string/mnt/media}"
}

function demo2 {
  echo "demo 2..."
  input=~/slag-configurations/fstab.dat
  while IFS= read -r line
  do
    replace_host "$line"
    replace_mnt "$HOST_REPLACED"
  echo "$MNT_REPLACED"
  done < $input
}

# demo 3
function demo3 {

  # this also runs with '&' instead of  '§'
  # this does not runs with '$', '#', '%'

  local firstString="this ist a '§xvar' test"
  echo "${firstString/§xvar/nice}"
  echo "${firstString/§xvar/fancy}"
}

demo1
demo2
demo3
