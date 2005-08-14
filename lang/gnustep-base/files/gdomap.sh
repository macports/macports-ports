#!/bin/sh

CAT="/bin/cat"
KILL="/bin/kill -15"
PIDFILE="/var/run/gdomap.pid"

case "$1" in

start)
  
	echo "Starting gdomap"
    . /opt/local/GNUstep/System/Library/Makefiles/GNUstep.sh
    /opt/local/bin/opentool gdomap -p -I $PIDFILE &
    ;;

stop)

	echo "Stopping gdomap"
	if [ -r $PIDFILE ]
	    then
		$KILL `$CAT $PIDFILE`
	fi
	;;
	
*)
  echo "Usage: $0 {start|stop}"
  exit 1
  ;;

esac
