#!/bin/sh

ZOPEINST="__ZOPEINST"

echo "`date`: $0: $1" >>${zopeinst}/log/zopectl.log 2>&1

case "$1" in
start)
	__PREFIX/bin/zopectl start >>$ZOPEINST/log/zopectl.log 2>&1
	;;
stop)
	__PREFIX/bin/zopectl stop >>$ZOPEINST/log/zopectl.log 2>&1
	;;
restart)
	__PREFIX/bin/zopectl restart >>$ZOPEINST/log/zopectl.log 2>&1
	;;
*)
	echo "Usage: `basename $0` {start|stop|restart}" >&2
	;;
esac

exit 0

