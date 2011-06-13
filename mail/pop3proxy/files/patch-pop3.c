--- pop3.c.orig	2007-01-15 11:35:59.000000000 -0600
+++ pop3.c	2011-06-13 03:20:33.000000000 -0500
@@ -37,7 +37,7 @@
 #include <netinet/in.h>
 #include <syslog.h>
 #include <time.h>
-#include <wait.h>
+#include <sys/wait.h>
 
 #if defined (__linux__)
 #  include <linux/netfilter_ipv4.h>
