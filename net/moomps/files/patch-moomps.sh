--- moomps.sh.org	2006-04-10 13:00:53.000000000 -0700
+++ moomps.sh	2006-05-04 22:37:44.000000000 -0700
@@ -14,16 +14,16 @@
 # config: /etc/moomps/rc
 # pidfile: /var/run/moomps.pid
 
-PATH=/sbin:/bin:/usr/bin:/usr/sbin
-. /etc/init.d/functions
+#PATH=/sbin:/bin:/usr/bin:/usr/sbin
+#. /etc/init.d/functions
 
-[ -f /usr/sbin/moomps ] || exit 1
-[ -d /etc/moomps ] || exit 1
-[ -d /srv/moomps ] || exit 1
+#[ -f __PREFIX__/sbin/moomps ] || exit 1
+#[ -d __PREFIX__/etc/moomps ] || exit 1
+#[ -d __PREFIX__/var/moomps ] || exit 1
 
 return=0
-lockfile=/var/lock/subsys/moomps
-pidfile=/var/run/moomps.pid
+lockfile=__PREFIX__/var/lock/moomps
+pidfile=__PREFIX__/var/run/moomps.pid
 
 
 start(){
@@ -31,7 +31,7 @@
     touch $pidfile
     chown moomps $pidfile
     # load all configuration files from directory and use process ID file:
-    daemon --user moomps /usr/sbin/moomps --pid-file $pidfile /srv/moomps/
+    __PREFIX__/sbin/moomps --pid-file $pidfile __PREFIX__/share/moomps/moofiles
     return=$?
     echo
     [ $return -eq 0 ] && touch $lockfile
@@ -40,7 +40,7 @@
 
 stop(){
     echo -n $"Stopping moomps: "
-    killproc moomps
+    kill -9 `cat $pidfile`
     return=$?
     echo
     [ $return -eq 0 ] && rm -f $pidfile $lockfile
