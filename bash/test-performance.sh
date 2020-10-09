#!/bin/bash
#set -x

## target duration in seconds
duration=2

start=$(date +%s)
target_end=$[$start+$duration]

echo "start performance test..."

i="0"
while [ true ]
do
  current_ts=$(date +%s)
  if [ $current_ts -ge $target_end ] ; then
    break;
  fi
  i=$[$i+1]
done
echo "test done. cycles: $i"
