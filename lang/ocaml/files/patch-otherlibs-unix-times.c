--- otherlibs/unix/times.c.orig	2005-08-13 09:00:26.000000000 +0900
+++ otherlibs/unix/times.c	2005-08-13 09:26:25.000000000 +0900
@@ -20,6 +20,7 @@
 #include <time.h>
 #include <sys/types.h>
 #include <sys/times.h>
+#include <machine/limits.h> /* workaround for radr://4215384 */
 
 #ifndef CLK_TCK
 #ifdef HZ
