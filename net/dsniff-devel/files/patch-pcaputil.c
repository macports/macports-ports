--- pcaputil.c.old	Thu Mar 25 11:14:26 2004
+++ pcaputil.c	Thu Mar 25 11:14:33 2004
@@ -14,6 +14,7 @@
 #include <string.h>
 #include <err.h>
 #include <pcap.h>
+#undef BSD
 #ifdef BSD
 #include <pcap-int.h>
 #endif
