#!/bin/sh
# $Id: openssh.sh,v 1.1 2003/08/18 05:17:39 waqar Exp $
# also from fink
if [ -f "__PREFIX/sbin/sshd" ]; then

	if [ ! -f "__PREFIX/etc/ssh/ssh_host_key" ]; then
		__PREFIX/bin/ssh-keygen -t rsa1 -f \
			__PREFIX/etc/ssh/ssh_host_key -N "" -C `hostname`
	fi
	if [ ! -f __PREFIX/etc/ssh/ssh_host_dsa_key ]; then
		__PREFIX/bin/ssh-keygen -t dsa -f \
			__PREFIX/etc/ssh/ssh_host_dsa_key -N "" -C `hostname`
	fi
	if [ ! -f __PREFIX/etc/ssh/ssh_host_rsa_key ]; then
		__PREFIX/bin/ssh-keygen -t rsa -f \
			__PREFIX/etc/ssh/ssh_host_rsa_key -N "" -C `hostname`
	fi

	echo "starting OpenSSH Server .."
	__PREFIX/sbin/sshd
fi
