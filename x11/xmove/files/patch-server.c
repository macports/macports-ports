--- xmove/server.c.orig	1997-08-03 14:36:45.000000000 -0500
+++ xmove/server.c	2011-06-13 03:47:06.000000000 -0500
@@ -40,7 +40,6 @@
 #include <sys/time.h>          /* for struct timeval * */
 #include <errno.h>             /* for EINTR, EADDRINUSE, ... */
 #include <X11/Xproto.h>
-#include <malloc.h>
 
 #include "xmove.h"
 
