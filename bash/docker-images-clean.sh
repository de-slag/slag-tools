#!/bin/bash

input="/tmp/docker-images-to-clear.txt"

if [ ! -f $input ] ; then
  echo "ERROR: file not found: $input"
  exit 1
fi



while IFS= read -r line
do
  echo "$line"
  sudo docker image rm $line
done < "$input"
