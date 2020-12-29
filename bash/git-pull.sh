#!/bin/bash

cd ~
echo "pull slag-configurations..."
cd slag-configurations
git pull
echo "pull slag-configurations. done."
cd ..

echo "pull slag-tools..."
cd slag-tools
git pull
echo "pull slag-tools. done."
