--- lib/qprintf.c.orig	Sat Jun 21 20:52:46 2003
+++ lib/qprintf.c	Sat Jun 21 20:53:01 2003
@@ -34,7 +34,8 @@
 * Same as fprintf to stderr but with optional print.			     *
 *****************************************************************************/
 #ifdef HAVE_VARARGS_H
-void GifQprintf(int va_alist)
+void GifQprintf(va_alist)
+va_dcl
 {
     char *Format, Line[128];
     va_list ArgPtr;
