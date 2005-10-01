--- mempcpy.c.orig	2004-07-16 08:07:01.000000000 -0600
+++ mempcpy.c	2005-09-30 02:10:29.000000000 -0600
@@ -29,13 +29,22 @@
 
 */
 
+#ifdef HAVE_ANSIDECL_H
 #include <ansidecl.h>
+#endif
 #ifdef ANSI_PROTOTYPES
 #include <stddef.h>
 #else
 #define size_t unsigned long
 #endif
 
+#ifndef PTR
+#define PTR 			void *
+#endif
+#ifndef PARAMS
+#define PARAMS(ARGS)	ARGS
+#endif
+
 extern PTR memcpy PARAMS ((PTR, const PTR, size_t));
 
 PTR
