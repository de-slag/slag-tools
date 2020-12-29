#!/bin/bash

#while [ true ] ; do ./03_monitor_data_migration.sh ; done

DIRS=
DIRS="$DIRS /media/test"
DIRS="$DIRS /mnt/test"

DIRS="$DIRS /media/logic"
DIRS="$DIRS /mnt/logic"

DIRS="$DIRS /media/backup"
DIRS="$DIRS /mnt/backup"

DIRS="$DIRS /media/data"
DIRS="$DIRS /mnt/data"

DIRS="$DIRS /media/vrt"
DIRS="$DIRS /mnt/vrt"

echo
date
du -hs $DIRS
date
