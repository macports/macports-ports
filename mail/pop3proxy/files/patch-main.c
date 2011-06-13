--- main.c.orig	2007-01-15 11:33:37.000000000 -0600
+++ main.c	2011-06-13 03:20:33.000000000 -0500
@@ -34,6 +34,7 @@
 #include <syslog.h>
 #include <signal.h>
 #include <time.h>
+#include <sys/time.h>
 
 #include "ip-lib.h"
 #include "procinfo.h"
