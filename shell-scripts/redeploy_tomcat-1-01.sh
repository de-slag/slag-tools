
#!/bin/bash
function log {
  printf "$1\n"
}


log "redeploy tomcat"
log "###"

if [ ! -d bin ] || [ ! -d webapps ]; then
  echo "ERROR: this script must be started from tomcat base dir"
  exit 1
fi


$WEBBAPPS
function determine_webapps {
  cd webapps
  WEBAPPS="$(ls *.war)"
}

determine_webapps
echo $WEBAPPS

log "UNFINISHED SCRIPT"

# first of all stop tomcat

# remove all directories and files that list in the $WEBAPPS array

# implement a mandatory cli parameter: -d which points to the directory with webapps to deploy (deploy-directory)

# copy all webapps in deploy-directory to webapps

# clear logs and temp dir

# restart tomcat





log "INFO: all done"


exit 0

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

