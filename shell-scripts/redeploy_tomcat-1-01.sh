y#!/bin/bash
readonly tomcat_basedir=/opt/tomcat

function cleanup_app {

  if [ -z $1 ] ; then
    echo "parameter not setted, break"
    return
  fi

  if [ ! -d $1 ] ; then
    echo "no dir found with name: '$1', break"
    return
  fi
  echo "remove dir : '$1'"
  rm -R $1/

}


cd $tomcat_basedir

bin/shutdown.sh

cd webapps
WAR_FILES=($(ls *.war))

for war_file in "${WAR_FILES[@]}"
do
  echo "found $war_file!"
  app_name=$(echo $war_file| cut -d'.' -f 1)
  echo "app name: '$app_name'"
  cleanup_app $app_name
done

cd $tomcat_basedir
cd logs
rm -R *

cd $tomcat_basedir
cd temp
rm -R *

echo "hit ENTER to continue"
read


cd $tomcat_basedir
bin/startup.sh

