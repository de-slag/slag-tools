#!/bin/bash

source ~/slag-tools/bash/core-script.sh

UP_TO=100000
OUTPUT=""
MAX_DURATION_CALIBRATION=5
COUNT_MULTIPLICATOR=25

IS_PRIME_NUMBER=
function is_prime_number {
  number=$1

  IS_PRIME_NUMBER=

  ## handle specials
  if [ 1 -ge $number ] ; then
    IS_PRIME_NUMBER=false
    return
  fi

  for((i=2; i<=$number/2; i++))
  do
    ans=$(( number%i ))
    if [ $ans -eq 0 ]
    then
      IS_PRIME_NUMBER=false
      return
    fi
  done
  IS_PRIME_NUMBER=true
}

CALIBRATED_UP_TO=
function calibrate {
  start_calibration=$(date +%s)
  max_end_calibration=$(( start_calibration + $MAX_DURATION_CALIBRATION ))

  local current_candidate=0
  while [ $current_candidate -le $UP_TO ] ; do

    is_prime_number $current_candidate
    if [ "true" == "$IS_PRIME_NUMBER" ] ; then
      CALIBRATED_UP_TO=$(( CALIBRATED_UP_TO + 1))
    fi

    local current_ts=$(date +%s)
    if [ $current_ts -ge $max_end_calibration ] ; then break ; fi
    current_candidate=$((current_candidate+1))  

  done
  CALIBRATED_UP_TO=$(( CALIBRATED_UP_TO * $COUNT_MULTIPLICATOR ))
}

DURATION=
function performance_test {
  performace_candidate=0
  start_performance_test=$(date +%s)
  while [ $performace_candidate -le $CALIBRATED_UP_TO ] ; do
    is_prime_number $performace_candidate
    performace_candidate=$((  performace_candidate + 1 ))  
  done
  end_performance_test=$(date +%s)
  DURATION=$(( end_performance_test - start_performance_test ))
}

PLAIN_DURATION=
function plain_performance_test {
  local plain_up_to=10000
  local plain_current=0
  local start=$(date +%s)

  while [ $plain_current -le $plain_up_to ] ; do
    is_prime_number $plain_current
    plain_current=$((plain_current+1))  
  done
  end=$(date +%s)
  PLAIN_DURATION=$(( end - start ))
}


echo "run calibration..."
calibrate
echo "calibration done. up to: $CALIBRATED_UP_TO"

echo "run test..."
performance_test
echo "performance test done. took: $DURATION"

echo "run plain test..."
plain_performance_test
echo "plain performance test done. took: $PLAIN_DURATION"

exit 0
