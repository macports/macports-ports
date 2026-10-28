--- base/pcap-snoop.c.orig	2005-08-21 16:19:14.000000000 +0900
+++ base/pcap-snoop.c	2005-08-21 16:19:16.000000000 +0900
@@ -49,7 +49,6 @@
 
 #include <pcap.h>
 #include <unistd.h>
-#include <net/bpf.h>
 #ifndef _WIN32
 #include <sys/param.h>
 #endif
