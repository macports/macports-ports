#!/bin/sh
NAME=mysql4.sh
CAT=/bin/cat
KILL=/bin/kill
PIDFILE=mysqld.pid

case "$1" in

start)
  
  echo "starting mysql"
  __PREFIX/bin/mysqld_safe --user=mysql --pid-file=__PREFIX/var/run/mysqld/mysqld.pid &
  ;;

stop)
  echo "stopping mysql"
  $KILL -15 `$CAT __PREFIX/var/run/mysqld/$PIDFILE` 
  ;;

*)
  echo "Usage: __PREFIX/etc/rc.d/mysql4.sh {start|stop}"
  exit 1
  ;;

esac
