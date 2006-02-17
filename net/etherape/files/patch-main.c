--- src/main.c.org	2006-01-10 10:06:26.000000000 -0800
+++ src/main.c	2006-02-16 22:37:29.000000000 -0800
@@ -21,6 +21,8 @@
 #include <config.h>
 #endif
 
+#include <stdint.h>
+#include <sys/types.h>
 #include <netinet/in.h>
 #include "globals.h"
 #include <signal.h>
