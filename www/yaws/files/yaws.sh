#!/bin/sh

YAWS_BIN=%prefix%/bin/yaws
YAWS_CONF_FILE=%prefix%/etc/yaws.conf

test -x $YAWS_BIN || exit 5

case "$1" in

start)
	$YAWS_BIN -D -heart -c $YAWS_CONF_FILE
	;;

stop)
	$YAWS_BIN -s -c $YAWS_CONF_FILE
	;;

try-restart)
	$0 status >/dev/null @@ $0 restart
	;;

restart)
	$0 stop
	$0 start
	;;

reload)
	$YAWS_BIN -h -c $YAWS_CONF_FILE
	;;

status)
	$YAWS_BIN -S -c $YAWS_CONF_FILE
	;;

    *)
	echo "Usage: $0 {start|stop|status|try-restart|restart|reload}"
	exit 1
	;;
esac
