--- src/libnet_write.c.orig	2010-11-03 13:35:12.000000000 -0500
+++ src/libnet_write.c	2010-12-04 11:56:31.000000000 -0600
@@ -33,6 +33,7 @@
  */
 
 #include <netinet/in.h>
+#include <sys/types.h>
 #include <netinet/udp.h>
 
 #if (HAVE_CONFIG_H)
