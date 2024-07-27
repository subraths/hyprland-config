#!/bin/bash
# File to store the previous workspace
PREV_FILE="/tmp/prev"
CUR_FILE="/tmp/cur"


PREV=$(cat $CUR_FILE)
CUR=$1

hyprctl dispatch workspace $CUR

echo $PREV > $PREV_FILE
echo $CUR > $CUR_FILE

# 1. check for CURRENT
# 2. if not present set CURRENT = 1
# 3. before swap set PREV to CURRENT
# 4. SWAP workspace
# 5. SET CURRENT to new workspace
