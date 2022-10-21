--- src/protocols.h.orig	2017-08-24 06:36:01.000000000 -0500
+++ src/protocols.h	2022-01-24 19:25:47.000000000 -0600
@@ -24,6 +24,7 @@
 #define __PROTOCOLS_H__
 
 #include <pcap.h>
+#include <sys/socket.h>
 #include <net/if.h>
 
 #ifdef SOLARIS
