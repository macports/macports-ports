--- bin/jetty.sh	Thu Sep 23 17:02:38 2004
+++ bin/jetty.sh	Thu Sep 23 17:04:12 2004
@@ -73,6 +73,9 @@
 #   The Jetty PID file, defaults to $JETTY_RUN/jetty.pid
 #   
 
+JETTY_HOME=@JETTY_HOME@
+JETTY_RUN=@JETTY_RUN@
+
 usage()
 {
     echo "Usage: $0 {start|stop|run|restart|check|supervise|demo} [ CONFIGS ... ] "
