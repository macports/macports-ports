#!/bin/sh
PREFIX=__PREFIX__

case "$1" in
	start)
		[ -x ${PREFIX}/sbin/fcron ] \
			&& ${PREFIX}/sbin/fcron -b \
			&& echo -n ' fcron'
	;;
	stop)
		[ -r ${PREFIX}/var/run/fcron/fcron.pid ] \
			&& kill -KILL `cat ${PREFIX}/var/run/fcron/fcron.pid` \
			&& echo -n ' fcron'
	;;
	restart)
		$0 stop
		$0 start
	;;
	*)
		echo "Usage: `basename $0` {start|stop|restart}" >&2
	;;
esac

exit 0
