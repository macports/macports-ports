--- src/constants.h	2009-12-10 13:07:26.000000000 -0800
+++ src/constants.h	2009-12-10 13:07:07.000000000 -0800
@@ -103,7 +103,7 @@
 #define INCLUDES	8
 #define	FIELDS		9
 
-#if (BSD || V9) && !__NetBSD__ && !__FreeBSD__
+#if (BSD || V9) && !__NetBSD__ && !__FreeBSD__ && !__APPLE__
 # define TERMINFO	0	/* no terminfo curses */
 #else
 # define TERMINFO	1

