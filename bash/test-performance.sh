#!/bin/bash
#set -x

duration=5

function test_performance {
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
  exit 0
}

function start_threads {
  cpu_count=$(nproc)
  echo "$cpu_count cpus found"
  threads=0
  while [ $threads -lt $cpu_count ]
  do
    test_performance &
    threads=$[$threads+1]
  done
}

start_threads


