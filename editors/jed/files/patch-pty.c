--- src/pty.c.orig	2009-12-13 20:12:55.000000000 -0600
+++ src/pty.c	2010-04-07 23:45:26.000000000 -0500
@@ -19,7 +19,7 @@
 #include <errno.h>
 
 #ifdef HAVE_GRANTPT
-# if !defined (__linux__) && !defined(__CYGWIN__) && !defined(__FreeBSD__) && !defined(_AIX)
+# if !defined (__linux__) && !defined(__CYGWIN__) && !defined(__APPLE__) && !defined(__FreeBSD__) && !defined(_AIX)
 #  define USE_SYSV_PTYS
 #  include <sys/types.h>
 #  include <stropts.h>
