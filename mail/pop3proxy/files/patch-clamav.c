--- clamav.c	Mon Nov 22 21:50:51 2004
+++ ../../pop3proxy-1.3.0-beta3/clamav.c	Tue Jan 11 22:33:27 2005
@@ -27,7 +27,7 @@
 
 #include <errno.h>
 #include <syslog.h>
-#include <wait.h>
+#include <sys/wait.h>
 
 #include <sys/stat.h>
 #include <sys/types.h>
