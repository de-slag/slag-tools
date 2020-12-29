#!/bin/bash

if [ -z $1 ] ; then
  echo "no args. Use a file as arg."
  exit 0
fi

if [ -e $1 ] ; then
  echo "file exists: $1"
fi

if [ ! -d $1 ] ; then
  echo "file is a dir: $1"
fi

if [ ! -f $1 ] ; then
  echo "file is a 'real' file: $1"
fi
