--- webpublish/ftplib.h.old	Sun Feb  8 13:41:22 2004
+++ webpublish/ftplib.h	Sun Feb  8 13:42:04 2004
@@ -24,7 +24,7 @@
 #if !defined(__FTPLIB_H)
 #define __FTPLIB_H
 
-#if defined(__unix__) || defined(VMS)
+#if defined(__unix__) || defined(VMS) || defined(__APPLE__)
 #define GLOBALDEF
 #define GLOBALREF extern
 #elif defined(_WIN32)
