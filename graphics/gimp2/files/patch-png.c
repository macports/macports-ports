--- plug-ins/common/png.c.orig	2004/11/23 14:28:43	1.118
+++ plug-ins/common/png.c	2006/04/23 07:01:47	1.118.2.1
@@ -1,5 +1,5 @@
 /*
- * "$Id: patch-png.c,v 1.1 2006/05/27 18:41:14 yves Exp $"
+ * "$Id: patch-png.c,v 1.1 2006/05/27 18:41:14 yves Exp $"
  *
  *   Portable Network Graphics (PNG) plug-in for The GIMP -- an image
  *   manipulation program
@@ -1012,7 +1012,11 @@
    * Done with the file...
    */
 
+#if PNG_LIBPNG_VER > 99
+  png_destroy_read_struct (&pp, &info, NULL);
+#else
   png_read_destroy (pp, info, NULL);
+#endif
 
   g_free (pixel);
   g_free (pixels);
@@ -1441,7 +1445,12 @@
     };
 
   png_write_end (pp, info);
+
+#if PNG_LIBPNG_VER > 99
+  png_destroy_write_struct (&pp, &info);
+#else
   png_write_destroy (pp);
+#endif
 
   g_free (pixel);
   g_free (pixels);
