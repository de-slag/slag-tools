#!/bin/bash

IS_PRIME_NUMBER=
function is_prime_number {
  number=$1

  IS_PRIME_NUMBER=

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


echo -e "Enter Number : \c"
read n
is_prime_number n

if [ "true" == "$IS_PRIME_NUMBER" ] ; then
  echo "$n is a prime number"
  exit
fi
echo "$n is not a prime number"
