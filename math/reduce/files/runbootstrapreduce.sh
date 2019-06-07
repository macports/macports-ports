#! /bin/sh

MYDIR=`dirname $0`
export MYDIR
CSLDIR="$(cd $MYDIR/../libexec/reduce/csl && pwd -P)"
exec $CSLDIR/bootstrapreduce.app/Contents/MacOS/bootstrapreduce "$@"
