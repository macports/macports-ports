--- bin/catalina.sh.orig	2010-06-29 07:33:40.000000000 -0700
+++ bin/catalina.sh	2010-07-13 08:47:10.000000000 -0700
@@ -220,6 +220,11 @@
   JAVA_OPTS="$JAVA_OPTS $LOGGING_MANAGER"
 fi
 
+# Run conf_setup.sh to check and repair the conf directory
+if [ -x "$CATALINA_HOME/bin/conf_setup.sh" ]; then
+       CATALINA_BASE="$CATALINA_BASE" "$CATALINA_HOME/bin/conf_setup.sh"
+fi
+
 # ----- Execute The Requested Command -----------------------------------------
 
 # Bugzilla 37848: only output this if we have a TTY
