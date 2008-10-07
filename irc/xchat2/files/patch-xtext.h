# http://bugs.gentoo.org/show_bug.cgi?id=234458
# http://bugs.gentoo.org/attachment.cgi?id=164726
--- xchat-2.8.6/src/fe-gtk/xtext.h.orig	2008-02-24 05:48:02.000000000 +0100
+++ xchat-2.8.6/src/fe-gtk/xtext.h	2008-09-06 02:18:39.000000000 +0200
@@ -270,6 +270,6 @@
 xtext_buffer *gtk_xtext_buffer_new (GtkXText *xtext);
 void gtk_xtext_buffer_free (xtext_buffer *buf);
 void gtk_xtext_buffer_show (GtkXText *xtext, xtext_buffer *buf, int render);
-GtkType gtk_xtext_get_type (void);
+GType gtk_xtext_get_type (void);
 
 #endif
