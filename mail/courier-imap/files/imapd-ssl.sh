#!/bin/sh
NAME=imapd-ssl
CAT=/bin/cat
KILL=/bin/kill

case "$1" in

start)
  echo "starting courier-imap - imapd-ssl"
  source __PREFIX/etc/courier/imapd
  source __PREFIX/etc/courier/imapd-ssl
  __PREFIX/libexec/imapd-ssl.rc start
  ;;

stop)
  echo "stopping courier-imap - imapd-ssl"
  source __PREFIX/etc/courier/imapd
  source __PREFIX/etc/courier/imapd-ssl
  __PREFIX/libexec/imapd-ssl.rc stop
  ;;

*)
  echo "Usage: __PREFIX/etc/rc.d/$NAME {start|stop}"
  exit 1
  ;;

esac
