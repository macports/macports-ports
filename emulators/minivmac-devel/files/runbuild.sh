#!/bin/bash
# $Id$

DIR="$1"
OPTIONS_FILE="$2"

"$DIR/Build.app/Contents/MacOS/Build" &
PID=$!
sleep 1
open -a "$DIR/Build.app" "$OPTIONS_FILE"
wait $PID
