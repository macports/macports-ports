--- adig.c.orig	2008-07-29 17:36:04.000000000 -0700
+++ adig.c	2008-07-29 17:36:39.000000000 -0700
@@ -27,6 +27,9 @@
 #include <netinet/in.h>
 #include <arpa/inet.h>
 #include <arpa/nameser.h>
+#ifdef HAVE_ARPA_NAMESER_COMPAT_H
+#include <arpa/nameser_compat.h>
+#endif
 #ifdef HAVE_UNISTD_H
 #include <unistd.h>
 #endif
