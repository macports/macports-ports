#!/bin/sh

RESTART_MODE=__RSMODE
STOP_MODE=__STMODE

case "$1" in

start)
  su postgres -c "__PREFIX/bin/pg_ctl start -D __DBDIR -l __LOGDIR/pgsql.log"
  ;;

restart)
  su postgres -c "__PREFIX/bin/pg_ctl restart -D __DBDIR -l __LOGDIR/pgsql.log -m $RESTART_MODE"
  ;;

stop)
  su postgres -c "__PREFIX/bin/pg_ctl stop -D __DBDIR -m $STOP_MODE"
  ;;

esac
