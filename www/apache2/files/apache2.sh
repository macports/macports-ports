#!/bin/sh
PREFIX=@@PREFIX@@

case "$1" in
start)
	[ -x ${PREFIX}/sbin/apachectl ] && ${PREFIX}/sbin/apachectl start > /dev/null && echo -n ' apache2'
	;;
stop)
	[ -r /var/run/httpd.pid ] && ${PREFIX}/sbin/apachectl stop > /dev/null && echo -n ' apache2'
	;;
*)
	echo "Usage: `basename $0` {start|stop}" >&2
	;;
esac

exit 0
