--- glib/gutils.c.org	2005-09-08 08:58:41.000000000 +0200
+++ glib/gutils.c	2005-09-08 08:58:58.000000000 +0200
@@ -46,9 +46,10 @@
 #ifdef HAVE_SYS_PARAM_H
 #include <sys/param.h>
 #endif
 #ifdef HAVE_CRT_EXTERNS_H 
-#include <crt-externs.h> /* for _NSGetEnviron */
+#include <crt_externs.h> /* for _NSGetEnviron */
+#define HAVE__NSGETENVIRON
 #endif
 
 /* implement gutils's inline functions
  */
