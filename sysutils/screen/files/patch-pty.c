--- ./pty.c.orig	2003-09-08 16:26:18.000000000 +0200
+++ ./pty.c	2007-10-28 16:27:56.000000000 +0100
@@ -34,7 +34,7 @@
 #endif
 
 /* for solaris 2.1, Unixware (SVR4.2) and possibly others */
-#ifdef HAVE_SVR4_PTYS
+#if defined(HAVE_SVR4_PTYS) && !defined(__APPLE__)
 # include <sys/stropts.h>
 #endif
 
