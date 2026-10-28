--- libpcap_stuff.c.org	2006-01-23 17:58:11.000000000 +0100
+++ libpcap_stuff.c	2006-01-23 17:58:46.000000000 +0100
@@ -16,8 +16,8 @@
 #include <string.h>
 #include <stdlib.h>
 #include <sys/ioctl.h>
-#include <pcap.h>
 #include <net/bpf.h>
+#include <pcap.h>
 
 #include "globals.h"
 
