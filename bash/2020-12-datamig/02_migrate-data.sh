#!/bin/bash
set -euxo pipefail
data_areas="backup data logic test vrt"

from_dir=/media
to_dir=/mnt

for area in $data_areas ; do
 echo "processing area: '$area'"
 from_area=$from_dir/$area
 to_area=$to_dir/$area
 if [ ! -d $from_area ] ; then
   echo "from-area does not exists: $from_area"
   exit 1
 else
   echo "from-area found: $from_area"
 fi

 if [ ! -d $to_area ] ; then
   echo "to-area does not exists: $to_area"
   exit 1
 else
   echo "to-area found: $to_area"
 fi

 echo "migrate '$from_area' to '$to_area'"
 #cp -R $from_area/* $to_area
 rsync -av $from_area/ $to_area

done 
