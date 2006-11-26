--- getc_putc.cpp.org	2006-11-26 00:02:44.000000000 -0800
+++ getc_putc.cpp	2006-11-26 00:03:50.000000000 -0800
@@ -16,6 +16,8 @@
 
 #include "duration.h"
 #include "getc_putc.h"
+#include <sys/param.h>
+#define min MIN
 
 static void usage()
 {
