--- gtk-xmhtml/XmHTMLI.h.orig	2005-06-23 10:20:16.000000000 -0700
+++ gtk-xmhtml/XmHTMLI.h	2005-06-23 10:38:01.000000000 -0700
@@ -1058,9 +1058,7 @@
 #include "gtk-xmhtml-p.h"
 
 void gtk_xmhtml_set_outline (GtkXmHTML *html, int flag);
-void my_x_query_colors(GdkColormap *colormap,
-		       GdkColor    *colors,
-		       gint         ncolors);
+
 void
 gtk_xmhtml_set_colors (GtkXmHTML *html,
 		       Pixel foreground,
