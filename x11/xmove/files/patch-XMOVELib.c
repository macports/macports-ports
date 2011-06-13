--- xmove/XMOVELib.c.orig	1997-10-18 15:03:47.000000000 -0500
+++ xmove/XMOVELib.c	2011-06-13 03:47:06.000000000 -0500
@@ -24,7 +24,6 @@
 
 #include <X11/Xatom.h>
 #include <errno.h>             /* for EINTR, EADDRINUSE, ... */
-#include <malloc.h>
 #include <sys/ioctl.h>
 #ifdef SYSV
 #include <sys/fcntl.h>
