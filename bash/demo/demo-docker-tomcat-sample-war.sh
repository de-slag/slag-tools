#!/bin/bash

source ~/slag-tools/bash/core-script.sh

# based on: https://medium.com/@pra4mesh/deploy-war-in-docker-tomcat-container-b52a3baea448

readonly TC_CONTAINER_NAME=my-tomcat-container

readonly OWN_IMAGE_NAME=slag/tomcat-sample-app
readonly OWN_CONTAINER_NAME=slag-tomcat-sample
readonly SAMPLE_WAR_FILE=~/slag-tools/resources/sample.war
readonly DOCKER_FILE=Dockerfile

function user_confirm {
  ui "[DEMO] $1\nhit ENTER to continue"
  echo
}

function list_images_and_containers {
  sudo docker images && echo && sudo docker ps -a
}


user_confirm "install docker.."
sudo apt install docker.io


user_confirm "pull docker image for tomcat.."

sudo docker image pull tomcat:8.0
list_images_and_containers

user_confirm "create docker container for tomcat image.."

sudo docker container create --publish 8082:8080 --name $TC_CONTAINER_NAME tomcat:8.0
list_images_and_containers

user_confirm "start tomcat docker container.."

sudo docker container start $TC_CONTAINER_NAME
echo "Tomcat application can be accessed in http://localhost:8082"
list_images_and_containers

# create docker image with own war within

user_confirm "write 'Dockerfile'.."

echo "# we are extending everything from tomcat:8.0 image ..."                 > $DOCKER_FILE
echo ""                                                                       >> $DOCKER_FILE
echo "FROM tomcat:8.0"                                                        >> $DOCKER_FILE
echo ""                                                                       >> $DOCKER_FILE
echo "MAINTAINER slag"                                                        >> $DOCKER_FILE
echo ""                                                                       >> $DOCKER_FILE
echo "# COPY path-to-your-application-war path-to-webapps-in-docker-tomcat"   >> $DOCKER_FILE
echo ""                                                                       >> $DOCKER_FILE
echo "COPY sample.war /usr/local/tomcat/webapps/"                             >> $DOCKER_FILE

cat Dockerfile

user_confirm "copy sample.war.."
cp $SAMPLE_WAR_FILE ./

user_confirm "build image.."
sudo docker image build -t $OWN_IMAGE_NAME ./

user_confirm "create and run docker container.."
sudo docker container run -d -it --publish 8081:8080 --name $OWN_CONTAINER_NAME $OWN_IMAGE_NAME
list_images_and_containers

echo "Your application can be accessed in http://localhost:8081/sample"

user_confirm "creation is done. feel free to test the application."

user_confirm "teardown on your own please"

exit 0

user_confirm "teardown.."

user_confirm "teardown: remove local created files.."

rm $DOCKER_FILE
rm sample.war

user_confirm "teardown: stopping containers.."

sudo docker container stop $TC_CONTAINER_NAME
sudo docker container stop $OWN_CONTAINER_NAME

sudo docker container rm $TC_CONTAINER_NAME
sudo docker container rm $OWN_CONTAINER_NAME




