--- src/pty.c.orig	2008-03-31 00:47:37.000000000 +0200
+++ src/pty.c	2008-03-31 00:48:54.000000000 +0200
@@ -19,7 +19,7 @@
 #include <errno.h>
 
 #ifdef HAVE_GRANTPT
-# if !defined (__linux__) && !defined(__CYGWIN__) && !defined(__FreeBSD__)
+# if !defined (__linux__) && !defined(__CYGWIN__) && !defined(__APPLE__) && !defined(__FreeBSD__)
 #  define USE_SYSV_PTYS
 #  include <sys/types.h>
 #  include <stropts.h>
