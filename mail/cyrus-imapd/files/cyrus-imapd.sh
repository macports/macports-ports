#!/bin/sh

case "$1" in

start)
    echo "Starting the Cyrus IMAP Server"
    __PREFIX__/bin/master -d
    ;;

stop)
    echo "Stopping the Cyrus IMAP Server"
    kill -TERM $(cat __PREFIX__/var/run/cyrus-master.pid)
    ;;

*)
    echo "Usage: __PREFIX__/etc/rc.d/cyrus-imapd.sh {start|stop}
    exit 1
    ;;

esac
