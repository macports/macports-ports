--- ssmtp.c.orig	2009-11-23 20:55:11.000000000 +1100
+++ ssmtp.c	2011-05-27 01:52:00.000000000 +1000
@@ -13,6 +13,7 @@
 #define VERSION "2.64"
 #define _GNU_SOURCE
 
+#include <sys/types.h>
 #include <sys/socket.h>
 #include <netinet/in.h>
 #include <sys/param.h>
