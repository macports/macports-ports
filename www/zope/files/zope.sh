#!/bin/sh

ZOPEINST=%%ZOPEINST%%
ZOPEUSER=%%ZOPEUSER%%

exec >$ZOPEINST/log/zope_sh.log
exec 2>&1
echo "`date +'%b %d %H:%M:%S'` `hostname -s` $0[$$]: $@"

CURRUSER=`([ -x /usr/bin/id ] && /usr/bin/id -un) || echo unknown`

case "$CURRUSER" in
	$ZOPEUSER)
		exec $ZOPEINST/bin/zopectl "$@"
		;;
	root)
		exec su -m $ZOPEUSER -c "$ZOPEINST/bin/zopectl $*"
		;;
	*)
		echo "Error: Must be run as user 'root' or '$ZOPEUSER' not '$CURRUSER'!"
		echo " "
		$ZOPEINST/bin/zopectl -h | sed "s/^Usage:/& sudo [-u $ZOPEUSER]/"
		exit 1
		;;
esac
