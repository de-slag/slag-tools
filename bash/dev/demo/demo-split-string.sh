#!/bin/bash

readonly STR="split=me"


KEY=
VALUE=
function split_at {
  local DELIMITER=$1
  local STRING=$2
  
  echo "delimiter: '$DELIMITER'"
  echo "string: '$STRING'"
  
  s=$STRING$DELIMITER
  local array=();
  while [[ $s ]]; do
    array+=( "${s%%"$DELIMITER"*}" );
    s=${s#*"$DELIMITER"};
   done;
   declare -p array
   KEY=$array[0]
   VALUE=$array[1]
}

echo $STR

split_at "=" $STR

echo $KEY
echo $VALUE


