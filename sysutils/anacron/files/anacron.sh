#!/bin/sh

CRONTAB=/etc/crontab

case "$1" in
start)
	[ -n "`grep anacron $CRONTAB`" ] \
		|| echo "10  *  *  *  *  root  __PREFIX/sbin/anacron -s" >>$CRONTAB
	__PREFIX/sbin/anacron -s
	;;
stop)
	/usr/bin/killall -SIGUSR1 anacron
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

