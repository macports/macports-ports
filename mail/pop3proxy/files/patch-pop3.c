--- pop3.c	Thu Nov 18 00:06:38 2004
+++ ../../pop3proxy-1.3.0-beta3/pop3.c	Tue Jan 11 22:33:14 2005
@@ -37,7 +37,7 @@
 #include <netinet/in.h>
 #include <syslog.h>
 #include <time.h>
-#include <wait.h>
+#include <sys/wait.h>
 
 #include "pop3.h"
 #include "ip-lib.h"
