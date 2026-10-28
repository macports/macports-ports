--- binutils/strings.c.orig	2009-06-26 12:59:38.000000000 -0700
+++ binutils/strings.c	2009-06-26 12:59:46.000000000 -0700
@@ -97,7 +97,7 @@
 typedef off_t file_off;
 #define file_open(s,m) fopen(s, m)
 #endif
-#ifdef HAVE_STAT64
+#if 0
 typedef struct stat64 statbuf;
 #define file_stat(f,s) stat64(f, s)
 #else
