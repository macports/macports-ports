--- jsprf.c.orig	2006-10-26 05:41:48.000000000 +1000
+++ jsprf.c	2010-11-16 20:18:31.000000000 +1100
@@ -56,6 +56,8 @@
 */
 #ifdef HAVE_VA_COPY
 #define VARARGS_ASSIGN(foo, bar)        VA_COPY(foo,bar)
+#elif defined(va_copy)
+#define VARARGS_ASSIGN(foo, bar)        va_copy(foo,bar)
 #elif defined(HAVE_VA_LIST_AS_ARRAY)
 #define VARARGS_ASSIGN(foo, bar)        foo[0] = bar[0]
 #else
