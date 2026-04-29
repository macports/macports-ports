--- tsl.c	1995-08-10 01:47:29.000000000 +0200
+++ tsl.c	2005-12-13 22:02:33.000000000 +0100
@@ -106,7 +106,7 @@
 \*----------------------------------------------------------------------*/
 
 #include <stdio.h>
-#include <varargs.h>
+#include <stdarg.h>
 #include "tsl.h"
 
 
@@ -155,7 +155,7 @@
 
 
 
-tsl_error( fatal, va_alist )
+tsl_error( int fatal, ... )
 /*----------------------------------------------------------------------
 |   NAME:
 |       tsl_error
@@ -172,13 +172,11 @@
 |
 \*----------------------------------------------------------------------*/
 
-int fatal;
-va_dcl
 {
     va_list ap;
     char *format;
 
-    va_start(ap);
+    va_start(ap, fatal);
 
     format = va_arg(ap, char *);
     vfprintf(stderr, format, ap);
