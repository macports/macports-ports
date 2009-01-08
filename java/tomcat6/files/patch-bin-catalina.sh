--- bin/catalina.sh.orig	2009-01-02 11:57:54.000000000 -0800
+++ bin/catalina.sh	2009-01-02 11:58:16.000000000 -0800
@@ -185,6 +185,11 @@
   LOGGING_CONFIG="-Djava.util.logging.config.file=$CATALINA_BASE/conf/logging.properties"
 fi
 
+# Run conf_setup.sh to check and repair the conf directory
+if [ -x "$CATALINA_HOME/bin/conf_setup.sh" ]; then
+       CATALINA_BASE="$CATALINA_BASE" "$CATALINA_HOME/bin/conf_setup.sh"
+fi
+
 # ----- Execute The Requested Command -----------------------------------------
 
 # Bugzilla 37848: only output this if we have a TTY
