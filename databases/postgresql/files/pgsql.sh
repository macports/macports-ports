#!/bin/sh

RESTART_MODE=fast
STOP_MODE=fast

DBDIR=__PREFIX__/var/db/pgsql/defaultdb
PGCTL=__PREFIX__/bin/pg_ctl
PGVAC=__PREFIX__/bin/pg_autovacuum
OPTIONS="'-c stats_start_collector=true -c stats_row_level=true'"

LOGFILE=__PREFIX__/var/log/pgsql/pgsql.log
VLOGFILE=__PREFIX__/var/log/pgsql/pg_autovacuum.log

SU="su -l postgres -c"

case "$1" in

start)
	${SU} "exec $PGCTL start -D $DBDIR -l $LOGFILE -o $OPTIONS"
	if [ -f ${PGVAC} -a -x ${PGVAC} ]; then
		${SU} "touch ${VLOGFILE} || echo unable to write ${VLOGFILE}"
		${SU} "exec ${PGVAC} -D -L ${VLOGFILE}"
	fi
	;;

restart)
	${SU} "exec $PGCTL restart -D $DBDIR -l $LOGFILE -m $RESTART_MODE"
	;;

stop)
	${SU} "exec $PGCTL stop -D $DBDIR -m $STOP_MODE"
	;;

esac
