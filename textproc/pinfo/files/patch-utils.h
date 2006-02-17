--- src/utils.h.org	2002-02-06 22:16:23.000000000 +0300
+++ src/utils.h	2005-11-07 17:22:15.000000000 +0300
@@ -51,4 +51,5 @@
 
 extern int curses_open;		/* is curses screen open? */
 
+void handlewinch ();
 #endif
