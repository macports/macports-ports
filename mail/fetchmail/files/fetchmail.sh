#!/bin/sh

case "$1" in

start)
	if [ -f __PREFIX/etc/fetchmailrc ]; then
		__PREFIX/bin/fetchmail \
			--fetchmailrc __PREFIX/etc/fetchmailrc \
			--logfile /var/log/mail.log
	fi
	;;

restart)
	__PREFIX/bin/fetchmail --quit
	if [ -f __PREFIX/etc/fetchmailrc ]; then
		__PREFIX/bin/fetchmail \
			--fetchmailrc __PREFIX/etc/fetchmailrc \
			--logfile /var/log/mail.log
	fi
	;;

stop)
	__PREFIX/bin/fetchmail --quit
	;;

esac

