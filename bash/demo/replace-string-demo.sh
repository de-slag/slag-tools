#!/bin/bash

# demo 1
firstString="I love Suzi and Marry"
secondString="Sara"
echo "${firstString/Suzi/$secondString}"



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


# demo 2
echo "demo 2..."
input=~/slag-configurations/fstab.dat
while IFS= read -r line
do
  replace_host "$line"
  replace_mnt "$HOST_REPLACED"
  echo "$MNT_REPLACED"
done < $input

