#!/bin/sh

case "$1" in

start)
  __PREFIX/sbin/postfix start
  ;;

restart)
  __PREFIX/sbin/postfix reload
  ;;

stop)
  __PREFIX/sbin/postfix stop
  ;;

esac
