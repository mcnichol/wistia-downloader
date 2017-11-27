#!/usr/bin/env bash

msg(){
   if [ -n "$2" ]; then
      printf $2"$1${NO_COLOUR}"
   else
      printf ${WHITE}"$1${NO_COLOUR}"
   fi
}

msgWithColor(){
   msg "$1" "$2"
}

program_is_installed(){
   type $1 &>/dev/null
}

strip_quotes_from_files(){
   FILES=$1

   for f in $FILES; do
      mv "$f"  "./$(echo "$f" | sed 's/\"//g')"
   done
}
