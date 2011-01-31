--- src/motifutils.c	2011-01-30 19:39:41.000000000 +0100
+++ src/motifutils.c	2011-01-30 19:39:47.000000000 +0100
@@ -121,7 +121,7 @@
 
     i = 0;
     va_start(var, nchoices);
-    while ((s = va_arg(var, char *)) != NULL) {
+    while ((s = va_arg(var, char *)) != NULL && i<nchoices) {
 	retval[i + 2] = XmCreatePushButton(retval[1], s, NULL, 0);
 	i++;
     }
