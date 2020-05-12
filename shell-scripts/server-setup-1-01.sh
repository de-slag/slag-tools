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


echo "FIXME: dont echo DOLLAR0 here"
exit 1

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

