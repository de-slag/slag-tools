#!/bin/bash

source logging-utils-stable.sh

CLI_ARGUMENT=
#usage example:
#  read_cli_argument "-c" "$@"
#  echo $CLI_ARGUMENT"
function read_cli_argument {
  argument=$1
  all_arguments=$2
  CLI_ARGUMENT=

  log_debug "argument looking for: '$argument', from all arguments: '$all_arguments'"

  for i in $all_arguments
    do
    case $i in
      $argument=*)
        log_debug "found: $i"
        CLI_ARGUMENT="${i#*=}"
        shift
        ;;

      *)
        log_debug "unknown option: '$i', skipped"
        # unknown option
        ;;

    esac
    done
}

echo "cli-args-utils, methods"
echo "  \$CLI_ARGUMENT read_cli_argument (argument all_arguments)"
