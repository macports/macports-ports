#!/bin/sh

case "$1" in

start)
  su postgres -c "__PREFIX/bin/pg_ctl start -D __DBDIR -l __PREFIX/log/pgsql.log"
  ;;

restart)
  su postgres -c "__PREFIX/bin/pg_ctl restart -D __DBDIR -m fast"
  ;;

stop)
  su postgres -c "__PREFIX/bin/pg_ctl stop -D __DBDIR -m fast"
  ;;

esac
