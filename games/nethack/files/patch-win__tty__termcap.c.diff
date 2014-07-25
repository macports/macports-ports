--- nethack-3.4.3/win/tty/termcap.c.orig	2005-09-02 13:35:49.000000000 -0700
+++ nethack-3.4.3/win/tty/termcap.c	2005-09-02 13:36:13.000000000 -0700
@@ -835,7 +835,7 @@
 
 #include <curses.h>
 
-#ifndef LINUX
+#if !defined(LINUX) && !defined(__APPLE__)
 extern char *tparm();
 #endif
 
