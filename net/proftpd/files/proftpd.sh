#!/bin/sh
NAME=proftpd
CAT=/bin/cat
KILL=/bin/kill

case "$1" in

start)
  echo "starting proftpd ftp server"
  __PREFIX/sbin/proftpd
  ;;

restart)
  echo "restarting proftpd ftp server"
  $KILL -HUP `$CAT __PREFIX/var/run/$NAME.pid` 
  ;;

stop)
  echo "stopping proftpd ftp server"
  $KILL -15 `$CAT __PREFIX/var/run/$NAME.pid` 
  ;;

*)
  echo "Usage: __PREFIX/etc/rc.d/$NAME {start|stop|restart}"
  exit 1
  ;;

esac
