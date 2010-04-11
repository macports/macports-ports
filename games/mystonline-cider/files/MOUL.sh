#!/bin/bash

# This script runs the game launcher, installing it if it's not already there.

export WINEPREFIX="@WINEPREFIX@"

USER=$(id -u)
GROUP=$(id -g)

#if [ "$(stat -f '%u %g' "$WINEPREFIX")" != "$USER $GROUP" ]; then
    "@LIBEXEC@/chown-data" "$USER:$GROUP"
#fi

LAUNCHER="@LAUNCHER@"
BOOTSTRAP_LAUNCHER="@BOOTSTRAP_LAUNCHER@"
if [ ! -r "$LAUNCHER" ]; then
    cp -p "$BOOTSTRAP_LAUNCHER" "$LAUNCHER"
fi

"$(dirname "$0")/../Resources/Myst Online.app/Contents/MacOS/cider" &
