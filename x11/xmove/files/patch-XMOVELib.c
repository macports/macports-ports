--- xmove/XMOVELib.c	Sat Oct 18 22:03:47 1997
+++ ../../xmove.patches/xmove/XMOVELib.c	Tue Mar 22 10:28:17 2005
@@ -24,7 +24,6 @@
 
 #include <X11/Xatom.h>
 #include <errno.h>             /* for EINTR, EADDRINUSE, ... */
-#include <malloc.h>
 #include <sys/ioctl.h>
 #ifdef SYSV
 #include <sys/fcntl.h>
