#!/bin/bash

source ~/slag-tools/bash/core-script.sh

for i in "$@" ; do
  case $i in
    -p=*|--printer-name=*)
      PRINTER_NAME="${i#*=}"
      shift # past argument=value
      ;;
    -d=*|--dir-to-print=*)
      TO_PRINT_DIR="${i#*=}"
      shift # past argument=value
      ;;
    *)
      log_warn "unknown option: $i"
    ;;
  esac
done

readonly TS=$(date '+%Y-%m-%d_%H-%M-%S')

log_debug "printer name: $PRINTER_NAME"
log_debug "to print dir: $TO_PRINT_DIR"
log_debug "timestamp: $TS"

log_info "start"

cd $TO_PRINT_DIR
lp -d $PRINTER_NAME *.pdf
tar -cvzf $TS.tar.gz *.pdf
rm -Rv *.pdf


