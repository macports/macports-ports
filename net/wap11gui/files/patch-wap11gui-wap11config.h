--- wap11gui/wap11config.h.orig	Sat Feb  7 08:09:01 2004
+++ wap11gui/wap11config.h	Sat Feb  7 08:09:38 2004
@@ -18,6 +18,9 @@
 #ifndef WAP11CONFIG_H
 #define WAP11CONFIG_H
 
+#ifdef __APPLE__
+#include <sys/types.h>
+#endif
 #include <netinet/in.h>
 #if NET_SNMP
 #include <net-snmp/net-snmp-config.h>
