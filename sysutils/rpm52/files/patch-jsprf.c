Index: js/src/jsprf.c
===================================================================
RCS file: /v/rpm/cvs/js/src/jsprf.c,v
retrieving revision 1.1.1.1
retrieving revision 1.1.1.1.2.2
diff -u -r1.1.1.1 -r1.1.1.1.2.2
--- js/src/jsprf.c	20 Apr 2009 18:27:13 -0000	1.1.1.1
+++ js/src/jsprf.c	24 Jul 2009 11:18:57 -0000	1.1.1.1.2.2
@@ -57,7 +57,7 @@
 ** and requires array notation.
 */
 #ifdef HAVE_VA_COPY
-#define VARARGS_ASSIGN(foo, bar)        VA_COPY(foo,bar)
+#define VARARGS_ASSIGN(foo, bar)        va_copy(foo,bar)
 #elif defined(HAVE_VA_LIST_AS_ARRAY)
 #define VARARGS_ASSIGN(foo, bar)        foo[0] = bar[0]
 #else
