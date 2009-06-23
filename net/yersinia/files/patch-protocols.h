--- src/protocols.h.orig	2009-05-04 11:12:15.000000000 +0200
+++ src/protocols.h	2009-05-04 11:13:49.000000000 +0200
@@ -26,6 +26,7 @@
 #define __PROTOCOLS_H__
 
 #include <pcap.h>
+#include <sys/socket.h>
 #include <net/if.h>
 
 #ifdef SOLARIS
