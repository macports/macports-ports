--- src/rxvt.h	2006-10-01 21:50:38.000000000 +0000
+++ src/rxvt.h.new	2007-06-14 22:59:53.000000000 +0000
@@ -53,7 +53,6 @@
 # define ALL_NUMERIC_PTYS
 #endif
 
-
 #include <stdio.h>
 #include <ctype.h>
 #include <errno.h>
@@ -197,6 +196,11 @@
 # define ut_name    ut_user
 #endif
 
+/* Need this to get prototype for openpty(), at least on Mac OS X 10.4 */
+#ifdef OS_DARWIN
+# include <util.h>
+#endif
+
 #ifdef TTY_GID_SUPPORT
 # include <grp.h>
 #endif
