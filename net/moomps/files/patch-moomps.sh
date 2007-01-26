--- moomps.sh.org	2006-10-01 10:13:22.000000000 -0700
+++ moomps.sh	2006-10-01 13:13:11.000000000 -0700
@@ -14,8 +14,8 @@
 # config: $MOOMPSRCFILE
 # pidfile: $PIDFILE
 
-PATH=/sbin:/bin:/usr/bin:/usr/sbin
-. /etc/init.d/functions
+#PATH=/sbin:/bin:/usr/bin:/usr/sbin
+#. /etc/init.d/functions
 
 [ -f $SBINDIR/moomps ] || exit 1
 [ -d `dirname $MOOMPSRCFILE` ] || exit 1
@@ -31,7 +31,7 @@
     touch $pidfile
     chown moomps $pidfile
     # load all configuration files from directory and use process ID file:
-    daemon --user moomps $SBINDIR/moomps --pid-file $pidfile -r $MOOMPSRCFILE $DATADIR/moomps
+    $SBINDIR/moomps --pid-file $pidfile -r $MOOMPSRCFILE $DATADIR/moomps/moofiles
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
