#!/bin/sh

# $Id$

INFILE="$1"

if [ $# -ne 1 ]; then
	echo "usage: $0 <infile>" 1>&2
	exit 1
fi

if [ ! -f "$INFILE" ]; then
	echo "$0: $INFILE: No such file" 1>&2
	exit 1
fi

OUTFILE="$(basename "$INFILE" .bin)"

if [ "$INFILE" == "$OUTFILE" ]; then
	echo "$0: $INFILE: Filename doesn't end with .bin" 1>&2
	exit 1
fi

MACBINARY="/usr/bin/macbinary"
if [ -x "$MACBINARY" ]; then
	"$MACBINARY" decode -o "$OUTFILE" "$INFILE"
	exit $?
fi

DATAFORKFILE="$OUTFILE.data"
RSRCFORKFILE="$OUTFILE.rsrc"
INFOFILE="$OUTFILE.info"

macunpack -3 "$INFILE" || exit $?
cp "$DATAFORKFILE" "$OUTFILE" || exit $?
cp "$RSRCFORKFILE" "$OUTFILE/rsrc" || exit $?
rm -f "$DATAFORKFILE" "$RSRCFORKFILE" "$INFOFILE"
