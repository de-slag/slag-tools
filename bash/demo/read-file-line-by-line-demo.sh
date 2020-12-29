#!/bin/bash
input=~/slag-configurations/global.properties
while IFS= read -r line
do
  echo "$line"
done < $input
