--- rpmio/rpmzq.c.orig	2009-03-09 03:27:30.000000000 +0100
+++ rpmio/rpmzq.c	2009-03-11 16:39:01.000000000 +0100
@@ -71,6 +71,10 @@
 
 #include "debug.h"
 
+#if !defined(POPT_ARGFLAG_TOGGLE)	/* XXX compat with popt < 1.15 */
+#define	POPT_ARGFLAG_TOGGLE	0
+#endif
+
 /*@unchecked@*/
 int _rpmzq_debug = 0;
 
