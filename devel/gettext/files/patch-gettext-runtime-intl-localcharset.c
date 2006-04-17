--- gettext-runtime/intl/localcharset.c.orig	2006-04-16 15:55:06.000000000 -0700
+++ gettext-runtime/intl/localcharset.c	2006-04-16 15:57:13.000000000 -0700
@@ -23,6 +23,8 @@
 # include <config.h>
 #endif
 
+#ifndef HAVE_ICONV
+
 /* Specification.  */
 #include "localcharset.h"
 
@@ -407,3 +409,5 @@
 
   return codeset;
 }
+
+#endif
