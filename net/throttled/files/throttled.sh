#!/bin/sh
CONF=__PREFIX__/etc/throttled.conf

case $1 in
 
start)
	/sbin/ipfw -f flush && sh $THROTTLED && echo -n ' throttled'
	;;

stop)
	pid=`ps ax | awk '{if (match($5, ".*/throttled$") || $5 == "throttled") print $1}'`
	if test "$pid" != ""; then
		kill -HUP ${pid}
	fi
	;;

restart)
	${0} stop && ${0} start
	;;

*)
	echo "Usage: `basename ${0}` {start|stop|restart}"
	;;
esac
