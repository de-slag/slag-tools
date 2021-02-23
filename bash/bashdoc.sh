#!/bin/bash

source ~/slag-tools/bash/core-script.sh

readonly SCRIPT_TO_PRINT=$1



## prints script if starts with ## or with 'function'
## @parameters: (none)
## @return: void
function doc_script {
  while IFS= read -r line ; do
    if [[ $line == \#\#* ]] || [[ $line == function* ]]; then
      if [[ $line == *0\ { ]] ; then
        ## private / internal function
        continue
      fi
      echo "$line"
      
      if [[ $line == *{ ]] ; then
        ## this is the function itself, end this section with and empty line
        echo ""
      fi
      continue
    fi
    log_debug "do not print line '$line'"
  done < "$SCRIPT_TO_PRINT"
}


## asserts that the script parameter is setted and that this file exists
## @parameters: none
## @return: void
function assert_script {
  if [ -z $SCRIPT_TO_PRINT ] ; then
    log_error "script name not setted: '$SCRIPT_TO_PRINT'"
    exit 1
  fi

  if [ ! -f $SCRIPT_TO_PRINT ] ; then
    log_error "script not found: '$SCRIPT_TO_PRINT'"
    exit 1
  fi
  log_debug "ok, script asserted"
}

assert_script
doc_script
