#!/bin/sh

case "$1" in

start)
  if [ -f __PREFIX/share/abyss/abyss.pid ]; then
    echo "abyss seems to be running with pid" `cat __PREFIX/share/abyss/abyss.pid`
  else
    __PREFIX/sbin/abyss -c __PREFIX/share/abyss/conf/abyss.conf >> __PREFIX/share/abyss/log/error.log 2>&1
  fi
  ;;

stop)
  if [ -f __PREFIX/share/abyss/abyss.pid ]; then
    (kill QUIT `cat __PREFIX/share/abyss/abyss.pid`) 2> /dev/null > /dev/null
    rm -f __PREFIX/share/abyss/abyss.pid
  else
    echo "abyss doesn't seem to be running (pid file not found)"
  fi
  ;;

esac
