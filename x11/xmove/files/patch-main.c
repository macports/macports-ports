--- xmove/main.c	Tue Oct 21 00:20:47 1997
+++ ../../xmove.patches/xmove/main.c	Tue Mar 22 10:28:17 2005
@@ -42,7 +42,6 @@
 #include <signal.h>
 #define NEED_REPLIES
 #include <X11/Xproto.h>
-#include <malloc.h>
 
 #if defined(DL_W_PRAGMA) || defined(DL_WOUT_PRAGMA)
 #include <dlfcn.h>
