--- win/tty/termcap.c.orig	2006-08-09 19:55:36.000000000 +0900
+++ win/tty/termcap.c	2006-08-09 20:05:44.000000000 +0900
@@ -861,7 +861,7 @@
 
 #include <curses.h>
 
-#ifndef LINUX
+#if !defined(LINUX) && !defined(__APPLE__)
 extern char *tparm();
 #endif
 
