#!/bin/bash

DIR=src
FILE="$DIR.tar"

if [ ! -d "$DIR" ]; then
    if [ ! -r "$FILE" ]; then
        curl -L -o "$FILE" "http://netlib.sandia.gov/cgi-bin/netlib/netlibfiles.tar?filename=netlib/f2c/$DIR" || exit 1
    fi
    tar xf "$FILE" || exit 1
fi

NEWEST=$(find "$DIR" \! -type d -print0 | TZ=UTC xargs -0 gls -tl --time-style="+%Y%m%d" | awk '{print $6; exit}')

if [ -z "$NEWEST" ]; then
    echo "can't find newest item in $DIR directory" 1>&2
    exit 1
fi

DISTDIR="f2c-$NEWEST"
DISTFILE="$DISTDIR.tar.bz2"

echo "$DISTFILE"

mv "$DIR" "$DISTDIR"

if [ ! -r "$DISTFILE" ]; then
    tar cjf "$DISTFILE" "$DISTDIR"
fi

rm -rf "$DISTDIR"
