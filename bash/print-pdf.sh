#!/bin/bash
PRINTER_NAME=Kyocera_FS-1030D
DIR_TO_PRINT=/var/spool/lpd
PRINT_ARCHIVE=/tmp/var-spool-lpd-archive

cd $DIR_TO_PRINT
lp -d $PRINTER_NAME *.pdf
if [ ! -e $PRINT_ARCHIVE ] ; then
  mkdir $PRINT_ARCHIVE
fi
mv *.pdf $PRINT_ARCHIVE

