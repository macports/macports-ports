#! /bin/sh

case `uname -m` in
i*)
      STORE=16000000
      ;;
x86_64)
      STORE=1000
      ;;
esac

MYDIR=`dirname $0`
export MYDIR
PSLDIR="$(cd $MYDIR/../libexec/reduce/psl && pwd -P)"
bin="$PSLDIR/psl/bpsl"
img="$PSLDIR/red/reduce.img"

exec $bin -td $STORE -f $img $@

