#!/bin/sh

case "$1" in
start)
	[ -x %%PREFIX%%/bin/apachectl ] \
            && %%PREFIX%%/bin/apachectl start \
            > /dev/null && echo -n ' apache2'
	;;
stop)
	[ -r %%PREFIX%%/logs/httpd.pid ] \
            && %%PREFIX%%/bin/apachectl stop \
            > /dev/null && echo -n ' apache2'
	;;
*)
	echo "Usage: `basename $0` {start|stop}" >&2
	;;
esac

exit 0
