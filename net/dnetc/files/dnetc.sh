#!/bin/sh
#
# $Id: dnetc.sh,v 1.1 2003/08/15 15:30:33 fkr Exp $
#
# This was stolen from NetBSD rc.d script.
#
command="dnetc"
dnetc_user="nobody"
dnetc_group="nobody"
dnetc_homedir="__PREFIX/var/db/dnetc"
PATH=__PREFIX/bin:/bin:/sbin:/usr/bin:/usr/sbin

dnetc_config() {
    if [ ! -d ${dnetc_homedir} ]; then
        mkdir ${dnetc_homedir}
        chmod 755 ${dnetc_homedir}
        chown ${dnetc_user}:${dnetc_group} ${dnetc_homedir}
    fi

    su -fm ${dnetc_user} -c "cd ${dnetc_homedir} && exec ${command} -config"
    return 0
}

dnetc_start() {
    if [ ! -f ${dnetc_homedir}/dnetc.ini ]; then
        dnetc_config
    fi

    echo "Starting distributed.net client.."
    su -fm ${dnetc_user} -c "cd ${dnetc_homedir} && exec ${command} -quiet" \
        2>/dev/null 1>/dev/null
}


case "$1" in

start)
  #__PREFIX/bin/dnetc start
  dnetc_start
  ;;

config)
  #__PREFIX/bin/dnetc -config
  dnetc_config
  ;;

restart)
  __PREFIX/bin/dnetc -restart
  ;;

stop)
  __PREFIX/bin/dnetc -shutdown
  ;;

*)
  echo "Usage: __PREFIX/etc/rc.d/dnetc {start|stop|restart|config}"
  exit 1
  ;;

esac
