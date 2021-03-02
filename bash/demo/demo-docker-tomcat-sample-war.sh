#!/bin/bash

source ~/slag-tools/bash/core-script.sh

# based on: https://medium.com/@pra4mesh/deploy-war-in-docker-tomcat-container-b52a3baea448

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

sudo docker container create --publish 8082:8080 --name my-tomcat-container tomcat:8.0
list_images_and_containers

user_confirm "start tomcat docker container.."

sudo docker container start my-tomcat-container
echo "Tomcat application can be accessed in http://localhost:8082"
list_images_and_containers

# create docker image with own war within

user_confirm "write 'Dockerfile'.."

echo "# we are extending everything from tomcat:8.0 image ..."                 > Dockerfile
echo ""                                                                       >> Dockerfile
echo "FROM tomcat:8.0"                                                        >> Dockerfile
echo ""                                                                       >> Dockerfile
echo "MAINTAINER slag"                                                        >> Dockerfile
echo ""                                                                       >> Dockerfile
echo "# COPY path-to-your-application-war path-to-webapps-in-docker-tomcat"   >> Dockerfile
echo ""                                                                       >> Dockerfile
echo "COPY sample.war /usr/local/tomcat/webapps/"      >> Dockerfile

cat Dockerfile

user_confirm "copy sample.war.."
cp ~/slag-tools/resources/sample.war ./

user_confirm "build image.."
sudo docker image build -t slag/tomcat-sample-app ./

user_confirm "create and run docker container.."
sudo docker container run -d -it --publish 8081:8080 --name slag-tomcat-sample slag/tomcat-sample-app
list_images_and_containers

echo "Your application can be accessed in http://localhost:8081/sample"

user_confirm "creation is done. feel free to test the application."

user_confirm "teardown on your own please"
