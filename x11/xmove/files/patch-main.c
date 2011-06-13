--- xmove/main.c.orig	1997-10-20 17:20:47.000000000 -0500
+++ xmove/main.c	2011-06-13 03:47:06.000000000 -0500
@@ -42,7 +42,6 @@
 #include <signal.h>
 #define NEED_REPLIES
 #include <X11/Xproto.h>
-#include <malloc.h>
 
 #if defined(DL_W_PRAGMA) || defined(DL_WOUT_PRAGMA)
 #include <dlfcn.h>
