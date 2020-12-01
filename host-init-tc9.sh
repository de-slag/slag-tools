#!/bin/bash

apt-get install openjdk-11-jdk

cd /opt
wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.40/bin/apache-tomcat-9.0.40.tar.gz
tar -xf apache-tomcat-9.0.40.tar.gz

