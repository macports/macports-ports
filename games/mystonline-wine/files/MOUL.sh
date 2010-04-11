#!/bin/bash

# This script runs the game launcher, installing it if it's not already there.

export PREFIX="@PREFIX@"
export WINEPREFIX="@WINEPREFIX@"

function cleanup {
    "$PREFIX/bin/wineserver" -k &
    exit 0
}

trap cleanup SIGHUP SIGINT SIGTERM

# Set DISPLAY if it's not set (e.g. on Tiger).
if [ -z "$DISPLAY" ]; then
    export DISPLAY=:0.0
    # Launch X11.app if it's not already running, preferring the MacPorts version if available.
    if [ -z "$(ps auxww | grep /X11.app/ | grep -v grep)" ]; then
        if [ -d "@APPLICATIONS_DIR@/X11.app" ]; then
            open "@APPLICATIONS_DIR@/X11.app"
        elif [ -d "/Applications/Utilities/X11.app" ]; then
            open "/Applications/Utilities/X11.app"
        else
            echo "No X11.app found" 1>&2
            exit 1
        fi
    fi
fi

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

"$PREFIX/bin/wine" "$LAUNCHER"
sleep 5

# The launcher might have downloaded and launched a new launcher.
# Wait for all apps to exit before exiting this script.
#"$PREFIX/bin/wineserver" -w
SOCKET="$(printf "/tmp/.wine-$USER/server-%x-%x/socket" $(stat -f '%d %i' "$WINEPREFIX"))"
while [ -r "$SOCKET" ]; do
    sleep 1
done
