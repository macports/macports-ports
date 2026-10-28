--- clamav.c.orig	2007-01-15 11:35:31.000000000 -0600
+++ clamav.c	2011-06-13 03:20:33.000000000 -0500
@@ -27,7 +27,7 @@
 
 #include <errno.h>
 #include <syslog.h>
-#include <wait.h>
+#include <sys/wait.h>
 
 #include <sys/stat.h>
 #include <sys/types.h>
