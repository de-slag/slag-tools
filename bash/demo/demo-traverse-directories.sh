#!/bin/bash
set -euo pipefail

function traverse_entry {
  local entry_path=$1
  if [[ "$entry_path" == *\. ]] || [[ "$entry_path" == *\.\. ]] ; then
    echo "element '$entry_path' is this/parent directory. skipping."
    return
  fi 

  if [ -f $entry_path ] ; then
    echo "it is a regular file: '$entry_path', skipping"
    return
  fi

  if [ -L $entry_path ] ; then
    echo "it is a link: '$entry_path', skipping"
    return
  fi

  if [ ! -d $entry_path ] ; then
    echo "it is NOT a directory. that should not be: '$entry_path', exit"
    ## may
    exit 1
  fi

  echo "this is a directory: '$entry_path'"
  traverse_dir $entry_path

}

function traverse_dir {
  local directory_path=$1

  if [ ! -d $directory_path ] ; then
    echo "'$directory_path' is not a directory"
    exit 1
  fi

  local all_entries=$(ls -a $directory_path)

  for entry in $all_entries ; do
    traverse_entry $directory_path/$entry
  done
}

for i in "$@"
do
case $i in
    -d=*|--dir-to-cleanup=*)
      DIR="${i#*=}"
      shift # past argument=value
      ;;
    -h|--help)
      echo "usage demo-traverse-directories.sh -d=/path/to/dir"
      exit
      ;;
    *)
      # unknown option
      ;;
esac
done

traverse_dir $DIR

