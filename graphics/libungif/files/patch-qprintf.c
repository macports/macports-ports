--- lib/qprintf.c.orig	Mon Sep 30 16:14:40 2002
+++ lib/qprintf.c	Mon Sep 30 16:15:06 2002
@@ -33,22 +33,12 @@
 /*****************************************************************************
 * Same as fprintf to stderr but with optional print.			     *
 *****************************************************************************/
-#ifdef HAVE_VARARGS_H
-void GifQprintf(int va_alist)
-{
-    char *Format, Line[128];
-    va_list ArgPtr;
-
-    va_start(ArgPtr);
-    Format = va_arg(ArgPtr, char *);
-#else
 void GifQprintf(char *Format, ...)
 {
     char Line[128];
     va_list ArgPtr;
 
-    va_start(ArgPtr, Format);
-#endif /* HAVE_VARARGS_H */
+    va_start(ArgPtr);
 
     if (GifQuietPrint) return;
 
