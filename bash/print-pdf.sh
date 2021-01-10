#!/bin/bash
set -euo pipefail

PRINTER_NAME=Kyocera_FS-1030D
TO_PRINT_DIR=/var/spool/lpd
TS=$(date '+%Y-%m-%d_%H-%M-%S')
LOG_FILE=print.log

cd $TO_PRINT_DIR

lp -d $PRINTER_NAME *.pdf >> $LOG_FILE 
tar -cvzf $TS.tar.gz *.pdf >> $LOG_FILE
