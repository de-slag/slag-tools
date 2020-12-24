#!/bin/bash

source base-utils.sh

function ui {
  user_input "$1"
}

function ui {
  user_input "$1"
}

clear
echo "### Setup VM Wizard ###"

cd /mnt/vrt/images
img_list=$(ls -fA *.img)
idx=0
for entry in $img_list ; do
  echo "($idx) $entry"
  idx=$(expr $idx + 1)
done

ui "choose an image:"
IMG_SELECT_IDX=$USER_INPUT
echo "you choosed: '$IMG_SELECT_IDX'"

idx=0
SELECTED_IMG=
for entry in $img_list ; do
  if [ $IMG_SELECT_IDX -eq $idx ] ; then
    SELECTED_IMG=$entry
  fi
  idx=$(expr $idx + 1)
done
echo "you choosed img: '$SELECTED_IMG'"


IMG_TYPE="o"
ui "(f)ull image or (o)verlay-image (default '$IMG_TYPE')?"
if [ ! -z $USER_INPUT ] ; then
  IMG_TYPE=$USER_INPUT
fi
echo "you choosed image-type: '$IMG_TYPE'"

## TODO: complete script
exit 1


