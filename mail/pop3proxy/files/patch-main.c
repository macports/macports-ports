--- main.c	Tue Nov 23 23:26:12 2004
+++ ../../pop3proxy-1.3.0-beta3/main.c	Tue Jan 11 22:34:30 2005
@@ -34,6 +34,7 @@
 #include <syslog.h>
 #include <signal.h>
 #include <time.h>
+#include <sys/time.h>
 
 #include "pop3.h"
 #include "ip-lib.h"
