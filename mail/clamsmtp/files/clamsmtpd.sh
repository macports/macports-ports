#!/bin/sh
. __PREFIX__/etc/clamsmtpd.conf
case $1 in
	start)
		mkdir -p $piddir
		chown $user $piddir
		su -m $user -c "$prefix/sbin/clamsmtpd -c $clamsock -D $tmpdir -p $piddir/clamsmtpd.pid $smtp"
		echo -n "clam-smtpd "
		;;
	stop)
		[ -f $piddir/clamsmtpd.pid ] && kill `cat $piddir/clamsmtpd.pid`
		echo -n "clam-smtpd "
		;;
	*)
		echo "usage: clamsmptd.sh {start|stop}" >&2
		;;
esac
