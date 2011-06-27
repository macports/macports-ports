--- modules/fcgid/fcgid_conf.c.orig	2011-06-24 15:15:55.000000000 -0700
+++ modules/fcgid/fcgid_conf.c	2011-06-24 15:41:58.000000000 -0700
@@ -28,9 +28,7 @@
 #include "fcgid_global.h"
 #include "fcgid_conf.h"
 
-#ifndef DEFAULT_REL_RUNTIMEDIR /* Win32, etc. */
-#define DEFAULT_REL_RUNTIMEDIR "logs"
-#endif
+#define DEFAULT_REL_RUNTIMEDIR "var/run"
 
 #define DEFAULT_IDLE_TIMEOUT 300
 #define DEFAULT_IDLE_SCAN_INTERVAL 120
