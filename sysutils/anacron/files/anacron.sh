#!/bin/sh

CRONTAB=/etc/crontab

checkinstall() 
{
	# test if anacrontab is present
	if [ ! -f "__PREFIX/etc/anacrontab" ]; then
		echo "Error: __PREFIX/etc/anacrontab is missing!"
		echo "Try copying __PREFIX/etc/anacrontab.sample to __PREFIX/etc/anacrontab"
		exit 1
	fi

	# test if default directory are present, if not we create them
	if [ ! -d "__PREFIX/etc/cron.daily" ]; then
		mkdir __PREFIX/etc/cron.daily
	fi

	if [ ! -d "__PREFIX/etc/cron.weekly" ]; then
		mkdir __PREFIX/etc/cron.weekly
	fi

	if [ ! -d "__PREFIX/etc/cron.monthly" ]; then
		mkdir __PREFIX/etc/cron.monthly
	fi


	# Add anacron to /etc/crontab if not already done
	if [ -z "`grep anacron $CRONTAB`" ]; then
		echo "10	*	*	*	*	root	__PREFIX/sbin/anacron -s" >>$CRONTAB
	fi
}

case "$1" in
start)
	checkinstall
	__PREFIX/sbin/anacron -s
	;;
stop)
	/usr/bin/killall -SIGUSR1 anacron
	;;
*)
	echo "Usage: `basename $0` {start|stop}" >&2
	;;
esac

exit 0

