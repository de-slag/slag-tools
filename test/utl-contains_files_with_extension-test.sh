#!/bin/bash

source ../bash/utl-contains_files_with_extension.sh

function ok_found_files_test {
  dir=$1
  extension=$2
  contains_files_with_extension $dir $extension
  echo $CONTAINS_FILES_WITH_EXTENSION
}
