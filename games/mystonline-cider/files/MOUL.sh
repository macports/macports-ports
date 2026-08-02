#!/bin/bash

# This script runs the game launcher, installing it if it's not already there.

export WINEPREFIX="@WINEPREFIX@"

USER=$(id -u)
GROUP=$(id -g)

#if [ "$(stat -f '%u %g' "$WINEPREFIX")" != "$USER $GROUP" ]; then
    "@LIBEXEC@/chown-data" "$USER:$GROUP"
#fi

# http://mystonline.com/forums/viewtopic.php?f=40&t=26954&start=0#p404798
ASSETS="@ASSETS@"
rm -f "$ASSETS/dat/GlobalClothing_District_FemaleFan01.prp" "$ASSETS/dat/GlobalClothing_District_MaleFan01.prp"

LAUNCHER="@LAUNCHER@"
BOOTSTRAP_LAUNCHER="@BOOTSTRAP_LAUNCHER@"
if [ ! -r "$LAUNCHER" ]; then
    cp -p "$BOOTSTRAP_LAUNCHER" "$LAUNCHER"
fi

"$(dirname "$0")/../Resources/Myst Online.app/Contents/MacOS/cider" &
