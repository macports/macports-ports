--- privoxy.sh.orig	Thu Oct 17 11:04:22 2002
+++ privoxy.sh	Fri Oct 29 20:07:36 2004
@@ -75,27 +75,17 @@
 # logfile is writable by $P_USER (logfile is defined in config), and that 
 # there is suitable write access for $P_PIDFILE.
 
-PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin/:/usr/bin:/sbin:/bin
+PATH=@@PREFIX@@/sbin:@@PREFIX@@/bin:/usr/sbin/:/usr/bin:/sbin:/bin
 P_NAME=Privoxy
 # Path to executable.
 P_DAEMON=privoxy
 # Full path to location of Privoxy config file. 
-P_CONF_FILE=/usr/local/etc/privoxy/config
+P_CONF_FILE=@@PREFIX@@/etc/privoxy/config
 # Full path to PID file location. Location must be writable by 
 # whoever runs this script.
-P_PIDFILE=/var/run/privoxy.pid
-# If uncommented, this script will try to run as USER=privoxy, which
-# may require special handling of config, *.action, trust, logfile, 
-# jarfile, and pidfile.
-P_USER=privoxy
+P_PIDFILE=@@PREFIX@@/var/run/privoxy.pid
 
-# If a privoxy user is specified, lets try that. /bin/sh does not seem to 
-# know about $UID.
-if [ "$USER" = "root" ] && [ -n "$P_USER" ] && id $P_USER >/dev/null; then
-  P_OWNER=$P_USER
-else 
-  P_OWNER=$USER
-fi
+P_OWNER=@@PRIVOXY_USER@@
 
 if [ ! -f $P_CONF_FILE ]; then
   echo "Can't find $P_CONF_FILE, exiting."
