#!/bin/sh
#
# Postgrey Macports startup script

# default values
POSTGREY_OPTS="--inet=127.0.0.1:60000"
USER_OPTS="--user=postgrey --group=postgrey"
PIDFILE=__PREFIX/var/run/postgrey/postgrey.pid

# create empty .local files if they don't exist
if [ ! -r __PREFIX/etc/postgrey/postgrey_whitelist_clients.local ]
then
    touch __PREFIX/etc/postgrey/postgrey_whitelist_clients.local
fi
if [ ! -r __PREFIX/etc/postgrey/postgrey_whitelist_recipients ]
then
    cp __PREFIX/etc/postgrey/postgrey_whitelist_recipients.default \
    touch __PREFIX/etc/postgrey/postgrey_whitelist_recipients
fi

# Read config file if it exists
if [ -r __PREFIX/etc/postgrey/postgrey.conf ]
then
    . __PREFIX/etc/postgrey/postgrey.conf
fi

POSTGREY_OPTS="--pidfile=$PIDFILE --daemonize $POSTGREY_OPTS $USER_OPTS $WL_CLIENTS $WL_RECIPIENTS"
if [ -z "$POSTGREY_TEXT" ]; then
    POSTGREY_TEXT_OPT=""
else
    POSTGREY_TEXT_OPT="--greylist-text=$POSTGREY_TEXT"
fi

# Start or stop
case "$1" in

start)
  echo "starting postgrey"
  # db cleanup because files may be unusable in some cases
  rm -f __PREFIX/var/spool/postgrey/__db.*
  unset PATH
  cd /
  __PREFIX/sbin/postgrey $POSTGREY_OPTS "$POSTGREY_TEXT_OPT"
  ;;

stop)
  echo "stopping postgrey"
  if [ -r $PIDFILE ]
  then
    kill `cat $PIDFILE` 2> /dev/null
  else
    pid=`ps ax | awk '{if ($5=="__PREFIX/sbin/postgrey") print $1}'`
    /bin/kill $pid 2> /dev/null
  fi
  ;;
restart)
  $0 stop
  $0 start
  ;;
esac

