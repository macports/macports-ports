--- src/vm.c.orig	Tue Apr 29 09:25:20 2003
+++ src/vm.c	Sat May  8 01:29:33 2004
@@ -45,6 +45,8 @@
 #ifdef _MSC_VER
 #include <io.h>   /* read() */
 #define lseek64 lseek
+#elif defined(__DARWIN__)
+#define lseek64 lseek
 #endif /* _MSC_VER */
 
 /*
@@ -128,7 +130,7 @@
 
 static void dvd_read_name(char *name, const char *device) {
     int fd, i;
-#if !defined(__FreeBSD__) && !defined(WIN32)
+#if !defined(__FreeBSD__) && !defined(WIN32) && !defined(__DARWIN__)
     off64_t off;
 #else
     off_t off;
