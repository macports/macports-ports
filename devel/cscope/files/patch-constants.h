--- src/constants.h	2006-09-30 10:13:00.000000000 +0200
+++ src/constants.h	2007-02-18 00:01:30.000000000 +0100
@@ -121,6 +121,7 @@
 #  define	KEY_BACKSPACE	0402
 # endif
 
+#ifndef __APPLE__
 # if !sun
 #  define cbreak()	crmode()			/* name change */
 # endif
@@ -133,5 +134,6 @@
 #  define killchar()  (_tty.sg_kill)			/* equivalent */
 # endif /* if UNIXPC */
 #endif	/* if !TERMINFO */
+#endif
 
 #endif /* CSCOPE_CONSTANTS_H */
