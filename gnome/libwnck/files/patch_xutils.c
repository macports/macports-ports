--- libwnck/xutils.c.org	Wed Sep 17 14:26:10 2003
+++ libwnck/xutils.c	Wed Sep 17 14:26:53 2003
@@ -2113,10 +2113,6 @@
   return FALSE;
 }
 
-#ifdef HAVE_GDK_PIXBUF_NEW_FROM_STREAM
-#define gdk_pixbuf_new_from_inline gdk_pixbuf_new_from_stream
-#endif
-
 static GdkPixbuf*
 default_icon_at_size (int width,
                       int height)
