#!/bin/sh

# $Id$

INFILE="$1"
OUT="$2"

if [ $# -ne 2 ]; then
	echo "usage: $0 <infile> <outfile or outdir>" 1>&2
	exit 1
fi

if [ ! -f "$INFILE" ]; then
	echo "$0: $INFILE: No such file" 1>&2
	exit 1
fi

if [ -d "$OUT" ]; then
	OUTDIR="$OUT"
	OUTFILE="$OUTDIR/`basename "$INFILE" .bin`"
else
	OUTFILE="$OUT"
	OUTDIR="`dirname "$OUTFILE"`"
fi

if [ ! -d "$OUTDIR" ]; then
	echo "$0: $OUTDIR: No such directory" 1>&2
	exit 1
fi

MACBINARY="/usr/bin/macbinary"
if [ -x "$MACBINARY" ]; then
	"$MACBINARY" decode -C "$OUTDIR" -o "$OUTFILE" "$INFILE"
	exit $?
fi

DATAFORKFILE="$OUTFILE.data"
RSRCFORKFILE="$OUTFILE.rsrc"
INFOFILE="$OUTFILE.info"

(cd "$OUTDIR" && macunpack -3 "$INFILE" || exit $?)
cp "$DATAFORKFILE" "$OUTFILE" || exit $?
cp "$RSRCFORKFILE" "$OUTFILE/rsrc" || exit $?
rm -f "$DATAFORKFILE" "$RSRCFORKFILE" "$INFOFILE"
