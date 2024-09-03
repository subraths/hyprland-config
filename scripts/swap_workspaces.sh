#!/bin/bash

# File to store the previous workspace
CUR_FILE="/tmp/cur"
PREV_FILE="/tmp/prev"

CUR=`cat $CUR_FILE`
PREV=`cat $PREV_FILE`

hyprctl dispatch workspace $PREV

# swap
TEMP=$CUR
CUR=$PREV
PREV=$TEMP

echo $CUR > $CUR_FILE
echo $PREV > $PREV_FILE
