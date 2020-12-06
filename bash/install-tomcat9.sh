#!/bin/bash
cd /opt
wget https://ftp.fau.de/apache/tomcat/tomcat-9/v9.0.39/bin/apache-tomcat-9.0.39.tar.gz
tar -xvf apache-tomcat-9.0.39.tar.gz
ln -sf apache-tomcat-9.0.39 apache-tomcat
rm apache-tomcat-9.0.39.tar.gz

