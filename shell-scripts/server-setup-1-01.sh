#!/bin/bash

CURRENT_TS=$(date +'%s')

cd /root
if [ ! -e logic ] ; then
  mkdir logic
fi

if [ ! -e data/logs ] ; then
  mkdir data/logs
fi

cd logic

if [ -e minutely.sh ] ; then
  mv minutely.sh minutely.sh-BAK_$CURRENT_TS
fi

echo "#!/bin/bash" > minutely.sh
echo "run 'minutely.sh'" >> minutely.sh


if [ -e at-startup.sh ] ; then
  mv at-startup.sh at-startup.sh-BAK_$CURRENT_TS
fi

echo "#!/bin/bash" > at-startup.sh
echo "run 'at-startup'" >> at-startup.sh

