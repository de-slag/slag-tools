#!/bin/bash

source ~/slag-tools/bash/core-script.sh

readonly TS=$(date +%s)
readonly WORKDIR=/tmp/deploy-war-to-docker-$TS
readonly TMP_WAR_FILE=app.war
readonly DOCKER_FILE=Dockerfile

read_config_value docker.tomcat9.tag
readonly CONFIG_DOCKER_TAG=$CONFIG_VALUE
if [ -z $CONFIG_VALUE ] ; then log_error "config value 'docker.tomcat9.tag' not setted" ; exit ; fi
readonly TC_IMAGE=tomcat:$CONFIG_VALUE

function print_help {
  echo "--war-file        mandatory, the full path of the war file that should be deployed"
  echo "--image-name      mandatory, the target docker image name"  
  echo "--container-name  mandatory, the target docker container name"
  echo "--force           force container start, when another container with this name is running" 
  echo "--move-war        moves war file instead of copy to workdir"


}

function print_dockerfile {
  echo "# we are extending everything from $TC_IMAGE image ..."                 > $DOCKER_FILE
  echo ""                                                                       >> $DOCKER_FILE
  echo "FROM $TC_IMAGE"                                                         >> $DOCKER_FILE
  echo ""                                                                       >> $DOCKER_FILE
  echo "MAINTAINER slag"                                                        >> $DOCKER_FILE
  echo ""                                                                       >> $DOCKER_FILE
  echo "# COPY path-to-your-application-war path-to-webapps-in-docker-tomcat"   >> $DOCKER_FILE
  echo ""                                                                       >> $DOCKER_FILE
  echo "COPY $TMP_WAR_FILE /usr/local/tomcat/webapps/"                          >> $DOCKER_FILE
}

WAR_FILE=
IMAGE_NAME=
CONTAINER_NAME=
FORCE=false
MOVE_WAR=false
for i in "$@" ; do
  case $i in
    --war-file=*)
      WAR_FILE="${i#*=}"
      shift # past argument=value
      ;;
    --image-name=*)
      IMAGE_NAME="${i#*=}"
      shift # past argument=value
      ;;
    --container-name=*)
      CONTAINER_NAME="${i#*=}"
      shift # past argument=value
      ;;
    --force=*)
      FORCE="${i#*=}"
      shift # past argument=value
      log_warn "--force flag is not applicable up to now"
      ;;
    --move-war=*)
      MOVE_WAR="${i#*=}"
      shift # past argument=value
      ;;
    --help)
      print_help
      exit 0
      ;;
    *)
      log_warn "unknown option: $i"
    ;;
  esac
done

if [ -z $WAR_FILE ] ;       then log_error "--war-file not setted"       ; exit ; fi
if [ -z $IMAGE_NAME ] ;     then log_error "--image-name not setted"     ; exit ; fi
if [ -z $CONTAINER_NAME ] ; then log_error "--container-name not setted" ; exit ; fi

log_info "warfile: $WAR_FILE"
log_info "image name: $IMAGE_NAME"
log_info "container name: $CONTAINER_NAME"

if [ ! -f $WAR_FILE ] ; then
  log_info "war file '$WAR_FILE' not found. nothing to do. exit"
  exit 0
fi

log_info "install docker.."
sudo apt install docker.io

log_info "pull docker image for tomcat '$TC_IMAGE'.."
sudo docker image pull $TC_IMAGE

log_info "create workdir and change to.."
mkdir $WORKDIR
cd $WORKDIR


if [ "true" == "$MOVE_WAR" ] ; then
  log_info "move warfile '$WAR_FILE' to '$TMP_WAR_FILE'.."
  mv $WAR_FILE ./$TMP_WAR_FILE
else
  log_info "copy warfile '$WAR_FILE' to '$TMP_WAR_FILE'.."
  cp $WAR_FILE ./$TMP_WAR_FILE
fi


log_info "create docker file.."
print_dockerfile

log_info "build image.."
sudo docker image build -t $IMAGE_NAME:latest ./


# this fails when no container with this name is running at the 'grep' line
# when fixed, remove warning at cli args processing

#if [ "true" == "$FORCE" ] ; then
#  log_info "force is TRUE, delete container '$CONTAINER_NAME' if any..."
#  output=$(sudo docker ps -a)
#  output=$(echo "$output" | grep $CONTAINER_NAME)
#  if [ ! -z "$output" ] ; then
#    log_info "docker container found: '$CONTAINER_NAME', stopping.."
#    sudo docker container stop $CONTAINER_NAME
#    sudo docker container rm $CONTAINER_NAME
#  fi
#fi

log_info "create and run docker container.."
sudo docker container run -d -it --publish 18080:8080 --name $CONTAINER_NAME $IMAGE_NAME:latest
sudo docker images && echo && sudo docker ps -a





