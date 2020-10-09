#!/bin/bash
start=$(date +%s)
i="0" 
while [ $i -lt 4 ]
do
echo "$i"
 i=$[$i+1]
done
echo "$start"
