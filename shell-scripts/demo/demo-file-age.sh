#!/bin/bash
readonly DAY_IN_SECONDS=86400

readonly DAYS_14=$(echo "$DAY_IN_SECONDS*14" |bc)
readonly DAY=$DAY_IN_SECONDS
readonly HALF_DAY=$(echo "$DAY_IN_SECONDS/2"|bc)

function print_file_timestamp {
  file_ts=$(date -r $1 "+%s")
  echo "timestamp of file '$1' is '$file_ts'"
}


TIMEOUT=$DAY
function is_outdated {
  local file=$1

  local ts=$(date +%s)
  local file_ts=$(date -r $file "+%s")
  local calc_expression="$ts-$file_ts"
  local result=$(echo $calc_expression | bc)

  if [ $TIMEOUT -gt $result ] ; then
    echo "'$file' is not outdated"
  else
    echo "'$file' is outdated"
  fi

}

print_file_timestamp test.dat
is_outdated test.dat

