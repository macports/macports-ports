--- lib/canna/lisp.c.orig	2004-04-27 07:49:21.000000000 +0900
+++ lib/canna/lisp.c	2007-10-16 03:49:46.000000000 +0900
@@ -2643,15 +2643,21 @@
 int n;
 {
   list p, t;
-  FILE *instream, *fopen();
+  list noerror = NIL;
+  FILE *instream;
 
-  argnchk("load",1);
+  if (n != 1 && n != 2)
+    argnerr("load");
+  if (n == 2)
+    noerror = pop1();
   p = pop1();
   if ( !stringp(p) ) {
     error("load: illegal file name  ",p);
     /* NOTREACHED */
   }
   if ((instream = fopen(xstring(p), "r")) == (FILE *)NULL) {
+    if (noerror)
+      return NIL;
     error("load: file not found  ",p);
     /* NOTREACHED */
   }
