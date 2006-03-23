--- tools/gpgparsemail.c.orig	2005-12-14 03:45:28.000000000 -0700
+++ tools/gpgparsemail.c	2006-03-22 14:29:47.000000000 -0700
@@ -145,6 +145,7 @@
   return p;
 }
 
+#if 0
 static char *
 stpcpy (char *a,const char *b)
 {
@@ -154,6 +155,7 @@
   
   return (char*)a;
 }
+#endif
 
 
 static int
