#!/bin/bash

source logging-utils.sh

IS_PRIME=
function is_prime0 {
    if [[ $1 -eq 2 ]] || [[ $1 -eq 3 ]]; then
        log_debug "'$1' is a prime"
        IS_PRIME=1 # prime
        return
    fi
    if [[ $(($1 % 2)) -eq 0 ]] || [[ $(($1 % 3)) -eq 0 ]]; then
        log_debug "'$1' is not a prime"
        IS_PRIME=0  # not a prime
        return
    fi
    i=5; w=2
    while [[ $((i * i)) -le $1 ]]; do
        if [[ $(($1 % i)) -eq 0 ]]; then
            log_debug "'$1' is not a prime"
            IS_PRIME=0  # not a prime
            return
        fi
        i=$((i + w))
        w=$((6 - w))
    done
    log_debug "'$1' is a prime"
    IS_PRIME=1  # prime
}

function is_prime {
  local number=$1
  if [ -z $number ] ; then
    log_error "number is not setted. exit"
    exit 1
  fi
  is_prime0 $1
}


for i in {1..10000}
do
   is_prime $i
done
