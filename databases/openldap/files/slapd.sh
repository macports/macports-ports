#!/bin/sh
NAME=slapd
PIDFILE=$NAME.pid
CAT=/bin/cat
KILL=/bin/kill

case "$1" in

start)
  echo "starting slapd"
  __PREFIX/libexec/slapd -f __PREFIX/etc/openldap/slapd.conf 
  ;;

stop)
  echo "stopping slapd"
  $KILL -15 `$CAT __PREFIX/var/run/$PIDFILE` 
  ;;

*)
  echo "Usage: __PREFIX/etc/rc.d/$NAME {start|stop}"
  exit 1
  ;;

esac
