--- assuan/assuan.h.orig	2005-10-01 14:14:48.000000000 -0600
+++ assuan/assuan.h	2006-03-22 17:52:35.000000000 -0700
@@ -24,6 +24,7 @@
 #include <stdio.h>
 #include <sys/types.h>
 #include <unistd.h>
+#include <sys/socket.h>
 
 
 /* To use this file with libraries the following macros are often
