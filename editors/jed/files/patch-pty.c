--- src/pty.c.org	Sun Sep  5 08:55:33 2004
+++ src/pty.c	Sun Sep  5 08:56:08 2004
@@ -18,7 +18,7 @@
 
 #include <errno.h>
 
-#if !defined (__linux__) && !defined(__CYGWIN__) && defined(HAVE_GRANTPT)
+#if !defined (__linux__) && !defined(__CYGWIN__) && !defined (__APPLE__) && defined(HAVE_GRANTPT) 
 # define USE_SYSV_PTYS
 # include <sys/types.h>
 # include <stropts.h>
