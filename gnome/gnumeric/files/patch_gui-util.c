--- src/gui-util.c.org	Sat Nov 29 21:53:08 2003
+++ src/gui-util.c	Sat Nov 29 21:59:46 2003
@@ -1403,7 +1403,7 @@
 	gdk_cursor_unref (cursor);
 }
 
-#ifndef HAVE_GDK_CURSOR_NEW_FROM_PIXBUF
+/*#ifndef HAVE_GDK_CURSOR_NEW_FROM_PIXBUF */
 /* See http://bugzilla.gnome.org/showattachment.cgi?attach_id=17695 */
 static GdkCursor *
 gdk_cursor_new_from_pixbuf (GdkDisplay *display, 
@@ -1472,7 +1472,7 @@
   
   return cursor;
 }
-#endif
+/* #endif */
 
 GdkCursor *
 gnm_fat_cross_cursor (GdkDisplay *display)
