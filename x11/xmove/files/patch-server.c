--- xmove/server.c	Sun Aug  3 21:36:45 1997
+++ ../../xmove.patches/xmove/server.c	Tue Mar 22 10:28:17 2005
@@ -40,7 +40,6 @@
 #include <sys/time.h>          /* for struct timeval * */
 #include <errno.h>             /* for EINTR, EADDRINUSE, ... */
 #include <X11/Xproto.h>
-#include <malloc.h>
 
 #include "xmove.h"
 
