--- lib/ap-utils.h.orig	Tue Feb 10 21:56:26 2004
+++ lib/ap-utils.h	Tue Feb 10 21:57:01 2004
@@ -19,6 +19,10 @@
 
 #include "config.h"
 
+#ifdef __APPLE__
+#include <sys/types.h>
+#include <stdint.h>
+#else
 #ifdef OS_BSD
 #include <sys/types.h>
 #else
@@ -30,6 +34,7 @@
 typedef unsigned   int uint32_t;
 #endif
 
+#endif
 #endif
 
 #define TITLE "Wireless Access Point Utilites for Unix"
