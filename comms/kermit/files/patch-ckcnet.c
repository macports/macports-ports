--- ckcnet.c.orig	Fri Nov 14 10:20:57 2003
+++ ckcnet.c	Sun Nov 16 10:19:57 2003
@@ -69,7 +69,7 @@
 #endif /* NT */
 #else /* OS2 */
 #include <arpa/inet.h>
-#include <arpa/nameser.h>
+#include <arpa/nameser8_compat.h>
 #include <resolv.h>
 #ifndef PS2AIX10
 #ifndef BSD4
