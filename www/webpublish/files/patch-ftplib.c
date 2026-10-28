--- webpublish/ftplib.c.old	Sun Feb  8 13:58:50 2004
+++ webpublish/ftplib.c	Sun Feb  8 13:59:13 2004
@@ -32,7 +32,7 @@
 #include <string.h>
 #include <errno.h>
 #include <ctype.h>
-#if defined(__unix__)
+#if defined(__unix__) || defined(__APPLE__)
 #include <sys/time.h>
 #include <sys/types.h>
 #include <sys/socket.h>
@@ -91,7 +91,7 @@
 
 GLOBALDEF int ftplib_debug = 0;
 
-#if defined(__unix__) || defined(VMS)
+#if defined(__unix__) || defined(VMS) || defined(__APPLE__)
 #define net_read read
 #define net_write write
 #define net_close close
