#!/bin/bash

CURRENT_TS=$(date +'%s')

cd /root
mkdir logic
mkdir data/logs
cd logic



if [ -e minutely.sh ] ; then
  mv minutely.sh minutely.sh-BAK_$CURRENT_TS
fi

echo "#!/bin/bash" > minutely.sh
echo "run '$0'" >> minutely.sh


if [ -e at-startup.sh ] ; then
  mv at-startup.sh at-startup.sh-BAK_$CURRENT_TS
fi

echo "#!/bin/bash" > at-startup.sh
echo "run '$0'" >> minutely.sh

