--- jsprf.c.orig	2009-07-26 12:32:01.000000000 -0700
+++ jsprf.c	2009-07-26 12:33:12.000000000 -0700
@@ -58,6 +58,8 @@
 */
 #ifdef HAVE_VA_COPY
 #define VARARGS_ASSIGN(foo, bar)        VA_COPY(foo,bar)
+#elif defined(va_copy)
+#define VARARGS_ASSIGN(foo, bar)        va_copy(foo,bar)
 #elif defined(HAVE_VA_LIST_AS_ARRAY)
 #define VARARGS_ASSIGN(foo, bar)        foo[0] = bar[0]
 #else
