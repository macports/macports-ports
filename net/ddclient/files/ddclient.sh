#!/bin/sh

NAME=ddclient

CAT=/bin/cat
KILL=/bin/kill

CONFFILE=__PREFIX/etc/$NAME.conf
PIDFILE=__PREFIX/var/run/$NAME.pid

case "$1" in

start)
	if [ -f $CONFFILE ]; then
		echo "Starting $NAME daemon"
		__PREFIX/sbin/$NAME -pid $PIDFILE
	else
		echo "Cannot start $NAME daemon: $CONFFILE does not exist!"
		exit 1
	fi
	;;

stop)
	if [ -f $PIDFILE ]; then
		echo "Stopping $NAME daemon"
		$KILL -15 `$CAT $PIDFILE`
	else
		echo "Cannot stop $NAME daemon: $PIDFILE does not exist!"
		exit 1
	fi
	;;

restart)
	$0 stop
	$0 start
	;;

*)
	echo "Usage: $0 {start|stop|restart}"
	exit 1
	;;

esac

