#!/bin/sh

PIDFILE=named.pid
CAT=/bin/cat
KILL=/bin/kill

case "$1" in

start)
  echo "starting bind"
  %%PREFIX%%/sbin/named
  ;;

restart)
  echo "restarting bind"
  $KILL -HUP `$CAT %%PREFIX%%/var/run/$PIDFILE` 
  ;;

stop)
  echo "stopping bind"
  $KILL -15 `$CAT %%PREFIX%%/var/run/$PIDFILE` 
  ;;

*)
  echo "Usage: %%PREFIX%%/etc/rc.d/bind {start|stop|restart}"
  exit 1
  ;;

esac
