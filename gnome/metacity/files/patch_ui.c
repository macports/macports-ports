--- src/ui.c.org	Wed Sep 17 15:34:57 2003
+++ src/ui.c	Wed Sep 17 15:35:22 2003
@@ -524,10 +524,6 @@
   meta_frames_pop_delay_exposes (ui->frames);
 }
 
-#ifdef HAVE_GDK_PIXBUF_NEW_FROM_STREAM
-#define gdk_pixbuf_new_from_inline gdk_pixbuf_new_from_stream
-#endif
-
 GdkPixbuf*
 meta_ui_get_default_window_icon (MetaUI *ui)
 {
