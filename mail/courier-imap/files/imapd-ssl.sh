#!/bin/sh
NAME=imapd-ssl
CAT=/bin/cat
KILL=/bin/kill

checkinstall()
{
        # test if imap service is present in /etc/pam.d
        if [ ! -f "__PREFIX/etc/pam.d/imap" ]; then
                cp /etc/pam.d/passwd /etc/pam.d/imap
        fi      
}

case "$1" in

start)
  checkinstall
  echo "starting courier-imap - imapd-ssl"
  source __PREFIX/etc/courier-imap/imapd
  source __PREFIX/etc/courier-imap/imapd-ssl
  __PREFIX/libexec/imapd-ssl.rc start
  ;;

stop)
  echo "stopping courier-imap - imapd-ssl"
  source __PREFIX/etc/courier-imap/imapd
  source __PREFIX/etc/courier-imap/imapd-ssl
  __PREFIX/libexec/imapd-ssl.rc stop
  ;;

*)
  echo "Usage: __PREFIX/etc/rc.d/$NAME {start|stop}"
  exit 1
  ;;

esac
