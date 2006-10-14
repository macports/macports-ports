--- ftp.c.org	2006-10-14 01:29:19.000000000 -0700
+++ ftp.c	2006-10-14 01:34:28.000000000 -0700
@@ -59,7 +59,9 @@
 #include <sys/param.h>
 #include <sys/socket.h>
 #include <netinet/in.h>
-
+/* define socklen_t for systems, aka Jaguar, that don't define it */
+#ifndef socklen_t +typedef int socklen_t;
+#endif
 #include <ctype.h>
 #include <err.h>
 #include <errno.h>
