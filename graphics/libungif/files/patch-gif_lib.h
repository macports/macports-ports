--- lib/gif_lib.h.orig	Mon Sep 30 16:16:47 2002
+++ lib/gif_lib.h	Mon Sep 30 16:17:00 2002
@@ -209,11 +209,7 @@
 ******************************************************************************/
 extern int GifQuietPrint;
 
-#ifdef HAVE_VARARGS_H
-extern void GifQprintf();
-#else
 extern void GifQprintf(char *Format, ...);
-#endif /* HAVE_VARARGS_H */
 
 /******************************************************************************
 * O.K., here are the routines from GIF_LIB file GIF_ERR.C.		      *
