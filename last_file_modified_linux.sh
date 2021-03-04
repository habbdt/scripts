#!/bin/bash

####################read-me#########
# last file modified in a directory
###################################


DIRECTORY="$(find /mnt/home/ -maxdepth 1 -type d)"

for dir in $DIRECTORY; do
  FILE_MODIFIED="$(find $dir -type f -printf '%T+ %p\n' | sort -n | tail -2)"

  if [ -z "$FILE_MODIFIED" ]
  then
    echo "$dir is EMPTY"
    echo ""
  else
    echo "$dir"
    echo "$FILE_MODIFIED"
    echo ""
  fi
done