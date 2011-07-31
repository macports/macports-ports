--- container/catalina/src/bin/catalina.sh.orig	2005-09-23 06:45:08.000000000 -0700
+++ container/catalina/src/bin/catalina.sh	2005-10-25 12:54:10.000000000 -0700
@@ -146,6 +146,11 @@
   JAVA_OPTS="$JAVA_OPTS "-Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager" "-Djava.util.logging.config.file="$CATALINA_BASE/conf/logging.properties"
 fi
 
+# Run conf_setup.sh to check and repair the conf directory
+if [ -x "$CATALINA_HOME/bin/conf_setup.sh" ]; then
+	CATALINA_BASE="$CATALINA_BASE" "$CATALINA_HOME/bin/conf_setup.sh"
+fi
+
 # ----- Execute The Requested Command -----------------------------------------
 
 echo "Using CATALINA_BASE:   $CATALINA_BASE"
