#! /bin/sh

# File to store the previous workspace
PREV_FILE="/tmp/prev"
CUR_FILE="/tmp/cur"

PREV=`cat $CUR_FILE`
CUR=$1

if [ $PREV ]; then
  PREV=`cat $CUR_FILE`
else
  PREV=1
fi

if (( $CUR != $PREV )); then
  hyprctl dispatch workspace $CUR
  echo $PREV > $PREV_FILE
  echo $CUR > $CUR_FILE
fi
