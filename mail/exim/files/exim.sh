#!/bin/sh
NAME=exim
PIDFILE=$NAME-daemon.pid
CAT=/bin/cat
KILL=/bin/kill

case "$1" in

start)
  echo "starting exim mail transfer agent"
  __PREFIX/sbin/exim -bd -q30m
  ;;

restart)
  echo "restarting exim mail transfer agent"
  $KILL -HUP `$CAT __PREFIX/var/spool/exim/$PIDFILE` 
  ;;

stop)
  echo "stopping exim mail transfer agent"
  $KILL -15 `$CAT __PREFIX/var/spool/exim/$PIDFILE` 
  ;;

*)
  echo "Usage: __PREFIX/etc/rc.d/$NAME {start|stop|restart}"
  exit 1
  ;;

esac
