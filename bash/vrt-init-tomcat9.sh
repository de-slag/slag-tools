#!/bin/bash
set -euo pipefail

# CONSTANTS

readonly CONFIG_FILE=~/slag-configurations/global.properties

# CONFIG

#server.tomcat.installation.dir.parent
readonly tc_inst_dir_parent=/opt
#server.tomcat.name
readonly tc_name=apache-tomcat-9.0.41
#server.tomcat.download.url
readonly tc_dl_url="https://downloads.apache.org/tomcat/tomcat-9/v9.0.41/bin/apache-tomcat-9.0.41.tar.gz"

## DERIVED CONFIG

readonly tc_inst_dir=$tc_inst_dir_parent/$tc_name
readonly target_file=$tc_name.tar.gz

# FUNCTIONS

function log {
  echo "$1"
}

log "assert crontab rebootly feature"
if [ -d /etc/cron.rebootly ] ; then
  log "crontab rebootly feature seems not to be installed"
  exit 1
fi

## MAIN SCRIPT


log "install packages"
apt-get -y install curl openjdk-11-jdk

log "download Tomcat install package"
cd $tc_inst_dir_parent
curl -o $target_file $tc_dl_url

log "unzip Tomcat install package"
tar -xf $target_file

log "set symbolic link to Tomcat dir"
ln -sf $tc_name apache-tomcat-current

log "start Tomcat"
cd $tc_inst_dir_parent/apache-tomcat-current/bin
bash -euo pipefail ./startup.sh

log "create crontab rebootly entry"
echo '#!/bin/bash'                                               > /etc/cron.rebootly/start_tomcat
echo '$tc_inst_dir_parent/apache-tomcat-current/bin/startup.sh' >> /etc/cron.rebootly/start_tomcat

chmod +x /etc/cron.rebootly/start_tomcat

log "all done"
