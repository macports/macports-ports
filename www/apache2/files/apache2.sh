#!/bin/sh
PREFIX=@@PREFIX@@

case "$1" in
start)
	[ -x ${PREFIX}/apache2/bin/apachectl ] && ${PREFIX}/apache2/bin/apachectl start > /dev/null && echo -n ' apache2'
	;;
stop)
	[ -r ${PREFIX}/apache2/logs/httpd.pid ] && ${PREFIX}/apache2/bin/apachectl stop > /dev/null && echo -n ' apache2'
	;;
*)
	echo "Usage: `basename $0` {start|stop}" >&2
	;;
esac

exit 0
