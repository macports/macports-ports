#!/bin/sh

RESTART_MODE=fast
STOP_MODE=fast

DBDIR=__PREFIX__/var/db/pgsql/defaultdb
LOGFILE=__PREFIX__/var/log/pgsql/pgsql.log
PGCTL=__PREFIX__/bin/pg_ctl

case "$1" in

start)
  su postgres -c "$PGCTL start -D $DBDIR -l $LOGFILE"
  ;;

restart)
  su postgres -c "$PGCTL restart -D $DBDIR -l $LOGFILE -m $RESTART_MODE"
  ;;

stop)
  su postgres -c "$PGCTL stop -D $DBDIR -m $STOP_MODE"
  ;;

esac
