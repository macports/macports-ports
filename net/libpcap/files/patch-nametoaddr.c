--- nametoaddr.c.orig	2005-04-03 08:33:42.000000000 -0400
+++ nametoaddr.c	2005-04-03 08:35:24.000000000 -0400
@@ -390,7 +390,7 @@
  * compile on one of 3.x or 4.x).
  */
 #if !defined(sgi) && !defined(__NetBSD__) && !defined(__FreeBSD__) && \
-       !defined(_UNICOSMP)
+       !defined(_UNICOSMP) && !defined(__APPLE__)
 extern int ether_hostton(char *, struct ether_addr *);
 #endif
 
