--- arping-2/arping.c	Sun Aug 29 20:44:15 2004
+++ arping-2/arping.c.new	Mon Aug 30 10:23:33 2004
@@ -62,6 +62,8 @@
 #if defined(linux)
 #define HAVE_ESIZE_TYPES 1
 #define FINDIF 1
+#elif __APPLE__
+#define HAVE_ESIZE_TYPES 1
 #endif
 
 #ifdef HAVE_NET_BPF_H
