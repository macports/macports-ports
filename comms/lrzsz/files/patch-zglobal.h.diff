--- src/zglobal.h.orig	Wed May 28 13:05:52 2003
+++ src/zglobal.h	Wed May 28 13:06:01 2003
@@ -392,7 +392,7 @@
 #define vchar(x) putc(x,stderr)
 #define vstring(x) fputs(x,stderr)
 
-#ifdef __GNUC__
+#if defined(__GNUC__) && !defined(__APPLE__)
 #if __GNUC__ > 1
 #define vstringf(format,args...) fprintf(stderr,format, ##args)
 #endif
